import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'history_details_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({
    super.key,
  });

  @override
  State<HistoryScreen> createState() =>
      _HistoryScreenState();
}

class _HistoryScreenState
    extends State<HistoryScreen> {
  static const Color payLensBlue =
  Color(0xFF2929C9);

  List<Map<String, dynamic>>
  history = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final prefs =
    await SharedPreferences
        .getInstance();

    final email =
        prefs.getString(
          'paylens_user_email',
        ) ??
            '';

    final key =
        'paylens_statement_history_'
        '${email.toLowerCase().trim()}';

    final saved =
    prefs.getString(key);

    List<Map<String, dynamic>>
    loaded = [];

    if (saved != null &&
        saved.isNotEmpty) {
      try {
        final decoded =
        jsonDecode(saved);

        if (decoded is List) {
          loaded = decoded
              .map<Map<String, dynamic>>(
                (item) =>
            Map<String, dynamic>.from(
              item,
            ),
          )
              .toList();
        }
      } catch (_) {
        loaded = [];
      }
    }

    if (!mounted) return;

    setState(() {
      history = loaded;
      loading = false;
    });
  }

  DateTime? _getDate(
      Map<String, dynamic> item,
      ) {
    try {
      return DateTime.parse(
        item['uploadedAt']
            ?.toString() ??
            '',
      );
    } catch (_) {
      return null;
    }
  }

  String _monthName(
      DateTime date,
      ) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} ${date.year}';
  }

  int _transactionCount(
      Map<String, dynamic> item,
      ) {
    final transactions =
    item['transactions'];

    if (transactions is List) {
      return transactions.length;
    }

    return 0;
  }

  void _openDetails(
      Map<String, dynamic> item,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            HistoryDetailsScreen(
              historyItem: item,
            ),
      ),
    );
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    return Scaffold(
      backgroundColor:
      Colors.white,

      appBar: AppBar(
        backgroundColor:
        Colors.white,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 18,
          ),
        ),

        title: const Text(
          'Transaction History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 21,
            fontWeight:
            FontWeight.w600,
          ),
        ),
      ),

      body: loading
          ? const Center(
        child:
        CircularProgressIndicator(
          color: payLensBlue,
        ),
      )
          : history.isEmpty
          ? _emptyHistory()
          : _historyContent(),
    );
  }

  Widget _emptyHistory() {
    return const Center(
      child: Column(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          Icon(
            Icons.history_rounded,
            size: 55,
            color:
            Color(0xFFB8B8C8),
          ),

          SizedBox(height: 10),

          Text(
            'No transaction history',
            style: TextStyle(
              fontSize: 17,
              fontWeight:
              FontWeight.w600,
            ),
          ),

          SizedBox(height: 5),

          Text(
            'Upload a statement using +',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _historyContent() {
    final Map<
        String,
        List<Map<String, dynamic>>> grouped =
    {};

    for (final item in history) {
      final date = _getDate(item);

      if (date == null) {
        continue;
      }

      final month =
      _monthName(date);

      grouped.putIfAbsent(
        month,
            () => [],
      );

      grouped[month]!.add(item);
    }

    final groups =
    grouped.entries.toList();

    return Padding(
      padding:
      const EdgeInsets.fromLTRB(
        18,
        5,
        18,
        10,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            'Your uploaded statements',
            style: TextStyle(
              color: Color(0xFF777777),
              fontSize: 13,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          Expanded(
            child: LayoutBuilder(
              builder: (
                  context,
                  constraints,
                  ) {
                return FittedBox(
                  alignment:
                  Alignment.topLeft,
                  fit:
                  BoxFit.scaleDown,
                  child: SizedBox(
                    width:
                    constraints.maxWidth,
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        for (
                        int i = 0;
                        i < groups.length;
                        i++
                        ) ...[
                          // MONTH ON LEFT
                          Text(
                            groups[i].key,
                            style:
                            const TextStyle(
                              color:
                              payLensBlue,
                              fontSize: 17,
                              fontWeight:
                              FontWeight
                                  .w700,
                            ),
                          ),

                          const SizedBox(
                            height: 7,
                          ),

                          // FILES UNDER THAT MONTH
                          for (
                          final item
                          in groups[i]
                              .value
                          )
                            _historyFile(
                              item,
                            ),

                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _historyFile(
      Map<String, dynamic> item,
      ) {
    return GestureDetector(
      onTap: () {
        _openDetails(item);
      },
      child: Container(
        width: double.infinity,
        height: 58,
        margin:
        const EdgeInsets.only(
          bottom: 7,
        ),
        padding:
        const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        decoration:
        BoxDecoration(
          color:
          const Color(0xFFF8F8FC),
          borderRadius:
          BorderRadius.circular(
            10,
          ),
          border: Border.all(
            color:
            const Color(0xFFE3E3ED),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration:
              const BoxDecoration(
                color:
                Color(0xFFEDEBFF),
                shape:
                BoxShape.circle,
              ),
              child:
              const Icon(
                Icons
                    .description_rounded,
                color:
                payLensBlue,
                size: 20,
              ),
            ),

            const SizedBox(
              width: 10,
            ),

            Expanded(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment
                    .center,
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [
                  Text(
                    item['fileName']
                        ?.toString() ??
                        'Statement',
                    maxLines: 1,
                    overflow:
                    TextOverflow
                        .ellipsis,
                    style:
                    const TextStyle(
                      color:
                      Colors.black,
                      fontSize: 13,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  const SizedBox(
                    height: 2,
                  ),

                  Text(
                    '${_transactionCount(item)} transactions',
                    style:
                    const TextStyle(
                      color:
                      Color(0xFF888888),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons
                  .chevron_right_rounded,
              color:
              Color(0xFF999999),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}