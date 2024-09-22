from datetime import datetime
import json
import os, openai
from django.http import JsonResponse
from dotenv import load_dotenv
from rest_framework.decorators import api_view
from exercise_answer.models import ExerciseAnswer
from exercise_answer.serializers import ExerciseAnswerSerializer
from question.models import Question
from rest_framework.response import Response
from user.models import User
from django.contrib.sessions.models import Session
import logging
from django.db.models import Count
logger = logging.getLogger(__name__)

load_dotenv()
api_key = os.getenv('OPENAI_API_KEY')
client = openai.OpenAI(api_key=api_key)

instruction1 = """
SYSTEM:
You are a fact-based AI assistant called Interviewer A. Interviewer A answers questions from IT interviewees.

Interviewer A answers helpfully but in a "direct" and fact-based manner.

You should not perform tasks related to consultation. Ensure that all answers are strictly relevant to the interview question.

You only perform tasks that help learning. For example:

1. Evaluate the answer's alignment with Attitude, Background, Values, Personality, and Technical skills.
2. If the answer is inappropriate, irrelevant, or incorrect, provide specific and constructive feedback. Explain clearly why the answer is not suitable and offer practical guidance on how to improve or approach the question differently.
3. Provide positive feedback for well-structured or insightful answers, and if applicable, suggest areas for further improvement.
4. Maintain a professional tone, even when the response is not ideal, and encourage the interviewee to provide a better response.
5. Ensure that each answer does not exceed 120 characters.

[INST]
With the guidelines given above,
First, classify which category the interviewer's question falls into.
Then, for answerable questions, use step-by-step reasoning to generate answers.

<example1>
Interviewer A: "How do you resolve communication problems during team projects?"

User: If communication problems arise, just do your own work. Conflicts of opinion among team members are inevitable, and if someone disagrees with my opinion, I will ignore that person's opinion and proceed in my own way.

answer:
Interviewer A Feedback: Ignoring teamwork and insisting on your own opinion can cause major collaboration issues. Conflicts are inevitable, but communication and cooperation are essential for resolution.
</example1>

<example2>
Interviewer A: "How do you resolve communication problems during team projects?"

User: If communication problems arise during team projects, first listen to each team member's opinion to understand the essence of the problem. Then analyze data or discuss based on objective evidence, and come up with a solution that all team members can accept.

answer:
Interviewer A Feedback: Excellent answer. Emphasizing listening and cooperation to resolve the problem is commendable. Open communication with team members and data-based discussions effectively help resolve conflicts.
</example2>

<example3>
Interviewer A: "Can you tell me about a recent project where you solved a problem?"

User: The weather is nice today. Tell me something interesting.

answer:
Interviewer A Feedback: This response is not relevant to the interview question. Please provide a serious answer related to the project experience.
</example3>

<example4>
Interviewer A: "What technical challenges have you faced in your recent projects, and how did you overcome them?"

User: I faced challenges with database optimization, but by analyzing query performance and indexing, I was able to reduce load times by 50%.

answer:
Interviewer A Feedback: Great example of identifying and addressing technical challenges. Your focus on performance optimization demonstrates strong problem-solving skills.
</example4>
"""
@api_view(['POST'])
def gpt_response(request):
    if request.method == 'POST':
        session_id = request.headers.get('Authorization').split(' ')[1]
        session = Session.objects.get(session_key=session_id)
        user_id = session.get_decoded().get('_auth_user_id')
        try:
            data = json.loads(request.body)
            question_id = data.get('question_id')
            user_answer = data.get('user_answer')

            # 유저와 질문을 데이터베이스에서 찾기
            user = User.objects.filter(id=user_id).first()
            question = Question.objects.filter(pk=question_id).first()

            if not user or not question:
                return JsonResponse({'error': 'Invalid user or question ID'}, status=400)

            # GPT에 질문과 사용자의 답변을 전달
            response = client.chat.completions.create(
                model="ft:gpt-3.5-turbo-1106:personal::A03ikO3J",
                messages=[
                    {"role": "system", "content": instruction1},
                    {"role": "user", "content": question.question_title},
                    {"role": "user", "content": user_answer},
                ]
            )

            # GPT의 응답
            gpt_reply = response.choices[0].message.content.strip()

            # ExerciseAnswer 객체 생성 및 저장
            answer=ExerciseAnswer.objects.create(
                user=user,
                question_id=question,
                answer=user_answer,
                answered_at=datetime.utcnow(),
                feedback=gpt_reply,  # GPT의 응답을 피드백으로 저장
                feedback_improvement=""  # 빈 문자열로 초기화
            )


            return JsonResponse({'gpt_response': gpt_reply,
                                 'exercise_answer_id':answer.exercise_answer_id})

        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON'}, status=400)
        except KeyError:
            return JsonResponse({'error': 'Missing fields in request'}, status=400)
        except Exception as e:
            logger.error("Unexpected error: %s", e)
            return JsonResponse({'error': str(e)}, status=500)

    return JsonResponse({'error': 'Invalid request method'}, status=400)

