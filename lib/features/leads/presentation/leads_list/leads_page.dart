import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../data/csv_leads_exporter.dart';
import '../../data/csv_leads_importer.dart';
import '../../domain/lead.dart';
import '../../domain/leads_repository.dart';
import 'leads_list_cubit.dart';

class LeadsPage extends StatelessWidget {
  const LeadsPage({required this.onLocaleSelected, super.key});

  final Future<void> Function(Locale locale) onLocaleSelected;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LeadsListCubit, LeadsListState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage != null,
      listener: (context, state) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        context.read<LeadsListCubit>().clearMessage();
      },
      child: BlocBuilder<LeadsListCubit, LeadsListState>(
        builder: (context, state) {
          final isCompact = MediaQuery.sizeOf(context).width < 720;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Outreach leads'),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _LanguageSelector(onLocaleSelected: onLocaleSelected),
                      const SizedBox(width: 8),
                      if (isCompact)
                        PopupMenuButton<_ToolbarAction>(
                          tooltip: 'Actions',
                          onSelected: (action) => _handleToolbarAction(
                            context,
                            action: action,
                            state: state,
                          ),
                          itemBuilder: (context) => [
                            PopupMenuItem<_ToolbarAction>(
                              value: _ToolbarAction.export,
                              child: Text(
                                state.hasSelection
                                    ? 'Export selected (${state.selectedCount})'
                                    : 'Export CSV',
                              ),
                            ),
                            const PopupMenuItem<_ToolbarAction>(
                              value: _ToolbarAction.import,
                              child: Text('Import CSV'),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () =>
                                  _exportCsv(context, state: state),
                              icon: const Icon(Icons.download_outlined),
                              label: Text(
                                state.hasSelection
                                    ? 'Export selected (${state.selectedCount})'
                                    : 'Export CSV',
                              ),
                            ),
                            const SizedBox(width: 8),
                            TextButton.icon(
                              onPressed: () => _previewAndImportCsv(context),
                              icon: const Icon(Icons.upload_file_outlined),
                              label: const Text('Import CSV'),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => context.go('/leads/new'),
              icon: const Icon(Icons.add),
              label: const Text('New lead'),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pipeline overview',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Keep your next conversations moving.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        _PipelineSummary(leads: state.leads),
                        const SizedBox(height: 20),
                        TextField(
                          onChanged: context.read<LeadsListCubit>().setQuery,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: 'Search company or email',
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 40,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _StatusFilterChip(
                                label: 'All',
                                selected: state.selectedStatus == null,
                                onSelected: (_) => context
                                    .read<LeadsListCubit>()
                                    .setStatus(null),
                              ),
                              const SizedBox(width: 8),
                              ...LeadStatus.values.expand(
                                (status) => [
                                  _StatusFilterChip(
                                    label: status.label,
                                    selected: state.selectedStatus == status,
                                    onSelected: (_) => context
                                        .read<LeadsListCubit>()
                                        .setStatus(status),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text('${state.leads.length} lead(s)'),
                            TextButton.icon(
                              onPressed: state.leads.isEmpty
                                  ? null
                                  : () => context
                                        .read<LeadsListCubit>()
                                        .toggleSelectAllVisible(),
                              icon: const Icon(Icons.select_all_outlined),
                              label: Text(
                                _areAllVisibleSelected(state)
                                    ? 'Clear visible'
                                    : 'Select visible',
                              ),
                            ),
                            if (state.hasSelection) ...[
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: () => context
                                    .read<LeadsListCubit>()
                                    .clearSelection(),
                                child: Text(
                                  'Clear selection (${state.selectedCount})',
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: state.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : state.isEmpty
                        ? const _EmptyState()
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              if (constraints.maxWidth >= 920) {
                                return _DesktopLeadsTable(
                                  leads: state.leads,
                                  selectedLeadIds: state.selectedLeadIds,
                                );
                              }

                              return _MobileLeadsList(
                                leads: state.leads,
                                selectedLeadIds: state.selectedLeadIds,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector({required this.onLocaleSelected});

  final Future<void> Function(Locale locale) onLocaleSelected;

  @override
  Widget build(BuildContext context) {
    final isSpanish = Localizations.localeOf(context).languageCode == 'es';
    return PopupMenuButton<Locale>(
      tooltip: 'Language',
      onSelected: onLocaleSelected,
      itemBuilder: (context) => const [
        PopupMenuItem(value: Locale('en'), child: Text('English')),
        PopupMenuItem(value: Locale('es'), child: Text('Español')),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.language_outlined),
          const SizedBox(width: 4),
          Text(isSpanish ? 'Español' : 'English'),
        ],
      ),
    );
  }
}

class _PipelineSummary extends StatelessWidget {
  const _PipelineSummary({required this.leads});

  final List<Lead> leads;

  @override
  Widget build(BuildContext context) {
    int count(LeadStatus status) =>
        leads.where((lead) => lead.status == status).length;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _PipelineMetric(label: 'All leads', value: leads.length),
        _PipelineMetric(label: 'To reach', value: count(LeadStatus.pending)),
        _PipelineMetric(label: 'In progress', value: count(LeadStatus.sent)),
        _PipelineMetric(label: 'Replied', value: count(LeadStatus.replied)),
      ],
    );
  }
}

class _PipelineMetric extends StatelessWidget {
  const _PipelineMetric({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 142,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 4),
              Text(
                '$value',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _exportCsv(
  BuildContext context, {
  required LeadsListState state,
  List<Lead>? overrideLeads,
  String? suggestedName,
}) async {
  final leads =
      overrideLeads ?? await context.read<LeadsListCubit>().getLeadsForExport();

  if (!context.mounted) {
    return;
  }

  if (leads.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('There are no leads to export.')),
    );
    return;
  }

  final location = await getSaveLocation(
    suggestedName: suggestedName ?? _buildSuggestedCsvName(state, leads.length),
    acceptedTypeGroups: const [
      XTypeGroup(label: 'csv', extensions: <String>['csv']),
    ],
  );

  if (location == null || !context.mounted) {
    return;
  }

  final csvContent = CsvLeadsExporter().build(leads);
  await File(location.path).writeAsString(csvContent);

  if (!context.mounted) {
    return;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        state.hasSelection
            ? 'Exported ${leads.length} selected lead(s) to CSV.'
            : 'Exported ${leads.length} lead(s) to CSV.',
      ),
    ),
  );
}

Future<void> _handleToolbarAction(
  BuildContext context, {
  required _ToolbarAction action,
  required LeadsListState state,
}) {
  switch (action) {
    case _ToolbarAction.export:
      return _exportCsv(context, state: state);
    case _ToolbarAction.import:
      return _previewAndImportCsv(context);
  }
}

Future<void> _previewAndImportCsv(BuildContext context) async {
  final file = await openFile(
    acceptedTypeGroups: const [
      XTypeGroup(label: 'csv', extensions: <String>['csv']),
    ],
  );

  if (file == null || !context.mounted) {
    return;
  }

  final csvContent = await file.readAsString();
  if (!context.mounted) {
    return;
  }

  final cubit = context.read<LeadsListCubit>();
  late final CsvLeadsImportParseResult preview;
  try {
    preview = await cubit.previewCsvImport(csvContent);
  } on FormatException catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    }
    return;
  }

  if (!context.mounted) {
    return;
  }

  final shouldImport = await _showImportPreviewDialog(
    context,
    preview,
    file.name,
  );
  if (!context.mounted || shouldImport == null) {
    return;
  }

  final result = await cubit.importParsedCsv(preview, mode: shouldImport);
  if (!context.mounted) {
    return;
  }

  await _showImportSummaryDialog(context, result);
}

class _MobileLeadsList extends StatelessWidget {
  const _MobileLeadsList({required this.leads, required this.selectedLeadIds});

  final List<Lead> leads;
  final Set<int> selectedLeadIds;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
      itemCount: leads.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final lead = leads[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value:
                          lead.id != null && selectedLeadIds.contains(lead.id),
                      onChanged: lead.id == null
                          ? null
                          : (_) => context
                                .read<LeadsListCubit>()
                                .toggleLeadSelection(lead),
                    ),
                    Expanded(
                      child: Text(
                        lead.companyName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    _LeadStatusBadge(status: lead.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text(lead.email),
                if ((lead.contactName ?? '').isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(lead.contactName!),
                ],
                if ((lead.website ?? '').isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(lead.website!),
                ],
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => context.go('/leads/${lead.id}/edit'),
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Edit'),
                    ),
                    if (lead.status != LeadStatus.sent)
                      OutlinedButton.icon(
                        onPressed: () =>
                            context.read<LeadsListCubit>().markAsSent(lead),
                        icon: const Icon(Icons.send_outlined),
                        label: const Text('Mark sent'),
                      ),
                    FilledButton.tonalIcon(
                      onPressed: () => _confirmDelete(context, lead.id!),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Delete'),
                    ),
                    PopupMenuButton<_LeadCsvAction>(
                      tooltip: 'CSV actions',
                      onSelected: (action) => _handleLeadCsvAction(
                        context,
                        action: action,
                        lead: lead,
                      ),
                      itemBuilder: (context) => const [
                        PopupMenuItem<_LeadCsvAction>(
                          value: _LeadCsvAction.export,
                          child: Text('Export this lead'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DesktopLeadsTable extends StatelessWidget {
  const _DesktopLeadsTable({
    required this.leads,
    required this.selectedLeadIds,
  });

  final List<Lead> leads;
  final Set<int> selectedLeadIds;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
      children: [
        Card(
          child: PaginatedDataTable(
            rowsPerPage: 10,
            availableRowsPerPage: const [10, 20, 50],
            columns: const [
              DataColumn(label: Text('Company')),
              DataColumn(label: Text('Contact')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Sent')),
              DataColumn(label: Text('Reply')),
              DataColumn(label: Text('Actions')),
            ],
            source: _LeadsTableSource(
              context: context,
              leads: leads,
              selectedLeadIds: selectedLeadIds,
            ),
          ),
        ),
      ],
    );
  }
}

class _LeadsTableSource extends DataTableSource {
  _LeadsTableSource({
    required this.context,
    required this.leads,
    required this.selectedLeadIds,
  });

  final BuildContext context;
  final List<Lead> leads;
  final Set<int> selectedLeadIds;

  @override
  DataRow? getRow(int index) {
    if (index >= leads.length) {
      return null;
    }

    final lead = leads[index];
    return DataRow.byIndex(
      index: index,
      selected: lead.id != null && selectedLeadIds.contains(lead.id),
      onSelectChanged: lead.id == null
          ? null
          : (_) => context.read<LeadsListCubit>().toggleLeadSelection(lead),
      cells: [
        DataCell(Text(lead.companyName)),
        DataCell(Text(lead.contactName ?? '-')),
        DataCell(Text(lead.email)),
        DataCell(_LeadStatusBadge(status: lead.status)),
        DataCell(Text(_formatDate(context, lead.sentAt))),
        DataCell(Text(_formatDate(context, lead.repliedAt))),
        DataCell(
          Wrap(
            spacing: 8,
            children: [
              IconButton(
                tooltip: 'Edit',
                onPressed: () => context.go('/leads/${lead.id}/edit'),
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                tooltip: 'Mark sent',
                onPressed: lead.status == LeadStatus.sent
                    ? null
                    : () => context.read<LeadsListCubit>().markAsSent(lead),
                icon: const Icon(Icons.send_outlined),
              ),
              IconButton(
                tooltip: 'Delete',
                onPressed: () => _confirmDelete(context, lead.id!),
                icon: const Icon(Icons.delete_outline),
              ),
              PopupMenuButton<_LeadCsvAction>(
                tooltip: 'CSV actions',
                onSelected: (action) =>
                    _handleLeadCsvAction(context, action: action, lead: lead),
                itemBuilder: (context) => const [
                  PopupMenuItem<_LeadCsvAction>(
                    value: _LeadCsvAction.export,
                    child: Text('Export this lead'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => leads.length;

  @override
  int get selectedRowCount => selectedLeadIds.length;
}

bool _areAllVisibleSelected(LeadsListState state) {
  if (state.leads.isEmpty) {
    return false;
  }

  return state.leads.every(
    (lead) => lead.id != null && state.selectedLeadIds.contains(lead.id),
  );
}

String _buildSuggestedCsvName(LeadsListState state, int exportCount) {
  final segments = <String>['outreach', 'leads'];

  if (state.hasSelection) {
    segments.add('selected-$exportCount');
  } else if (state.selectedStatus != null) {
    segments.add(state.selectedStatus!.name.toLowerCase());
  }

  final query = state.query.trim().toLowerCase();
  if (query.isNotEmpty) {
    final sanitizedQuery = query.replaceAll(RegExp(r'[^a-z0-9]+'), '-');
    final normalizedQuery = sanitizedQuery.replaceAll(RegExp(r'-+'), '-');
    if (normalizedQuery.isNotEmpty) {
      segments.add(normalizedQuery);
    }
  }

  return '${segments.join('-')}.csv';
}

Future<LeadImportMode?> _showImportPreviewDialog(
  BuildContext context,
  CsvLeadsImportParseResult preview,
  String fileName,
) async {
  final previewRows = preview.drafts.take(5).toList(growable: false);
  var selectedMode = LeadImportMode.insertOnly;

  final confirmed = await showDialog<LeadImportMode>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Preview CSV import'),
        content: SizedBox(
          width: 560,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('File: $fileName'),
                const SizedBox(height: 8),
                Text('Valid leads to import: ${preview.drafts.length}'),
                Text('Empty rows: ${preview.skippedEmptyRows}'),
                Text('Rows with errors: ${preview.rowErrors.length}'),
                const SizedBox(height: 16),
                StatefulBuilder(
                  builder: (context, setDialogState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Import mode',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        SegmentedButton<LeadImportMode>(
                          segments: const [
                            ButtonSegment<LeadImportMode>(
                              value: LeadImportMode.insertOnly,
                              label: Text('Insert only'),
                            ),
                            ButtonSegment<LeadImportMode>(
                              value: LeadImportMode.mergeByEmail,
                              label: Text('Merge/update'),
                            ),
                          ],
                          selected: <LeadImportMode>{selectedMode},
                          onSelectionChanged: (selection) {
                            setDialogState(() {
                              selectedMode = selection.first;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        Text(
                          selectedMode == LeadImportMode.insertOnly
                              ? 'Always create new leads.'
                              : 'Update an existing lead when the email already exists.',
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text('Preview', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                if (previewRows.isEmpty)
                  const Text('No valid rows found.')
                else
                  ...previewRows.map(
                    (draft) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '${draft.companyName} | ${draft.email} | ${draft.status.label}',
                      ),
                    ),
                  ),
                if (preview.drafts.length > previewRows.length)
                  Text(
                    '...and ${preview.drafts.length - previewRows.length} more',
                  ),
                if (preview.rowErrors.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Detected errors',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  ...preview.rowErrors
                      .take(5)
                      .map(
                        (error) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            'Row ${error.rowNumber}: ${error.message}',
                          ),
                        ),
                      ),
                  if (preview.rowErrors.length > 5)
                    Text('...and ${preview.rowErrors.length - 5} more errors'),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: preview.drafts.isEmpty
                ? null
                : () => Navigator.of(context).pop(selectedMode),
            child: const Text('Import'),
          ),
        ],
      );
    },
  );

  return confirmed;
}

Future<void> _showImportSummaryDialog(
  BuildContext context,
  LeadsCsvImportResult result,
) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('CSV import summary'),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Imported: ${result.importedCount}'),
                Text(
                  'Mode: ${result.mode == LeadImportMode.mergeByEmail ? 'Merge/update by email' : 'Insert only'}',
                ),
                Text('Skipped empty rows: ${result.skippedEmptyRows}'),
                Text('Rows with errors: ${result.skippedInvalidRows}'),
                if (result.rowErrors.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Row errors',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  ...result.rowErrors.map(
                    (error) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text('Row ${error.rowNumber}: ${error.message}'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

Future<void> _handleLeadCsvAction(
  BuildContext context, {
  required _LeadCsvAction action,
  required Lead lead,
}) {
  switch (action) {
    case _LeadCsvAction.export:
      return _exportCsv(
        context,
        state: const LeadsListState(),
        overrideLeads: [lead],
        suggestedName: _buildSingleLeadCsvName(lead),
      );
  }
}

enum _LeadCsvAction { export }

enum _ToolbarAction { export, import }

String _buildSingleLeadCsvName(Lead lead) {
  final normalizedCompany = lead.companyName
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'-+'), '-');
  final companySegment = normalizedCompany.isEmpty ? 'lead' : normalizedCompany;

  return 'outreach-lead-$companySegment.csv';
}

class _LeadStatusBadge extends StatelessWidget {
  const _LeadStatusBadge({required this.status});

  final LeadStatus status;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final Color backgroundColor;

    switch (status) {
      case LeadStatus.pending:
        backgroundColor = colorScheme.secondaryContainer;
      case LeadStatus.sent:
        backgroundColor = colorScheme.primaryContainer;
      case LeadStatus.replied:
        backgroundColor = colorScheme.tertiaryContainer;
      case LeadStatus.followUp:
        backgroundColor = colorScheme.surfaceContainerHighest;
      case LeadStatus.closed:
        backgroundColor = colorScheme.errorContainer;
    }

    return Chip(label: Text(status.label), backgroundColor: backgroundColor);
  }
}

class _StatusFilterChip extends StatelessWidget {
  const _StatusFilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'No leads found.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Create your first lead or change the active filters.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _confirmDelete(BuildContext context, int id) async {
  final confirmed =
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete lead'),
          content: const Text('This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        ),
      ) ??
      false;

  if (!context.mounted || !confirmed) {
    return;
  }

  await context.read<LeadsListCubit>().deleteLead(id);
}

String _formatDate(BuildContext context, DateTime? value) {
  if (value == null) {
    return '-';
  }

  return MaterialLocalizations.of(context).formatCompactDate(value);
}
