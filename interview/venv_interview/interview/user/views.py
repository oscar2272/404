import json
from django.http import HttpResponse, JsonResponse
from django.shortcuts import get_object_or_404
from django.views import View
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from .models import Bookmark, User
from .serializers import UserSerializer
from django.core.mail import send_mail
from django.urls import reverse
from django.conf import settings
from django.contrib.auth import authenticate, login, logout, get_user
from django.contrib.auth.tokens import default_token_generator
from django.contrib.sessions.models import Session
from django.core.files.storage import default_storage
import os
from django.conf import settings
from django.http import JsonResponse
from django.shortcuts import get_object_or_404
from .models import User


@api_view(['GET'])
def get_user_data(request):
    session_id = request.headers.get('Authorization').split(' ')[1]
    if session_id:
        # 세션에 연결된 사용자 ID 가져오기
        session = Session.objects.get(session_key=session_id)
        user_id = session.get_decoded().get('_auth_user_id')
        user = User.objects.get(pk=user_id)

        # 사용자 데이터 반환
        serializer = UserSerializer(user)
        return Response(serializer.data)
    else:
        # 세션이 없을 경우 처리
        return JsonResponse({"error": "Session not found"}, status=status.HTTP_404_NOT_FOUND)

@api_view(['POST'])
def signup(request):
    email = request.data.get('email')
    nickname = request.data.get('nickname')
    password = request.data.get('password')

    # 데이터 확인용 로그 추가 (개발 시만)
    # 이메일 중복 확인
    if User.objects.filter(email=email).exists():   #비어있지 않다면 True / 비어 있으면 False
        return Response({"error": "이미 사용 중인 이메일입니다."}, status=status.HTTP_400_BAD_REQUEST)

    # 닉네임 중복 확인
    if User.objects.filter(nickname=nickname).exists():
        return Response({"error": "이미 사용 중인 닉네임입니다."}, status=status.HTTP_400_BAD_REQUEST)

    #사용자 생성
    try:
        user = User.objects.create_user(email=email, password=password, nickname=nickname)
    except Exception as e:
        print(f"Error creating user: {e}")
        return Response({"error": "사용자 생성 중 오류 발생"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    # 세션 처리
    try:
        login(request, user)
    except Exception as e:
        print(f"Login error: {e}")
        return Response({"error": "로그인 중 오류 발생"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    request.session.save() # 세션 키 생성
    session_id = request.session.session_key # 세션 키꺼내기

    serializer = UserSerializer(user)
    return Response({"message": "회원가입 성공", "user": serializer.data,"session_id": session_id}, status=status.HTTP_201_CREATED)


@api_view(['POST'])
def login_view(request):
    email = request.data.get('email')
    password = request.data.get('password')
    # 사용자 인증
    user = authenticate(request, email=email, password=password)
    if(user is None):
        return Response({"message": "로그인 실패"}, status=status.HTTP_400_BAD_REQUEST)
    if user is not None:
        login(request, user)  # 세션 생성
        request.session.save() # 세션 키 생성
        session_id = request.session.session_key # 세션 키꺼내기
        serializer = UserSerializer(user)
        return Response({"message": "로그인 성공", "user": serializer.data,"session_id": session_id}, status=status.HTTP_200_OK)

@api_view(['POST'])
def login_with_session(request):
    session_id = request.headers.get('Authorization').split(' ')[1]
    session = Session.objects.get(session_key=session_id)
    user_id = session.get_decoded().get('_auth_user_id')
    user = User.objects.get(pk=user_id)
    serializer = UserSerializer(user)

    return Response({"message": "로그인 성공", "user": serializer.data}, status=status.HTTP_200_OK)


@api_view(['POST'])
def find_email(request):
    nickname = request.data.get('nickname')
    user = User.objects.get(nickname=nickname)
    if user is not None:
        serializer = UserSerializer(user)
        return Response({"message": "닉네임으로 이메일 찾기 성공", "user": serializer.data}, status=status.HTTP_200_OK)

@api_view(['POST'])
def reset_password(request):
    session_id = request.headers.get('Authorization').split(' ')[1]
    session = Session.objects.get(session_key=session_id)
    user_id = session.get_decoded().get('_auth_user_id')
    user = User.objects.get(pk=user_id)
    password = request.data.get('password')
    newPassword = request.data.get('new_password')
    if(user.check_password(password)):
        user.set_password(newPassword)
        user.save()
        return Response({"message": "비밀번호 변경 성공"}, status=status.HTTP_200_OK)
    else:
        return Response({"message": "비밀번호 변경 실패"}, status=status.HTTP_400_BAD_REQUEST)



@api_view(['POST'])
def request_reset_password(request):
    email = request.data.get('email')

    try:
        user = User.objects.get(email=email)
    except User.DoesNotExist:
        return Response({"message": "해당 이메일을 가진 사용자가 없습니다."}, status=status.HTTP_404_NOT_FOUND)
    token = default_token_generator.make_token(user)
    reset_url = request.build_absolute_uri(reverse('reset_password'))

    send_mail(
        '비밀번호 재설정',
        f'모바일에서 링크를 클릭하여 비밀번호를 재설정하세요: {reset_url}',
        settings.DEFAULT_FROM_EMAIL,
        [email],
    )

    return Response({"message": "비밀번호 재설정 이메일이 발송되었습니다."}, status=status.HTTP_200_OK)



def reset_image(request, user_id):
    if request.method == 'PUT':
        user = get_object_or_404(User, pk=user_id)
        # 기존 이미지 경로
        if user.image and user.image.url != '/media/images/profile.png':  # 기본 이미지는 삭제하지 않음
            old_image_path = os.path.join(settings.MEDIA_ROOT, user.image.path)

            # 기존 이미지 삭제
            if os.path.exists(old_image_path):
                os.remove(old_image_path)

        # 새로운 이미지로 설정
        user.image = 'images/profile.png'
        user.save()

        return JsonResponse({'message': 'Profile image reset successfully'})

    return JsonResponse({'error': 'Invalid request method'}, status=405)


@api_view(['POST'])
def add_bookmark(request):
    session_id = request.headers.get('Authorization').split(' ')[1]
    session = Session.objects.get(session_key=session_id)
    user_id = session.get_decoded().get('_auth_user_id')
    user = User.objects.get(pk=user_id)
    question_id = request.data.get('question_id')
    # 북마크가 이미 존재하는지 확인
    if Bookmark.objects.filter(user=user, question_id=question_id).exists():
        return Response({"message": "북마크가 이미 존재합니다"}, status=status.HTTP_400_BAD_REQUEST)

    # 새로운 북마크 생성
    bookmark = Bookmark.objects.create(user=user, question_id=question_id)
    return Response({
        "message": "북마크 추가 성공",
        "bookmark_id": bookmark.bookmark_id  # 생성된 북마크의 ID 반환
    }, status=status.HTTP_201_CREATED)

@api_view(['DELETE'])
def remove_bookmark(request, bookmark_id):
    session_id = request.headers.get('Authorization').split(' ')[1]
    session = Session.objects.get(session_key=session_id)
    user_id = session.get_decoded().get('_auth_user_id')
    user = User.objects.get(pk=user_id)

    bookmark = Bookmark.objects.filter(bookmark_id=bookmark_id, user=user).first()
    if bookmark is None:
        return Response({"message": "추가되어있지 않은 북마크입니다."}, status=status.HTTP_404_NOT_FOUND)

    # 북마크 삭제
    bookmark.delete()
    return Response({"message": "북마크 삭제 성공"}, status=status.HTTP_200_OK)

def setting_quota(request):
    if request.method == 'POST':
        session_id = request.headers.get('Authorization').split(' ')[1]
        session = Session.objects.get(session_key=session_id)
        user_id = session.get_decoded().get('_auth_user_id')
        user = User.objects.get(pk=user_id)

        data = json.loads(request.body)
        quota = data.get('quota')
        user.quota = quota
        user.save()

        return JsonResponse({'message': 'Quota updated successfully'})

    return JsonResponse({'error': 'Invalid request method'}, status=405)
class UpdateProfileView(View):
    def post(self, request, *args, **kwargs):
        user_id = kwargs.get('user_id')
        user = User.objects.get(pk=user_id)
        nickname = request.POST.get('nickname')
        if nickname:
            # 1. 기존 User.nickname이 그대로 올 경우
            if nickname == user.nickname:
                pass  # 닉네임을 변경하지 않음

            # 2. DB에 이미 있는 다른 사용자의 nickname이 올 경우
            elif User.objects.filter(nickname=nickname).exclude(pk=user_id).exists():
                return JsonResponse({'error':'해당 닉네임은 이미 존재합니다.'}, status=400)

            # 3. 생성 가능한 nickname이 올 경우
            else:
                user.nickname = nickname

        # 이미지 파일 처리
        image_file = request.FILES.get('image')
        if image_file:
            # 기본 이미지 저장소에 파일 저장
            file_path = default_storage.save('images/' + image_file.name, image_file)
            user.image = file_path

        user.save()

        return JsonResponse({'message': 'Profile updated successfully'})

class LogoutView(View):
    def get(self, request):
        logout(request)
        return HttpResponse("로그아웃 성공")

#회원탈퇴 메서드
class DeleteUserView(View):
    def delete(self, request, *args, **kwargs):
        session_id = request.headers.get('Authorization').split(' ')[1]
        session = Session.objects.get(session_key=session_id)
        user_id = session.get_decoded().get('_auth_user_id')
        user = User.objects.get(pk=user_id)
        user.delete()

        return HttpResponse("회원탈퇴 성공", status=204)