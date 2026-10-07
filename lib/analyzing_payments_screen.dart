import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class AnalyzingPaymentsScreen
    extends StatefulWidget {
  final XFile file;

  const AnalyzingPaymentsScreen({
    super.key,
    required this.file,
  });

  @override
  State<
      AnalyzingPaymentsScreen>
  createState() =>
      _AnalyzingPaymentsScreenState();
}

class _AnalyzingPaymentsScreenState
    extends State<
        AnalyzingPaymentsScreen> {
  double progress = 0;

  String status =
      'Preparing your PDF...';

  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _analyzePdf();
  }

  Future<void> _analyzePdf() async {
    try {
      setState(() {
        progress = 0.15;
        status =
        'Reading your bank statement...';
      });

      final extension =
          widget.file.name
              .toLowerCase()
              .split('.')
              .last;

      if (extension != 'pdf') {
        throw Exception(
          'Please upload a PDF bank statement.',
        );
      }

      final bytes =
      await widget.file
          .readAsBytes();

      if (bytes.isEmpty) {
        throw Exception(
          'The PDF file is empty or could not be read.',
        );
      }

      setState(() {
        progress = 0.30;
        status =
        'Extracting statement data...';
      });

      final document =
      PdfDocument(
        inputBytes: bytes,
      );

      String extractedText = '';

      try {
        extractedText =
            PdfTextExtractor(
              document,
            ).extractText();
      } finally {
        document.dispose();
      }

      if (extractedText
          .trim()
          .isEmpty) {
        throw Exception(
          'No readable text was found in this PDF.',
        );
      }

      setState(() {
        progress = 0.55;
        status =
        'Finding transactions...';
      });

      final transactions =
      _parseBankStatement(
        extractedText,
      );

      if (transactions.isEmpty) {
        throw Exception(
          'No transactions could be detected from this PDF.',
        );
      }

      setState(() {
        progress = 0.70;
        status =
        'Detecting subscriptions...';
      });

      final subscriptions =
      _findSubscriptions(
        transactions,
      );

      setState(() {
        progress = 0.82;
        status =
        'Saving transaction history...';
      });

      // =========================================
      // CURRENT ACCOUNT
      // =========================================

      final prefs =
      await SharedPreferences
          .getInstance();

      final email =
          prefs.getString(
            'paylens_user_email',
          ) ??
              '';

      final userName =
          prefs.getString(
            'paylens_user_name',
          ) ??
              '';

      final historyKey =
          'paylens_statement_history_'
          '${email.toLowerCase().trim()}';

      // =========================================
      // GET OLD HISTORY
      // =========================================

      List<dynamic> history = [];

      final oldHistory =
      prefs.getString(
        historyKey,
      );

      if (oldHistory != null &&
          oldHistory.isNotEmpty) {
        try {
          final decoded =
          jsonDecode(
            oldHistory,
          );

          if (decoded is List) {
            history =
            List<dynamic>.from(
              decoded,
            );
          }
        } catch (_) {
          history = [];
        }
      }

      // =========================================
      // SAVE THIS DOCUMENT
      // =========================================

      final historyItem = {
        'fileName':
        widget.file.name,

        'uploadedAt':
        DateTime.now()
            .toIso8601String(),

        'transactions':
        transactions.map(
              (item) {
            return {
              'date':
              item.date,
              'description':
              item.description,
              'amount':
              item.amount,
              'isCredit':
              item.isCredit,
            };
          },
        ).toList(),
      };

      // VERY IMPORTANT:
      // DO NOT REPLACE OLD FILES.
      // ADD NEW FILE AT TOP.
      history.insert(
        0,
        historyItem,
      );

      await prefs.setString(
        historyKey,
        jsonEncode(history),
      );

      setState(() {
        progress = 1.0;
        status =
        'Analysis complete';
      });

      await Future.delayed(
        const Duration(
          milliseconds: 500,
        ),
      );

      if (!mounted) return;

      // =========================================
      // BACK TO DASHBOARD
      // =========================================

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              DashboardScreen(
                payments:
                subscriptions,
                pdfFileName:
                widget.file.name,
                pdfText:
                extractedText,
                userName:
                userName,
                userEmail:
                email,
              ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        progress = 0;
        status =
        'Analysis failed';

        errorMessage =
            e.toString().replaceFirst(
              'Exception: ',
              '',
            );
      });
    }
  }

  // =============================================
  // TRANSACTION PARSER
  // =============================================

  List<BankTransaction>
  _parseBankStatement(
      String text,
      ) {
    final lines = text
        .replaceAll(
      '\r\n',
      '\n',
    )
        .replaceAll(
      '\r',
      '\n',
    )
        .replaceAll(
      '\u00A0',
      ' ',
    )
        .split('\n')
        .map(
          (line) => line
          .replaceAll(
        RegExp(
          r'\s+',
        ),
        ' ',
      )
          .trim(),
    )
        .where(
          (line) =>
      line.isNotEmpty,
    )
        .toList();

    final transactions =
    <BankTransaction>[];

    for (
    int i = 0;
    i < lines.length;
    i++
    ) {
      final dateMatch =
      _findDate(
        lines[i],
      );

      if (dateMatch == null) {
        continue;
      }

      final date =
      dateMatch.group(0)!;

      String block =
      lines[i];

      for (
      int j = 1;
      j <= 3 &&
          i + j <
              lines.length;
      j++
      ) {
        final next =
        lines[i + j];

        if (_findDate(next) !=
            null ||
            _looksLikeMetadata(
              next,
            )) {
          break;
        }

        block =
        '$block $next';
      }

      if (_looksLikeMetadata(
        block,
      )) {
        continue;
      }

      final amounts =
      _extractAmounts(
        block,
      );

      final amount =
      _chooseAmount(
        block,
        amounts,
      );

      if (amount == null ||
          amount <= 0) {
        continue;
      }

      final description =
      _cleanDescription(
        block,
        date,
      );

      if (description
          .trim()
          .isEmpty) {
        continue;
      }

      transactions.add(
        BankTransaction(
          date: date,
          description:
          description,
          amount: amount,
          isCredit:
          _detectCredit(
            block,
          ),
        ),
      );
    }

    return _removeDuplicates(
      transactions,
    );
  }

  // =============================================
  // SUBSCRIPTIONS
  // =============================================

  List<BankTransaction>
  _findSubscriptions(
      List<BankTransaction>
      transactions,
      ) {
    return transactions
        .where(
          (item) =>
      !item.isCredit &&
          _looksLikeSubscription(
            item.description,
          ),
    )
        .toList();
  }

  bool _looksLikeSubscription(
      String description,
      ) {
    final text =
    description.toLowerCase();

    const keywords = [
      'subscription',
      'netflix',
      'spotify',
      'amazon prime',
      'prime video',
      'youtube premium',
      'youtube music',
      'apple music',
      'apple tv',
      'icloud',
      'google one',
      'google storage',
      'microsoft 365',
      'office 365',
      'adobe',
      'creative cloud',
      'canva',
      'disney',
      'hotstar',
      'jiohotstar',
      'sonyliv',
      'zee5',
      'gaana',
      'wynk',
      'chatgpt',
      'openai',
      'notion',
      'dropbox',
      'zoom',
      'grammarly',
      'membership',
      'recurring',
      'autopay',
      'auto pay',
      'standing instruction',
      'emi',
    ];

    return keywords.any(
      text.contains,
    );
  }

  // =============================================
  // DATE
  // =============================================

  RegExpMatch? _findDate(
      String text,
      ) {
    final patterns = [
      RegExp(
        r'\b\d{1,2}[-/]\d{1,2}[-/]\d{2,4}\b',
      ),
      RegExp(
        r'\b\d{1,2}[-/][A-Za-z]{3,9}[-/]\d{2,4}\b',
      ),
      RegExp(
        r'\b\d{1,2}\s+[A-Za-z]{3,9}\s+\d{2,4}\b',
      ),
      RegExp(
        r'\b\d{4}[-/]\d{1,2}[-/]\d{1,2}\b',
      ),
    ];

    for (final pattern
    in patterns) {
      final match =
      pattern.firstMatch(
        text,
      );

      if (match != null) {
        return match;
      }
    }

    return null;
  }

  // =============================================
  // AMOUNT
  // =============================================

  List<double> _extractAmounts(
      String text,
      ) {
    final result =
    <double>[];

    final regex =
    RegExp(
      r'(?:₹|Rs\.?|INR)?\s*'
      r'([0-9]{1,3}(?:,[0-9]{2,3})*'
      r'(?:\.[0-9]{1,2})?|'
      r'[0-9]+(?:\.[0-9]{1,2})?)',
      caseSensitive: false,
    );

    for (final match
    in regex.allMatches(
      text,
    )) {
      final value =
      double.tryParse(
        (match.group(1) ?? '')
            .replaceAll(
          ',',
          '',
        ),
      );

      if (value != null &&
          value > 0) {
        result.add(value);
      }
    }

    return result;
  }

  double? _chooseAmount(
      String block,
      List<double> amounts,
      ) {
    if (amounts.isEmpty) {
      return null;
    }

    final debit =
    RegExp(
      r'(?:dr|debit|debited|withdrawal|withdrawn)'
      r'[^0-9₹]{0,15}'
      r'(?:₹|rs\.?|inr)?\s*'
      r'([0-9,]+(?:\.[0-9]{1,2})?)',
      caseSensitive: false,
    ).firstMatch(block);

    if (debit != null) {
      return double.tryParse(
        debit
            .group(1)!
            .replaceAll(
          ',',
          '',
        ),
      );
    }

    final credit =
    RegExp(
      r'(?:cr|credit|credited|deposit|received|salary|refund|cashback)'
      r'[^0-9₹]{0,15}'
      r'(?:₹|rs\.?|inr)?\s*'
      r'([0-9,]+(?:\.[0-9]{1,2})?)',
      caseSensitive: false,
    ).firstMatch(block);

    if (credit != null) {
      return double.tryParse(
        credit
            .group(1)!
            .replaceAll(
          ',',
          '',
        ),
      );
    }

    return amounts.length >= 2
        ? amounts[
    amounts.length - 2]
        : amounts.first;
  }

  // =============================================
  // CREDIT / DEBIT
  // =============================================

  bool _detectCredit(
      String text,
      ) {
    final lower =
    text.toLowerCase();

    const keywords = [
      'credit',
      'credited',
      'salary',
      'deposit',
      'refund',
      'cashback',
      'interest',
      'reversal',
      'received',
      'neft cr',
      'imps cr',
      'upi cr',
    ];

    return keywords.any(
      lower.contains,
    );
  }

  // =============================================
  // METADATA
  // =============================================

  bool _looksLikeMetadata(
      String text,
      ) {
    final lower =
    text.toLowerCase();

    const keywords = [
      'opening balance',
      'closing balance',
      'available balance',
      'account balance',
      'statement period',
      'account number',
      'account no',
      'customer id',
      'customer name',
      'branch',
      'ifsc',
      'micr',
      'transaction date',
      'transaction details',
      'transaction description',
      'page no',
      'page number',
    ];

    return keywords.any(
      lower.contains,
    );
  }

  // =============================================
  // DESCRIPTION
  // =============================================

  String _cleanDescription(
      String block,
      String date,
      ) {
    var description =
    block.replaceFirst(
      date,
      '',
    );

    description =
        description.replaceAll(
          RegExp(
            r'(?:₹|Rs\.?|INR)?\s*'
            r'[0-9]{1,3}(?:,[0-9]{2,3})*'
            r'(?:\.[0-9]{1,2})?',
            caseSensitive: false,
          ),
          ' ',
        );

    description =
        description.replaceAll(
          RegExp(
            r'\b(?:DR|CR|DEBIT|CREDIT)\b',
            caseSensitive: false,
          ),
          ' ',
        );

    description =
        description
            .replaceAll(
          RegExp(
            r'\s+',
          ),
          ' ',
        )
            .trim();

    final lower =
    description.toLowerCase();

    const invalid = [
      'transaction',
      'transaction details',
      'transaction description',
      'description',
      'date',
    ];

    if (invalid.contains(
      lower,
    )) {
      return '';
    }

    return description;
  }

  // =============================================
  // REMOVE DUPLICATES
  // =============================================

  List<BankTransaction>
  _removeDuplicates(
      List<BankTransaction>
      input,
      ) {
    final map =
    <String, BankTransaction>{};

    for (final item in input) {
      final key =
          '${item.date}|'
          '${item.description.toLowerCase()}|'
          '${item.amount.toStringAsFixed(2)}|'
          '${item.isCredit}';

      map[key] = item;
    }

    return map.values.toList();
  }

  // =============================================
  // UI
  // =============================================

  @override
  Widget build(
      BuildContext context,
      ) {
    return Scaffold(
      backgroundColor:
      Colors.white,

      body: SafeArea(
        child: LayoutBuilder(
          builder: (
              context,
              constraints,
              ) {
            return Padding(
              padding:
              const EdgeInsets
                  .symmetric(
                horizontal: 16,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height:
                    constraints
                        .maxHeight <
                        650
                        ? 35
                        : 70,
                  ),

                  Container(
                    width: 70,
                    height: 70,
                    decoration:
                    BoxDecoration(
                      color:
                      const Color(
                        0xFFEDEDFF,
                      ),
                      borderRadius:
                      BorderRadius
                          .circular(
                        20,
                      ),
                    ),
                    child:
                    const Icon(
                      Icons
                          .picture_as_pdf_rounded,
                      color:
                      Color(
                        0xFF2222C8,
                      ),
                      size: 34,
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  const Text(
                    'Analyzing your PDF',
                    style:
                    TextStyle(
                      fontSize: 25,
                      fontWeight:
                      FontWeight
                          .w600,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Text(
                    status,
                    textAlign:
                    TextAlign.center,
                    style:
                    const TextStyle(
                      fontSize: 14,
                      color:
                      Color(
                        0xFF999999,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor:
                    const Color(
                      0xFFE5E5E5,
                    ),
                    valueColor:
                    const AlwaysStoppedAnimation<
                        Color>(
                      Color(
                        0xFF2222C8,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Text(
                    '${(progress * 100).round()}%',
                    style:
                    const TextStyle(
                      fontSize: 15,
                      fontWeight:
                      FontWeight
                          .w500,
                    ),
                  ),

                  if (errorMessage !=
                      null) ...[
                    const SizedBox(
                      height: 25,
                    ),

                    Container(
                      width:
                      double.infinity,
                      padding:
                      const EdgeInsets
                          .all(
                        16,
                      ),
                      decoration:
                      BoxDecoration(
                        color:
                        const Color(
                          0xFFFFF0F0,
                        ),
                        borderRadius:
                        BorderRadius
                            .circular(
                          12,
                        ),
                      ),
                      child:
                      Text(
                        errorMessage!,
                        textAlign:
                        TextAlign
                            .center,
                        style:
                        const TextStyle(
                          color:
                          Color(
                            0xFFE53935,
                          ),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],

                  const Spacer(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}