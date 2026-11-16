import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/lead.dart';
import '../../domain/leads_repository.dart';

part 'lead_form_state.dart';

class LeadFormCubit extends Cubit<LeadFormState> {
  LeadFormCubit(this._repository) : super(const LeadFormState());

  final LeadsRepository _repository;

  Future<void> loadLead(int id) async {
    emit(state.copyWith(status: LeadFormStatus.loading, clearError: true));

    try {
      final lead = await _repository.getLeadById(id);
      if (lead == null) {
        emit(
          state.copyWith(
            status: LeadFormStatus.failure,
            errorMessage: 'Lead not found.',
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: LeadFormStatus.ready,
          lead: lead,
          clearError: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: LeadFormStatus.failure,
          errorMessage: 'Could not load the lead.',
        ),
      );
    }
  }

  Future<void> saveLead(LeadDraft draft, {int? id}) async {
    emit(state.copyWith(status: LeadFormStatus.saving, clearError: true));

    try {
      await _repository.saveLead(draft, id: id);
      emit(state.copyWith(status: LeadFormStatus.success, clearError: true));
    } on FormatException catch (error) {
      emit(
        state.copyWith(
          status: LeadFormStatus.failure,
          errorMessage: error.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: LeadFormStatus.failure,
          errorMessage: 'Could not save the lead.',
        ),
      );
    }
  }
}
