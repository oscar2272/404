from datetime import datetime
import json
import random
from django.shortcuts import get_object_or_404
from django.http import JsonResponse
from user.models import User
from .models import Question, LogMockInterview, MockInterviewAnswer
from django.contrib.sessions.models import Session
from rest_framework.decorators import api_view
from dotenv import load_dotenv
import os, openai
from django.views.decorators.csrf import csrf_exempt

load_dotenv()
api_key = os.getenv('OPENAI_API_KEY')
client = openai.OpenAI(api_key=api_key)

#새로운 면접을 시작하는 메서드
def start_new_mock_interview(request):
    session_id = request.headers.get('Authorization').split(' ')[1]
    session = Session.objects.get(session_key=session_id)
    user_id = session.get_decoded().get('_auth_user_id')
    user = User.objects.get(pk=user_id)

    # 진행 중인 면접 찾기
    ongoing_interview = LogMockInterview.objects.filter(user=user, submit_at__isnull=True).first()

    if ongoing_interview:
        # 진행 중인 면접이 있으면 기존 면접 삭제
        LogMockInterview.objects.filter(user=user, submit_at__isnull=True).delete()

    # 새로운 면접 세션 시작 (LogMockInterview 생성)
    latest_interview = LogMockInterview.objects.filter(user=user).order_by('-round').first()
    round_number = (latest_interview.round + 1) if latest_interview else 1
    new_interview = LogMockInterview.objects.create(user=user, round=round_number)

    # 새로운 면접 세션의 log_mock_interview_id 반환
    response = get_next_question(request, new_interview.log_mock_interview_id)

    # response에 log_mock_interview_id를 포함해 반환
    response_data = response.json()
    response_data['log_mock_interview_id'] = new_interview.log_mock_interview_id  # 면접 ID 추가

    return JsonResponse(response_data)


# 랜덤한 질문을 불러오는 메서드
def get_next_question(request, log_mock_interview_id):

    log_mock_interview = get_object_or_404(LogMockInterview, pk=log_mock_interview_id)

    answered_questions = MockInterviewAnswer.objects.filter(log_mock_interview_id=log_mock_interview).values_list('question_id', flat=True)

    # 모든 질문에 답변한 경우
    if len(answered_questions) >= 6:
        return JsonResponse({'status': 'complete', 'message': '모든 질문에 답변하셨습니다.'})

    technical_questions = Question.objects.filter(category__in=['기술', '면접']).exclude(question_id__in=answered_questions)
    other_questions = Question.objects.exclude(category__in=['기술', '면접']).exclude(question_id__in=answered_questions)

    # 질문을 선택할 때 문제를 제외하고 나올 수 있도록 확인
    if len(answered_questions) < 3:
        if technical_questions.exists():
            question = random.choice(technical_questions)
        else:
            return JsonResponse({'status': 'error', 'message': '기술/면접 카테고리에서 더 이상 질문을 출제할 수 없습니다.'})
    else:
        if other_questions.exists():
            question = random.choice(other_questions)
        else:
            return JsonResponse({'status': 'error', 'message': '다른 카테고리에서 더 이상 질문을 출제할 수 없습니다.'})

    # 새로운 문제의 답변 저장
    MockInterviewAnswer.objects.create(
        log_mock_interview_id=log_mock_interview,
        question_id=question.question_id,
        question_num=len(answered_questions) + 1
    )

    return JsonResponse({
        'question_num': len(answered_questions) + 1,
        'question_title': question.question_title,
        'category': question.category,
        'sub_category': question.sub_category,
    })

#사용자 답변을 받아서 저장하는 메서드
@csrf_exempt  # CSRF 검증 비활성화 (API 요청에서 필요할 경우 사용)
def submit_answer(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        log_mock_interview_id = data.get('log_mock_interview_id')
        question_id = data.get('question_id')
        user_answer = data.get('user_answer')

        log_mock_interview = get_object_or_404(LogMockInterview, pk=log_mock_interview_id)

        try:
            MockInterviewAnswer.objects.filter(
                log_mock_interview_id=log_mock_interview,
                question_id=question_id
            ).update(answer=user_answer, feedback='')

            # 답변이 6번째 질문인지 확인
            answered_questions = MockInterviewAnswer.objects.filter(log_mock_interview_id=log_mock_interview).count()
            if answered_questions >= 6:
                # 6번째 답변 제출 후 GPT-3 응답 호출
                return gpt_response(log_mock_interview_id)
            # 다음 질문 반환
            return get_next_question(request, log_mock_interview_id)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
# 진행중인 면접이있는지 체크하는 메서드
def check_existing_mock_interview(request):
    session_id = request.headers.get('Authorization').split(' ')[1]
    session = Session.objects.get(session_key=session_id)
    user_id = session.get_decoded().get('_auth_user_id')
    user = User.objects.get(pk=user_id)

    ongoing_interview = LogMockInterview.objects.filter(user=user, submit_at__isnull=True).first()

    if ongoing_interview:
        # 진행 중인 면접이 있으면 True 반환
        return JsonResponse({'exists': True})

    # 진행 중인 면접이 없으면 False 반환
    return JsonResponse({'exists': False})

instruction = """당신은 면접관입니다."""

# 6개의 답변제출이 끝나면 gpt에 보내는 메서드
@api_view(['POST'])
def gpt_response(request):
    if request.method == 'POST':
        session_id = request.headers.get('Authorization').split(' ')[1]
        session = Session.objects.get(session_key=session_id)
        user_id = session.get_decoded().get('_auth_user_id')

        user = User.objects.filter(id=user_id).first()

        if not user:
            return JsonResponse({'error': 'Invalid user'}, status=400)

        data = json.loads(request.body)
        log_mock_interview_id = data.get('log_mock_interview_id')

        try:
            mock_interviews = MockInterviewAnswer.objects.filter(log_mock_interview_id=log_mock_interview_id)

            messages = []
            for mock_answer in mock_interviews:
                question = Question.objects.get(pk=mock_answer.question_id.pk)  # Question 객체 가져오기
                messages.append({"role": "user", "content": question.question_title})
                messages.append({"role": "user", "content": mock_answer.answer})
            response = client.chat.completions.create(
                # 모델 수정해야함
                # model="ft:gpt-3.5-turbo-1106:personal::A03ikO3J"
                messages=[
                    {"role": "system", "content": instruction},

                ] + messages
            )
            gpt_reply = response.choices[0].message.content.strip()

            LogMockInterview.objects.create(
                submit_at=datetime.utcnow(),
                intent =  "",
                potential = "",
                personality = "",
                loogical= "",
                expertise = "",
            )
            answer = MockInterviewAnswer.objects.filter(log_mock_interview_id=log_mock_interview_id,question_num=6)
            answer.update(feedback=gpt_reply)
            return JsonResponse({'gpt_response': gpt_reply})

        except MockInterviewAnswer.DoesNotExist:
            return JsonResponse({'error': 'Invalid log_mock_interview_id or no answers found'}, status=400)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)


### 모의면접목록 불러오는 메서드
#### 모의면접 하나 불러오는 메서드(기존면접하던것)
##### 모의면접 삭제하는 메서드
##### 모의면접기록 전체삭제하는 메서드
