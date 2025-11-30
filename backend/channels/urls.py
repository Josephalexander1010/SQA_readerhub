from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import (
    ChannelViewSet, UserChannelsView, SubChannelCreateView,
    FeedListView, PostCreateView, FollowChannelView, UnfollowChannelView
)

router = DefaultRouter()
router.register(r'channels', ChannelViewSet)

urlpatterns = [
    path('', include(router.urls)),
    path('user/channels/', UserChannelsView.as_view(), name='user_channels'),
    path('channels/<int:channel_id>/subchannels/', SubChannelCreateView.as_view(), name='create_subchannel'),
    path('channels/<int:channel_id>/follow/', FollowChannelView.as_view(), name='follow_channel'),
    path('channels/<int:channel_id>/unfollow/', UnfollowChannelView.as_view(), name='unfollow_channel'),
    path('feeds/', FeedListView.as_view(), name='feed_list'),
    path('feeds/create/', PostCreateView.as_view(), name='create_post'),
    path('feeds/timeline/', FeedListView.as_view(), name='timeline_feed'), # Reusing FeedListView logic
]
