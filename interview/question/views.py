from question.serializers import QuestionSerializer
from .models import Question
from rest_framework import generics


class QuestionListView(generics.ListAPIView):
    serializer_class = QuestionSerializer

    def get_queryset(self):
        category = self.request.query_params.get('category', None)
        sub_category = self.request.query_params.get('subCategory', None)

        queryset = Question.objects.all()

        if category:
            queryset = queryset.filter(category=category)

        if sub_category:
            sub_category_list = sub_category.split(',')
            queryset = queryset.filter(sub_category__in=sub_category_list)

        return queryset



