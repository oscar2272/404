# Generated by Django 5.0.2 on 2024-07-21 08:12

import django.core.validators
import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ("log_mock_interview", "0001_initial"),
        ("question", "0001_initial"),
    ]

    operations = [
        migrations.CreateModel(
            name="MockInterviewAnswer",
            fields=[
                (
                    "mock_interview_answer_id",
                    models.AutoField(primary_key=True, serialize=False),
                ),
                (
                    "question_num",
                    models.IntegerField(
                        blank=True,
                        null=True,
                        validators=[
                            django.core.validators.MinValueValidator(1),
                            django.core.validators.MaxValueValidator(6),
                        ],
                    ),
                ),
                ("answer", models.TextField()),
                ("feedback", models.TextField()),
                (
                    "log_mock_interview_id",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        to="log_mock_interview.logmockinterview",
                    ),
                ),
                (
                    "question_id",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        to="question.question",
                    ),
                ),
            ],
        ),
    ]
