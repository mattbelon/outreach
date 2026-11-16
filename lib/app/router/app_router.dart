import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/leads/domain/leads_repository.dart';
import '../../features/leads/presentation/lead_form/lead_form_cubit.dart';
import '../../features/leads/presentation/lead_form/lead_form_page.dart';
import '../../features/leads/presentation/lead_history/lead_history_cubit.dart';
import '../../features/leads/presentation/leads_list/leads_list_cubit.dart';
import '../../features/leads/presentation/leads_list/leads_page.dart';

class AppRouter {
  AppRouter(this._repository);

  final LeadsRepository _repository;

  late final GoRouter router = GoRouter(
    initialLocation: '/leads',
    routes: [
      GoRoute(
        path: '/leads',
        builder: (context, state) => BlocProvider(
          create: (_) => LeadsListCubit(_repository)..initialize(),
          child: const LeadsPage(),
        ),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => BlocProvider(
              create: (_) => LeadFormCubit(_repository),
              child: const LeadFormPage(),
            ),
          ),
          GoRoute(
            path: ':id/edit',
            builder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) => LeadFormCubit(_repository)..loadLead(id),
                  ),
                  BlocProvider(
                    create: (_) =>
                        LeadHistoryCubit(_repository)..watchHistory(id),
                  ),
                ],
                child: LeadFormPage(leadId: id),
              );
            },
          ),
        ],
      ),
    ],
  );
}
