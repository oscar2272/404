from django.contrib import admin
from . models import Users, Bookmark, Exerciseanswer, Logmockinterview, Mockinterviewanswer, Question

admin.site.register(Users)
admin.site.register(Bookmark)
admin.site.register(Exerciseanswer)
admin.site.register(Logmockinterview)
admin.site.register(Mockinterviewanswer)
admin.site.register(Question)