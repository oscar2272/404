from django.urls import path
from . import views

app_name = 'logMockInterview'

urlpatterns = [
  path('',views.LogMock_handler),
  path('start/',views.start_new_mock_interview,name='start_new_mock_interview'),
  path('<int:log_mock_interview_id>/mockInterviewAnswer/random/',views.get_next_question,name='get_next_question'),
  path('<int:log_mock_interview_id>/mockInterviewAnswer/retry/',views.delete_user_answers,name='delete_user_answers'),
  path('<int:log_mock_interview_id>/mockInterviewAnswer/',views.mock_interview_handler,name='mock_interview_handler'),
  path('check/',views.check_existing_mock_interview),
]