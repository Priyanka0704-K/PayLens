import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'dashboard_screen.dart';

class BankTransaction {
  final String date;
  final String description;
  final double amount;
  final bool isCredit;

  const BankTransaction({
    required this.date,
    required this.description,
    required this.amount,
    required this.isCredit,
  });
}

class AnalyzingPaymentsScreen extends StatefulWidget {
  final XFile file;

  const AnalyzingPaymentsScreen({
    super.key,
    required this.file,
  });

  @override
  State<AnalyzingPaymentsScreen> createState() =>
      _AnalyzingPaymentsScreenState();
}

class _AnalyzingPaymentsScreenState
    extends State<AnalyzingPaymentsScreen> {
  double progress = 0.0;
  String status = 'Preparing your statement...';
  bool completed = false;

  @override
  void initState() {
    super.initState();
    _analyzePdf();
  }

  Future<void> _analyzePdf() async {
    try {
      if (!widget.file.name.toLowerCase().endsWith('.pdf')) {
        throw Exception('Please select a PDF statement.');
      }

      setState(() {
        progress = 0.15;
        status = 'Reading your statement...';
      });

      final List<int> bytes = await widget.file.readAsBytes();

      setState(() {
        progress = 0.35;
        status = 'Extracting transaction data...';
      });

      final PdfDocument document = PdfDocument(
        inputBytes: bytes,
      );

      final PdfTextExtractor extractor =
      PdfTextExtractor(document);

      final String extractedText =
      extractor.extractText();

      document.dispose();

      setState(() {
        progress = 0.60;
        status = 'Analyzing transactions...';
      });

      final List<BankTransaction> allTransactions =
      _parseBankStatement(extractedText);

      setState(() {
        progress = 0.80;
        status = 'Finding subscriptions...';
      });

      final List<BankTransaction> subscriptions =
      _findSubscriptions(allTransactions);

      setState(() {
        progress = 1.0;
        status = 'Analysis complete';
        completed = true;
      });

      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardScreen(
            payments: subscriptions,
            pdfFileName: widget.file.name,
            pdfText: extractedText, userName: '', userEmail: '',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        status = 'Unable to analyze this statement';
      });

      await Future.delayed(
        const Duration(milliseconds: 300),
      );

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Analysis failed'),
          content: Text(
            'We could not read this PDF statement.\n\n$e',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // ------------------------------------------------------------
  // DATE DETECTION
  // ------------------------------------------------------------

  List<RegExpMatch> _findDates(String text) {
    final List<RegExp> patterns = [
      RegExp(
        r'\b\d{1,2}[-/.](?:\d{1,2}|Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Sept|Oct|Nov|Dec)[-/.]\d{2,4}\b',
        caseSensitive: false,
      ),

      RegExp(
        r'\b\d{1,2}\s+(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Sept|Oct|Nov|Dec)[a-z]*\s+\d{2,4}\b',
        caseSensitive: false,
      ),

      RegExp(
        r'\b(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Sept|Oct|Nov|Dec)[a-z]*\s+\d{1,2},?\s+\d{2,4}\b',
        caseSensitive: false,
      ),
    ];

    final List<RegExpMatch> matches = [];

    for (final pattern in patterns) {
      matches.addAll(pattern.allMatches(text));
    }

    matches.sort(
          (a, b) => a.start.compareTo(b.start),
    );

    return matches;
  }

  bool _containsTransactionDate(String line) {
    return _findDates(line).isNotEmpty;
  }

  // ------------------------------------------------------------
  // STATEMENT PARSER
  // ------------------------------------------------------------

  List<BankTransaction> _parseBankStatement(
      String rawText,
      ) {
    if (rawText.trim().isEmpty) {
      return [];
    }

    final List<String> lines = rawText
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    final List<List<String>> blocks = [];

    List<String>? currentBlock;

    for (final line in lines) {
      if (_containsTransactionDate(line)) {
        if (currentBlock != null &&
            currentBlock.isNotEmpty) {
          blocks.add(currentBlock);
        }

        currentBlock = [line];
      } else {
        if (currentBlock != null) {
          currentBlock.add(line);
        }
      }
    }

    if (currentBlock != null &&
        currentBlock.isNotEmpty) {
      blocks.add(currentBlock);
    }

    final List<BankTransaction> transactions = [];

    for (final block in blocks) {
      final BankTransaction? transaction =
      _parseTransactionBlock(block);

      if (transaction != null) {
        transactions.add(transaction);
      }
    }

    return _removeDuplicateTransactions(
      transactions,
    );
  }

  // ------------------------------------------------------------
  // TRANSACTION BLOCK
  // ------------------------------------------------------------

  BankTransaction? _parseTransactionBlock(
      List<String> block,
      ) {
    if (block.isEmpty) return null;

    final String originalBlock =
    block.join(' ').replaceAll(RegExp(r'\s+'), ' ').trim();

    final String lower =
    originalBlock.toLowerCase();

    // Ignore non-transaction sections.
    if (_isNonTransactionText(lower)) {
      return null;
    }

    final List<RegExpMatch> dates =
    _findDates(originalBlock);

    if (dates.isEmpty) {
      return null;
    }

    // If the block contains multiple dates, it is usually
    // a statement period / summary / header rather than
    // one transaction.
    if (dates.length > 1) {
      return null;
    }

    final String date = dates.first.group(0)!;

    // Remove the date before extracting amounts.
    //
    // This is very important because otherwise:
    //
    // 02-Sep-2026 Netflix Subscription 649.00
    //
    // can be interpreted as:
    //
    // 02 + 2026 + 649
    //
    // and the parser may choose the wrong number.
    String withoutDate = originalBlock.replaceFirst(
      dates.first.group(0)!,
      ' ',
    );

    withoutDate = withoutDate
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final List<double> amounts =
    _extractMoneyAmounts(withoutDate);

    if (amounts.isEmpty) {
      return null;
    }

    final double amount =
    _chooseTransactionAmount(
      withoutDate,
      amounts,
    );

    if (amount <= 0) {
      return null;
    }

    String description =
    _cleanDescription(withoutDate);

    if (description.isEmpty) {
      return null;
    }

    if (_looksLikeHeader(description)) {
      return null;
    }

    final bool isCredit =
    _isCreditTransaction(lower);

    return BankTransaction(
      date: date,
      description: description,
      amount: amount,
      isCredit: isCredit,
    );
  }

  // ------------------------------------------------------------
  // IGNORE HEADERS / NON TRANSACTION TEXT
  // ------------------------------------------------------------

  bool _isNonTransactionText(String text) {
    const ignored = [
      'statement period',
      'statement date',
      'generated on',
      'account summary',
      'account details',
      'opening balance',
      'closing balance',
      'available balance',
      'transaction history',
      'transaction summary',
      'subscription transactions',
      'monthly subscription summary',
      'yearly subscription summary',
      'date description debit credit balance',
      'date description amount balance',
      'currency inr',
      'currency',
      'page number',
    ];

    for (final word in ignored) {
      if (text.contains(word)) {
        return true;
      }
    }

    return false;
  }

  bool _looksLikeHeader(String description) {
    final text = description.toLowerCase();

    const headerWords = [
      'date',
      'description',
      'debit',
      'credit',
      'balance',
      'transaction',
      'transactions',
      'currency',
      'statement',
      'summary',
    ];

    int matches = 0;

    for (final word in headerWords) {
      if (text.contains(word)) {
        matches++;
      }
    }

    return matches >= 2;
  }

  // ------------------------------------------------------------
  // MONEY EXTRACTION
  // ------------------------------------------------------------

  List<double> _extractMoneyAmounts(
      String text,
      ) {
    final RegExp amountRegex = RegExp(
      r'(?:(?:₹|Rs\.?|INR|USD|\$|EUR|€|GBP|£)\s*)?'
      r'[-+]?\(?'
      r'(?:\d{1,3}(?:,\d{3})+|\d+)'
      r'(?:\.\d{1,2})?'
      r'\)?',
      caseSensitive: false,
    );

    final List<double> amounts = [];

    for (final match in amountRegex.allMatches(text)) {
      final String raw =
      match.group(0)!.trim();

      final String cleaned = raw
          .replaceAll(
        RegExp(
          r'[₹$€£A-Za-z()]',
          caseSensitive: false,
        ),
        '',
      )
          .replaceAll(',', '')
          .trim();

      final double? value =
      double.tryParse(cleaned);

      if (value == null) continue;

      // Ignore tiny standalone numbers that are usually
      // part of descriptions, reference numbers, etc.
      final bool hasDecimal =
      cleaned.contains('.');

      final bool hasCurrency =
      RegExp(
        r'[₹$€£]|Rs|INR|USD|EUR|GBP',
        caseSensitive: false,
      ).hasMatch(raw);

      if (!hasDecimal &&
          !hasCurrency &&
          value < 10) {
        continue;
      }

      // Ignore obvious years.
      if (value >= 1900 && value <= 2100) {
        continue;
      }

      amounts.add(value.abs());
    }

    return amounts;
  }

  // ------------------------------------------------------------
  // CHOOSE THE REAL TRANSACTION AMOUNT
  // ------------------------------------------------------------

  double _chooseTransactionAmount(
      String text,
      List<double> amounts,
      ) {
    if (amounts.isEmpty) return 0;

    final String lower =
    text.toLowerCase();

    // Most bank statement rows are:
    //
    // description | debit/credit | balance
    //
    // Therefore the first amount is normally the
    // transaction amount and the last amount is
    // the running balance.

    if (amounts.length >= 2) {
      if (lower.contains('balance')) {
        return amounts.first;
      }

      if (lower.contains('debit') ||
          lower.contains('credit') ||
          lower.contains('withdraw') ||
          lower.contains('payment') ||
          lower.contains('purchase') ||
          lower.contains('subscription') ||
          lower.contains('membership') ||
          lower.contains('premium') ||
          lower.contains('autopay') ||
          lower.contains('auto pay')) {
        return amounts.first;
      }

      // Generic table layout:
      // first number = transaction
      // second number = balance
      return amounts.first;
    }

    return amounts.first;
  }

  // ------------------------------------------------------------
  // DESCRIPTION CLEANING
  // ------------------------------------------------------------

  String _cleanDescription(
      String text,
      ) {
    String result = text;

    // Remove monetary values.
    result = result.replaceAll(
      RegExp(
        r'(?:(?:₹|Rs\.?|INR|USD|\$|EUR|€|GBP|£)\s*)?'
        r'[-+]?\(?'
        r'(?:\d{1,3}(?:,\d{3})+|\d+)'
        r'(?:\.\d{1,2})?'
        r'\)?',
        caseSensitive: false,
      ),
      ' ',
    );

    // Remove transaction column words.
    result = result.replaceAll(
      RegExp(
        r'\b(?:DR|CR|DEBIT|CREDIT)\b',
        caseSensitive: false,
      ),
      ' ',
    );

    // Remove balance-related words.
    result = result.replaceAll(
      RegExp(
        r'\b(?:balance|running balance|available balance)\b',
        caseSensitive: false,
      ),
      ' ',
    );

    // Remove common reference labels.
    result = result.replaceAll(
      RegExp(
        r'\b(?:ref|reference|ref no|reference no|transaction id|txn id|utr)\b[:#\-\s]*[A-Za-z0-9\-_]+',
        caseSensitive: false,
      ),
      ' ',
    );

    // Remove long transaction/reference numbers.
    result = result.replaceAll(
      RegExp(r'\b\d{6,}\b'),
      ' ',
    );

    result = result
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    // Remove leading/trailing separators.
    result = result
        .replaceAll(RegExp(r'^[|:\-–—]+'), '')
        .replaceAll(RegExp(r'[|:\-–—]+$'), '')
        .trim();

    return result;
  }

  // ------------------------------------------------------------
  // CREDIT / DEBIT
  // ------------------------------------------------------------

  bool _isCreditTransaction(
      String text,
      ) {
    final lower = text.toLowerCase();

    if (lower.contains('credit')) return true;
    if (lower.contains('salary')) return true;
    if (lower.contains('cashback')) return true;
    if (lower.contains('refund')) return true;
    if (lower.contains('deposit')) return true;
    if (lower.contains('interest')) return true;

    return false;
  }

  // ------------------------------------------------------------
  // SUBSCRIPTION DETECTION
  // ------------------------------------------------------------

  List<BankTransaction> _findSubscriptions(
      List<BankTransaction> transactions,
      ) {
    final List<BankTransaction> subscriptions = [];

    for (final transaction in transactions) {
      if (transaction.isCredit) {
        continue;
      }

      if (_looksLikeSubscription(
        transaction.description,
      )) {
        subscriptions.add(transaction);
      }
    }

    return subscriptions;
  }

  bool _looksLikeSubscription(
      String description,
      ) {
    final String text =
    description.toLowerCase();

    const subscriptionKeywords = [
      // Direct subscription words
      'subscription',
      'subscribed',
      'membership',
      'recurring',
      'recurring payment',
      'recurring debit',
      'autopay',
      'auto pay',
      'standing instruction',
      'standing order',

      // Streaming / entertainment
      'netflix',
      'spotify',
      'youtube premium',
      'youtube music',
      'amazon prime',
      'prime video',
      'disney',
      'disney+',
      'hotstar',
      'jiohotstar',
      'sonyliv',
      'zee5',
      'gaana',
      'wynk',

      // Software / cloud
      'adobe',
      'creative cloud',
      'canva',
      'microsoft 365',
      'office 365',
      'google one',
      'google storage',
      'icloud',
      'dropbox',
      'notion',
      'zoom',
      'grammarly',
      'chatgpt',
      'openai',
      'linkedin premium',

      // Learning
      'coursera',
      'udemy',
      'skillshare',

      // Fitness / services
      'gym membership',
      'fitness membership',
      'club membership',
      'premium plan',
      'pro plan',
      'monthly plan',
      'annual plan',
      'yearly plan',
    ];

    for (final keyword in subscriptionKeywords) {
      if (text.contains(keyword)) {
        return true;
      }
    }

    return false;
  }

  // ------------------------------------------------------------
  // DUPLICATE REMOVAL
  // ------------------------------------------------------------

  List<BankTransaction> _removeDuplicateTransactions(
      List<BankTransaction> transactions,
      ) {
    final Map<String, BankTransaction> unique = {};

    for (final transaction in transactions) {
      final key =
          '${transaction.date}|'
          '${transaction.description.toLowerCase()}|'
          '${transaction.amount.toStringAsFixed(2)}|'
          '${transaction.isCredit}';

      unique[key] = transaction;
    }

    return unique.values.toList();
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final int percent =
    (progress * 100).round();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
            ),
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDEBFF),
                    borderRadius:
                    BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.analytics_rounded,
                    color: Color(0xFF2929C9),
                    size: 46,
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  'Analyzing your statement',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  status,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF777777),
                  ),
                ),

                const SizedBox(height: 28),

                ClipRRect(
                  borderRadius:
                  BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor:
                    const Color(0xFFE8E8F4),
                    valueColor:
                    const AlwaysStoppedAnimation<Color>(
                      Color(0xFF2929C9),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  '$percent%',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2929C9),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  widget.file.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF888888),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}