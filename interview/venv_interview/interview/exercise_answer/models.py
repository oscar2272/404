from django.db import models

from question.models import Question
from user.models import User

class ExerciseAnswer(models.Model):
    exercise_answer_id = models.AutoField(primary_key=True)
    user = models.ForeignKey(User,on_delete=models.CASCADE,related_name='exercise_answers')
    question_id = models.ForeignKey(Question,on_delete=models.CASCADE)
    answer = models.TextField()
    answered_at = models.DateTimeField(auto_now_add=True)
    feedback = models.TextField()
    feedback_improvement = models.TextField()


