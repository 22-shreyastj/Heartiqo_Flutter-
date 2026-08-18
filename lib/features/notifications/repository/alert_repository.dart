import 'package:flutter/material.dart';
import '../model/alert_model.dart';

class AlertRepository {
  List<AlertModel> fetchRecentAlerts() {
    return [
      AlertModel(
        id: '1',
        icon: Icons.favorite,
        title: 'New Match',
        description: 'You have a new match with Sarah!',
        time: '5m ago',
        isUnread: true,
      ),
      AlertModel(
        id: '2',
        icon: Icons.chat_bubble,
        title: 'New Message',
        description: 'Alex sent you a message',
        time: '18m ago',
        isUnread: true,
      ),
      AlertModel(
        id: '3',
        icon: Icons.favorite_border,
        title: 'Profile Like',
        description: 'Someone liked your profile',
        time: '1h ago',
        isUnread: false,
      ),
    ];
  }

  List<AlertModel> fetchEarlierAlerts() {
    return [
      AlertModel(
        id: '4',
        icon: Icons.emoji_events,
        title: 'Weekly Matches',
        description: "You've reached 10 matches this week! Keep it up.",
        time: 'Yesterday',
        isUnread: false,
      ),
      AlertModel(
        id: '5',
        icon: Icons.favorite,
        title: 'New Match',
        description: 'You matched with David.',
        time: 'Yesterday',
        isUnread: false,
      ),
    ];
  }
}