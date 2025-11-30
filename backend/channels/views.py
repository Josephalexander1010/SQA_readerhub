from rest_framework import viewsets, generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.decorators import action
from django.shortcuts import get_object_or_404
from .models import Channel, SubChannel, Post, ChannelFollow
from .serializers import ChannelSerializer, SubChannelSerializer, PostSerializer

class ChannelViewSet(viewsets.ModelViewSet):
    queryset = Channel.objects.all()
    serializer_class = ChannelSerializer
    permission_classes = (permissions.IsAuthenticatedOrReadOnly,)

    def perform_create(self, serializer):
        channel = serializer.save(owner=self.request.user)
        # Create default sub-channels
        SubChannel.objects.create(channel=channel, name="General")
        SubChannel.objects.create(channel=channel, name="Announcements")

    @action(detail=False, methods=['get'])
    def search(self, request):
        query = request.query_params.get('q', '')
        channels = self.queryset.filter(name__icontains=query)
        serializer = self.get_serializer(channels, many=True)
        return Response(serializer.data)

class UserChannelsView(generics.ListAPIView):
    serializer_class = ChannelSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def get_queryset(self):
        user = self.request.user
        owned_channels = Channel.objects.filter(owner=user)
        followed_channels = Channel.objects.filter(followers__user=user)
        return (owned_channels | followed_channels).distinct()

class SubChannelCreateView(generics.CreateAPIView):
    queryset = SubChannel.objects.all()
    serializer_class = SubChannelSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def perform_create(self, serializer):
        channel_id = self.kwargs.get('channel_id')
        channel = get_object_or_404(Channel, id=channel_id)
        if channel.owner != self.request.user:
            raise permissions.PermissionDenied("You are not the owner of this channel.")
        serializer.save(channel=channel)

class FeedListView(generics.ListAPIView):
    serializer_class = PostSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def get_queryset(self):
        sub_channel_id = self.request.query_params.get('sub_channel_id')
        if sub_channel_id:
            return Post.objects.filter(sub_channel_id=sub_channel_id).order_by('-created_at')
        
        # Timeline feed (posts from followed channels)
        user = self.request.user
        followed_channels = Channel.objects.filter(followers__user=user)
        return Post.objects.filter(sub_channel__channel__in=followed_channels).order_by('-created_at')

class PostCreateView(generics.CreateAPIView):
    queryset = Post.objects.all()
    serializer_class = PostSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def perform_create(self, serializer):
        serializer.save(author=self.request.user)

class FollowChannelView(APIView):
    permission_classes = (permissions.IsAuthenticated,)

    def post(self, request, channel_id):
        channel = get_object_or_404(Channel, id=channel_id)
        ChannelFollow.objects.get_or_create(user=request.user, channel=channel)
        return Response({'message': 'Followed successfully'}, status=status.HTTP_200_OK)

class UnfollowChannelView(APIView):
    permission_classes = (permissions.IsAuthenticated,)

    def post(self, request, channel_id):
        channel = get_object_or_404(Channel, id=channel_id)
        ChannelFollow.objects.filter(user=request.user, channel=channel).delete()
        return Response({'message': 'Unfollowed successfully'}, status=status.HTTP_200_OK)
