// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outgoing_document_db.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOutgoingDocumentDbCollection on Isar {
  IsarCollection<OutgoingDocumentDb> get outgoingDocumentDbs =>
      this.collection();
}

const OutgoingDocumentDbSchema = CollectionSchema(
  name: r'OutgoingDocumentDb',
  id: -8889016209233249462,
  properties: {
    r'actionBy': PropertySchema(
      id: 0,
      name: r'actionBy',
      type: IsarType.string,
    ),
    r'archiveFolder': PropertySchema(
      id: 1,
      name: r'archiveFolder',
      type: IsarType.string,
    ),
    r'attachments': PropertySchema(
      id: 2,
      name: r'attachments',
      type: IsarType.objectList,
      target: r'AttachmentDocumentDb',
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'date': PropertySchema(id: 4, name: r'date', type: IsarType.string),
    r'documentId': PropertySchema(
      id: 5,
      name: r'documentId',
      type: IsarType.string,
    ),
    r'filePath': PropertySchema(
      id: 6,
      name: r'filePath',
      type: IsarType.string,
    ),
    r'followUpBy': PropertySchema(
      id: 7,
      name: r'followUpBy',
      type: IsarType.string,
    ),
    r'followUpDate': PropertySchema(
      id: 8,
      name: r'followUpDate',
      type: IsarType.string,
    ),
    r'letterNumber': PropertySchema(
      id: 9,
      name: r'letterNumber',
      type: IsarType.string,
    ),
    r'needsFollowUp': PropertySchema(
      id: 10,
      name: r'needsFollowUp',
      type: IsarType.bool,
    ),
    r'organization': PropertySchema(
      id: 11,
      name: r'organization',
      type: IsarType.string,
    ),
    r'priority': PropertySchema(
      id: 12,
      name: r'priority',
      type: IsarType.string,
    ),
    r'recipient': PropertySchema(
      id: 13,
      name: r'recipient',
      type: IsarType.string,
    ),
    r'registrationDate': PropertySchema(
      id: 14,
      name: r'registrationDate',
      type: IsarType.string,
    ),
    r'registrationNumber': PropertySchema(
      id: 15,
      name: r'registrationNumber',
      type: IsarType.string,
    ),
    r'saveFile': PropertySchema(id: 16, name: r'saveFile', type: IsarType.bool),
    r'sendMethod': PropertySchema(
      id: 17,
      name: r'sendMethod',
      type: IsarType.string,
    ),
    r'signer': PropertySchema(id: 18, name: r'signer', type: IsarType.string),
    r'subject': PropertySchema(id: 19, name: r'subject', type: IsarType.string),
    r'tags': PropertySchema(id: 20, name: r'tags', type: IsarType.stringList),
  },
  estimateSize: _outgoingDocumentDbEstimateSize,
  serialize: _outgoingDocumentDbSerialize,
  deserialize: _outgoingDocumentDbDeserialize,
  deserializeProp: _outgoingDocumentDbDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'AttachmentDocumentDb': AttachmentDocumentDbSchema},
  getId: _outgoingDocumentDbGetId,
  getLinks: _outgoingDocumentDbGetLinks,
  attach: _outgoingDocumentDbAttach,
  version: '3.1.0+1',
);

