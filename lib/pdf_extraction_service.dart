import 'package:file_selector/file_selector.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfExtractionService {
  static Future<String> extractText(XFile file) async {
    final bytes = await file.readAsBytes();

    if (bytes.isEmpty) {
      throw Exception('Selected PDF is empty.');
    }

    final document = PdfDocument(
      inputBytes: bytes,
    );

    try {
      final extractor = PdfTextExtractor(document);
      final buffer = StringBuffer();

      for (int i = 0; i < document.pages.count; i++) {
        final pageText = extractor.extractText(
          startPageIndex: i,
          endPageIndex: i,
        );

        buffer.writeln(pageText);
      }

      return buffer.toString();
    } finally {
      document.dispose();
    }
  }
}