abstract final class FormatUtils {
  static String formatValue(dynamic value) {
    final String cleanValue = value
        .toString()
        .replaceAll('.', ',')
        .replaceAll(' ', '');
    return cleanValue;
  }
}
