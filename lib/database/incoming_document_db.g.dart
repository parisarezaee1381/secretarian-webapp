// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incoming_document_db.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIncomingDocumentDbCollection on Isar {
  IsarCollection<IncomingDocumentDb> get incomingDocumentDbs =>
      this.collection();
}

const IncomingDocumentDbSchema = CollectionSchema(
  name: r'IncomingDocumentDb',
  id: 5181264296762117421,
  properties: {
    r'archiveFolder': PropertySchema(
      id: 0,
      name: r'archiveFolder',
      type: IsarType.string,
    ),
    r'attachments': PropertySchema(
      id: 1,
      name: r'attachments',
      type: IsarType.objectList,
      target: r'IncomingAttachmentDocumentDb',
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'date': PropertySchema(
      id: 3,
      name: r'date',
      type: IsarType.string,
    ),
    r'documentId': PropertySchema(
      id: 4,
      name: r'documentId',
      type: IsarType.string,
    ),
    r'filePath': PropertySchema(
      id: 5,
      name: r'filePath',
      type: IsarType.string,
    ),
    r'followUpBy': PropertySchema(
      id: 6,
      name: r'followUpBy',
      type: IsarType.string,
    ),
    r'followUpDate': PropertySchema(
      id: 7,
      name: r'followUpDate',
      type: IsarType.string,
    ),
    r'letterNumber': PropertySchema(
      id: 8,
      name: r'letterNumber',
      type: IsarType.string,
    ),
    r'needsFollowUp': PropertySchema(
      id: 9,
      name: r'needsFollowUp',
      type: IsarType.bool,
    ),
    r'organization': PropertySchema(
      id: 10,
      name: r'organization',
      type: IsarType.string,
    ),
    r'priority': PropertySchema(
      id: 11,
      name: r'priority',
      type: IsarType.string,
    ),
    r'recipient': PropertySchema(
      id: 12,
      name: r'recipient',
      type: IsarType.string,
    ),
    r'registrationDate': PropertySchema(
      id: 13,
      name: r'registrationDate',
      type: IsarType.string,
    ),
    r'saveFile': PropertySchema(
      id: 14,
      name: r'saveFile',
      type: IsarType.bool,
    ),
    r'sender': PropertySchema(
      id: 15,
      name: r'sender',
      type: IsarType.string,
    ),
    r'senderLetterNumber': PropertySchema(
      id: 16,
      name: r'senderLetterNumber',
      type: IsarType.string,
    ),
    r'subject': PropertySchema(
      id: 17,
      name: r'subject',
      type: IsarType.string,
    ),
    r'tags': PropertySchema(
      id: 18,
      name: r'tags',
      type: IsarType.stringList,
    )
  },
  estimateSize: _incomingDocumentDbEstimateSize,
  serialize: _incomingDocumentDbSerialize,
  deserialize: _incomingDocumentDbDeserialize,
  deserializeProp: _incomingDocumentDbDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'IncomingAttachmentDocumentDb': IncomingAttachmentDocumentDbSchema
  },
  getId: _incomingDocumentDbGetId,
  getLinks: _incomingDocumentDbGetLinks,
  attach: _incomingDocumentDbAttach,
  version: '3.1.0+1',
);

