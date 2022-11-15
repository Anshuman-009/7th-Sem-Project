from django.urls import path
from django.conf.urls.static import static
from .views import sentiment
from polls import views

urlpatterns = [
    path('', views.sentiment, name='homepage'),
    ]