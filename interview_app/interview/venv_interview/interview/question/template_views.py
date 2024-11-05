from django.http import HttpResponse
from django.shortcuts import redirect, render
from django.shortcuts import get_object_or_404
from .models import Question

def uploaded_page(request):
    questions = Question.objects.all()
    question_count = questions.count()  # 질문의 개수 계산

    # 쿼리 파라미터에서 삭제된 질문 수를 가져옴
    deleted_count = request.GET.get('deleted_count', 0)

    context = {
        'questions': questions,
        'question_count': question_count,
    }
    return render(request, 'questions.html', context)

def delete_question(request, question_id):
    if request.method == 'POST':
        # 특정 Question 객체를 가져옴
        question = get_object_or_404(Question, pk=question_id)
        question.delete()
        return redirect('questions:uploaded_page')  # 질문 목록 페이지로 리다이렉트
    else:
        return HttpResponse(status=405)  # Method Not Allowed

def delete_all_questions(request):
    if request.method == 'POST':
        Question.objects.all().delete()
        return redirect('questions:uploaded_page')  # 수정된 부분
    return redirect('questions:uploaded_page')  # 수정된 부분

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
        return redirect('questions:uploaded_page')
    else:
        return HttpResponse(status=405)  # Method Not Allowed