int _incomingDocumentDbEstimateSize(
  IncomingDocumentDb object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.archiveFolder.length * 3;
  bytesCount += 3 + object.attachments.length * 3;
  {
    final offsets = allOffsets[IncomingAttachmentDocumentDb]!;
    for (var i = 0; i < object.attachments.length; i++) {
      final value = object.attachments[i];
      bytesCount += IncomingAttachmentDocumentDbSchema.estimateSize(
          value, offsets, allOffsets);
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
  bytesCount += 3 + object.sender.length * 3;
  bytesCount += 3 + object.senderLetterNumber.length * 3;
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

void _incomingDocumentDbSerialize(
  IncomingDocumentDb object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.archiveFolder);
  writer.writeObjectList<IncomingAttachmentDocumentDb>(
    offsets[1],
    allOffsets,
    IncomingAttachmentDocumentDbSchema.serialize,
    object.attachments,
  );
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.date);
  writer.writeString(offsets[4], object.documentId);
  writer.writeString(offsets[5], object.filePath);
  writer.writeString(offsets[6], object.followUpBy);
  writer.writeString(offsets[7], object.followUpDate);
  writer.writeString(offsets[8], object.letterNumber);
  writer.writeBool(offsets[9], object.needsFollowUp);
  writer.writeString(offsets[10], object.organization);
  writer.writeString(offsets[11], object.priority);
  writer.writeString(offsets[12], object.recipient);
  writer.writeString(offsets[13], object.registrationDate);
  writer.writeBool(offsets[14], object.saveFile);
  writer.writeString(offsets[15], object.sender);
  writer.writeString(offsets[16], object.senderLetterNumber);
  writer.writeString(offsets[17], object.subject);
  writer.writeStringList(offsets[18], object.tags);
}

IncomingDocumentDb _incomingDocumentDbDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IncomingDocumentDb();
  object.archiveFolder = reader.readString(offsets[0]);
  object.attachments = reader.readObjectList<IncomingAttachmentDocumentDb>(
        offsets[1],
        IncomingAttachmentDocumentDbSchema.deserialize,
        allOffsets,
        IncomingAttachmentDocumentDb(),
      ) ??
      [];
  object.createdAt = reader.readDateTime(offsets[2]);
  object.date = reader.readString(offsets[3]);
  object.documentId = reader.readString(offsets[4]);
  object.filePath = reader.readStringOrNull(offsets[5]);
  object.followUpBy = reader.readStringOrNull(offsets[6]);
  object.followUpDate = reader.readStringOrNull(offsets[7]);
  object.id = id;
  object.letterNumber = reader.readString(offsets[8]);
  object.needsFollowUp = reader.readBool(offsets[9]);
  object.organization = reader.readString(offsets[10]);
  object.priority = reader.readString(offsets[11]);
  object.recipient = reader.readString(offsets[12]);
  object.registrationDate = reader.readString(offsets[13]);
  object.saveFile = reader.readBool(offsets[14]);
  object.sender = reader.readString(offsets[15]);
  object.senderLetterNumber = reader.readString(offsets[16]);
  object.subject = reader.readString(offsets[17]);
  object.tags = reader.readStringList(offsets[18]) ?? [];
  return object;
}