int _outgoingDocumentDbEstimateSize(
  OutgoingDocumentDb object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.actionBy.length * 3;
  bytesCount += 3 + object.archiveFolder.length * 3;
  bytesCount += 3 + object.attachments.length * 3;
  {
    final offsets = allOffsets[AttachmentDocumentDb]!;
    for (var i = 0; i < object.attachments.length; i++) {
      final value = object.attachments[i];
      bytesCount += AttachmentDocumentDbSchema.estimateSize(
        value,
        offsets,
        allOffsets,
      );
    }
  }
  bytesCount += 3 + object.date.length * 3;
  bytesCount += 3 + object.documentId.length * 3;
  {
    final value = object.filePath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.followUpBy;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.followUpDate;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.letterNumber.length * 3;
  bytesCount += 3 + object.organization.length * 3;
  bytesCount += 3 + object.priority.length * 3;
  bytesCount += 3 + object.recipient.length * 3;
  bytesCount += 3 + object.registrationDate.length * 3;
  bytesCount += 3 + object.registrationNumber.length * 3;
  bytesCount += 3 + object.sendMethod.length * 3;
  bytesCount += 3 + object.signer.length * 3;
  bytesCount += 3 + object.subject.length * 3;
  bytesCount += 3 + object.tags.length * 3;
  {
    for (var i = 0; i < object.tags.length; i++) {
      final value = object.tags[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _outgoingDocumentDbSerialize(
  OutgoingDocumentDb object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.actionBy);
  writer.writeString(offsets[1], object.archiveFolder);
  writer.writeObjectList<AttachmentDocumentDb>(
    offsets[2],
    allOffsets,
    AttachmentDocumentDbSchema.serialize,
    object.attachments,
  );
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeString(offsets[4], object.date);
  writer.writeString(offsets[5], object.documentId);
  writer.writeString(offsets[6], object.filePath);
  writer.writeString(offsets[7], object.followUpBy);
  writer.writeString(offsets[8], object.followUpDate);
  writer.writeString(offsets[9], object.letterNumber);
  writer.writeBool(offsets[10], object.needsFollowUp);
  writer.writeString(offsets[11], object.organization);
  writer.writeString(offsets[12], object.priority);
  writer.writeString(offsets[13], object.recipient);
  writer.writeString(offsets[14], object.registrationDate);
  writer.writeString(offsets[15], object.registrationNumber);
  writer.writeBool(offsets[16], object.saveFile);
  writer.writeString(offsets[17], object.sendMethod);
  writer.writeString(offsets[18], object.signer);
  writer.writeString(offsets[19], object.subject);
  writer.writeStringList(offsets[20], object.tags);
}

OutgoingDocumentDb _outgoingDocumentDbDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OutgoingDocumentDb();
  object.actionBy = reader.readString(offsets[0]);
  object.archiveFolder = reader.readString(offsets[1]);
  object.attachments =
      reader.readObjectList<AttachmentDocumentDb>(
        offsets[2],
        AttachmentDocumentDbSchema.deserialize,
        allOffsets,
        AttachmentDocumentDb(),
      ) ??
      [];
  object.createdAt = reader.readDateTime(offsets[3]);
  object.date = reader.readString(offsets[4]);
  object.documentId = reader.readString(offsets[5]);
  object.filePath = reader.readStringOrNull(offsets[6]);
  object.followUpBy = reader.readStringOrNull(offsets[7]);
  object.followUpDate = reader.readStringOrNull(offsets[8]);
  object.id = id;
  object.letterNumber = reader.readString(offsets[9]);
  object.needsFollowUp = reader.readBool(offsets[10]);
  object.organization = reader.readString(offsets[11]);
  object.priority = reader.readString(offsets[12]);
  object.recipient = reader.readString(offsets[13]);
  object.registrationDate = reader.readString(offsets[14]);
  object.registrationNumber = reader.readString(offsets[15]);
  object.saveFile = reader.readBool(offsets[16]);
  object.sendMethod = reader.readString(offsets[17]);
  object.signer = reader.readString(offsets[18]);
  object.subject = reader.readString(offsets[19]);
  object.tags = reader.readStringList(offsets[20]) ?? [];
  return object;
}

P _outgoingDocumentDbDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readObjectList<AttachmentDocumentDb>(
                offset,
                AttachmentDocumentDbSchema.deserialize,
                allOffsets,
                AttachmentDocumentDb(),
              ) ??
              [])
          as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readBool(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readString(offset)) as P;
    case 19:
      return (reader.readString(offset)) as P;
    case 20:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _outgoingDocumentDbGetId(OutgoingDocumentDb object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _outgoingDocumentDbGetLinks(
  OutgoingDocumentDb object,
) {
  return [];
}

void _outgoingDocumentDbAttach(
  IsarCollection<dynamic> col,
  Id id,
  OutgoingDocumentDb object,
) {
  object.id = id;
}

extension OutgoingDocumentDbQueryWhereSort
    on QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QWhere> {
  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension OutgoingDocumentDbQueryWhere
    on QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QWhereClause> {
  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterWhereClause>
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterWhereClause>
  idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension OutgoingDocumentDbQueryFilter
    on QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QFilterCondition> {
  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  actionByEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'actionBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  actionByGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'actionBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  actionByLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'actionBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  actionByBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'actionBy',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  actionByStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'actionBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  actionByEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'actionBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  actionByContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'actionBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  actionByMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'actionBy',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  actionByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'actionBy', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  actionByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'actionBy', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  archiveFolderEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'archiveFolder',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  archiveFolderGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'archiveFolder',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  archiveFolderLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'archiveFolder',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  archiveFolderBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'archiveFolder',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  archiveFolderStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'archiveFolder',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  archiveFolderEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'archiveFolder',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  archiveFolderContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'archiveFolder',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  archiveFolderMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'archiveFolder',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  archiveFolderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'archiveFolder', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  archiveFolderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'archiveFolder', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  attachmentsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'attachments', length, true, length, true);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  attachmentsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'attachments', 0, true, 0, true);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  attachmentsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'attachments', 0, false, 999999, true);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  attachmentsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'attachments', 0, true, length, include);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  attachmentsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'attachments', length, include, 999999, true);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  attachmentsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'attachments',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  createdAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  createdAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  dateEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'date',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  dateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'date',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  dateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'date',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  dateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'date',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  dateStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'date',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  dateEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'date',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  dateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'date',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  dateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'date',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  dateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'date', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  dateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'date', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  documentIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'documentId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  documentIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'documentId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  documentIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'documentId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  documentIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'documentId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  documentIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'documentId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  documentIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'documentId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  documentIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'documentId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  documentIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'documentId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  documentIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'documentId', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  documentIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'documentId', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  filePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'filePath'),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  filePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'filePath'),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  filePathEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'filePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  filePathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'filePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  filePathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'filePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  filePathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'filePath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  filePathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'filePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  filePathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'filePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  filePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'filePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  filePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'filePath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  filePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'filePath', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  filePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'filePath', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  followUpByIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'followUpBy'),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  followUpByIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'followUpBy'),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  followUpByEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'followUpBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  followUpByGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'followUpBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  followUpByLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'followUpBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  followUpByBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'followUpBy',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  followUpByStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'followUpBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  followUpByEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'followUpBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  followUpByContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'followUpBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  followUpByMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'followUpBy',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  followUpByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'followUpBy', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  followUpByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'followUpBy', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  followUpDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'followUpDate'),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  followUpDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'followUpDate'),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  followUpDateEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'followUpDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  followUpDateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'followUpDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  followUpDateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'followUpDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  followUpDateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'followUpDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  followUpDateStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'followUpDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  followUpDateEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'followUpDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  followUpDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'followUpDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  followUpDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'followUpDate',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  followUpDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'followUpDate', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  followUpDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'followUpDate', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  letterNumberEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'letterNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  letterNumberGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'letterNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  letterNumberLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'letterNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  letterNumberBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'letterNumber',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  letterNumberStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'letterNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  letterNumberEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'letterNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  letterNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'letterNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  letterNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'letterNumber',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  letterNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'letterNumber', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  letterNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'letterNumber', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  needsFollowUpEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'needsFollowUp', value: value),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  organizationEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'organization',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  organizationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'organization',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  organizationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'organization',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  organizationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'organization',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  organizationStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'organization',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  organizationEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'organization',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  organizationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'organization',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  organizationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'organization',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  organizationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'organization', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  organizationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'organization', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  priorityEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'priority',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  priorityGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'priority',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  priorityLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'priority',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  priorityBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'priority',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  priorityStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'priority',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  priorityEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'priority',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  priorityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'priority',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  priorityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'priority',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  priorityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'priority', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  priorityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'priority', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  recipientEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'recipient',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  recipientGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'recipient',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  recipientLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'recipient',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  recipientBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'recipient',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  recipientStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'recipient',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  recipientEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'recipient',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  recipientContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'recipient',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  recipientMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'recipient',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  recipientIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'recipient', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  recipientIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'recipient', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  registrationDateEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'registrationDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  registrationDateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'registrationDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  registrationDateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'registrationDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  registrationDateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'registrationDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  registrationDateStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'registrationDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  registrationDateEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'registrationDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  registrationDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'registrationDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  registrationDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'registrationDate',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  registrationDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'registrationDate', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  registrationDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'registrationDate', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  registrationNumberEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'registrationNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  registrationNumberGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'registrationNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  registrationNumberLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'registrationNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  registrationNumberBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'registrationNumber',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  registrationNumberStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'registrationNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  registrationNumberEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'registrationNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  registrationNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'registrationNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  registrationNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'registrationNumber',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  registrationNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'registrationNumber', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  registrationNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'registrationNumber', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  saveFileEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'saveFile', value: value),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  sendMethodEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'sendMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  sendMethodGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sendMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  sendMethodLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sendMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  sendMethodBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sendMethod',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  sendMethodStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'sendMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  sendMethodEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'sendMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  sendMethodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'sendMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  sendMethodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'sendMethod',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  sendMethodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sendMethod', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  sendMethodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'sendMethod', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  signerEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'signer',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  signerGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'signer',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  signerLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'signer',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  signerBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'signer',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  signerStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'signer',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  signerEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'signer',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  signerContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'signer',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  signerMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'signer',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  signerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'signer', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  signerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'signer', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  subjectEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'subject',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  subjectGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'subject',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  subjectLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'subject',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  subjectBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'subject',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  subjectStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'subject',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  subjectEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'subject',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  subjectContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'subject',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  subjectMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'subject',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  subjectIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'subject', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  subjectIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'subject', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  tagsElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'tags',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  tagsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'tags',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  tagsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'tags',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  tagsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'tags',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  tagsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'tags',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  tagsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'tags',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  tagsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'tags',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  tagsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'tags',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  tagsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tags', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  tagsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'tags', value: ''),
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  tagsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tags', length, true, length, true);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  tagsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tags', 0, true, 0, true);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  tagsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tags', 0, false, 999999, true);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  tagsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tags', 0, true, length, include);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  tagsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tags', length, include, 999999, true);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  tagsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension OutgoingDocumentDbQueryObject
    on QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QFilterCondition> {
  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterFilterCondition>
  attachmentsElement(FilterQuery<AttachmentDocumentDb> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'attachments');
    });
  }
}

