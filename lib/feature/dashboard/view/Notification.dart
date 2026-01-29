import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/appcolors.dart';
import '../controller/NotificationController.dart';


class NotificationPage extends StatelessWidget {
  NotificationPage({Key? key}) : super(key: key);
  final controller = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. PREMIUM HEADER WITH SIGNATURE CURVE
          SliverAppBar(
            expandedHeight: 160.0,
            floating: false,
            pinned: true,
            backgroundColor: primaryColor, // Dashboard style primary color
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50), // Luxury Curve
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 35),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.notifications_active_rounded, size: 38, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Notifications',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Obx(() {
                      int unread = controller.notifications.where((n) => !n.isRead).length;
                      return Text(
                        unread > 0 ? 'You have $unread new alerts' : 'You are all caught up',
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),

          // 2. NOTIFICATIONS LIST
          Obx(() {
            if (controller.notifications.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_none_rounded, size: 70, color: Colors.grey.shade300),
                      const SizedBox(height: 15),
                      Text(
                        "No notifications yet",
                        style: GoogleFonts.poppins(color: Colors.grey, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              );
            }
            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final item = controller.notifications[index];
                    return NotificationTile(
                      item: item,
                      onTap: () => controller.markAsRead(index),
                    );
                  },
                  childCount: controller.notifications.length,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final dynamic item; // NotificationItem item
  final VoidCallback onTap;

  const NotificationTile({Key? key, required this.item, required this.onTap}) : super(key: key);

  Color getIconColor() {
    // Enum selection logic
    switch (item.type.toString().split('.').last) {
      case 'success':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      default:
        return primaryColor;
    }
  }

  IconData getIcon() {
    switch (item.type.toString().split('.').last) {
      case 'success':
        return Icons.check_circle_outline_rounded;
      case 'warning':
        return Icons.error_outline_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: item.isRead ? Colors.white : primaryColor.withOpacity(0.04),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: item.isRead ? Colors.grey.shade100 : primaryColor.withOpacity(0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Rounded Container
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: getIconColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(getIcon(), color: getIconColor(), size: 22),
            ),
            const SizedBox(width: 15),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: item.isRead ? FontWeight.w500 : FontWeight.bold,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      if (!item.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.redAccent,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF64748B),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat('dd MMM • hh:mm a').format(item.timestamp),
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade400,
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

// UI Model & Enum (Agar controller mein defined hain toh wahan se use karein)
class NotificationItem {
  final String title;
  final String description;
  final NotificationType type;
  final DateTime timestamp;
  bool isRead;

  NotificationItem({
    required this.title,
    required this.description,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });
}

enum NotificationType { success, warning, info }
