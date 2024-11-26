class AuthService {
  // Mock authentication service
  // In a real app, this would interact with backend services
  static Future<bool> login(String email, String password) async {
    // Simulated login logic
    await Future.delayed(const Duration(seconds: 1));
    return email.isNotEmpty && password.isNotEmpty;
  }

  static Future<bool> signup(String name, String email, String password) async {
    // Simulated signup logic
    await Future.delayed(const Duration(seconds: 1));
    return email.isNotEmpty && password.isNotEmpty && name.isNotEmpty;
  }

  static Future<bool> resetPassword(String email) async {
    // Simulated password reset logic
    await Future.delayed(const Duration(seconds: 1));
    return email.isNotEmpty;
  }

  static Future<void> logout() async {
    // Simulated logout logic
    await Future.delayed(const Duration(seconds: 1));
  }
}