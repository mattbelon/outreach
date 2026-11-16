part of 'lead_form_cubit.dart';

enum LeadFormStatus { ready, loading, saving, success, failure }

class LeadFormState extends Equatable {
  const LeadFormState({
    this.status = LeadFormStatus.ready,
    this.lead,
    this.errorMessage,
  });

  final LeadFormStatus status;
  final Lead? lead;
  final String? errorMessage;

  bool get isSaving => status == LeadFormStatus.saving;
  bool get isLoading => status == LeadFormStatus.loading;

  LeadFormState copyWith({
    LeadFormStatus? status,
    Lead? lead,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LeadFormState(
      status: status ?? this.status,
      lead: lead ?? this.lead,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, lead, errorMessage];
}
