abstract class ApiService {
  /// Sends OTP to the specified phone number.
  Future<Map<String, dynamic>> sendOtp(String phone);

  /// Verifies the OTP sent to the phone number.
  Future<Map<String, dynamic>> verifyOtp(String phone, String otp);

  /// Sets a new 4-digit security PIN.
  Future<Map<String, dynamic>> setPin(String pin);

  /// Logs in the user with their phone number and PIN.
  Future<Map<String, dynamic>> login(String phone, String pin);

  /// Retrieves the list of products and brands.
  Future<Map<String, dynamic>> getProducts();

  /// Retrieves the details for a specific product.
  Future<Map<String, dynamic>> getProductDetails(int id);

  /// Retrieves the list of branches.
  Future<Map<String, dynamic>> getBranches();

  /// Uploads multiple files to the server.
  Future<Map<String, dynamic>> uploadMultipleFiles(
    List<String> filePaths,
    String folder,
  );

  /// Places a new order on the server.
  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> orderData);

  /// Logs out the user and invalidates the session token.
  Future<Map<String, dynamic>> logout();
}
