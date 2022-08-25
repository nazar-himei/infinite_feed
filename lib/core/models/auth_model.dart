/// [CheckAuthModel] model for auth user.
class CheckAuthModel {
  const CheckAuthModel({
    required this.message,
  });

  factory CheckAuthModel.fromMap(Map<String, dynamic> map) {
    return CheckAuthModel(
      message: map['message'],
    );
  }

  final String? message;
}
