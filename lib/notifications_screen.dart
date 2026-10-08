import 'package:flutter/material.dart';

import 'paylens_notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {
  static const Color primaryBlue = Color(0xFF2222C8);
  static const Color pageBackground = Color(0xFFF7F7FB);

  List<PayLensNotification> notifications = [];

  bool isLoading = true;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  // ============================================================
  // LOAD NOTIFICATIONS
  // ============================================================

  Future<void> _loadNotifications() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    final data =
    await PayLensNotificationService.getNotifications();

    if (!mounted) {
      return;
    }

    setState(() {
      notifications = data;
      isLoading = false;
    });
  }

  // ============================================================
  // MARK ALL READ
  // ============================================================

  Future<void> _markAllRead() async {
    if (notifications.isEmpty) {
      return;
    }

    await PayLensNotificationService.markAllRead();

    await _loadNotifications();
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> _refreshNotifications() async {
    final data =
    await PayLensNotificationService.getNotifications();

    if (!mounted) {
      return;
    }

    setState(() {
      notifications = data;
    });
  }

  // ============================================================
  // NOTIFICATION STYLE
  // ============================================================

  Map<String, Color> _notificationColors(String type) {
    switch (type.toLowerCase()) {
      case 'recurring':
        return {
          'background': const Color(0xFFFFD8C8),
          'border': const Color(0xFFFF765C),
        };

      case 'renewal':
        return {
          'background': const Color(0xFFFFF1C7),
          'border': const Color(0xFFE6C84A),
        };

      case 'payment':
        return {
          'background': const Color(0xFFDDE7FF),
          'border': const Color(0xFF8098FF),
        };

      case 'source':
        return {
          'background': const Color(0xFFE8DFFF),
          'border': const Color(0xFF9A7BE7),
        };

      default:
        return {
          'background': const Color(0xFFF0F1F5),
          'border': const Color(0xFFD0D2D8),
        };
    }
  }

  // ============================================================
  // NOTIFICATION ICON
  // ============================================================

  IconData _notificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'recurring':
        return Icons.autorenew_rounded;

      case 'renewal':
        return Icons.event_available_rounded;

      case 'payment':
        return Icons.payments_rounded;

      case 'source':
        return Icons.account_balance_wallet_rounded;

      default:
        return Icons.notifications_rounded;
    }
  }

  // ============================================================
  // NOTIFICATION ICON COLOR
  // ============================================================

  Color _notificationIconColor(String type) {
    switch (type.toLowerCase()) {
      case 'recurring':
        return const Color(0xFFE85D3F);

      case 'renewal':
        return const Color(0xFFB39400);

      case 'payment':
        return const Color(0xFF4868D8);

      case 'source':
        return const Color(0xFF7653C5);

      default:
        return primaryBlue;
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final int unreadCount =
        notifications.where((item) => item.unread).length;

    return Scaffold(
      backgroundColor: pageBackground,

      appBar: AppBar(
        backgroundColor: pageBackground,
        elevation: 0,
        centerTitle: false,

        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),

        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: const Text(
                'Mark all read',
                style: TextStyle(
                  color: primaryBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

          const SizedBox(width: 8),
        ],
      ),

      body: RefreshIndicator(
        color: primaryBlue,
        onRefresh: _refreshNotifications,

        child: _buildBody(),
      ),
    );
  }

  // ============================================================
  // BODY
  // ============================================================

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: primaryBlue,
        ),
      );
    }

    if (notifications.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.28,
          ),

          Icon(
            Icons.notifications_none_rounded,
            size: 72,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 20),

          const Center(
            child: Text(
              'No notifications yet',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Center(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Upload a statement and PayLens will show useful payment insights here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        24,
      ),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];

        return _buildNotificationCard(
          notification,
        );
      },
    );
  }

  // ============================================================
  // NOTIFICATION CARD
  // ============================================================

  Widget _buildNotificationCard(
      PayLensNotification notification,
      ) {
    final colors =
    _notificationColors(notification.type);

    final icon =
    _notificationIcon(notification.type);

    final iconColor =
    _notificationIconColor(notification.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: colors['border']!,
          width: 1.2,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [
            // ----------------------------------------------------
            // ICON
            // ----------------------------------------------------

            Container(
              width: 48,
              height: 48,

              decoration: BoxDecoration(
                color: colors['background'],
                shape: BoxShape.circle,
              ),

              child: Icon(
                icon,
                color: iconColor,
                size: 25,
              ),
            ),

            const SizedBox(width: 14),

            // ----------------------------------------------------
            // CONTENT
            // ----------------------------------------------------

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      if (notification.unread)
                        Container(
                          width: 9,
                          height: 9,

                          margin:
                          const EdgeInsets.only(
                            left: 8,
                            top: 5,
                          ),

                          decoration:
                          const BoxDecoration(
                            color: primaryBlue,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 7),

                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    notification.time,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}