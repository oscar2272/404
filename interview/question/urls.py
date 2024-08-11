from django.urls import path
from . import views
from . import template_views


app_name = 'questions'

urlpatterns = [
    path('', views.QuestionListView.as_view(), name='question_list'), #api view

    path('upload_page/', template_views.uploaded_page, name='uploaded_page'),
    path('delete_all', template_views.delete_all_questions, name='delete_all_questions'),
    path('<int:question_id>/', template_views.delete_question, name='delete_question'),
    path('fill_other/', template_views.fill_empty_fields_with_other, name='fill_other'),
]
