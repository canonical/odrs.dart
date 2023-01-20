import 'package:meta/meta.dart';

@immutable
class OdrsRating {
  const OdrsRating({
    required this.star0,
    required this.star1,
    required this.star2,
    required this.star3,
    required this.star4,
    required this.star5,
    required this.total,
  });

  final int star0;
  final int star1;
  final int star2;
  final int star3;
  final int star4;
  final int star5;
  final int total;

  factory OdrsRating.fromJson(Map<String, dynamic> json) {
    return OdrsRating(
      star0: json['star0'] as int,
      star1: json['star1'] as int,
      star2: json['star2'] as int,
      star3: json['star3'] as int,
      star4: json['star4'] as int,
      star5: json['star5'] as int,
      total: json['total'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'star0': star0,
      'star1': star1,
      'star2': star2,
      'star3': star3,
      'star4': star4,
      'star5': star5,
      'total': total,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OdrsRating &&
        other.star0 == star0 &&
        other.star1 == star1 &&
        other.star2 == star2 &&
        other.star3 == star3 &&
        other.star4 == star4 &&
        other.star5 == star5 &&
        other.total == total;
  }

  @override
  int get hashCode {
    return Object.hash(star0, star1, star2, star3, star4, star5, total);
  }

  @override
  String toString() {
    return 'OdrsRating(star0: $star0, star1: $star1, star2: $star2, star3: $star3, star4: $star4, star5: $star5, total: $total)';
  }
}
