import 'package:odrs/odrs.dart';
import 'package:test/test.dart';

void main() {
  test('odrs errors', () {
    expect(
      OdrsException('account has been disabled due to abuse').error,
      OdrsError.accountDisabled,
    );
    expect(
      OdrsException('all negative karma used up').error,
      OdrsError.negativeKarma,
    );
    expect(
      OdrsException('already reviewed this app').error,
      OdrsError.alreadyReviewed,
    );
    expect(
      OdrsException('already voted on this app').error,
      OdrsError.alreadyVoted,
    );
    expect(
      OdrsException('description is too long').error,
      OdrsError.longDescription,
    );
    expect(
      OdrsException('description is too short').error,
      OdrsError.shortDescription,
    );
    expect(
      OdrsException('invalid review ID').error,
      OdrsError.invalidReviewId,
    );
    expect(
      OdrsException('invalid user_skey').error,
      OdrsError.invalidUserSkey,
    );
    expect(
      OdrsException('no review').error,
      OdrsError.noReview,
    );
    expect(
      OdrsException('review contains taboo word').error,
      OdrsError.tabooWord,
    );
    expect(
      OdrsException('summary is too long').error,
      OdrsError.longSummary,
    );
    expect(
      OdrsException('summary is too short').error,
      OdrsError.shortSummary,
    );
    expect(
      OdrsException('the app_id is invalid').error,
      OdrsError.invalidAppId,
    );
    expect(
      OdrsException('the user_hash is invalid').error,
      OdrsError.invalidUserHash,
    );
    expect(
      OdrsException('foo is not a valid string').error,
      OdrsError.invalidString,
    );
    expect(
      OdrsException('invalid data, expected foo').error,
      OdrsError.invalidData,
    );
    expect(
      OdrsException('missing data, expected foo').error,
      OdrsError.missingData,
    );
    expect(
      OdrsException('no user for foo').error,
      OdrsError.noUser,
    );
    expect(
      OdrsException('foo').error,
      OdrsError.unknown,
    );
  });
}
