from django.http import HttpResponse
from django.shortcuts import redirect, render
from rest_framework.response import Response
from rest_framework.views import APIView
import re
from exercise_answer.models import ExerciseAnswer
from question.models import Question
from user.models import Bookmark, User
from django.contrib.sessions.models import Session
from django.core.cache import cache

class QuestionListView(APIView):
    def get(self, request, *args, **kwargs):
        category = request.query_params.get('category', None)
        sub_category = request.query_params.get('subCategory', None)
        bookmark = request.query_params.get('bookmark', None)
        answer = request.query_params.get('answer', None)

        session_id = request.headers.get('Authorization').split(' ')[1]
        # 세션 및 사용자 정보 가져오기
        session = Session.objects.get(session_key=session_id)
        user_id = session.get_decoded().get('_auth_user_id')
        user = User.objects.get(pk=user_id)

        # 쿼리셋에 prefetch_related 적용
        queryset = Question.objects.prefetch_related('bookmark_set', 'exerciseanswer_set').all()

        # 필터링 적용
        if category:
            queryset = queryset.filter(category=category)
        if sub_category:
            sub_category_list = sub_category.split(',')
            queryset = queryset.filter(sub_category__in=sub_category_list)
        if bookmark:
            bookmark_ids = Bookmark.objects.filter(user=user).values_list('question_id', flat=True)
            if bookmark == 'true':
                queryset = queryset.filter(question_id__in=bookmark_ids)
            elif bookmark == 'false':
                queryset = queryset.exclude(question_id__in=bookmark_ids)
        if answer:
            answered_question_ids = ExerciseAnswer.objects.filter(user=user).values_list('question_id', flat=True)
            if answer == 'true':
                queryset = queryset.filter(question_id__in=answered_question_ids)
            elif answer == 'false':
                queryset = queryset.exclude(question_id__in=answered_question_ids)

        # 응답 데이터 생성
        questions = [
            {
                "question_id": question.question_id,
                "category": question.category,
                "sub_category": question.sub_category,
                "question_title": question.question_title,
                "bookmark_id": Bookmark.objects.filter(user=user, question=question).values_list('bookmark_id', flat=True).first(),
                "exercise_answer_id": ExerciseAnswer.objects.filter(user=user, question=question).values_list('exercise_answer_id', flat=True).first(),
            }
            for question in queryset
        ]

        return Response(questions)


class QuestionDetailView(APIView):
    def get(self, request, question_id):
        session_id = request.headers.get('Authorization').split(' ')[1]
        session = Session.objects.get(session_key=session_id)
        user_id = session.get_decoded().get('_auth_user_id')
        user = User.objects.get(pk=user_id)

        question = Question.objects.filter(question_id=question_id).first()
        if not question:
            return Response({'error': 'Invalid question ID'}, status=400)

        bookmark = Bookmark.objects.filter(user=user, question=question).first()
        exercise_answer = ExerciseAnswer.objects.filter(user=user, question=question).first()

        response_data = {
            "question_id": question.question_id,
            "category": question.category,
            "sub_category": question.sub_category,
            "question_title": question.question_title,
            "bookmark_id": bookmark.bookmark_id if bookmark else None,
            "exercise_answer_id": exercise_answer.exercise_answer_id if exercise_answer else None
        }

        return Response(response_data)

def extract_number(file_name):
    # 파일 이름 끝에 있는 숫자를 추출
    match = re.search(r'_([0-9]+)\.json$', file_name)

    return int(match.group(1)) if match else 0


def view_uploaded_questions(request):
    print("test")
    questions = Question.objects.all()
    # file_name의 숫자 부분을 기준으로 정렬
    sorted_questions = sorted(questions, key=lambda q: extract_number(q.file_name))

    print("Sorted file names:")
    for question in sorted_questions:
        print(question.file_name)
    question_count = questions.count()  # 전체 질문 수 계산

    context = {
        'questions': sorted_questions,  # 여기를 sorted_questions로 변경
        'question_count': question_count
    }

    return render(request, 'questions.html', context)

def delete_all_questions(request):
    if request.method == 'POST':
        Question.objects.all().delete()
        return redirect('questions:view_uploaded_questions')  # 수정된 부분
    return redirect('questions:view_uploaded_questions')  # 수정된 부분

def fill_empty_fields_with_other(request):
    if request.method == "POST":
        # 모든 Question 객체를 가져와서 빈 값을 'Other'로 업데이트
        questions = Question.objects.all()
        for question in questions:
            if not question.category:
                question.category = 'other'
            if not question.sub_category:
                question.sub_category = 'other'
            question.save()
        return redirect('questions:view_uploaded_questions')
    else:
        return HttpResponse(status=405)  # Method Not Allowed

