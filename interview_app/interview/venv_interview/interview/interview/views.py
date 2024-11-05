from django.http import JsonResponse
from django.views import View
from django.middleware.csrf import get_token

class GetCSRFTokenView(View):
    def get(self, request, *args, **kwargs):
        csrf_token = get_token(request)
        return JsonResponse({'csrf_token': csrf_token})