import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../data/csv_leads_importer.dart';
import '../../domain/lead.dart';
import '../../domain/leads_repository.dart';

part 'leads_list_state.dart';

class LeadsListCubit extends Cubit<LeadsListState> {
  LeadsListCubit(this._repository) : super(const LeadsListState());

  final LeadsRepository _repository;
  StreamSubscription<List<Lead>>? _subscription;
  Timer? _queryDebounce;

  void initialize() {
    _subscribe();
  }

  Future<void> deleteLead(int id) async {
    try {
      await _repository.deleteLead(id);
      final selectedLeadIds = Set<int>.from(state.selectedLeadIds)..remove(id);
      emit(state.copyWith(selectedLeadIds: selectedLeadIds));
    } catch (_) {
      emit(
        state.copyWith(
          status: LeadsListStatus.failure,
          errorMessage: 'Could not delete the lead.',
        ),
      );
    }
  }

  Future<void> markAsSent(Lead lead) async {
    try {
      await _repository.markAsSent(lead);
    } catch (_) {
      emit(
        state.copyWith(
          status: LeadsListStatus.failure,
          errorMessage: 'Could not update the lead.',
        ),
      );
    }
  }

  Future<int> importCsv(String csvContent) async {
    return importCsvWithSummary(
      csvContent,
    ).then((result) => result.importedCount);
  }

  Future<CsvLeadsImportParseResult> previewCsvImport(String csvContent) async {
    return compute(parseCsvLeadsImport, csvContent);
  }

  Future<LeadsCsvImportResult> importParsedCsv(
    CsvLeadsImportParseResult parseResult, {
    LeadImportMode mode = LeadImportMode.insertOnly,
  }) async {
    try {
      final importedCount = await _repository.importLeads(
        parseResult.drafts,
        mode: mode,
      );

      final result = LeadsCsvImportResult(
        importedCount: importedCount,
        skippedEmptyRows: parseResult.skippedEmptyRows,
        rowErrors: parseResult.rowErrors,
        mode: mode,
      );

      emit(state.copyWith(lastImportResult: result, clearError: true));

      return result;
    } catch (_) {
      emit(
        state.copyWith(
          status: LeadsListStatus.failure,
          errorMessage: 'Could not import the CSV file.',
        ),
      );
      return const LeadsCsvImportResult(
        importedCount: 0,
        skippedEmptyRows: 0,
        rowErrors: <CsvLeadImportRowError>[],
      );
    }
  }

  Future<LeadsCsvImportResult> importCsvWithSummary(String csvContent) async {
    try {
      final parseResult = await previewCsvImport(csvContent);
      return importParsedCsv(parseResult);
    } on FormatException catch (error) {
      emit(
        state.copyWith(
          status: LeadsListStatus.failure,
          errorMessage: error.message,
        ),
      );
      return const LeadsCsvImportResult(
        importedCount: 0,
        skippedEmptyRows: 0,
        rowErrors: <CsvLeadImportRowError>[],
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: LeadsListStatus.failure,
          errorMessage: 'Could not import the CSV file.',
        ),
      );
      return const LeadsCsvImportResult(
        importedCount: 0,
        skippedEmptyRows: 0,
        rowErrors: <CsvLeadImportRowError>[],
      );
    }
  }

  void toggleLeadSelection(Lead lead) {
    final leadId = lead.id;
    if (leadId == null) {
      return;
    }

    final selectedLeadIds = Set<int>.from(state.selectedLeadIds);
    if (selectedLeadIds.contains(leadId)) {
      selectedLeadIds.remove(leadId);
    } else {
      selectedLeadIds.add(leadId);
    }

    emit(state.copyWith(selectedLeadIds: selectedLeadIds));
  }

  void toggleSelectAllVisible() {
    final visibleLeads = state.leads
        .where((lead) => lead.id != null)
        .toList(growable: false);
    final visibleIds = visibleLeads.map((lead) => lead.id!).toSet();
    final selectedLeadIds = Set<int>.from(state.selectedLeadIds);
    final allVisibleSelected =
        visibleIds.isNotEmpty && visibleIds.every(selectedLeadIds.contains);

    if (allVisibleSelected) {
      selectedLeadIds.removeAll(visibleIds);
    } else {
      selectedLeadIds.addAll(visibleIds);
    }

    emit(state.copyWith(selectedLeadIds: selectedLeadIds));
  }

  void clearSelection() {
    emit(state.copyWith(selectedLeadIds: <int>{}));
  }

  void setQuery(String query) {
    emit(
      state.copyWith(
        query: query,
        status: LeadsListStatus.loading,
        clearError: true,
      ),
    );
    _queryDebounce?.cancel();
    _queryDebounce = Timer(const Duration(milliseconds: 250), _subscribe);
  }

  void setStatus(LeadStatus? status) {
    emit(
      state.copyWith(
        selectedStatus: status,
        clearSelectedStatus: status == null,
        status: LeadsListStatus.loading,
        clearError: true,
      ),
    );
    _subscribe();
  }

  void clearMessage() {
    emit(state.copyWith(clearError: true));
  }

  void _subscribe() {
    _subscription?.cancel();
    _subscription = _repository
        .watchLeads(query: state.query, status: state.selectedStatus)
        .listen(
          (leads) {
            emit(
              state.copyWith(
                status: LeadsListStatus.success,
                leads: leads,
                clearError: true,
              ),
            );
          },
          onError: (error, stackTrace) {
            emit(
              state.copyWith(
                status: LeadsListStatus.failure,
                errorMessage: 'Could not load leads.',
              ),
            );
          },
        );
  }

  @override
  Future<void> close() async {
    _queryDebounce?.cancel();
    await _subscription?.cancel();
    return super.close();
  }

  Future<List<Lead>> getLeadsForExport() async {
    if (!state.hasSelection) {
      return state.leads;
    }

    return _repository.getLeadsByIds(
      state.selectedLeadIds.toList(growable: false),
    );
  }
}

class LeadsCsvImportResult extends Equatable {
  const LeadsCsvImportResult({
    required this.importedCount,
    required this.skippedEmptyRows,
    required this.rowErrors,
    this.mode = LeadImportMode.insertOnly,
  });

  final int importedCount;
  final int skippedEmptyRows;
  final List<CsvLeadImportRowError> rowErrors;
  final LeadImportMode mode;

  int get skippedInvalidRows => rowErrors.length;

  bool get hasDetails => skippedEmptyRows > 0 || rowErrors.isNotEmpty;

  @override
  List<Object?> get props => [importedCount, skippedEmptyRows, rowErrors, mode];
}
