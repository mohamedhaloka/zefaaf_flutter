bool containsNoUrlOrPhoneNumber(String text) {
  // Regular expression for URL
  const urlPattern = r'((https?|ftp)://[^\s/$.?#].[^\s]*)';
  // Regular expression for phone number (simple version)
  const phonePattern =
      r'(\+?\d{1,4}[-.\s]?)?(\(?\d{1,4}\)?[-.\s]?)?(\d{1,4}[-.\s]?){1,5}';

  final urlRegex = RegExp(urlPattern, caseSensitive: false);
  final phoneRegex = RegExp(phonePattern);

  if (urlRegex.hasMatch(text) || phoneRegex.hasMatch(text)) {
    return false;
  }

  return true;
}
