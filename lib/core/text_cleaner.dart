class TextCleaner {
  static String cleanStringForTTS(String input) {
    // Remove emojis and symbols
    String cleanedText = input.replaceAll(RegExp(r'[^\w\s.,!?]'), '');

    // Replace unwanted characters (dashes, underscores) with spaces
    cleanedText = cleanedText.replaceAll(RegExp(r'[-_]'), ' ');

    // Trim extra spaces
    cleanedText = cleanedText.replaceAll(RegExp(r'\s+'), ' ').trim();

    return cleanedText;
  }
}