from rest_framework.response import Response
from rest_framework.views import APIView

from exercise_answer.models import ExerciseAnswer
from question.models import Question
from user.models import Bookmark, User
from django.contrib.sessions.models import Session

class QuestionListView(APIView):
    def get(self, request, *args, **kwargs):
        category = request.query_params.get('category', None)
        sub_category = request.query_params.get('subCategory', None)
        bookmark = request.query_params.get('bookmark', None)
        answer = request.query_params.get('answer', None)  # 답변 여부 필터링 추가

        session_id = request.headers.get('Authorization').split(' ')[1]
        session = Session.objects.get(session_key=session_id)
        user_id = session.get_decoded().get('_auth_user_id')
        user = User.objects.get(pk=user_id)

        queryset = Question.objects.all()

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

        # 사용자 답변에 대한 필터링 로직 추가
        if answer:
            answered_question_ids = ExerciseAnswer.objects.filter(user=user).values_list('question_id', flat=True)
            if answer == 'true':
                queryset = queryset.filter(question_id__in=answered_question_ids)
            elif answer == 'false':
                queryset = queryset.exclude(question_id__in=answered_question_ids)

        # 북마크 및 답변 정보를 함께 응답에 포함
        bookmark_info = Bookmark.objects.filter(user=user).values('question_id', 'bookmark_id')
        bookmark_info_dict = {info['question_id']: info['bookmark_id'] for info in bookmark_info}

        exercise_answers = ExerciseAnswer.objects.filter(user=user).values('question_id', 'exercise_answer_id')
        exercise_answer_dict = {answer['question_id']: answer['exercise_answer_id'] for answer in exercise_answers}

        response_data = [
            {
                "question_id": question.question_id,
                "category": question.category,
                "sub_category": question.sub_category,
                "question_title": question.question_title,
                "bookmark_id": bookmark_info_dict.get(question.question_id, None),
                "exercise_answer_id": exercise_answer_dict.get(question.question_id, None)  # 답변 여부를 추가
            }
            for question in queryset
        ]

        return Response(response_data)

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

