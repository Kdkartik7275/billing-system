import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


class PdfFonts {
  static pw.ThemeData? _theme;

  static Future<pw.ThemeData> theme() async {
    return _theme ??= pw.ThemeData.withFont(
      base: await PdfGoogleFonts.notoSansRegular(),
      bold: await PdfGoogleFonts.notoSansBold(),
    );
  }
}