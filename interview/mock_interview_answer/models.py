from django.db import models
from django.core.validators import MinValueValidator, MaxValueValidator
from log_mock_interview.models import LogMockInterview
from question.models import Question

class MockInterviewAnswer(models.Model):
    mock_interview_answer_id = models.AutoField(primary_key=True)
    question_id = models.ForeignKey(Question,on_delete=models.CASCADE)
    log_mock_interview_id = models.ForeignKey(LogMockInterview,on_delete=models.CASCADE)
    question_num = models.IntegerField(validators=[MinValueValidator(1),MaxValueValidator(6)],blank=True,null=True)
    answer = models.TextField()
    feedback = models.TextField()