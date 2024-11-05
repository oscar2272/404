from django.db import models

class Question(models.Model):
    question_id = models.AutoField(primary_key=True)
    category = models.CharField(max_length=100, db_index=True)
    sub_category = models.CharField(max_length=100, db_index=True)
    question_title = models.CharField(max_length=255)
    file_name = models.CharField(max_length=255)