from django.urls import path
from . import views

app_name = 'logMockInterview'

urlpatterns = [
  path('',views.start_new_mock_interview,name='start_new_mock_interview'),
  path('<int:log_mock_interview_id>/mockInterviewAnswer/random/',views.get_next_question,name='get_next_question'),
  path('check/',views.check_existing_mock_interview),
]