extension OutgoingDocumentDbQueryLinks
    on QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QFilterCondition> {}

extension OutgoingDocumentDbQuerySortBy
    on QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QSortBy> {
  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByActionBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionBy', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByActionByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionBy', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByArchiveFolder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archiveFolder', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByArchiveFolderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archiveFolder', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByDocumentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentId', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByDocumentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentId', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByFollowUpBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpBy', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByFollowUpByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpBy', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByFollowUpDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpDate', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByFollowUpDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpDate', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByLetterNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'letterNumber', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByLetterNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'letterNumber', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByNeedsFollowUp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'needsFollowUp', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByNeedsFollowUpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'needsFollowUp', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByOrganization() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'organization', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByOrganizationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'organization', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByRecipient() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipient', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByRecipientDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipient', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByRegistrationDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationDate', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByRegistrationDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationDate', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByRegistrationNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationNumber', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortByRegistrationNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationNumber', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortBySaveFile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saveFile', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortBySaveFileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saveFile', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortBySendMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sendMethod', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortBySendMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sendMethod', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortBySigner() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signer', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortBySignerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signer', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortBySubject() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subject', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  sortBySubjectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subject', Sort.desc);
    });
  }
}

