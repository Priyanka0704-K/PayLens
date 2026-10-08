import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {
  static const Color payLensBlue = Color(0xFF2929C9);

  List<Map<String, dynamic>> notifications = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();

    final email =
        prefs.getString('paylens_user_email') ?? '';

    final key =
        'paylens_notifications_'
        '${email.toLowerCase().trim()}';

    final saved = prefs.getString(key);

    List<Map<String, dynamic>> loaded = [];

    if (saved != null && saved.isNotEmpty) {
      try {
        final decoded = jsonDecode(saved);

        if (decoded is List) {
          loaded = decoded
              .map<Map<String, dynamic>>(
                (item) => Map<String, dynamic>.from(item),
          )
              .toList();
        }
      } catch (_) {
        loaded = [];
      }
    }

    if (!mounted) return;

    setState(() {
      notifications = loaded;
      loading = false;
    });
  }

  Future<void> _markAllRead() async {
    final prefs = await SharedPreferences.getInstance();

    final email =
        prefs.getString('paylens_user_email') ?? '';

    final key =
        'paylens_notifications_'
        '${email.toLowerCase().trim()}';

    final updated = notifications.map((item) {
      final copy = Map<String, dynamic>.from(item);
      copy['isRead'] = true;
      return copy;
    }).toList();

    await prefs.setString(
      key,
      jsonEncode(updated),
    );

    if (!mounted) return;

    setState(() {
      notifications = updated;
    });
  }

  Future<void> _markRead(int index) async {
    if (index < 0 ||
        index >= notifications.length) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    final email =
        prefs.getString('paylens_user_email') ?? '';

    final key =
        'paylens_notifications_'
        '${email.toLowerCase().trim()}';

    final updated = notifications
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    updated[index]['isRead'] = true;

    await prefs.setString(
      key,
      jsonEncode(updated),
    );

    if (!mounted) return;

    setState(() {
      notifications = updated;
    });
  }

  int get unreadCount {
    return notifications.where((item) {
      return item['isRead'] != true;
    }).length;
  }

  Color _cardColor(String type) {
    switch (type) {
      case 'subscription':
        return const Color(0xFFFFEDED);

      case 'credit':
        return const Color(0xFFEFFFF1);

      case 'large_payment':
        return const Color(0xFFFFF6D9);

      default:
        return const Color(0xFFF6F5FF);
    }
  }

  Color _borderColor(String type) {
    switch (type) {
      case 'subscription':
        return const Color(0xFFE49A9A);

      case 'credit':
        return const Color(0xFF9BD3A3);

      case 'large_payment':
        return const Color(0xFFE5D36C);

      default:
        return const Color(0xFFB8B3E6);
    }
  }

  IconData _notificationIcon(String type) {
    switch (type) {
      case 'subscription':
        return Icons.subscriptions_outlined;

      case 'credit':
        return Icons.arrow_downward_rounded;

      case 'large_payment':
        return Icons.warning_amber_rounded;

      default:
        return Icons.notifications_none_rounded;
    }
  }

  String _timeAgo(dynamic value) {
    try {
      final date =
      DateTime.parse(value.toString());

      final difference =
      DateTime.now().difference(date);

      if (difference.inMinutes < 1) {
        return 'Just now';
      }

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes} min ago';
      }

      if (difference.inHours < 24) {
        return '${difference.inHours} hrs ago';
      }

      if (difference.inDays == 1) {
        return 'Yesterday';
      }

      if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      }

      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return '';
    }
  }

  void _openNotification(int index) {
    _markRead(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                // =====================================================
                // HEADER
                // =====================================================

                SizedBox(
                  height: 55,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 18,
                            color: Colors.black,
                          ),
                        ),

                        const Text(
                          'Stay informed',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const Spacer(),

                        if (unreadCount > 0)
                          GestureDetector(
                            onTap: _markAllRead,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 10,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Mark all read',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 11,
                                      fontWeight:
                                      FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.done_all_rounded,
                                    size: 14,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // =====================================================
                // CONTENT
                // =====================================================

                Expanded(
                  child: loading
                      ? const Center(
                    child: CircularProgressIndicator(
                      color: payLensBlue,
                    ),
                  )
                      : notifications.isEmpty
                      ? _emptyState()
                      : _notificationContent(
                    constraints.maxHeight,
                  ),
                ),

                // =====================================================
                // BOTTOM BAR
                // =====================================================

                Container(
                  height: 55,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: Color(0xFFE0E0E5),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      _bottomItem(
                        Icons.home_outlined,
                        false,
                      ),
                      _bottomItem(
                        Icons.subscriptions_outlined,
                        false,
                      ),
                      _bottomItem(
                        Icons.history_outlined,
                        false,
                      ),
                      _bottomItem(
                        Icons.person_outline_rounded,
                        false,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _notificationContent(
      double availableHeight,
      ) {
    final maxCards =
    ((availableHeight - 35) / 92).floor();

    final count = maxCards.clamp(
      1,
      notifications.length,
    );

    final visible =
    notifications.take(count).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        8,
        0,
        8,
        8,
      ),
      child: Column(
        children: [
          for (int i = 0; i < visible.length; i++)
            _notificationCard(
              visible[i],
              i,
            ),

          if (notifications.length > visible.length)
            Padding(
              padding: const EdgeInsets.only(
                top: 3,
              ),
              child: Text(
                '+${notifications.length - visible.length} more notifications',
                style: const TextStyle(
                  color: payLensBlue,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _notificationCard(
      Map<String, dynamic> notification,
      int index,
      ) {
    final type =
        notification['type']?.toString() ?? 'payment';

    final isRead =
        notification['isRead'] == true;

    return GestureDetector(
      onTap: () {
        _openNotification(index);
      },
      child: Container(
        width: double.infinity,
        height: 84,
        margin: const EdgeInsets.only(
          bottom: 8,
        ),
        padding: const EdgeInsets.fromLTRB(
          10,
          9,
          10,
          8,
        ),
        decoration: BoxDecoration(
          color: _cardColor(type),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _borderColor(type),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            // ICON
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.65,
                ),
                borderRadius:
                BorderRadius.circular(5),
              ),
              child: Icon(
                _notificationIcon(type),
                color: Colors.black87,
                size: 16,
              ),
            ),

            const SizedBox(width: 8),

            // TEXT
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    notification['title']
                        ?.toString() ??
                        'New notification',
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: isRead
                          ? FontWeight.w500
                          : FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    notification['message']
                        ?.toString() ??
                        '',
                    maxLines: 2,
                    overflow:
                    TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF555555),
                      fontSize: 9,
                      height: 1.2,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    _timeAgo(
                      notification['createdAt'],
                    ),
                    style: const TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // UNREAD DOT
            if (!isRead)
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(
                  top: 2,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF2196F3),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 58,
            color: Color(0xFFB9B9C8),
          ),
          SizedBox(height: 10),
          Text(
            'No notifications yet',
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Upload a statement to receive alerts.',
            style: TextStyle(
              color: Color(0xFF888888),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomItem(
      IconData icon,
      bool active,
      ) {
    return Expanded(
      child: Center(
        child: Icon(
          icon,
          size: 21,
          color: active
              ? payLensBlue
              : const Color(0xFF333333),
        ),
      ),
    );
  }
}