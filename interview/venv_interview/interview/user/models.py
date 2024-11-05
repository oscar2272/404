from django.db import models
from django.core.validators import MinValueValidator, MaxValueValidator
from django.contrib.auth.models import (
    AbstractBaseUser,
    BaseUserManager,
    PermissionsMixin,
)

from question.models import Question

class UserManager(BaseUserManager):
    """Manager for users."""

    use_in_migrations = True
    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError('Users must have an email address')
        user = self.model(email=self.normalize_email(email), **extra_fields)
        user.set_password(password)
        user.save(using=self._db)

        return user

    def create_superuser(self, email, password):
        """Create and return a new superuser."""
        user = self.create_user(email, password)
        user.is_staff = True
        user.is_superuser = True
        user.save(using=self._db)

        return user

class User(AbstractBaseUser,PermissionsMixin):
    """ user in the system."""
    email = models.EmailField(max_length=255,unique=True)
    nickname = models.CharField(max_length=255)
    image = models.ImageField(upload_to='images/',default='images/profile.png',null=True,blank=True)
    quota = models.IntegerField(validators=[MaxValueValidator(50)],default=10)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    objects = UserManager()

    USERNAME_FIELD = 'email'

    def __str__(self):
        return self.nickname

class Bookmark(models.Model):
    """Bookmark model."""
    bookmark_id = models.AutoField(primary_key=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    question = models.ForeignKey(Question, on_delete=models.CASCADE)

