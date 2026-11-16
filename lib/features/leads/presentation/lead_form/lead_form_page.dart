import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/lead.dart';
import '../lead_history/lead_history_cubit.dart';
import 'lead_form_cubit.dart';

class LeadFormPage extends StatefulWidget {
  const LeadFormPage({this.leadId, super.key});

  final int? leadId;

  @override
  State<LeadFormPage> createState() => _LeadFormPageState();
}

class _LeadFormPageState extends State<LeadFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _companyController;
  late final TextEditingController _contactController;
  late final TextEditingController _emailController;
  late final TextEditingController _websiteController;
  late final TextEditingController _notesController;

  LeadStatus _selectedStatus = LeadStatus.pending;
  DateTime? _sentAt;
  DateTime? _repliedAt;
  bool _didHydrate = false;

  @override
  void initState() {
    super.initState();
    _companyController = TextEditingController();
    _contactController = TextEditingController();
    _emailController = TextEditingController();
    _websiteController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _companyController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LeadFormCubit, LeadFormState>(
      listener: (context, state) {
        if (!_didHydrate && state.lead != null) {
          _hydrateForm(state.lead!);
        }

        if (state.status == LeadFormStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.leadId == null ? 'Lead created.' : 'Lead updated.',
              ),
            ),
          );
          context.go('/leads');
        }

        if (state.status == LeadFormStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        final isEditing = widget.leadId != null;

        return Scaffold(
          appBar: AppBar(title: Text(isEditing ? 'Edit lead' : 'New lead')),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                controller: _companyController,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  labelText: 'Company name',
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Company name is required.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _contactController,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  labelText: 'Contact name',
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                ),
                                validator: (value) {
                                  final email = value?.trim() ?? '';
                                  final emailRegex = RegExp(
                                    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                  );
                                  if (!emailRegex.hasMatch(email)) {
                                    return 'Enter a valid email.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _websiteController,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  labelText: 'Website',
                                ),
                              ),
                              const SizedBox(height: 12),
                              DropdownButtonFormField<LeadStatus>(
                                initialValue: _selectedStatus,
                                decoration: const InputDecoration(
                                  labelText: 'Status',
                                ),
                                items: LeadStatus.values
                                    .map(
                                      (status) => DropdownMenuItem(
                                        value: status,
                                        child: Text(status.label),
                                      ),
                                    )
                                    .toList(growable: false),
                                onChanged: (status) {
                                  if (status == null) {
                                    return;
                                  }

                                  setState(() {
                                    _selectedStatus = status;
                                  });
                                },
                              ),
                              const SizedBox(height: 12),
                              _DateField(
                                label: 'Sent date',
                                value: _sentAt,
                                onTap: () => _pickDate(
                                  context,
                                  initialDate: _sentAt,
                                  onDateSelected: (value) {
                                    setState(() {
                                      _sentAt = value;
                                    });
                                  },
                                ),
                                onClear: _sentAt == null
                                    ? null
                                    : () {
                                        setState(() {
                                          _sentAt = null;
                                        });
                                      },
                              ),
                              const SizedBox(height: 12),
                              _DateField(
                                label: 'Reply date',
                                value: _repliedAt,
                                onTap: () => _pickDate(
                                  context,
                                  initialDate: _repliedAt,
                                  onDateSelected: (value) {
                                    setState(() {
                                      _repliedAt = value;
                                    });
                                  },
                                ),
                                onClear: _repliedAt == null
                                    ? null
                                    : () {
                                        setState(() {
                                          _repliedAt = null;
                                        });
                                      },
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _notesController,
                                minLines: 4,
                                maxLines: 6,
                                decoration: const InputDecoration(
                                  labelText: 'Notes',
                                  alignLabelWithHint: true,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: state.isSaving
                                          ? null
                                          : () => context.go('/leads'),
                                      child: const Text('Cancel'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: FilledButton(
                                      onPressed: state.isSaving
                                          ? null
                                          : _submit,
                                      child: state.isSaving
                                          ? const SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : Text(
                                              isEditing
                                                  ? 'Save changes'
                                                  : 'Create lead',
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                              if (isEditing) ...[
                                const SizedBox(height: 24),
                                const _LeadHistorySection(),
                              ],
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _hydrateForm(Lead lead) {
    _companyController.text = lead.companyName;
    _contactController.text = lead.contactName ?? '';
    _emailController.text = lead.email;
    _websiteController.text = lead.website ?? '';
    _notesController.text = lead.notes ?? '';
    _selectedStatus = lead.status;
    _sentAt = lead.sentAt;
    _repliedAt = lead.repliedAt;
    _didHydrate = true;
  }

  Future<void> _pickDate(
    BuildContext context, {
    required DateTime? initialDate,
    required ValueChanged<DateTime> onDateSelected,
  }) async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 5),
      initialDate: initialDate ?? now,
    );

    if (selected != null) {
      onDateSelected(selected);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final draft = LeadDraft(
      companyName: _companyController.text,
      contactName: _contactController.text,
      email: _emailController.text,
      website: _websiteController.text,
      status: _selectedStatus,
      sentAt: _sentAt,
      repliedAt: _repliedAt,
      notes: _notesController.text,
    );

    context.read<LeadFormCubit>().saveLead(draft, id: widget.leadId);
  }
}

class _LeadHistorySection extends StatelessWidget {
  const _LeadHistorySection();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<LeadHistoryCubit, LeadHistoryState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('History', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                if (state.status == LeadHistoryStatus.loading)
                  const Center(child: CircularProgressIndicator())
                else if (state.status == LeadHistoryStatus.failure)
                  Text(state.errorMessage ?? 'Could not load history.')
                else if (state.entries.isEmpty)
                  const Text('No history yet.')
                else
                  ...state.entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Chip(label: Text(entry.action.label)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(entry.summary),
                                const SizedBox(height: 2),
                                Text(
                                  _formatHistoryTimestamp(
                                    context,
                                    entry.createdAt,
                                  ),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

String _formatHistoryTimestamp(BuildContext context, DateTime value) {
  final localizations = MaterialLocalizations.of(context);
  final timeOfDay = TimeOfDay.fromDateTime(value);
  return '${localizations.formatFullDate(value)} ${localizations.formatTimeOfDay(timeOfDay)}';
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
    this.onClear,
  });

  final String label;
  final DateTime? value;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final text = value == null
        ? 'Select a date'
        : MaterialLocalizations.of(context).formatCompactDate(value!);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: onClear == null
              ? const Icon(Icons.calendar_today_outlined)
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Clear date',
                      onPressed: onClear,
                      icon: const Icon(Icons.clear),
                    ),
                    const Icon(Icons.calendar_today_outlined),
                    const SizedBox(width: 12),
                  ],
                ),
        ),
        child: Text(text),
      ),
    );
  }
}
