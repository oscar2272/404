from datetime import datetime
import json
import os
from django.http import JsonResponse
from dotenv import load_dotenv
import openai
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
                model="ft:gpt-3.5-turbo-1106:personal::9uxOudfs",
                messages=[
                    {"role": "system", "content": "면접 질문에 대해 답변을 피드백해주는 어시스턴트입니다."},
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
        print(most_answered)
        return JsonResponse({
            'category': most_answered['category'],
        })

    return JsonResponse({'error': 'Invalid request method'}, status=405)

