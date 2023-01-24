class OdrsException implements Exception {
  const OdrsException(this.message);

  final String message;

  @override
  String toString() => 'ODRS: $message';
}
