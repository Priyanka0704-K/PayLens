import 'package:flutter/material.dart';

class HistoryDetailsScreen
    extends StatelessWidget {
  final Map<String, dynamic>
  historyItem;

  const HistoryDetailsScreen({
    super.key,
    required this.historyItem,
  });

  static const Color payLensBlue =
  Color(0xFF2929C9);

  String _monthName() {
    try {
      final date =
      DateTime.parse(
        historyItem['uploadedAt']
            ?.toString() ??
            '',
      );

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
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    final raw =
    historyItem['transactions'];

    final List<dynamic>
    transactions =
    raw is List
        ? raw
        : [];

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
          'History Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 21,
            fontWeight:
            FontWeight.w600,
          ),
        ),
      ),

      body: Padding(
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
            // MONTH LEFT
            Text(
              _monthName(),
              style:
              const TextStyle(
                color:
                payLensBlue,
                fontSize: 20,
                fontWeight:
                FontWeight.w700,
              ),
            ),

            const SizedBox(
              height: 3,
            ),

            // PDF NAME
            Text(
              historyItem['fileName']
                  ?.toString() ??
                  'Statement',
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,
              style:
              const TextStyle(
                color:
                Color(0xFF777777),
                fontSize: 12,
              ),
            ),

            const SizedBox(
              height: 13,
            ),

            Text(
              '${transactions.length} transactions',
              style:
              const TextStyle(
                color:
                Colors.black,
                fontSize: 16,
                fontWeight:
                FontWeight.w600,
              ),
            ),

            const SizedBox(
              height: 9,
            ),

            Expanded(
              child: transactions
                  .isEmpty
                  ? const Center(
                child: Text(
                  'No transactions found',
                  style:
                  TextStyle(
                    color:
                    Colors.grey,
                  ),
                ),
              )
                  : LayoutBuilder(
                builder: (
                    context,
                    constraints,
                    ) {
                  return FittedBox(
                    alignment:
                    Alignment
                        .topLeft,
                    fit:
                    BoxFit.scaleDown,
                    child: SizedBox(
                      width:
                      constraints
                          .maxWidth,
                      child:
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          for (
                          final transaction
                          in transactions
                          )
                            _transactionCard(
                              transaction,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _transactionCard(
      dynamic transaction,
      ) {
    final Map<String, dynamic>
    data =
    transaction is Map
        ? Map<String, dynamic>.from(
      transaction,
    )
        : {};

    final description =
        data['description']
            ?.toString() ??
            'Transaction';

    final date =
        data['date']
            ?.toString() ??
            '';

    final amount =
        double.tryParse(
          data['amount']
              ?.toString() ??
              '',
        ) ??
            0;

    final isCredit =
        data['isCredit'] == true;

    return Container(
      width: 500,
      height: 53,
      margin:
      const EdgeInsets.only(
        bottom: 6,
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
          9,
        ),
        border: Border.all(
          color:
          const Color(0xFFE4E4EC),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration:
            BoxDecoration(
              color: isCredit
                  ? const Color(
                0xFFEAF8EF,
              )
                  : const Color(
                0xFFEDEBFF,
              ),
              shape:
              BoxShape.circle,
            ),
            child: Icon(
              isCredit
                  ? Icons
                  .arrow_downward_rounded
                  : Icons
                  .arrow_upward_rounded,
              color: isCredit
                  ? const Color(
                0xFF159447,
              )
                  : payLensBlue,
              size: 18,
            ),
          ),

          const SizedBox(
            width: 9,
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
                  description,
                  maxLines: 1,
                  overflow:
                  TextOverflow
                      .ellipsis,
                  style:
                  const TextStyle(
                    color:
                    Colors.black,
                    fontSize: 12,
                    fontWeight:
                    FontWeight
                        .w600,
                  ),
                ),

                const SizedBox(
                  height: 2,
                ),

                Text(
                  date,
                  style:
                  const TextStyle(
                    color:
                    Color(0xFF999999),
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),

          Text(
            '${isCredit ? '+' : '-'}₹${amount.toStringAsFixed(2)}',
            style:
            TextStyle(
              color: isCredit
                  ? const Color(
                0xFF159447,
              )
                  : Colors.black,
              fontSize: 11,
              fontWeight:
              FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}