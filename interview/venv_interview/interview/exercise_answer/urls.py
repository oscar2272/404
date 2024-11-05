from django.urls import path
from . import views

app_name = 'exerciseAnswer'

urlpatterns = [
  path('', views.gpt_response, name='gpt_response'),
  path('<int:exercise_answer_id>/', views.answer_detail, name='answer_detail'),

  path('count/', views.answered_count, name='answered_count'),
  path('todayCount/', views.today_answered_count, name='today_answered_count'),
  path('category/',views.most_answered_category, name='most_answered_category'),
]