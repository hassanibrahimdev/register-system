class ResetPasswordModel {
  final String id;
  final String password;
  final String confirmPassword;

  ResetPasswordModel({
    required this.id,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {"id": id, "password": password, "confirmPassword": confirmPassword};
  }
}
