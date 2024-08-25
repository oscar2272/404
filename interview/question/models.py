from django.db import models

class Question(models.Model):
    question_id = models.AutoField(primary_key=True)
    category = models.CharField(max_length=20)
    sub_category = models.CharField(max_length=20)
    question_title = models.CharField(max_length=255)
    file_name = models.CharField(max_length=255)