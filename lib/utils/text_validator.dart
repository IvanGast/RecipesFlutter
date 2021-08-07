class TextValidator {
  static String isBigger(String _value, int minSize) {
    return _value != null && _value.trim().length > minSize
        ? null
        : "Must be at least $minSize characters long";
  }

  static String containsOnlyLetters(String _value) {
    Pattern pattern = r"^[a-zA-Z]*$";
    RegExp regex = new RegExp(pattern);
    if (_value == null || _value.trim().isNotEmpty || !regex.hasMatch(_value))
      return null;
    else
      return "Text must contain only letters";
  }
}
