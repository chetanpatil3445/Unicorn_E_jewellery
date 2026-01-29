import 'package:get/get.dart';
import '../view/Notification.dart';

class NotificationController extends GetxController {
  var notifications = <NotificationItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void loadNotifications() {
    notifications.value = [
      NotificationItem(
        title: 'Stock Low Alert',
        description: 'Gold Ring (22K) stock is below minimum level.',
        type: NotificationType.warning,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
      ),
      NotificationItem(
        title: 'New Sale Transaction',
        description: 'Invoice #INV-1025 generated for ₹1,85,400.',
        type: NotificationType.success,
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        isRead: false,
      ),
      NotificationItem(
        title: 'Purchase Entry Added',
        description: 'New gold purchase added from ABC Bullion.',
        type: NotificationType.info,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isRead: true,
      ),
      NotificationItem(
        title: 'Scheme Installment Due',
        description: 'Customer Rahul Sharma scheme installment pending.',
        type: NotificationType.warning,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: true,
      ),
      NotificationItem(
        title: 'Loan Interest Posted',
        description: 'Monthly interest posted for loan account #LN-204.',
        type: NotificationType.info,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      NotificationItem(
        title: 'Barcode Generated',
        description: 'Barcode generated for Necklace Item Code NK-889.',
        type: NotificationType.success,
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isRead: true,
      ),
      NotificationItem(
        title: 'Credit Balance Alert',
        description: 'Customer Anil Verma has pending credit of ₹52,000.',
        type: NotificationType.warning,
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        isRead: false,
      ),
      NotificationItem(
        title: 'Debit Entry Updated',
        description: 'Debit entry updated for firm Mumbai Gold LLP.',
        type: NotificationType.info,
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isRead: true,
      ),
      NotificationItem(
        title: 'New User Added',
        description: 'Staff account created for Sales Executive.',
        type: NotificationType.success,
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        isRead: true,
      ),
      NotificationItem(
        title: 'Daily Accounts Closed',
        description: 'Today’s cash and ledger accounts closed successfully.',
        type: NotificationType.success,
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        isRead: true,
      ),
    ];
  }

  void markAsRead(int index) {
    notifications[index].isRead = true;
    notifications.refresh();
  }
}