P _incomingDocumentDbDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readObjectList<IncomingAttachmentDocumentDb>(
            offset,
            IncomingAttachmentDocumentDbSchema.deserialize,
            allOffsets,
            IncomingAttachmentDocumentDb(),
          ) ??
          []) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readBool(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _incomingDocumentDbGetId(IncomingDocumentDb object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _incomingDocumentDbGetLinks(
    IncomingDocumentDb object) {
  return [];
}

void _incomingDocumentDbAttach(
    IsarCollection<dynamic> col, Id id, IncomingDocumentDb object) {
  object.id = id;
}

extension IncomingDocumentDbQueryWhereSort
    on QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QWhere> {
  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IncomingDocumentDbQueryWhere
    on QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QWhereClause> {
  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterWhereClause>
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

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IncomingDocumentDbQueryFilter
    on QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QFilterCondition> {
  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      archiveFolderEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'archiveFolder',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      archiveFolderGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'archiveFolder',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      archiveFolderLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'archiveFolder',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      archiveFolderBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'archiveFolder',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      archiveFolderStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'archiveFolder',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      archiveFolderEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'archiveFolder',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      archiveFolderContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'archiveFolder',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      archiveFolderMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'archiveFolder',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      archiveFolderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'archiveFolder',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      archiveFolderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'archiveFolder',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      attachmentsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'attachments',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      attachmentsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'attachments',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      attachmentsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'attachments',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      attachmentsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'attachments',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      attachmentsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'attachments',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      dateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      dateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      dateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      dateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      dateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      dateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      dateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      dateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'date',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      dateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      dateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      documentIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'documentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      documentIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'documentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      documentIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'documentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      documentIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'documentId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      documentIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'documentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      documentIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'documentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      documentIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'documentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      documentIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'documentId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      documentIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'documentId',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      documentIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'documentId',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      filePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'filePath',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      filePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'filePath',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      filePathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      filePathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      filePathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      filePathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'filePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      filePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      filePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      filePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      filePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'filePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      filePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filePath',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      filePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'filePath',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      followUpByIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'followUpBy',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      followUpByIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'followUpBy',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      followUpByEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'followUpBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      followUpByGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'followUpBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      followUpByLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'followUpBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      followUpByBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'followUpBy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      followUpByStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'followUpBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      followUpByEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'followUpBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      followUpByContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'followUpBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      followUpByMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'followUpBy',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      followUpByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'followUpBy',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      followUpByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'followUpBy',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      followUpDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'followUpDate',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      followUpDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'followUpDate',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      followUpDateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'followUpDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      followUpDateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'followUpDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      followUpDateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'followUpDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      followUpDateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'followUpDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      followUpDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'followUpDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      followUpDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'followUpDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      followUpDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'followUpDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      followUpDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'followUpDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      followUpDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'followUpDate',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      followUpDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'followUpDate',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      letterNumberEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'letterNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      letterNumberGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'letterNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      letterNumberLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'letterNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      letterNumberBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'letterNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      letterNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'letterNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      letterNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'letterNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      letterNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'letterNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      letterNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'letterNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      letterNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'letterNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      letterNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'letterNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      needsFollowUpEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'needsFollowUp',
        value: value,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      organizationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'organization',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      organizationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'organization',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      organizationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'organization',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      organizationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'organization',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      organizationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'organization',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      organizationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'organization',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      organizationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'organization',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      organizationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'organization',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      organizationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'organization',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      organizationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'organization',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      priorityEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      priorityGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      priorityLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      priorityBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'priority',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      priorityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      priorityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      priorityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      priorityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'priority',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      priorityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priority',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      priorityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'priority',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      recipientEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recipient',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      recipientGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recipient',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      recipientLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recipient',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      recipientBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recipient',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      recipientStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recipient',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      recipientEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recipient',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      recipientContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recipient',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      recipientMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recipient',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      recipientIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recipient',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      recipientIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recipient',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      registrationDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'registrationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      registrationDateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'registrationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      registrationDateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'registrationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      registrationDateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'registrationDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      registrationDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'registrationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      registrationDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'registrationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      registrationDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'registrationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      registrationDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'registrationDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      registrationDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'registrationDate',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      registrationDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'registrationDate',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      saveFileEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'saveFile',
        value: value,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      senderEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      senderGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      senderLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      senderBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sender',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      senderStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      senderEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      senderContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      senderMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sender',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      senderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sender',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      senderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sender',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      senderLetterNumberEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'senderLetterNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      senderLetterNumberGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'senderLetterNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      senderLetterNumberLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'senderLetterNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      senderLetterNumberBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'senderLetterNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      senderLetterNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'senderLetterNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      senderLetterNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'senderLetterNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      senderLetterNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'senderLetterNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      senderLetterNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'senderLetterNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      senderLetterNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'senderLetterNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      senderLetterNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'senderLetterNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      subjectEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subject',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      subjectGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subject',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      subjectLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subject',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      subjectBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subject',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      subjectStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'subject',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      subjectEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'subject',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      subjectContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'subject',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      subjectMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'subject',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      subjectIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subject',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      subjectIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'subject',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      tagsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      tagsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      tagsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      tagsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tags',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      tagsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      tagsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      tagsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      tagsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tags',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      tagsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tags',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      tagsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tags',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      tagsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      tagsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      tagsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      tagsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      tagsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
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

extension IncomingDocumentDbQueryObject
    on QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QFilterCondition> {
  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterFilterCondition>
      attachmentsElement(FilterQuery<IncomingAttachmentDocumentDb> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'attachments');
    });
  }
}

extension IncomingDocumentDbQueryLinks
    on QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QFilterCondition> {}

extension IncomingDocumentDbQuerySortBy
    on QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QSortBy> {
  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortByArchiveFolder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archiveFolder', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortByArchiveFolderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archiveFolder', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortByDocumentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentId', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortByDocumentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentId', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortByFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortByFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortByFollowUpBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpBy', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortByFollowUpByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpBy', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortByFollowUpDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpDate', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortByFollowUpDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpDate', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortByLetterNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'letterNumber', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortByLetterNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'letterNumber', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortByNeedsFollowUp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'needsFollowUp', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortByNeedsFollowUpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'needsFollowUp', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortByOrganization() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'organization', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortByOrganizationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'organization', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortByRecipient() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipient', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortByRecipientDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipient', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortByRegistrationDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationDate', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortByRegistrationDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationDate', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortBySaveFile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saveFile', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortBySaveFileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saveFile', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortBySender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sender', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortBySenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sender', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortBySenderLetterNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderLetterNumber', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortBySenderLetterNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderLetterNumber', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortBySubject() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subject', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      sortBySubjectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subject', Sort.desc);
    });
  }
}

