import 'package:meta/meta.dart';

@immutable
class OdrsException implements Exception {
  const OdrsException(this.message);

  final String message;

  @override
  String toString() => 'OdrsException: $message';

  @override
  int get hashCode => message.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OdrsException && other.message == message;
  }
}