extension OutgoingDocumentDbQuerySortThenBy
    on QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QSortThenBy> {
  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByActionBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionBy', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByActionByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionBy', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByArchiveFolder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archiveFolder', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByArchiveFolderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archiveFolder', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByDocumentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentId', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByDocumentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentId', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByFollowUpBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpBy', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByFollowUpByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpBy', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByFollowUpDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpDate', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByFollowUpDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpDate', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByLetterNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'letterNumber', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByLetterNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'letterNumber', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByNeedsFollowUp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'needsFollowUp', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByNeedsFollowUpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'needsFollowUp', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByOrganization() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'organization', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByOrganizationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'organization', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByRecipient() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipient', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByRecipientDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipient', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByRegistrationDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationDate', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByRegistrationDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationDate', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByRegistrationNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationNumber', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenByRegistrationNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationNumber', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenBySaveFile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saveFile', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenBySaveFileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saveFile', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenBySendMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sendMethod', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenBySendMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sendMethod', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenBySigner() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signer', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenBySignerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signer', Sort.desc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenBySubject() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subject', Sort.asc);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QAfterSortBy>
  thenBySubjectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subject', Sort.desc);
    });
  }
}

extension OutgoingDocumentDbQueryWhereDistinct
    on QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QDistinct> {
  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QDistinct>
  distinctByActionBy({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actionBy', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QDistinct>
  distinctByArchiveFolder({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'archiveFolder',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QDistinct>
  distinctByDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QDistinct>
  distinctByDocumentId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'documentId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QDistinct>
  distinctByFilePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'filePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QDistinct>
  distinctByFollowUpBy({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'followUpBy', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QDistinct>
  distinctByFollowUpDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'followUpDate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QDistinct>
  distinctByLetterNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'letterNumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QDistinct>
  distinctByNeedsFollowUp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'needsFollowUp');
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QDistinct>
  distinctByOrganization({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'organization', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QDistinct>
  distinctByPriority({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'priority', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QDistinct>
  distinctByRecipient({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recipient', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QDistinct>
  distinctByRegistrationDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'registrationDate',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QDistinct>
  distinctByRegistrationNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'registrationNumber',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QDistinct>
  distinctBySaveFile() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'saveFile');
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QDistinct>
  distinctBySendMethod({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sendMethod', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QDistinct>
  distinctBySigner({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'signer', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QDistinct>
  distinctBySubject({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subject', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QDistinct>
  distinctByTags() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tags');
    });
  }
}

extension OutgoingDocumentDbQueryProperty
    on QueryBuilder<OutgoingDocumentDb, OutgoingDocumentDb, QQueryProperty> {
  QueryBuilder<OutgoingDocumentDb, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OutgoingDocumentDb, String, QQueryOperations>
  actionByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actionBy');
    });
  }

  QueryBuilder<OutgoingDocumentDb, String, QQueryOperations>
  archiveFolderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'archiveFolder');
    });
  }

  QueryBuilder<OutgoingDocumentDb, List<AttachmentDocumentDb>, QQueryOperations>
  attachmentsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'attachments');
    });
  }

  QueryBuilder<OutgoingDocumentDb, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<OutgoingDocumentDb, String, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<OutgoingDocumentDb, String, QQueryOperations>
  documentIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'documentId');
    });
  }

  QueryBuilder<OutgoingDocumentDb, String?, QQueryOperations>
  filePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'filePath');
    });
  }

  QueryBuilder<OutgoingDocumentDb, String?, QQueryOperations>
  followUpByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'followUpBy');
    });
  }

  QueryBuilder<OutgoingDocumentDb, String?, QQueryOperations>
  followUpDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'followUpDate');
    });
  }

  QueryBuilder<OutgoingDocumentDb, String, QQueryOperations>
  letterNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'letterNumber');
    });
  }

  QueryBuilder<OutgoingDocumentDb, bool, QQueryOperations>
  needsFollowUpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'needsFollowUp');
    });
  }

  QueryBuilder<OutgoingDocumentDb, String, QQueryOperations>
  organizationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'organization');
    });
  }

  QueryBuilder<OutgoingDocumentDb, String, QQueryOperations>
  priorityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'priority');
    });
  }

  QueryBuilder<OutgoingDocumentDb, String, QQueryOperations>
  recipientProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recipient');
    });
  }

  QueryBuilder<OutgoingDocumentDb, String, QQueryOperations>
  registrationDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'registrationDate');
    });
  }

  QueryBuilder<OutgoingDocumentDb, String, QQueryOperations>
  registrationNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'registrationNumber');
    });
  }

  QueryBuilder<OutgoingDocumentDb, bool, QQueryOperations> saveFileProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'saveFile');
    });
  }

  QueryBuilder<OutgoingDocumentDb, String, QQueryOperations>
  sendMethodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sendMethod');
    });
  }

  QueryBuilder<OutgoingDocumentDb, String, QQueryOperations> signerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'signer');
    });
  }

  QueryBuilder<OutgoingDocumentDb, String, QQueryOperations> subjectProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subject');
    });
  }

  QueryBuilder<OutgoingDocumentDb, List<String>, QQueryOperations>
  tagsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tags');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const AttachmentDocumentDbSchema = Schema(
  name: r'AttachmentDocumentDb',
  id: -1840357819104449082,
  properties: {
    r'bytes': PropertySchema(id: 0, name: r'bytes', type: IsarType.byteList),
    r'name': PropertySchema(id: 1, name: r'name', type: IsarType.string),
    r'path': PropertySchema(id: 2, name: r'path', type: IsarType.string),
  },
  estimateSize: _attachmentDocumentDbEstimateSize,
  serialize: _attachmentDocumentDbSerialize,
  deserialize: _attachmentDocumentDbDeserialize,
  deserializeProp: _attachmentDocumentDbDeserializeProp,
);