extension IncomingDocumentDbQuerySortThenBy
    on QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QSortThenBy> {
  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenByArchiveFolder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archiveFolder', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenByArchiveFolderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archiveFolder', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenByDocumentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentId', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenByDocumentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentId', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenByFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenByFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenByFollowUpBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpBy', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenByFollowUpByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpBy', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenByFollowUpDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpDate', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenByFollowUpDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpDate', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenByLetterNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'letterNumber', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenByLetterNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'letterNumber', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenByNeedsFollowUp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'needsFollowUp', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenByNeedsFollowUpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'needsFollowUp', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenByOrganization() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'organization', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenByOrganizationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'organization', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenByRecipient() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipient', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenByRecipientDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipient', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenByRegistrationDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationDate', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenByRegistrationDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationDate', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenBySaveFile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saveFile', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenBySaveFileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saveFile', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenBySender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sender', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenBySenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sender', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenBySenderLetterNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderLetterNumber', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenBySenderLetterNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderLetterNumber', Sort.desc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenBySubject() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subject', Sort.asc);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QAfterSortBy>
      thenBySubjectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subject', Sort.desc);
    });
  }
}

extension IncomingDocumentDbQueryWhereDistinct
    on QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QDistinct> {
  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QDistinct>
      distinctByArchiveFolder({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'archiveFolder',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QDistinct>
      distinctByDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QDistinct>
      distinctByDocumentId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'documentId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QDistinct>
      distinctByFilePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'filePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QDistinct>
      distinctByFollowUpBy({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'followUpBy', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QDistinct>
      distinctByFollowUpDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'followUpDate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QDistinct>
      distinctByLetterNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'letterNumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QDistinct>
      distinctByNeedsFollowUp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'needsFollowUp');
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QDistinct>
      distinctByOrganization({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'organization', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QDistinct>
      distinctByPriority({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'priority', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QDistinct>
      distinctByRecipient({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recipient', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QDistinct>
      distinctByRegistrationDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'registrationDate',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QDistinct>
      distinctBySaveFile() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'saveFile');
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QDistinct>
      distinctBySender({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sender', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QDistinct>
      distinctBySenderLetterNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'senderLetterNumber',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QDistinct>
      distinctBySubject({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subject', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QDistinct>
      distinctByTags() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tags');
    });
  }
}

extension IncomingDocumentDbQueryProperty
    on QueryBuilder<IncomingDocumentDb, IncomingDocumentDb, QQueryProperty> {
  QueryBuilder<IncomingDocumentDb, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IncomingDocumentDb, String, QQueryOperations>
      archiveFolderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'archiveFolder');
    });
  }

  QueryBuilder<IncomingDocumentDb, List<IncomingAttachmentDocumentDb>,
      QQueryOperations> attachmentsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'attachments');
    });
  }

  QueryBuilder<IncomingDocumentDb, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<IncomingDocumentDb, String, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<IncomingDocumentDb, String, QQueryOperations>
      documentIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'documentId');
    });
  }

  QueryBuilder<IncomingDocumentDb, String?, QQueryOperations>
      filePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'filePath');
    });
  }

  QueryBuilder<IncomingDocumentDb, String?, QQueryOperations>
      followUpByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'followUpBy');
    });
  }

  QueryBuilder<IncomingDocumentDb, String?, QQueryOperations>
      followUpDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'followUpDate');
    });
  }

  QueryBuilder<IncomingDocumentDb, String, QQueryOperations>
      letterNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'letterNumber');
    });
  }

  QueryBuilder<IncomingDocumentDb, bool, QQueryOperations>
      needsFollowUpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'needsFollowUp');
    });
  }

  QueryBuilder<IncomingDocumentDb, String, QQueryOperations>
      organizationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'organization');
    });
  }

  QueryBuilder<IncomingDocumentDb, String, QQueryOperations>
      priorityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'priority');
    });
  }

  QueryBuilder<IncomingDocumentDb, String, QQueryOperations>
      recipientProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recipient');
    });
  }

  QueryBuilder<IncomingDocumentDb, String, QQueryOperations>
      registrationDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'registrationDate');
    });
  }

  QueryBuilder<IncomingDocumentDb, bool, QQueryOperations> saveFileProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'saveFile');
    });
  }

  QueryBuilder<IncomingDocumentDb, String, QQueryOperations> senderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sender');
    });
  }

  QueryBuilder<IncomingDocumentDb, String, QQueryOperations>
      senderLetterNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'senderLetterNumber');
    });
  }

  QueryBuilder<IncomingDocumentDb, String, QQueryOperations> subjectProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subject');
    });
  }

  QueryBuilder<IncomingDocumentDb, List<String>, QQueryOperations>
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

