import 'dart:math';

class PaymentTransaction {
  final String merchant;
  final double amount;
  final DateTime? date;
  final String rawText;

  PaymentTransaction({
    required this.merchant,
    required this.amount,
    required this.date,
    required this.rawText,
  });
}

class PdfPaymentAnalyzer {
  // ============================================================
  // MERCHANT KEYWORDS
  // ============================================================

  static const List<String> knownMerchants = [
    'Netflix',
    'Amazon Prime',
    'Amazon',
    'YouTube Premium',
    'YouTube',
    'Spotify',
    'Adobe',
    'Microsoft',
    'Google',
    'Apple',
    'Disney',
    'Hotstar',
    'Canva',
    'ChatGPT',
    'OpenAI',
    'Dropbox',
    'iCloud',
    'Prime Video',
  ];

  // ============================================================
  // ANALYZE PDF TEXT
  // ============================================================

  static List<PaymentTransaction> analyze(String text) {
    final transactions = <PaymentTransaction>[];

    final lines = text
        .split(RegExp(r'\r?\n'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      final merchant = _findMerchant(line);

      if (merchant == null) {
        continue;
      }

      final amount = _findAmount(line);

      if (amount == null) {
        continue;
      }

      final date = _findDate(line);

      transactions.add(
        PaymentTransaction(
          merchant: merchant,
          amount: amount,
          date: date,
          rawText: line,
        ),
      );
    }

    return transactions;
  }

  // ============================================================
  // FIND MERCHANT
  // ============================================================

  static String? _findMerchant(String text) {
    final lower = text.toLowerCase();

    for (final merchant in knownMerchants) {
      if (lower.contains(merchant.toLowerCase())) {
        return merchant;
      }
    }

    return null;
  }

  // ============================================================
  // FIND AMOUNT
  // ============================================================

  static double? _findAmount(String text) {
    final matches = RegExp(
      r'(?:₹|rs\.?|inr)?\s?([0-9,]+(?:\.[0-9]{1,2})?)',
      caseSensitive: false,
    ).allMatches(text);

    if (matches.isEmpty) {
      return null;
    }

    final values = <double>[];

    for (final match in matches) {
      final value = match.group(1);

      if (value == null) {
        continue;
      }

      final parsed = double.tryParse(
        value.replaceAll(',', ''),
      );

      if (parsed != null && parsed > 0) {
        values.add(parsed);
      }
    }

    if (values.isEmpty) {
      return null;
    }

    return values.reduce(max);
  }

  // ============================================================
  // FIND DATE
  // ============================================================

  static DateTime? _findDate(String text) {
    final datePatterns = [
      RegExp(r'(\d{2})[/-](\d{2})[/-](\d{4})'),
      RegExp(r'(\d{2})[/-](\d{2})[/-](\d{2})'),
      RegExp(r'(\d{4})-(\d{2})-(\d{2})'),
    ];

    for (final pattern in datePatterns) {
      final match = pattern.firstMatch(text);

      if (match == null) {
        continue;
      }

      try {
        if (pattern.pattern.startsWith(r'(\d{4})')) {
          return DateTime(
            int.parse(match.group(1)!),
            int.parse(match.group(2)!),
            int.parse(match.group(3)!),
          );
        }

        var year = int.parse(match.group(3)!);

        if (year < 100) {
          year += 2000;
        }

        return DateTime(
          year,
          int.parse(match.group(2)!),
          int.parse(match.group(1)!),
        );
      } catch (_) {
        return null;
      }
    }

    return null;
  }
}