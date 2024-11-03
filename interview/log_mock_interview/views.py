from datetime import datetime, timezone
import json
import random
import re
import traceback
from django.shortcuts import get_object_or_404
from django.http import JsonResponse
from log_mock_interview.serializers import MockInterviewAnswerSerializer
from user.models import User
from .models import Question, LogMockInterview, MockInterviewAnswer
from django.contrib.sessions.models import Session
from rest_framework.decorators import api_view
from dotenv import load_dotenv
import os, openai
from django.db.models import Q

load_dotenv()
api_key = os.getenv('OPENAI_API_KEY')
client = openai.OpenAI(api_key=api_key)


def start_new_mock_interview(request):
    session_id = request.headers.get('Authorization').split(' ')[1]
    session = Session.objects.get(session_key=session_id)
    user_id = session.get_decoded().get('_auth_user_id')
    user = User.objects.get(pk=user_id)

    latest_interview = LogMockInterview.objects.filter(user=user).order_by('-round').first()
    round_number = (latest_interview.round + 1) if latest_interview else 1
    new_interview = LogMockInterview.objects.create(user=user, round=round_number)
    new_interview_id = new_interview.log_mock_interview_id
    # 새로운 면접 세션의 log_mock_interview_id 반환
    response = get_next_question(new_interview_id)

    # response에 log_mock_interview_id를 포함해 반환
    response_data = json.loads(response.content)

    return JsonResponse(response_data, safe=False)


# 랜덤한 질문을 불러오는 메서드
def get_next_question(new_or_old_interview_id):
    # mock 객체를 가져옴
    answered_questions = MockInterviewAnswer.objects.filter(log_mock_interview_id=new_or_old_interview_id).values_list('question_id', flat=True)
    # 기술/면접 카테고리의 질문과 다른 카테고리의 질문을 분리
    technical_questions = Question.objects.filter(category__in=['technology']).exclude(question_id__in=answered_questions)
    other_questions = Question.objects.exclude(category__in=['technology']).exclude(question_id__in=answered_questions)
    questionCount=answered_questions.count()

    question = None
    if questionCount <= 6:
        if questionCount < 4 and technical_questions.exists():
            question = random.choice(technical_questions)
        elif questionCount >= 4 and other_questions.exists():
            question = random.choice(other_questions)
    if question is None:
        return JsonResponse({'status': 'error', 'message': '질문이 더 이상 없습니다.'})
    mock = MockInterviewAnswer.objects.create(
        log_mock_interview_id=LogMockInterview.objects.get(log_mock_interview_id=new_or_old_interview_id),
        question_id=question,
        question_num=len(answered_questions) + 1,
        answer ="",
    )
    serializer = MockInterviewAnswerSerializer(mock)
    return JsonResponse({
        'data': {
            **serializer.data,
            'question_title': question.question_title
        }
    })


def get_or_create_question(log_mock_interview_id):
    #mock 객체들 가져오기
    mock = MockInterviewAnswer.objects.filter(
        log_mock_interview_id=log_mock_interview_id,
    )
    empty_mock = MockInterviewAnswer.objects.filter(
        log_mock_interview_id=log_mock_interview_id,
        answer="")
    if mock.exists():
        # 기존 질문이 있고 답변이 빈 문자열인지 확인

        if empty_mock.first():
        # 답변이 빈 문자열이면 해당 질문 반환
            print("빈문자열 입장")
            question = Question.objects.get(pk=empty_mock.first().question_id.pk)

            return {
                  'data': {
                      'question_num': empty_mock.first().question_num,
                      'question_title': question.question_title,
                      'category': question.category,
                      'sub_category': question.sub_category,
                  }
            }

        else:
            # 답변이 빈 문자열이 아닌 경우 (기존 log에 기존 질문 출제)
            response=json.loads(get_next_question(log_mock_interview_id).content)
            return response

    else:
        # 에러
        return {'status': 'error', 'message': 'no saved question found'}

