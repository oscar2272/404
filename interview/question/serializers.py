from rest_framework import serializers
from .models import Question

class QuestionSerializer(serializers.ModelSerializer):  #json 변환
    class Meta:
        model = Question
        fields = '__all__'
