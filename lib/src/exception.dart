enum OdrsError {
  invalidString,
  accountDisabled,
  negativeKarma,
  alreadyReviewed,
  alreadyVoted,
  longDescription,
  shortDescription,
  invalidData,
  invalidReviewId,
  invalidUserSkey,
  missingData,
  noReview,
  noUser,
  tabooWord,
  longSummary,
  shortSummary,
  invalidAppId,
  invalidUserHash,
  unknown,
}

class OdrsException implements Exception {
  const OdrsException._(this.error, this.message);

  factory OdrsException(String message) {
    OdrsError parse(String message) {
      if (message.endsWith(' is not a valid string')) {
        return OdrsError.invalidString;
      } else if (message.startsWith('invalid data, expected ')) {
        return OdrsError.invalidData;
      } else if (message.startsWith('missing data, expected ')) {
        return OdrsError.missingData;
      } else if (message.startsWith('no user for ')) {
        return OdrsError.noUser;
      } else {
        return OdrsError.unknown;
      }
    }

    final error = switch (message) {
      'account has been disabled due to abuse' => OdrsError.accountDisabled,
      'all negative karma used up' => OdrsError.negativeKarma,
      'already reviewed this app' => OdrsError.alreadyReviewed,
      'already voted on this app' => OdrsError.alreadyVoted,
      'description is too long' => OdrsError.longDescription,
      'description is too short' => OdrsError.shortDescription,
      'invalid review ID' => OdrsError.invalidReviewId,
      'invalid user_skey' => OdrsError.invalidUserSkey,
      'no review' => OdrsError.noReview,
      'review contains taboo word' => OdrsError.tabooWord,
      'summary is too long' => OdrsError.longSummary,
      'summary is too short' => OdrsError.shortSummary,
      'the app_id is invalid' => OdrsError.invalidAppId,
      'the user_hash is invalid' => OdrsError.invalidUserHash,
      _ => parse(message),
    };
    return OdrsException._(error, message);
  }

  final OdrsError error;
  final String message;

  @override
  String toString() => 'ODRS: $message';
}
