from log_mock_interview.models import LogMockInterview, MockInterviewAnswer
from rest_framework import serializers


class LogMockInterviewSerializer(serializers.ModelSerializer):
    class Meta:
        model = LogMockInterview
        fields = '__all__'

class MockInterviewAnswerSerializer(serializers.ModelSerializer):
    class Meta:
        model = MockInterviewAnswer
        fields = '__all__'