int _attachmentDocumentDbEstimateSize(
  AttachmentDocumentDb object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.bytes;
    if (value != null) {
      bytesCount += 3 + value.length;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.path;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _attachmentDocumentDbSerialize(
  AttachmentDocumentDb object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByteList(offsets[0], object.bytes);
  writer.writeString(offsets[1], object.name);
  writer.writeString(offsets[2], object.path);
}

AttachmentDocumentDb _attachmentDocumentDbDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AttachmentDocumentDb();
  object.bytes = reader.readByteList(offsets[0]);
  object.name = reader.readString(offsets[1]);
  object.path = reader.readStringOrNull(offsets[2]);
  return object;
}

P _attachmentDocumentDbDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readByteList(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension AttachmentDocumentDbQueryFilter
    on
        QueryBuilder<
          AttachmentDocumentDb,
          AttachmentDocumentDb,
          QFilterCondition
        > {
  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  bytesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'bytes'),
      );
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  bytesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'bytes'),
      );
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  bytesElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'bytes', value: value),
      );
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  bytesElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'bytes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  bytesElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'bytes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  bytesElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'bytes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  bytesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'bytes', length, true, length, true);
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  bytesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'bytes', 0, true, 0, true);
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  bytesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'bytes', 0, false, 999999, true);
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  bytesLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'bytes', 0, true, length, include);
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  bytesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'bytes', length, include, 999999, true);
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  bytesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bytes',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  nameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  nameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  nameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  pathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'path'),
      );
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  pathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'path'),
      );
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  pathEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'path',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  pathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'path',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  pathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'path',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  pathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'path',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  pathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'path',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  pathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'path',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  pathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'path',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  pathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'path',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  pathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'path', value: ''),
      );
    });
  }

  QueryBuilder<
    AttachmentDocumentDb,
    AttachmentDocumentDb,
    QAfterFilterCondition
  >
  pathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'path', value: ''),
      );
    });
  }
}

extension AttachmentDocumentDbQueryObject
    on
        QueryBuilder<
          AttachmentDocumentDb,
          AttachmentDocumentDb,
          QFilterCondition
        > {}
