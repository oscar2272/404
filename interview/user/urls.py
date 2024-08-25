from django.urls import path
from . import views
from .views import UpdateProfileView

urlpatterns = [
  path('bookmarks/', views.add_bookmark, name='bookmarks'),
  path('bookmarks/<int:bookmark_id>/', views.remove_bookmark, name='bookmarks'),
  path('<int:user_id>/', UpdateProfileView.as_view(), name='UpdateProfileView'),
  path('<int:user_id>/image/', views.reset_image, name='image'),

  path('quota/', views.setting_quota),
  path('data/', views.get_user_data, name='data'),
  path('signup/', views.signup, name='signup'),
  path('login/',views.login_view, name='login'),
  path('logout/',views.LogoutView.as_view(), name='logout'),
  path('find_email/',views.find_email, name='find_email'),
  path('reset_password/<int:user_id>/<str:token>/',views.reset_password, name='reset_password'),
  path('request_reset_password/',views.request_reset_password, name='request_reset_password'),
]