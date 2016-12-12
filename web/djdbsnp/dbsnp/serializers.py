from rest_framework import serializers
from .models import Snp

class SnpSerializer(serializers.ModelSerializer):
    class Meta:
        model = Snp
        fields = '__all__'
