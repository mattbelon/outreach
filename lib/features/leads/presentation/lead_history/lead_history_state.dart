part of 'lead_history_cubit.dart';

enum LeadHistoryStatus { initial, loading, success, failure }

class LeadHistoryState extends Equatable {
  const LeadHistoryState({
    this.status = LeadHistoryStatus.initial,
    this.entries = const <LeadHistoryEntry>[],
    this.errorMessage,
  });

  final LeadHistoryStatus status;
  final List<LeadHistoryEntry> entries;
  final String? errorMessage;

  LeadHistoryState copyWith({
    LeadHistoryStatus? status,
    List<LeadHistoryEntry>? entries,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LeadHistoryState(
      status: status ?? this.status,
      entries: entries ?? this.entries,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, entries, errorMessage];
}
