import 'pdf_payment_analyzer.dart';
import 'paylens_notification_service.dart';

class PayLensInsightEngine {
  static Future<void> analyzePayments(
      List<PaymentTransaction> transactions,
      ) async {
    if (transactions.isEmpty) {
      return;
    }

    // ==========================================================
    // GROUP BY MERCHANT
    // ==========================================================

    final Map<String, List<PaymentTransaction>>
    grouped = {};

    for (final transaction in transactions) {
      grouped.putIfAbsent(
        transaction.merchant,
            () => [],
      );

      grouped[transaction.merchant]!
          .add(transaction);
    }

    // ==========================================================
    // CHECK EACH MERCHANT
    // ==========================================================

    for (final entry in grouped.entries) {
      final merchant = entry.key;
      final payments = entry.value;

      // --------------------------------------------------------
      // NEW RECURRING PAYMENT
      // --------------------------------------------------------

      if (payments.length >= 2) {
        final latest = payments.last;

        await PayLensNotificationService
            .saveNotification(
          title: 'Recurring payment detected',
          message:
          'A recurring payment of ₹${latest.amount.toStringAsFixed(0)} '
              'was detected for $merchant.',
          type: 'recurring',
        );
      }

      // --------------------------------------------------------
      // HIGH PAYMENT
      // --------------------------------------------------------

      for (final payment in payments) {
        if (payment.amount >= 1000) {
          await PayLensNotificationService
              .saveNotification(
            title: '$merchant payment detected',
            message:
            'Your payment of ₹${payment.amount.toStringAsFixed(0)} '
                'was detected in the uploaded statement.',
            type: 'payment',
          );
        }
      }

      // --------------------------------------------------------
      // UPCOMING RENEWAL
      // --------------------------------------------------------

      final latest = payments.last;

      if (latest.date != null) {
        final nextRenewal =
        DateTime(
          latest.date!.year,
          latest.date!.month + 1,
          latest.date!.day,
        );

        final now = DateTime.now();

        final difference =
            nextRenewal.difference(now).inDays;

        if (difference >= 0 &&
            difference <= 7) {
          await PayLensNotificationService
              .saveNotification(
            title: 'Annual renewal approaching',
            message:
            '$merchant may renew around '
                '${_formatDate(nextRenewal)}.',
            type: 'renewal',
          );
        }
      }
    }
  }

  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}