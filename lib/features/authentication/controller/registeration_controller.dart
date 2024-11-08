class RegisterController {
  ///checking the email is valid or not
  ///[value]=entered email
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a username or E-mail';
    }

    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid E-mail address';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  static String? validateConfirmPassword(
      String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.trim().isEmpty) {
      return 'Confirm Password is required';
    }

    if (password != confirmPassword) {
      return 'Password does not match';
    }
    return null;
  }

//register page on tap
  static void registerPageOnTap() {}
}
