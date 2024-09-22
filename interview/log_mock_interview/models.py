from django.db import models
from django.core.validators import MinValueValidator, MaxValueValidator
from question.models import Question
from user.models import User

class LogMockInterview(models.Model):
    log_mock_interview_id = models.AutoField(primary_key=True)
    user = models.ForeignKey(User,on_delete=models.CASCADE)
    submit_at = models.DateTimeField(auto_now_add=True)
    round = models.IntegerField(validators=[MinValueValidator(1)],blank=True,null=True)

    # Evaluation criteria fields
    intent = models.BooleanField(default=False) # 발화의도
    potential = models.BooleanField(default=False)  # 잠재력
    logical = models.BooleanField(default=False)  # 논리력
    personality = models.BooleanField(default=False)  # 성격
    expertise = models.BooleanField(default=False) # 전문지식

class MockInterviewAnswer(models.Model):
    mock_interview_answer_id = models.AutoField(primary_key=True)
    question_id = models.ForeignKey(Question,on_delete=models.CASCADE)
    log_mock_interview_id = models.ForeignKey(LogMockInterview,on_delete=models.CASCADE)
    question_num = models.IntegerField(validators=[MinValueValidator(1),MaxValueValidator(6)],blank=True,null=True)
    answer = models.TextField()
    feedback = models.TextField()

