// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LeadsTable extends Leads with TableInfo<$LeadsTable, LeadRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeadsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _companyNameMeta = const VerificationMeta(
    'companyName',
  );
  @override
  late final GeneratedColumn<String> companyName = GeneratedColumn<String>(
    'company_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contactNameMeta = const VerificationMeta(
    'contactName',
  );
  @override
  late final GeneratedColumn<String> contactName = GeneratedColumn<String>(
    'contact_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _websiteMeta = const VerificationMeta(
    'website',
  );
  @override
  late final GeneratedColumn<String> website = GeneratedColumn<String>(
    'website',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LeadStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<LeadStatus>($LeadsTable.$converterstatus);
  static const VerificationMeta _sentAtMeta = const VerificationMeta('sentAt');
  @override
  late final GeneratedColumn<DateTime> sentAt = GeneratedColumn<DateTime>(
    'sent_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repliedAtMeta = const VerificationMeta(
    'repliedAt',
  );
  @override
  late final GeneratedColumn<DateTime> repliedAt = GeneratedColumn<DateTime>(
    'replied_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    companyName,
    contactName,
    email,
    website,
    status,
    sentAt,
    repliedAt,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'leads';
  @override
  VerificationContext validateIntegrity(
    Insertable<LeadRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('company_name')) {
      context.handle(
        _companyNameMeta,
        companyName.isAcceptableOrUnknown(
          data['company_name']!,
          _companyNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_companyNameMeta);
    }
    if (data.containsKey('contact_name')) {
      context.handle(
        _contactNameMeta,
        contactName.isAcceptableOrUnknown(
          data['contact_name']!,
          _contactNameMeta,
        ),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('website')) {
      context.handle(
        _websiteMeta,
        website.isAcceptableOrUnknown(data['website']!, _websiteMeta),
      );
    }
    if (data.containsKey('sent_at')) {
      context.handle(
        _sentAtMeta,
        sentAt.isAcceptableOrUnknown(data['sent_at']!, _sentAtMeta),
      );
    }
    if (data.containsKey('replied_at')) {
      context.handle(
        _repliedAtMeta,
        repliedAt.isAcceptableOrUnknown(data['replied_at']!, _repliedAtMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LeadRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LeadRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      companyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_name'],
      )!,
      contactName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_name'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      website: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}website'],
      ),
      status: $LeadsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      sentAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sent_at'],
      ),
      repliedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}replied_at'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LeadsTable createAlias(String alias) {
    return $LeadsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LeadStatus, int, int> $converterstatus =
      const EnumIndexConverter<LeadStatus>(LeadStatus.values);
}

class LeadRecord extends DataClass implements Insertable<LeadRecord> {
  final int id;
  final String companyName;
  final String? contactName;
  final String email;
  final String? website;
  final LeadStatus status;
  final DateTime? sentAt;
  final DateTime? repliedAt;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const LeadRecord({
    required this.id,
    required this.companyName,
    this.contactName,
    required this.email,
    this.website,
    required this.status,
    this.sentAt,
    this.repliedAt,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['company_name'] = Variable<String>(companyName);
    if (!nullToAbsent || contactName != null) {
      map['contact_name'] = Variable<String>(contactName);
    }
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || website != null) {
      map['website'] = Variable<String>(website);
    }
    {
      map['status'] = Variable<int>($LeadsTable.$converterstatus.toSql(status));
    }
    if (!nullToAbsent || sentAt != null) {
      map['sent_at'] = Variable<DateTime>(sentAt);
    }
    if (!nullToAbsent || repliedAt != null) {
      map['replied_at'] = Variable<DateTime>(repliedAt);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LeadsCompanion toCompanion(bool nullToAbsent) {
    return LeadsCompanion(
      id: Value(id),
      companyName: Value(companyName),
      contactName: contactName == null && nullToAbsent
          ? const Value.absent()
          : Value(contactName),
      email: Value(email),
      website: website == null && nullToAbsent
          ? const Value.absent()
          : Value(website),
      status: Value(status),
      sentAt: sentAt == null && nullToAbsent
          ? const Value.absent()
          : Value(sentAt),
      repliedAt: repliedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(repliedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LeadRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LeadRecord(
      id: serializer.fromJson<int>(json['id']),
      companyName: serializer.fromJson<String>(json['companyName']),
      contactName: serializer.fromJson<String?>(json['contactName']),
      email: serializer.fromJson<String>(json['email']),
      website: serializer.fromJson<String?>(json['website']),
      status: $LeadsTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      sentAt: serializer.fromJson<DateTime?>(json['sentAt']),
      repliedAt: serializer.fromJson<DateTime?>(json['repliedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'companyName': serializer.toJson<String>(companyName),
      'contactName': serializer.toJson<String?>(contactName),
      'email': serializer.toJson<String>(email),
      'website': serializer.toJson<String?>(website),
      'status': serializer.toJson<int>(
        $LeadsTable.$converterstatus.toJson(status),
      ),
      'sentAt': serializer.toJson<DateTime?>(sentAt),
      'repliedAt': serializer.toJson<DateTime?>(repliedAt),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LeadRecord copyWith({
    int? id,
    String? companyName,
    Value<String?> contactName = const Value.absent(),
    String? email,
    Value<String?> website = const Value.absent(),
    LeadStatus? status,
    Value<DateTime?> sentAt = const Value.absent(),
    Value<DateTime?> repliedAt = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => LeadRecord(
    id: id ?? this.id,
    companyName: companyName ?? this.companyName,
    contactName: contactName.present ? contactName.value : this.contactName,
    email: email ?? this.email,
    website: website.present ? website.value : this.website,
    status: status ?? this.status,
    sentAt: sentAt.present ? sentAt.value : this.sentAt,
    repliedAt: repliedAt.present ? repliedAt.value : this.repliedAt,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LeadRecord copyWithCompanion(LeadsCompanion data) {
    return LeadRecord(
      id: data.id.present ? data.id.value : this.id,
      companyName: data.companyName.present
          ? data.companyName.value
          : this.companyName,
      contactName: data.contactName.present
          ? data.contactName.value
          : this.contactName,
      email: data.email.present ? data.email.value : this.email,
      website: data.website.present ? data.website.value : this.website,
      status: data.status.present ? data.status.value : this.status,
      sentAt: data.sentAt.present ? data.sentAt.value : this.sentAt,
      repliedAt: data.repliedAt.present ? data.repliedAt.value : this.repliedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LeadRecord(')
          ..write('id: $id, ')
          ..write('companyName: $companyName, ')
          ..write('contactName: $contactName, ')
          ..write('email: $email, ')
          ..write('website: $website, ')
          ..write('status: $status, ')
          ..write('sentAt: $sentAt, ')
          ..write('repliedAt: $repliedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    companyName,
    contactName,
    email,
    website,
    status,
    sentAt,
    repliedAt,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LeadRecord &&
          other.id == this.id &&
          other.companyName == this.companyName &&
          other.contactName == this.contactName &&
          other.email == this.email &&
          other.website == this.website &&
          other.status == this.status &&
          other.sentAt == this.sentAt &&
          other.repliedAt == this.repliedAt &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LeadsCompanion extends UpdateCompanion<LeadRecord> {
  final Value<int> id;
  final Value<String> companyName;
  final Value<String?> contactName;
  final Value<String> email;
  final Value<String?> website;
  final Value<LeadStatus> status;
  final Value<DateTime?> sentAt;
  final Value<DateTime?> repliedAt;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const LeadsCompanion({
    this.id = const Value.absent(),
    this.companyName = const Value.absent(),
    this.contactName = const Value.absent(),
    this.email = const Value.absent(),
    this.website = const Value.absent(),
    this.status = const Value.absent(),
    this.sentAt = const Value.absent(),
    this.repliedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  LeadsCompanion.insert({
    this.id = const Value.absent(),
    required String companyName,
    this.contactName = const Value.absent(),
    required String email,
    this.website = const Value.absent(),
    required LeadStatus status,
    this.sentAt = const Value.absent(),
    this.repliedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : companyName = Value(companyName),
       email = Value(email),
       status = Value(status);
  static Insertable<LeadRecord> custom({
    Expression<int>? id,
    Expression<String>? companyName,
    Expression<String>? contactName,
    Expression<String>? email,
    Expression<String>? website,
    Expression<int>? status,
    Expression<DateTime>? sentAt,
    Expression<DateTime>? repliedAt,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (companyName != null) 'company_name': companyName,
      if (contactName != null) 'contact_name': contactName,
      if (email != null) 'email': email,
      if (website != null) 'website': website,
      if (status != null) 'status': status,
      if (sentAt != null) 'sent_at': sentAt,
      if (repliedAt != null) 'replied_at': repliedAt,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  LeadsCompanion copyWith({
    Value<int>? id,
    Value<String>? companyName,
    Value<String?>? contactName,
    Value<String>? email,
    Value<String?>? website,
    Value<LeadStatus>? status,
    Value<DateTime?>? sentAt,
    Value<DateTime?>? repliedAt,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return LeadsCompanion(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      contactName: contactName ?? this.contactName,
      email: email ?? this.email,
      website: website ?? this.website,
      status: status ?? this.status,
      sentAt: sentAt ?? this.sentAt,
      repliedAt: repliedAt ?? this.repliedAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (companyName.present) {
      map['company_name'] = Variable<String>(companyName.value);
    }
    if (contactName.present) {
      map['contact_name'] = Variable<String>(contactName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (website.present) {
      map['website'] = Variable<String>(website.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $LeadsTable.$converterstatus.toSql(status.value),
      );
    }
    if (sentAt.present) {
      map['sent_at'] = Variable<DateTime>(sentAt.value);
    }
    if (repliedAt.present) {
      map['replied_at'] = Variable<DateTime>(repliedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeadsCompanion(')
          ..write('id: $id, ')
          ..write('companyName: $companyName, ')
          ..write('contactName: $contactName, ')
          ..write('email: $email, ')
          ..write('website: $website, ')
          ..write('status: $status, ')
          ..write('sentAt: $sentAt, ')
          ..write('repliedAt: $repliedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $LeadHistoryTable extends LeadHistory
    with TableInfo<$LeadHistoryTable, LeadHistoryRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeadHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _leadIdMeta = const VerificationMeta('leadId');
  @override
  late final GeneratedColumn<int> leadId = GeneratedColumn<int>(
    'lead_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LeadHistoryAction, int> action =
      GeneratedColumn<int>(
        'action',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<LeadHistoryAction>($LeadHistoryTable.$converteraction);
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    leadId,
    action,
    summary,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lead_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<LeadHistoryRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lead_id')) {
      context.handle(
        _leadIdMeta,
        leadId.isAcceptableOrUnknown(data['lead_id']!, _leadIdMeta),
      );
    } else if (isInserting) {
      context.missing(_leadIdMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LeadHistoryRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LeadHistoryRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      leadId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lead_id'],
      )!,
      action: $LeadHistoryTable.$converteraction.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}action'],
        )!,
      ),
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LeadHistoryTable createAlias(String alias) {
    return $LeadHistoryTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LeadHistoryAction, int, int> $converteraction =
      const EnumIndexConverter<LeadHistoryAction>(LeadHistoryAction.values);
}

class LeadHistoryRecord extends DataClass
    implements Insertable<LeadHistoryRecord> {
  final int id;
  final int leadId;
  final LeadHistoryAction action;
  final String summary;
  final DateTime createdAt;
  const LeadHistoryRecord({
    required this.id,
    required this.leadId,
    required this.action,
    required this.summary,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lead_id'] = Variable<int>(leadId);
    {
      map['action'] = Variable<int>(
        $LeadHistoryTable.$converteraction.toSql(action),
      );
    }
    map['summary'] = Variable<String>(summary);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LeadHistoryCompanion toCompanion(bool nullToAbsent) {
    return LeadHistoryCompanion(
      id: Value(id),
      leadId: Value(leadId),
      action: Value(action),
      summary: Value(summary),
      createdAt: Value(createdAt),
    );
  }

  factory LeadHistoryRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LeadHistoryRecord(
      id: serializer.fromJson<int>(json['id']),
      leadId: serializer.fromJson<int>(json['leadId']),
      action: $LeadHistoryTable.$converteraction.fromJson(
        serializer.fromJson<int>(json['action']),
      ),
      summary: serializer.fromJson<String>(json['summary']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'leadId': serializer.toJson<int>(leadId),
      'action': serializer.toJson<int>(
        $LeadHistoryTable.$converteraction.toJson(action),
      ),
      'summary': serializer.toJson<String>(summary),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LeadHistoryRecord copyWith({
    int? id,
    int? leadId,
    LeadHistoryAction? action,
    String? summary,
    DateTime? createdAt,
  }) => LeadHistoryRecord(
    id: id ?? this.id,
    leadId: leadId ?? this.leadId,
    action: action ?? this.action,
    summary: summary ?? this.summary,
    createdAt: createdAt ?? this.createdAt,
  );
  LeadHistoryRecord copyWithCompanion(LeadHistoryCompanion data) {
    return LeadHistoryRecord(
      id: data.id.present ? data.id.value : this.id,
      leadId: data.leadId.present ? data.leadId.value : this.leadId,
      action: data.action.present ? data.action.value : this.action,
      summary: data.summary.present ? data.summary.value : this.summary,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LeadHistoryRecord(')
          ..write('id: $id, ')
          ..write('leadId: $leadId, ')
          ..write('action: $action, ')
          ..write('summary: $summary, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, leadId, action, summary, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LeadHistoryRecord &&
          other.id == this.id &&
          other.leadId == this.leadId &&
          other.action == this.action &&
          other.summary == this.summary &&
          other.createdAt == this.createdAt);
}

class LeadHistoryCompanion extends UpdateCompanion<LeadHistoryRecord> {
  final Value<int> id;
  final Value<int> leadId;
  final Value<LeadHistoryAction> action;
  final Value<String> summary;
  final Value<DateTime> createdAt;
  const LeadHistoryCompanion({
    this.id = const Value.absent(),
    this.leadId = const Value.absent(),
    this.action = const Value.absent(),
    this.summary = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  LeadHistoryCompanion.insert({
    this.id = const Value.absent(),
    required int leadId,
    required LeadHistoryAction action,
    required String summary,
    this.createdAt = const Value.absent(),
  }) : leadId = Value(leadId),
       action = Value(action),
       summary = Value(summary);
  static Insertable<LeadHistoryRecord> custom({
    Expression<int>? id,
    Expression<int>? leadId,
    Expression<int>? action,
    Expression<String>? summary,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (leadId != null) 'lead_id': leadId,
      if (action != null) 'action': action,
      if (summary != null) 'summary': summary,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  LeadHistoryCompanion copyWith({
    Value<int>? id,
    Value<int>? leadId,
    Value<LeadHistoryAction>? action,
    Value<String>? summary,
    Value<DateTime>? createdAt,
  }) {
    return LeadHistoryCompanion(
      id: id ?? this.id,
      leadId: leadId ?? this.leadId,
      action: action ?? this.action,
      summary: summary ?? this.summary,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (leadId.present) {
      map['lead_id'] = Variable<int>(leadId.value);
    }
    if (action.present) {
      map['action'] = Variable<int>(
        $LeadHistoryTable.$converteraction.toSql(action.value),
      );
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeadHistoryCompanion(')
          ..write('id: $id, ')
          ..write('leadId: $leadId, ')
          ..write('action: $action, ')
          ..write('summary: $summary, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LeadsTable leads = $LeadsTable(this);
  late final $LeadHistoryTable leadHistory = $LeadHistoryTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [leads, leadHistory];
}

typedef $$LeadsTableCreateCompanionBuilder =
    LeadsCompanion Function({
      Value<int> id,
      required String companyName,
      Value<String?> contactName,
      required String email,
      Value<String?> website,
      required LeadStatus status,
      Value<DateTime?> sentAt,
      Value<DateTime?> repliedAt,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$LeadsTableUpdateCompanionBuilder =
    LeadsCompanion Function({
      Value<int> id,
      Value<String> companyName,
      Value<String?> contactName,
      Value<String> email,
      Value<String?> website,
      Value<LeadStatus> status,
      Value<DateTime?> sentAt,
      Value<DateTime?> repliedAt,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$LeadsTableFilterComposer extends Composer<_$AppDatabase, $LeadsTable> {
  $$LeadsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactName => $composableBuilder(
    column: $table.contactName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LeadStatus, LeadStatus, int> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get repliedAt => $composableBuilder(
    column: $table.repliedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LeadsTableOrderingComposer
    extends Composer<_$AppDatabase, $LeadsTable> {
  $$LeadsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactName => $composableBuilder(
    column: $table.contactName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get repliedAt => $composableBuilder(
    column: $table.repliedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LeadsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LeadsTable> {
  $$LeadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contactName => $composableBuilder(
    column: $table.contactName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get website =>
      $composableBuilder(column: $table.website, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LeadStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get sentAt =>
      $composableBuilder(column: $table.sentAt, builder: (column) => column);

  GeneratedColumn<DateTime> get repliedAt =>
      $composableBuilder(column: $table.repliedAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LeadsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LeadsTable,
          LeadRecord,
          $$LeadsTableFilterComposer,
          $$LeadsTableOrderingComposer,
          $$LeadsTableAnnotationComposer,
          $$LeadsTableCreateCompanionBuilder,
          $$LeadsTableUpdateCompanionBuilder,
          (LeadRecord, BaseReferences<_$AppDatabase, $LeadsTable, LeadRecord>),
          LeadRecord,
          PrefetchHooks Function()
        > {
  $$LeadsTableTableManager(_$AppDatabase db, $LeadsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LeadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeadsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> companyName = const Value.absent(),
                Value<String?> contactName = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<LeadStatus> status = const Value.absent(),
                Value<DateTime?> sentAt = const Value.absent(),
                Value<DateTime?> repliedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => LeadsCompanion(
                id: id,
                companyName: companyName,
                contactName: contactName,
                email: email,
                website: website,
                status: status,
                sentAt: sentAt,
                repliedAt: repliedAt,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String companyName,
                Value<String?> contactName = const Value.absent(),
                required String email,
                Value<String?> website = const Value.absent(),
                required LeadStatus status,
                Value<DateTime?> sentAt = const Value.absent(),
                Value<DateTime?> repliedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => LeadsCompanion.insert(
                id: id,
                companyName: companyName,
                contactName: contactName,
                email: email,
                website: website,
                status: status,
                sentAt: sentAt,
                repliedAt: repliedAt,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LeadsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LeadsTable,
      LeadRecord,
      $$LeadsTableFilterComposer,
      $$LeadsTableOrderingComposer,
      $$LeadsTableAnnotationComposer,
      $$LeadsTableCreateCompanionBuilder,
      $$LeadsTableUpdateCompanionBuilder,
      (LeadRecord, BaseReferences<_$AppDatabase, $LeadsTable, LeadRecord>),
      LeadRecord,
      PrefetchHooks Function()
    >;
typedef $$LeadHistoryTableCreateCompanionBuilder =
    LeadHistoryCompanion Function({
      Value<int> id,
      required int leadId,
      required LeadHistoryAction action,
      required String summary,
      Value<DateTime> createdAt,
    });
typedef $$LeadHistoryTableUpdateCompanionBuilder =
    LeadHistoryCompanion Function({
      Value<int> id,
      Value<int> leadId,
      Value<LeadHistoryAction> action,
      Value<String> summary,
      Value<DateTime> createdAt,
    });

class $$LeadHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $LeadHistoryTable> {
  $$LeadHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get leadId => $composableBuilder(
    column: $table.leadId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LeadHistoryAction, LeadHistoryAction, int>
  get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LeadHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $LeadHistoryTable> {
  $$LeadHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get leadId => $composableBuilder(
    column: $table.leadId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LeadHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $LeadHistoryTable> {
  $$LeadHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get leadId =>
      $composableBuilder(column: $table.leadId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LeadHistoryAction, int> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LeadHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LeadHistoryTable,
          LeadHistoryRecord,
          $$LeadHistoryTableFilterComposer,
          $$LeadHistoryTableOrderingComposer,
          $$LeadHistoryTableAnnotationComposer,
          $$LeadHistoryTableCreateCompanionBuilder,
          $$LeadHistoryTableUpdateCompanionBuilder,
          (
            LeadHistoryRecord,
            BaseReferences<_$AppDatabase, $LeadHistoryTable, LeadHistoryRecord>,
          ),
          LeadHistoryRecord,
          PrefetchHooks Function()
        > {
  $$LeadHistoryTableTableManager(_$AppDatabase db, $LeadHistoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeadHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LeadHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeadHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> leadId = const Value.absent(),
                Value<LeadHistoryAction> action = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => LeadHistoryCompanion(
                id: id,
                leadId: leadId,
                action: action,
                summary: summary,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int leadId,
                required LeadHistoryAction action,
                required String summary,
                Value<DateTime> createdAt = const Value.absent(),
              }) => LeadHistoryCompanion.insert(
                id: id,
                leadId: leadId,
                action: action,
                summary: summary,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LeadHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LeadHistoryTable,
      LeadHistoryRecord,
      $$LeadHistoryTableFilterComposer,
      $$LeadHistoryTableOrderingComposer,
      $$LeadHistoryTableAnnotationComposer,
      $$LeadHistoryTableCreateCompanionBuilder,
      $$LeadHistoryTableUpdateCompanionBuilder,
      (
        LeadHistoryRecord,
        BaseReferences<_$AppDatabase, $LeadHistoryTable, LeadHistoryRecord>,
      ),
      LeadHistoryRecord,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LeadsTableTableManager get leads =>
      $$LeadsTableTableManager(_db, _db.leads);
  $$LeadHistoryTableTableManager get leadHistory =>
      $$LeadHistoryTableTableManager(_db, _db.leadHistory);
}
