import '../domain/lead.dart';

class CsvLeadsImporter {
  CsvLeadsImportParseResult parse(String csvContent) {
    final rows = _parseRows(csvContent);
    if (rows.isEmpty) {
      throw const FormatException('The selected CSV is empty.');
    }

    final header = rows.first.map(_normalizeHeader).toList(growable: false);
    final companyIndex = _findHeaderIndex(header, const [
      'company_name',
      'companyname',
    ]);
    final emailIndex = _findHeaderIndex(header, const ['email']);

    if (companyIndex == -1 || emailIndex == -1) {
      throw const FormatException(
        'The CSV must include at least company_name and email columns.',
      );
    }

    final contactIndex = _findHeaderIndex(header, const [
      'contact_name',
      'contactname',
    ]);
    final websiteIndex = _findHeaderIndex(header, const ['website']);
    final statusIndex = _findHeaderIndex(header, const ['status']);
    final sentAtIndex = _findHeaderIndex(header, const ['sent_at', 'sentat']);
    final repliedAtIndex = _findHeaderIndex(header, const [
      'replied_at',
      'repliedat',
    ]);
    final notesIndex = _findHeaderIndex(header, const ['notes']);

    final drafts = <LeadDraft>[];
    final rowErrors = <CsvLeadImportRowError>[];
    var skippedEmptyRows = 0;

    for (var index = 1; index < rows.length; index++) {
      final row = rows[index];
      final rowNumber = index + 1;

      if (row.every((cell) => cell.trim().isEmpty)) {
        skippedEmptyRows++;
        continue;
      }

      final sentAtRaw = _nullableValueAt(row, sentAtIndex);
      final repliedAtRaw = _nullableValueAt(row, repliedAtIndex);
      final sentAt = _parseDate(sentAtRaw);
      final repliedAt = _parseDate(repliedAtRaw);

      if (sentAtRaw != null && sentAt == null) {
        rowErrors.add(
          CsvLeadImportRowError(
            rowNumber: rowNumber,
            message: 'Invalid sent_at date: $sentAtRaw',
          ),
        );
        continue;
      }

      if (repliedAtRaw != null && repliedAt == null) {
        rowErrors.add(
          CsvLeadImportRowError(
            rowNumber: rowNumber,
            message: 'Invalid replied_at date: $repliedAtRaw',
          ),
        );
        continue;
      }

      final draft = LeadDraft(
        companyName: _valueAt(row, companyIndex),
        contactName: _nullableValueAt(row, contactIndex),
        email: _valueAt(row, emailIndex),
        website: _nullableValueAt(row, websiteIndex),
        status: _parseStatus(_nullableValueAt(row, statusIndex)),
        sentAt: sentAt,
        repliedAt: repliedAt,
        notes: _nullableValueAt(row, notesIndex),
      );

      if (draft.isValid) {
        drafts.add(draft);
      } else {
        rowErrors.add(
          CsvLeadImportRowError(
            rowNumber: rowNumber,
            message: 'Missing company_name or invalid email.',
          ),
        );
      }
    }

    if (drafts.isEmpty && rowErrors.isEmpty) {
      throw const FormatException('No valid leads were found in the CSV.');
    }

    return CsvLeadsImportParseResult(
      drafts: drafts,
      skippedEmptyRows: skippedEmptyRows,
      rowErrors: rowErrors,
    );
  }

  int _findHeaderIndex(List<String> header, List<String> accepted) {
    for (var index = 0; index < header.length; index++) {
      if (accepted.contains(header[index])) {
        return index;
      }
    }

    return -1;
  }

  String _normalizeHeader(String value) {
    return value.trim().toLowerCase().replaceAll(' ', '').replaceAll('-', '_');
  }

  String _valueAt(List<String> row, int index) {
    if (index < 0 || index >= row.length) {
      return '';
    }

    return row[index].trim();
  }

  String? _nullableValueAt(List<String> row, int index) {
    final value = _valueAt(row, index);
    return value.isEmpty ? null : value;
  }

  LeadStatus _parseStatus(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'sent':
        return LeadStatus.sent;
      case 'replied':
        return LeadStatus.replied;
      case 'follow_up':
      case 'followup':
        return LeadStatus.followUp;
      case 'closed':
        return LeadStatus.closed;
      default:
        return LeadStatus.pending;
    }
  }

  DateTime? _parseDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    return DateTime.tryParse(value.trim());
  }

  List<List<String>> _parseRows(String input) {
    final rows = <List<String>>[];
    final currentRow = <String>[];
    final currentCell = StringBuffer();
    var inQuotes = false;

    for (var i = 0; i < input.length; i++) {
      final char = input[i];

      if (char == '"') {
        if (inQuotes && i + 1 < input.length && input[i + 1] == '"') {
          currentCell.write('"');
          i++;
        } else {
          inQuotes = !inQuotes;
        }
        continue;
      }

      if (char == ',' && !inQuotes) {
        currentRow.add(currentCell.toString());
        currentCell.clear();
        continue;
      }

      if ((char == '\n' || char == '\r') && !inQuotes) {
        if (char == '\r' && i + 1 < input.length && input[i + 1] == '\n') {
          i++;
        }

        currentRow.add(currentCell.toString());
        currentCell.clear();

        if (currentRow.isNotEmpty) {
          rows.add(List<String>.from(currentRow));
          currentRow.clear();
        }
        continue;
      }

      currentCell.write(char);
    }

    if (currentCell.isNotEmpty || currentRow.isNotEmpty) {
      currentRow.add(currentCell.toString());
      rows.add(List<String>.from(currentRow));
    }

    return rows;
  }
}

class CsvLeadsImportParseResult {
  const CsvLeadsImportParseResult({
    required this.drafts,
    required this.skippedEmptyRows,
    required this.rowErrors,
  });

  final List<LeadDraft> drafts;
  final int skippedEmptyRows;
  final List<CsvLeadImportRowError> rowErrors;
}

class CsvLeadImportRowError {
  const CsvLeadImportRowError({required this.rowNumber, required this.message});

  final int rowNumber;
  final String message;
}

CsvLeadsImportParseResult parseCsvLeadsImport(String csvContent) {
  return CsvLeadsImporter().parse(csvContent);
}
