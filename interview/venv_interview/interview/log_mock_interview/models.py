from django.db import models
from django.core.validators import MinValueValidator, MaxValueValidator
from question.models import Question
from user.models import User

class LogMockInterview(models.Model):
    class Meta:
        db_table = 'log_mock_interview'
    log_mock_interview_id = models.AutoField(primary_key=True)
    user = models.ForeignKey(User,on_delete=models.CASCADE)
    submit_at = models.DateTimeField(auto_now_add=True)
    round = models.IntegerField(validators=[MinValueValidator(1)],blank=True,null=True)

    # Evaluation criteria fields
    relevance = models.IntegerField (validators=[MinValueValidator(0),MaxValueValidator(25)],blank=True,null=True)  # 질문과 답변의 관련성
    clarity = models.IntegerField (validators=[MinValueValidator(0),MaxValueValidator(20)],blank=True,null=True)
    depth = models.IntegerField (validators=[MinValueValidator(0),MaxValueValidator(20)],blank=True,null=True)
    logic = models.IntegerField (validators=[MinValueValidator(0),MaxValueValidator(15)],blank=True,null=True)
    awareness = models.IntegerField (validators=[MinValueValidator(0),MaxValueValidator(10)],blank=True,null=True)

class MockInterviewAnswer(models.Model):
    class Meta:
        db_table = 'mock_interview_answer'
    mock_interview_answer_id = models.AutoField(primary_key=True)
    question_id = models.ForeignKey(Question,on_delete=models.CASCADE)
    log_mock_interview_id = models.ForeignKey(LogMockInterview,on_delete=models.CASCADE, related_name='mock_interviews')
    question_num = models.IntegerField(validators=[MinValueValidator(1),MaxValueValidator(6)],blank=True,null=True)
    answer = models.TextField(blank=True,null=True)
    feedback = models.TextField(blank=True,null=True)