const IncomingAttachmentDocumentDbSchema = Schema(
  name: r'IncomingAttachmentDocumentDb',
  id: -4808245462239998144,
  properties: {
    r'bytes': PropertySchema(
      id: 0,
      name: r'bytes',
      type: IsarType.byteList,
    ),
    r'name': PropertySchema(
      id: 1,
      name: r'name',
      type: IsarType.string,
    ),
    r'path': PropertySchema(
      id: 2,
      name: r'path',
      type: IsarType.string,
    )
  },
  estimateSize: _incomingAttachmentDocumentDbEstimateSize,
  serialize: _incomingAttachmentDocumentDbSerialize,
  deserialize: _incomingAttachmentDocumentDbDeserialize,
  deserializeProp: _incomingAttachmentDocumentDbDeserializeProp,
);

int _incomingAttachmentDocumentDbEstimateSize(
  IncomingAttachmentDocumentDb object,
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

void _incomingAttachmentDocumentDbSerialize(
  IncomingAttachmentDocumentDb object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByteList(offsets[0], object.bytes);
  writer.writeString(offsets[1], object.name);
  writer.writeString(offsets[2], object.path);
}

IncomingAttachmentDocumentDb _incomingAttachmentDocumentDbDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IncomingAttachmentDocumentDb();
  object.bytes = reader.readByteList(offsets[0]);
  object.name = reader.readString(offsets[1]);
  object.path = reader.readStringOrNull(offsets[2]);
  return object;
}

P _incomingAttachmentDocumentDbDeserializeProp<P>(
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

extension IncomingAttachmentDocumentDbQueryFilter on QueryBuilder<
    IncomingAttachmentDocumentDb,
    IncomingAttachmentDocumentDb,
    QFilterCondition> {
  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> bytesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bytes',
      ));
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> bytesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bytes',
      ));
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> bytesElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bytes',
        value: value,
      ));
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> bytesElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bytes',
        value: value,
      ));
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> bytesElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bytes',
        value: value,
      ));
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> bytesElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bytes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> bytesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bytes',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> bytesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bytes',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> bytesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bytes',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> bytesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bytes',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> bytesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bytes',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> bytesLengthBetween(
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

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
          QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
          QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> pathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'path',
      ));
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> pathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'path',
      ));
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> pathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> pathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> pathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> pathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'path',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> pathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> pathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
          QAfterFilterCondition>
      pathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
          QAfterFilterCondition>
      pathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'path',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> pathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'path',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomingAttachmentDocumentDb, IncomingAttachmentDocumentDb,
      QAfterFilterCondition> pathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'path',
        value: '',
      ));
    });
  }
}

extension IncomingAttachmentDocumentDbQueryObject on QueryBuilder<
    IncomingAttachmentDocumentDb,
    IncomingAttachmentDocumentDb,
    QFilterCondition> {}
