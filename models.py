# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class Bookmark(models.Model):
    bookmark_id = models.AutoField(primary_key=True)
    question = models.ForeignKey('Question', models.DO_NOTHING)
    user = models.ForeignKey('Users', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'Bookmark'


class Exerciseanswer(models.Model):
    exerciseanswer_id = models.AutoField(db_column='exerciseAnswer_id', primary_key=True)  # Field name made lowercase.
    question = models.ForeignKey('Question', models.DO_NOTHING)
    user = models.ForeignKey('Users', models.DO_NOTHING)
    answered_at = models.DateTimeField()
    answer = models.TextField()
    feedback = models.TextField()
    feedback_improvement = models.TextField()

    class Meta:
        managed = False
        db_table = 'ExerciseAnswer'


class Logmockinterview(models.Model):
    logmockinterview_id = models.AutoField(db_column='logMockinterview_id', primary_key=True)  # Field name made lowercase.
    user = models.ForeignKey('Users', models.DO_NOTHING)
    submit_at = models.DateTimeField()
    session = models.IntegerField()
    total_score = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'LogMockinterview'


class Mockinterviewanswer(models.Model):
    mockinterviewanswer_id = models.AutoField(db_column='mockinterviewAnswer_id', primary_key=True)  # Field name made lowercase.
    question = models.ForeignKey('Question', models.DO_NOTHING)
    logmockinterview = models.ForeignKey(Logmockinterview, models.DO_NOTHING, db_column='logMockinterview_id')  # Field name made lowercase.
    question_num = models.IntegerField()
    score = models.IntegerField()
    answer = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'MockinterviewAnswer'


class Question(models.Model):
    question_id = models.AutoField(primary_key=True)
    category = models.CharField(max_length=20)
    sub_category = models.CharField(max_length=30)
    question_title = models.TextField(db_column='Question_title')  # Field name made lowercase.
    question_text = models.TextField(db_column='Question_text')  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'Question'


class Users(models.Model):
    user_id = models.AutoField(primary_key=True)
    email = models.CharField(max_length=30)
    password = models.CharField(max_length=15)
    nickname = models.CharField(max_length=8)
    image = models.BinaryField(blank=True, null=True)
    quota = models.IntegerField(db_column='Quota', blank=True, null=True)  # Field name made lowercase.
    created = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'Users'


class AuthGroup(models.Model):
    name = models.CharField(unique=True, max_length=150)

    class Meta:
        managed = False
        db_table = 'auth_group'


class AuthGroupPermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)
    permission = models.ForeignKey('AuthPermission', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_group_permissions'
        unique_together = (('group', 'permission'),)


class AuthPermission(models.Model):
    name = models.CharField(max_length=255)
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING)
    codename = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'auth_permission'
        unique_together = (('content_type', 'codename'),)


class AuthUser(models.Model):
    password = models.CharField(max_length=128)
    last_login = models.DateTimeField(blank=True, null=True)
    is_superuser = models.BooleanField()
    username = models.CharField(unique=True, max_length=150)
    first_name = models.CharField(max_length=150)
    last_name = models.CharField(max_length=150)
    email = models.CharField(max_length=254)
    is_staff = models.BooleanField()
    is_active = models.BooleanField()
    date_joined = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'auth_user'


class AuthUserGroups(models.Model):
    id = models.BigAutoField(primary_key=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_groups'
        unique_together = (('user', 'group'),)


class AuthUserUserPermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    permission = models.ForeignKey(AuthPermission, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_user_permissions'
        unique_together = (('user', 'permission'),)


class DjangoAdminLog(models.Model):
    action_time = models.DateTimeField()
    object_id = models.TextField(blank=True, null=True)
    object_repr = models.CharField(max_length=200)
    action_flag = models.SmallIntegerField()
    change_message = models.TextField()
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING, blank=True, null=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'django_admin_log'


class DjangoContentType(models.Model):
    app_label = models.CharField(max_length=100)
    model = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'django_content_type'
        unique_together = (('app_label', 'model'),)


class DjangoMigrations(models.Model):
    id = models.BigAutoField(primary_key=True)
    app = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    applied = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_migrations'


class DjangoSession(models.Model):
    session_key = models.CharField(primary_key=True, max_length=40)
    session_data = models.TextField()
    expire_date = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_session'
