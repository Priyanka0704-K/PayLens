import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';
import 'analyzing_payments_screen.dart';
class UploadStatementScreen extends StatefulWidget {
  const UploadStatementScreen({super.key});

  @override
  State<UploadStatementScreen> createState() =>
      _UploadStatementScreenState();
}

class _UploadStatementScreenState extends State<UploadStatementScreen> {
  static const Color primaryBlue = Color(0xFF2222C8);
  static const Color backgroundColor = Color(0xFFF7F8FC);

  XFile? selectedFile;

  // ------------------------------------------------------------
  // PICK PDF
  // ------------------------------------------------------------

  Future<void> _pickPdf() async {
    try {
      const XTypeGroup pdfType = XTypeGroup(
        label: 'PDF files',
        extensions: <String>['pdf'],
      );

      final XFile? file = await openFile(
        acceptedTypeGroups: <XTypeGroup>[pdfType],
      );

      if (file == null) {
        return;
      }

      final String fileName = file.name.toLowerCase();

      if (!fileName.endsWith('.pdf')) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a PDF file.'),
          ),
        );

        return;
      }

      setState(() {
        selectedFile = file;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to select PDF: $e'),
        ),
      );
    }
  }

  // ------------------------------------------------------------
  // VIEW PDF
  // ------------------------------------------------------------

  Future<void> _viewPdf() async {
    if (selectedFile == null) return;

    try {
      if (kIsWeb) {
        final Uri uri = Uri.parse(selectedFile!.path);

        final bool opened = await launchUrl(
          uri,
          webOnlyWindowName: '_blank',
        );

        if (!opened && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to open PDF in browser.'),
            ),
          );
        }
      } else {
        await OpenFilex.open(selectedFile!.path);
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to open PDF: $e'),
        ),
      );
    }
  }

  // ------------------------------------------------------------
  // REMOVE PDF
  // ------------------------------------------------------------

  void _removePdf() {
    setState(() {
      selectedFile = null;
    });
  }

  // ------------------------------------------------------------
  // ANALYZE PDF
  // ------------------------------------------------------------

  void _analyzeStatement() {
    if (selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a PDF statement first.'),
        ),
      );

      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AnalyzingPaymentsScreen(
          file: selectedFile!,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // PAYLENS LOGO
  // ------------------------------------------------------------

  Widget _payLensLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/paylens_logo.png',
          width: 30,
          height: 30,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) {
            return Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: primaryBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.account_balance_wallet_rounded,
                color: Colors.white,
                size: 18,
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Pay',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: 'Lens',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: primaryBlue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // FILE READY CARD
  // ------------------------------------------------------------

  Widget _selectedPdfCard() {
    if (selectedFile == null) {
      return _uploadBox();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        14,
        12,
        14,
        10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE0E0EA),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'PDF ready',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          // FILE NAME
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8FC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFE5E5EF),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.description_outlined,
                  color: primaryBlue,
                  size: 20,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    selectedFile!.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF555555),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // VIEW + CHANGE BUTTONS
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 34,
                  child: OutlinedButton.icon(
                    onPressed: _viewPdf,
                    icon: const Icon(
                      Icons.visibility_outlined,
                      size: 17,
                      color: primaryBlue,
                    ),
                    label: const Text(
                      'View PDF',
                      style: TextStyle(
                        color: primaryBlue,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: primaryBlue,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: SizedBox(
                  height: 34,
                  child: OutlinedButton.icon(
                    onPressed: _pickPdf,
                    icon: const Icon(
                      Icons.change_circle_outlined,
                      size: 17,
                      color: Color(0xFF666666),
                    ),
                    label: const Text(
                      'Change',
                      style: TextStyle(
                        color: Color(0xFF555555),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFFD5D5D5),
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // REMOVE PDF
          TextButton(
            onPressed: _removePdf,
            style: TextButton.styleFrom(
              minimumSize: const Size(0, 28),
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Remove PDF',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // UPLOAD BOX
  // ------------------------------------------------------------

  Widget _uploadBox() {
    return GestureDetector(
      onTap: _pickPdf,
      child: Container(
        width: double.infinity,
        height: 190,
        decoration: BoxDecoration(
          color: const Color(0xFFFCF9FF),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFF9B5CFF),
            width: 1.7,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: const Color(0xFFEFE3FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.upload_file_rounded,
                color: Color(0xFF5520A8),
                size: 30,
              ),
            ),

            const SizedBox(height: 13),

            const Text(
              'Tap to browse files',
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              'Select your bank statement PDF',
              style: TextStyle(
                color: Color(0xFF777777),
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'PDF only  •  Maximum file size: 10 MB',
              style: TextStyle(
                color: Color(0xFF999999),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // LOCAL ANALYSIS CARD
  // ------------------------------------------------------------

  Widget _securityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF1FFF3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF8ED79A),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              color: Color(0xFF3B9B4A),
              size: 19,
            ),
          ),

          const SizedBox(width: 10),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Analyzed locally',
                  style: TextStyle(
                    color: Color(0xFF267535),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Your statement is processed locally to detect '
                      'recurring subscription patterns. Raw transaction '
                      'data is never stored or shared.',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF4F7155),
                    fontSize: 10,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // ANALYZE BUTTON
  // ------------------------------------------------------------

  Widget _analyzeButton() {
    final bool enabled = selectedFile != null;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: enabled ? _analyzeStatement : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
          enabled ? primaryBlue : const Color(0xFFE1E1E8),
          foregroundColor: Colors.white,
          disabledForegroundColor: const Color(0xFF8B8B95),
          disabledBackgroundColor: const Color(0xFFE1E1E8),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 20,
              color: enabled
                  ? Colors.white
                  : const Color(0xFF8B8B95),
            ),
            const SizedBox(width: 8),
            Text(
              enabled
                  ? 'Analyze Statement'
                  : 'Upload a statement to continue',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: enabled
                    ? Colors.white
                    : const Color(0xFF8B8B95),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool compact = constraints.maxHeight < 650;

            return Column(
              children: [
                // ------------------------------------------------
                // HEADER
                // ------------------------------------------------
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    18,
                    compact ? 8 : 14,
                    18,
                    8,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 34,
                          minHeight: 34,
                        ),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(width: 5),

                      Expanded(
                        child: _payLensLogo(),
                      ),

                    ],
                  ),
                ),

                // ------------------------------------------------
                // TITLE
                // ------------------------------------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    children: [
                      Text(
                        'Upload Statement',
                        style: TextStyle(
                          fontSize: compact ? 23 : 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Import your bank statement to find subscriptions',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF777777),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: compact ? 12 : 18),

                // ------------------------------------------------
                // MAIN CONTENT
                // ------------------------------------------------
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                    ),
                    child: Column(
                      children: [
                        // PDF SELECT / READY
                        _selectedPdfCard(),

                        SizedBox(height: compact ? 10 : 14),

                        // SECURITY
                        _securityCard(),

                        const Spacer(),

                        // ANALYZE BUTTON
                        _analyzeButton(),

                        SizedBox(height: compact ? 10 : 16),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}