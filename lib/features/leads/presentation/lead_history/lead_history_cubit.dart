import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/lead.dart';
import '../../domain/leads_repository.dart';

part 'lead_history_state.dart';

class LeadHistoryCubit extends Cubit<LeadHistoryState> {
  LeadHistoryCubit(this._repository) : super(const LeadHistoryState());

  final LeadsRepository _repository;
  StreamSubscription<List<LeadHistoryEntry>>? _subscription;

  void watchHistory(int leadId) {
    emit(state.copyWith(status: LeadHistoryStatus.loading));
    _subscription?.cancel();
    _subscription = _repository
        .watchLeadHistory(leadId)
        .listen(
          (entries) {
            emit(
              state.copyWith(
                status: LeadHistoryStatus.success,
                entries: entries,
                clearError: true,
              ),
            );
          },
          onError: (error, stackTrace) {
            emit(
              state.copyWith(
                status: LeadHistoryStatus.failure,
                errorMessage: 'Could not load lead history.',
              ),
            );
          },
        );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
