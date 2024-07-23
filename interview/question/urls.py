from django.urls import path
from . import views


app_name = 'questions'

urlpatterns = [
    path('upload/', views.view_uploaded_questions, name='view_uploaded_questions'),
    path('delete_all/', views.delete_all_questions, name='delete_all'),
    path('fill_other/', views.fill_empty_fields_with_other, name='fill_other'),
    path('', views.QuestionListView.as_view(), name='question-list'),

]
