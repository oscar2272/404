from django.shortcuts import redirect, render

from question.serializers import QuestionSerializer
from .models import Question
from django.http import HttpResponse
from rest_framework import generics

def view_uploaded_questions(request):
    questions = Question.objects.all()
    return render(request, 'questions.html', {'questions': questions})

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

class QuestionListView(generics.ListAPIView):
    serializer_class = QuestionSerializer

    def get_queryset(self):
        category = self.request.query_params.get('category', None)
        sub_category = self.request.query_params.get('subCategory', None)

        queryset = Question.objects.all()

        if category:
            queryset = queryset.filter(category=category)

        if sub_category:
            sub_category_list = sub_category.split(',')
            queryset = queryset.filter(sub_category__in=sub_category_list)

        return queryset