# 모의면접 하나에 대한 처리
@api_view(['GET', 'POST', 'DELETE'])
def mock_interview_handler(request, log_mock_interview_id):
    # 주어진 ID에 해당하는 면접 기록
    log_mock_interview = get_object_or_404(LogMockInterview, pk=log_mock_interview_id)

    if request.method == 'GET':
        # 해당 면접에 대한 모든 답변 가져오기
        answers = MockInterviewAnswer.objects.filter(log_mock_interview_id=log_mock_interview.pk)
        # 답변 목록을 객체로 변환하여 반환
        answer_list = [{
            'log_mock_interview_id': answer.log_mock_interview_id.log_mock_interview_id,
            'mock_interview_answer_id': answer.mock_interview_answer_id,
            'question_id': answer.question_id.question_id,
            'question_num': answer.question_num,
            'question_title': answer.question_id.question_title,
            'answer': answer.answer,
            'feedback': answer.feedback
        } for answer in answers]

        # JSON 응답으로 반환
        return JsonResponse({
            'answers': answer_list  # 답변 목록 반환
        })
    # POST 요청이면 사용자 답변을 저장하고 다음 질문을 반환
    elif request.method == 'POST':
        data = json.loads(request.body)
        user_answer = data.get('user_answer')

        try:
            #새면접의 경우 mock객체 개수로 판별가능 Or 마지막 mock객체의 답변이 "" 인지로  판별가능,
            #다시하기의 경우 마지막 mock객체의 답변이 None 으로판별가능

            answered_questions = MockInterviewAnswer.objects.filter(log_mock_interview_id=log_mock_interview)
            first_empty_mock = MockInterviewAnswer.objects.filter(log_mock_interview_id=log_mock_interview,answer="").first()
            first_empty_mock.answer = user_answer
            first_empty_mock.save()

            last_answer = answered_questions.last().answer

            if (answered_questions.count() >= 6 and last_answer != ''):
                gpt_data = gpt_response(log_mock_interview_id)
                return JsonResponse({'gpt_response': gpt_data}, status=201)

            question_data = get_or_create_question(log_mock_interview_id)
            return JsonResponse(status=201, data=question_data, safe=False)

        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)


    elif request.method == 'DELETE':
        # 면접 기록 삭제
        round_to_delete = log_mock_interview.round
        print("round_to_delete: ", round_to_delete)
        try:
          subsequent_interviews = LogMockInterview.objects.filter(round__gt=round_to_delete)
          print("subsequent_interviews: ", subsequent_interviews)
          # subsequent_interviews가 있는 경우에만 반복문 실행
          if subsequent_interviews.exists():
              for interview in subsequent_interviews:
                  interview.round -= 1
                  interview.save()  # 변경 사항 저장
              log_mock_interview.delete()
          else :
              log_mock_interview.delete()


          return JsonResponse({},status=204)
        except Exception as e:
          print("Exception occurred:", str(e))
          traceback.print_exc()  # 전체 예외 내용 출력
          return JsonResponse({'error': str(e)}, status=500)
# 진행중인 면접이 있는지 체크하는 메서드
def check_existing_mock_interview(request):
    session_id = request.headers.get('Authorization').split(' ')[1]
    session = Session.objects.get(session_key=session_id)
    user_id = session.get_decoded().get('_auth_user_id')
    user = User.objects.get(pk=user_id)

    ongoing_interviews = LogMockInterview.objects.filter(
        user=user,
    ).filter(
        Q(relevance=0) | Q(relevance__isnull=True),
        Q(awareness__isnull=True) | Q(awareness=0),
        Q(clarity__isnull=True) | Q(clarity=0),
        Q(depth__isnull=True) | Q(depth=0),
        Q(logic__isnull=True) | Q(logic=0),
    )



    if ongoing_interviews.exists():
        # 진행 중인 면접 리스트 반환
        interview_list = [{
            'log_mock_interview_id': interview.log_mock_interview_id,
            'round': interview.round,
            'submit_at': interview.submit_at,
        } for interview in ongoing_interviews]

        return JsonResponse({'exists': True, 'interviews': interview_list})

    # 진행 중인 면접이 없으면 False 반환
    return JsonResponse({'exists': False})


def extract_score(response_text, criterion):
    # 응답에서 기준별 점수를 추출하는 로직
    # 정규식을 사용하여 각 점수를 추출하며, 추출되지 않으면 0을 반환
    match = re.search(rf"\*\*{criterion}\*\*: (\d+)점", response_text)
    return int(match.group(1)) if match else 0


