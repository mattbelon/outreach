import 'package:flutter_test/flutter_test.dart';
import 'package:outreach_flutter/features/leads/domain/lead.dart';

void main() {
  group('LeadDraft', () {
    test('is valid when company and email are correct', () {
      const draft = LeadDraft(
        companyName: 'Acme Inc',
        email: 'hello@acme.com',
        status: LeadStatus.pending,
      );

      expect(draft.isValid, isTrue);
    });

    test('is invalid when email is malformed', () {
      const draft = LeadDraft(
        companyName: 'Acme Inc',
        email: 'invalid-email',
        status: LeadStatus.pending,
      );

      expect(draft.isValid, isFalse);
    });
  });
}
