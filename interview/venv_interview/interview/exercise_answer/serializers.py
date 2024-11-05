from exercise_answer.models import ExerciseAnswer
from rest_framework import serializers


class ExerciseAnswerSerializer(serializers.ModelSerializer):
    class Meta:
        model = ExerciseAnswer
        fields = '__all__'