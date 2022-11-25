bool validateEmail({required String email}) {
  RegExp pattern = RegExp(r'\w*@up.edu.ph');
  if (!pattern.hasMatch(email)) {
    return false;
  }

  return true;
}
