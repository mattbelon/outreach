part of 'leads_list_cubit.dart';

enum LeadsListStatus { loading, success, failure }

class LeadsListState extends Equatable {
  const LeadsListState({
    this.status = LeadsListStatus.loading,
    this.leads = const <Lead>[],
    this.query = '',
    this.selectedLeadIds = const <int>{},
    this.selectedStatus,
    this.errorMessage,
    this.lastImportResult,
  });

  final LeadsListStatus status;
  final List<Lead> leads;
  final String query;
  final Set<int> selectedLeadIds;
  final LeadStatus? selectedStatus;
  final String? errorMessage;
  final LeadsCsvImportResult? lastImportResult;

  bool get isLoading => status == LeadsListStatus.loading;
  bool get isEmpty => !isLoading && leads.isEmpty;
  bool get hasSelection => selectedLeadIds.isNotEmpty;
  int get selectedCount => selectedLeadIds.length;

  LeadsListState copyWith({
    LeadsListStatus? status,
    List<Lead>? leads,
    String? query,
    Set<int>? selectedLeadIds,
    LeadStatus? selectedStatus,
    String? errorMessage,
    LeadsCsvImportResult? lastImportResult,
    bool clearSelectedStatus = false,
    bool clearError = false,
  }) {
    return LeadsListState(
      status: status ?? this.status,
      leads: leads ?? this.leads,
      query: query ?? this.query,
      selectedLeadIds: selectedLeadIds ?? this.selectedLeadIds,
      selectedStatus: clearSelectedStatus
          ? null
          : (selectedStatus ?? this.selectedStatus),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastImportResult: lastImportResult ?? this.lastImportResult,
    );
  }

  @override
  List<Object?> get props => [
    status,
    leads,
    query,
    selectedLeadIds,
    selectedStatus,
    errorMessage,
    lastImportResult,
  ];
}