########################################################

# 모의 면접 목록에대한 처리
@api_view(['GET', 'POST', 'DELETE'])
def LogMock_handler(request):
    if(request.method == 'GET'):
      session_id = request.headers.get('Authorization').split(' ')[1]
      session = Session.objects.get(session_key=session_id)
      user_id = session.get_decoded().get('_auth_user_id')
      user = User.objects.get(pk=user_id)

      interviews = LogMockInterview.objects.filter(user=user).order_by('-round')  # 최신순으로 가져온 것

      # 면접 정보를 리스트로 변환
      interview_list = [
          {
              'log_mock_interview_id': interview.log_mock_interview_id,
              'round': interview.round,
              'submit_at': interview.submit_at,
              'relevance': interview.relevance,
              'clarity': interview.clarity,
              'depth': interview.depth,
              'logic': interview.logic,
              'awareness': interview.awareness,
          }
          for interview in interviews
      ]

      return JsonResponse({'interviews': interview_list})
    elif(request.method == 'DELETE'):
        interviews = LogMockInterview.objects.all()
        interviews.delete()
        return JsonResponse({'message': '모의 면접 기록이 삭제되었습니다.'})





# 모의면접(사용자답변만) 삭제하는 메서드(다시하기눌렀을때 첫질문 바로가져와야함)
@api_view(['DELETE'])
def delete_user_answers(request, log_mock_interview_id):
    try:
      # 주어진 ID에 해당하는 면접 기록을 가져옵니다.
      interview = get_object_or_404(LogMockInterview, pk=log_mock_interview_id)
      interview.awareness=0
      interview.clarity=0
      interview.depth=0
      interview.logic=0
      interview.relevance=0
      # 해당 면접의 모든 사용자 답변의 피드백과 답변 ""로 업데이트
      MockInterviewAnswer.objects.filter(log_mock_interview_id=interview).update(answer='', feedback='')


      return JsonResponse({'message': '사용자 답변과 피드백이 삭제되었습니다.'}, status=204)
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)



# 모의면접기록 전체삭제하는 메서드
@api_view(['DELETE'])
def delete_mock_interview(request, log_mock_interview_id):
    # 주어진 ID에 해당하는 면접 기록을 가져옵니다.
    interview = get_object_or_404(LogMockInterview, pk=log_mock_interview_id)
    # 면접 기록 삭제
    interview.delete()

    return JsonResponse({'message': '모의 면접 기록이 삭제되었습니다.'})


