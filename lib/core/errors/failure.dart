class Failure implements Exception {
  final String message;
  const Failure([this.message = 'Terjadi kesalahan. Silakan coba lagi.']);

  @override
  String toString() => message;
}