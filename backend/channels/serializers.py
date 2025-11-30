from rest_framework import serializers
from .models import Channel, SubChannel, Post, ChannelFollow, PostLike, PostSave
from users.serializers import UserSerializer

class SubChannelSerializer(serializers.ModelSerializer):
    class Meta:
        model = SubChannel
        fields = '__all__'

class ChannelSerializer(serializers.ModelSerializer):
    owner = UserSerializer(read_only=True)
    sub_channels = SubChannelSerializer(many=True, read_only=True)
    is_owned = serializers.SerializerMethodField()
    is_following = serializers.SerializerMethodField()

    class Meta:
        model = Channel
        fields = ('id', 'owner', 'name', 'description', 'avatar', 'created_at', 'sub_channels', 'is_owned', 'is_following')

    def get_is_owned(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            return obj.owner == request.user
        return False

    def get_is_following(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            return ChannelFollow.objects.filter(user=request.user, channel=obj).exists()
        return False

class PostSerializer(serializers.ModelSerializer):
    author = UserSerializer(read_only=True)
    sub_channel_name = serializers.ReadOnlyField(source='sub_channel.name')
    channel_name = serializers.ReadOnlyField(source='sub_channel.channel.name')
    liked = serializers.SerializerMethodField()
    likes_count = serializers.SerializerMethodField()

    class Meta:
        model = Post
        fields = ('id', 'sub_channel', 'sub_channel_name', 'channel_name', 'author', 'content', 'media', 'media_type', 'created_at', 'liked', 'likes_count')

    def get_liked(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            return PostLike.objects.filter(user=request.user, post=obj).exists()
        return False

    def get_likes_count(self, obj):
        return obj.likes.count()