instruction = """
SYSTEM:
넌 사용자에게 모의 면접 질문을 출제하고 피드백을 제공하는 면접관이야. 총 6개의 질문을 낼 거고, 사용자가 각 질문에 답변할 때마다 짧은 긍정적인 피드백을 주도록 해. 예를 들어, '네, 적절한 답변이군요.' 또는 '좋은 답변입니다.'라고 해줘.

6개의 질문이 끝나면, 사용자의 답변을 바탕으로 모의면접 평가표를 이용하여 종합 평가를 제공해. 평가는 적합성, 명확성, 깊이, 논리적 구성, 자기 인식, 대응력을 기반으로 해줘.

[ 모의면접 평가표 ]
1. 적합성
    - 답변이 질문에 적절하게 맞춰져 있는가?  15점
    - 질문에 대해 논리적이고 관련된 내용을 다루고 있는가?   10점

2. 명확성
    - 답변이 명확하고 이해하기 쉽게 표현되었는가?   10점
    - 복잡한 개념을 명확하게 설명했는가?    10점

3. 깊이
    - 답변이 단순한 정보 나열을 넘어서, 깊이 있는 통찰을 제공하는가? 10점
    - 예시나 구체적인 사례를 들어 답변을 뒷받침했는가?  10점

4. 논리적 구성
    - 답변이 논리적이고 체계적으로 구성되어 있는가? 10점
    - 처음부터 끝까지 일관성 있게 전개되었는가? 5점

5. 자기 인식
    - 자신의 경험이나 성격, 배경 등을 잘 인식하고 설명하는가?   5점
    - 약점이나 강점을 솔직하게 인식하고 발전 가능성을 나타내는가?   5점

점수 배분:
    - 적합성: 25점
    - 명확성: 20점
    - 깊이: 20점
    - 논리적 구성: 15점
    - 자기 인식: 10점
    - 총점: 100점

합격 기준:
    - 80점 <= 100점 = **합격**: 답변의 적합성, 명확성, 깊이, 논리적 구성이 매우 우수하며, 자기 인식이 뚜렷하고 개선 가능성도 잘 반영되었습니다.
    - 60점 <= 79점 = **보류**: 대부분의 답변이 적절하지만 일부 질문에서 깊이와 명확성이 부족하거나 논리적 구성에서 약간의 일관성 부족이 있습니다. 조금 더 구체적이고 통찰력 있는 답변이 필요합니다.
    - 40점 <= 59점 = **조금 더 준비하셔야 합니다**: 질문에 대한 답변이 충분하지 않거나 적합하지 않은 경우가 많습니다. 논리적 일관성 부족, 자기 인식 부재, 깊이 없는 답변이 많아 면접 준비가 더 필요합니다.
    - 1점 <= 39점 = **불합격**: 질문의 핵심을 파악하지 못하거나 대부분의 답변이 부적절하며, 전반적으로 준비 부족이 느껴집니다. 답변이 질문과 상관없거나 면접 기준에 크게 미치지 못합니다.

최종적으로 각 평가 항목에 대한 피드백을 주고, 최종 점수와 합격 기준을 보고 합격 여부를 판단해. 예시로 '최종 점수: 88점 / 합격입니다.' 처럼 알려줘.

주의사항:
- 면접과 관련이 없는 질문은 이 질문은 면접과 관련이 없습니다. 라고 답변해.
- 지원자가 학습과 성장할 수 있도록 도움을 주는 답변을 제공해.
- 모든 평가 항목에 대해 균형 잡힌 피드백을 제공하고, 최종 점수와 합격 여부는 답변의 전반적인 품질을 기준으로 판단해.

[INST]
1. 6개의 질문이 끝나면 종합 평가 제공.
2. 면접과 관련 없는 질문에 대해서는 적절히 대응.
3. 평가는 적합성, 명확성, 깊이, 논리적 구성, 자기 인식, 대응력을 기반으로 해.
"""

# 6개의 답변제출이 끝나면 gpt에 보내는 메서드
def gpt_response(log_mock_interview_id):
        try:
            mock_interviews = MockInterviewAnswer.objects.filter(log_mock_interview_id=log_mock_interview_id)
            messages = []
            for mock_answer in mock_interviews:
                question = Question.objects.get(pk=mock_answer.question_id.pk)  # Question 객체 가져오기
                messages.append({"role": "user", "content": question.question_title})
                messages.append({"role": "user", "content": mock_answer.answer})
            response = client.chat.completions.create(

                model="ft:gpt-3.5-turbo-1106:personal::ABFYiymn",
                messages=[
                    {"role": "system", "content": instruction},

                ] + messages
            )
            #gpt에서 받은답변
            gpt_reply = response.choices[0].message.content.strip()
            log_mock_interview = get_object_or_404(LogMockInterview, pk=log_mock_interview_id)
            answer = MockInterviewAnswer.objects.filter(log_mock_interview_id=log_mock_interview,question_num=6)
            answer.update(feedback=gpt_reply)

            relevance_score = extract_score(gpt_reply, "적합성")
            clarity_score = extract_score(gpt_reply, "명확성")
            depth_score = extract_score(gpt_reply, "깊이")
            logic_score = extract_score(gpt_reply, "논리적 구성")
            awareness_score = extract_score(gpt_reply, "자기 인식")

            log_mock_interview.relevance = relevance_score
            log_mock_interview.clarity = clarity_score
            log_mock_interview.depth = depth_score
            log_mock_interview.logic = logic_score
            log_mock_interview.awareness = awareness_score
            log_mock_interview.save()
            return gpt_reply

        except MockInterviewAnswer.DoesNotExist:
            return JsonResponse({'error': 'Invalid log_mock_interview_id or no answers found'}, status=400)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