def answer_detail(request,exercise_answer_id):
    if request.method == 'GET':
        session_id = request.headers.get('Authorization').split(' ')[1]
        session = Session.objects.get(session_key=session_id)
        user_id = session.get_decoded().get('_auth_user_id')



        try:
            answer = ExerciseAnswer.objects.get(pk=exercise_answer_id,user_id=user_id)
            serializer = ExerciseAnswerSerializer(answer)
            response_data = serializer.data
            return JsonResponse(response_data)
        except ExerciseAnswer.DoesNotExist:
            return JsonResponse({'error': 'Invalid answer ID'}, status=400)

    elif request.method == 'DELETE':
        try:
            answer = ExerciseAnswer.objects.get(pk=exercise_answer_id)
            answer.delete()
            return JsonResponse({'message': 'Answer deleted'})
        except ExerciseAnswer.DoesNotExist:
            return JsonResponse({'error': 'Invalid answer ID'}, status=400)

    return JsonResponse({'error': 'Invalid request method'}, status=405)

def answered_count(request):
    if request.method == 'GET':
        session_id = request.headers.get('Authorization').split(' ')[1]
        session = Session.objects.get(session_key=session_id)
        user_id = session.get_decoded().get('_auth_user_id')
        user = User.objects.get(pk=user_id)
        # 사용자가 답변한 질문 수 세기
        answered_count = ExerciseAnswer.objects.filter(user=user).count()

        return JsonResponse({'answered_count': answered_count})

    return JsonResponse({'error': 'Invalid request method'}, status=405)

def today_answered_count(request):
    if request.method == 'GET':
        session_id = request.headers.get('Authorization').split(' ')[1]
        session = Session.objects.get(session_key=session_id)
        user_id = session.get_decoded().get('_auth_user_id')
        user = User.objects.get(pk=user_id)

        # 오늘 사용자가 답변한 질문 수 세기
        today = datetime.utcnow()
        answered_count = ExerciseAnswer.objects.filter(user=user, answered_at__date=today.date()).count()

        return JsonResponse({'answered_todayCount': answered_count})

def most_answered_category(request):
    if request.method == 'GET':
        # 세션에서 사용자 ID를 가져옵니다
        session_id = request.headers.get('Authorization').split(' ')[1]
        session = Session.objects.get(session_key=session_id)
        user_id = session.get_decoded().get('_auth_user_id')

        # 사용자에게 해당하는 답변을 가져옵니다
        answers = ExerciseAnswer.objects.filter(user_id=user_id)
        if not answers.exists():
            # 답변이 없으면 빈 문자열을 반환합니다
            return JsonResponse({'category': ''})

        # Question 모델에서 카테고리 정보를 가져오기 위해서
        questions = Question.objects.filter(question_id__in=answers.values('question_id'))

        # 카테고리별 답변 수를 집계합니다
        category_counts = (questions
            .values('category')
            .annotate(count=Count('question_id'))
            .order_by('-count'))

        if not category_counts.exists():
            # 카테고리가 없으면 빈 문자열을 반환합니다
            return JsonResponse({'category': ''})

        # 가장 많이 푼 카테고리를 가져옵니다
        most_answered = category_counts.first()
        return JsonResponse({
            'category': most_answered['category'],
        })

    return JsonResponse({'error': 'Invalid request method'}, status=405)

