/// Returns the initials for a given name.
/// 
/// For example:
/// "John Doe" => "JD"
/// "Alice" => "AL"
/// "Bob A. Smith" => "BS"
/// "RivalMoon" => "RM"
/// If the name is empty, returns an empty string.
String getInitials(String name) {
  if (name.isEmpty) return '';

  final parts = name.trim().split(RegExp(r'\s+'));
  // Handle "Alice" and "RivalMoon" cases
  if (parts.length == 1) {
    final singlePart = parts[0];
    if (singlePart.length >= 2) {
      if (singlePart.contains(RegExp(r'[A-Z]'))) {
        // If there are uppercase letters, take the first two uppercase letters
        final initials = singlePart
            .split('')
            .where((char) => RegExp(r'[A-Z]').hasMatch(char))
            .take(2)
            .join();
        return initials.toUpperCase();
      } else {
        // Otherwise, take the first two letters
        return singlePart.substring(0, 2).toUpperCase();
      }
    } else {
      return singlePart[0].toUpperCase();
    }
  // Handle "John Doe" and "Bob A. Smith" cases
  } else {
    final firstInitial = parts.first[0];
    final lastInitial = parts.last[0];
    return (firstInitial + lastInitial).toUpperCase();
  }
}
