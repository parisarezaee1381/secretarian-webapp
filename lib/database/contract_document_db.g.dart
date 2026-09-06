// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_document_db.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetContractDocumentDbCollection on Isar {
  IsarCollection<ContractDocumentDb> get contractDocumentDbs =>
      this.collection();
}

const ContractDocumentDbSchema = CollectionSchema(
  name: r'ContractDocumentDb',
  id: 7194621155860547236,
  properties: {
    r'actionBy': PropertySchema(
      id: 0,
      name: r'actionBy',
      type: IsarType.string,
    ),
    r'attachments': PropertySchema(
      id: 1,
      name: r'attachments',
      type: IsarType.objectList,
      target: r'ContractAttachmentDocumentDb',
    ),
    r'contractSubject': PropertySchema(
      id: 2,
      name: r'contractSubject',
      type: IsarType.string,
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
    r'letterNumber': PropertySchema(
      id: 7,
      name: r'letterNumber',
      type: IsarType.string,
    ),
    r'organization': PropertySchema(
      id: 8,
      name: r'organization',
      type: IsarType.string,
    ),
    r'recipient': PropertySchema(
      id: 9,
      name: r'recipient',
      type: IsarType.string,
    ),
    r'referenceContractNumber': PropertySchema(
      id: 10,
      name: r'referenceContractNumber',
      type: IsarType.string,
    ),
    r'registrationDate': PropertySchema(
      id: 11,
      name: r'registrationDate',
      type: IsarType.string,
    ),
    r'saveFile': PropertySchema(id: 12, name: r'saveFile', type: IsarType.bool),
    r'subject': PropertySchema(id: 13, name: r'subject', type: IsarType.string),
    r'tags': PropertySchema(id: 14, name: r'tags', type: IsarType.stringList),
  },
  estimateSize: _contractDocumentDbEstimateSize,
  serialize: _contractDocumentDbSerialize,
  deserialize: _contractDocumentDbDeserialize,
  deserializeProp: _contractDocumentDbDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'ContractAttachmentDocumentDb': ContractAttachmentDocumentDbSchema,
  },
  getId: _contractDocumentDbGetId,
  getLinks: _contractDocumentDbGetLinks,
  attach: _contractDocumentDbAttach,
  version: '3.1.0+1',
);

int _contractDocumentDbEstimateSize(
  ContractDocumentDb object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.actionBy.length * 3;
  bytesCount += 3 + object.attachments.length * 3;
  {
    final offsets = allOffsets[ContractAttachmentDocumentDb]!;
    for (var i = 0; i < object.attachments.length; i++) {
      final value = object.attachments[i];
      bytesCount += ContractAttachmentDocumentDbSchema.estimateSize(
        value,
        offsets,
        allOffsets,
      );
    }
  }
  bytesCount += 3 + object.contractSubject.length * 3;
  bytesCount += 3 + object.date.length * 3;
  bytesCount += 3 + object.documentId.length * 3;
  {
    final value = object.filePath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.letterNumber.length * 3;
  bytesCount += 3 + object.organization.length * 3;
  bytesCount += 3 + object.recipient.length * 3;
  bytesCount += 3 + object.referenceContractNumber.length * 3;
  bytesCount += 3 + object.registrationDate.length * 3;
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

void _contractDocumentDbSerialize(
  ContractDocumentDb object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.actionBy);
  writer.writeObjectList<ContractAttachmentDocumentDb>(
    offsets[1],
    allOffsets,
    ContractAttachmentDocumentDbSchema.serialize,
    object.attachments,
  );
  writer.writeString(offsets[2], object.contractSubject);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeString(offsets[4], object.date);
  writer.writeString(offsets[5], object.documentId);
  writer.writeString(offsets[6], object.filePath);
  writer.writeString(offsets[7], object.letterNumber);
  writer.writeString(offsets[8], object.organization);
  writer.writeString(offsets[9], object.recipient);
  writer.writeString(offsets[10], object.referenceContractNumber);
  writer.writeString(offsets[11], object.registrationDate);
  writer.writeBool(offsets[12], object.saveFile);
  writer.writeString(offsets[13], object.subject);
  writer.writeStringList(offsets[14], object.tags);
}

ContractDocumentDb _contractDocumentDbDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ContractDocumentDb();
  object.actionBy = reader.readString(offsets[0]);
  object.attachments =
      reader.readObjectList<ContractAttachmentDocumentDb>(
        offsets[1],
        ContractAttachmentDocumentDbSchema.deserialize,
        allOffsets,
        ContractAttachmentDocumentDb(),
      ) ??
      [];
  object.contractSubject = reader.readString(offsets[2]);
  object.createdAt = reader.readDateTime(offsets[3]);
  object.date = reader.readString(offsets[4]);
  object.documentId = reader.readString(offsets[5]);
  object.filePath = reader.readStringOrNull(offsets[6]);
  object.id = id;
  object.letterNumber = reader.readString(offsets[7]);
  object.organization = reader.readString(offsets[8]);
  object.recipient = reader.readString(offsets[9]);
  object.referenceContractNumber = reader.readString(offsets[10]);
  object.registrationDate = reader.readString(offsets[11]);
  object.saveFile = reader.readBool(offsets[12]);
  object.subject = reader.readString(offsets[13]);
  object.tags = reader.readStringList(offsets[14]) ?? [];
  return object;
}

P _contractDocumentDbDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readObjectList<ContractAttachmentDocumentDb>(
                offset,
                ContractAttachmentDocumentDbSchema.deserialize,
                allOffsets,
                ContractAttachmentDocumentDb(),
              ) ??
              [])
          as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _contractDocumentDbGetId(ContractDocumentDb object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _contractDocumentDbGetLinks(
  ContractDocumentDb object,
) {
  return [];
}

void _contractDocumentDbAttach(
  IsarCollection<dynamic> col,
  Id id,
  ContractDocumentDb object,
) {
  object.id = id;
}

extension ContractDocumentDbQueryWhereSort
    on QueryBuilder<ContractDocumentDb, ContractDocumentDb, QWhere> {
  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ContractDocumentDbQueryWhere
    on QueryBuilder<ContractDocumentDb, ContractDocumentDb, QWhereClause> {
  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterWhereClause>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterWhereClause>
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

extension ContractDocumentDbQueryFilter
    on QueryBuilder<ContractDocumentDb, ContractDocumentDb, QFilterCondition> {
  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  actionByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'actionBy', value: ''),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  actionByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'actionBy', value: ''),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  attachmentsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'attachments', length, true, length, true);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  attachmentsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'attachments', 0, true, 0, true);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  attachmentsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'attachments', 0, false, 999999, true);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  attachmentsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'attachments', 0, true, length, include);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  attachmentsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'attachments', length, include, 999999, true);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  contractSubjectEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'contractSubject',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  contractSubjectGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'contractSubject',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  contractSubjectLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'contractSubject',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  contractSubjectBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'contractSubject',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  contractSubjectStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'contractSubject',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  contractSubjectEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'contractSubject',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  contractSubjectContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'contractSubject',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  contractSubjectMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'contractSubject',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  contractSubjectIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'contractSubject', value: ''),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  contractSubjectIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'contractSubject', value: ''),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  dateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'date', value: ''),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  dateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'date', value: ''),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  documentIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'documentId', value: ''),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  documentIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'documentId', value: ''),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  filePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'filePath'),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  filePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'filePath'),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  filePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'filePath', value: ''),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  filePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'filePath', value: ''),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  letterNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'letterNumber', value: ''),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  letterNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'letterNumber', value: ''),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  organizationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'organization', value: ''),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  organizationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'organization', value: ''),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  recipientIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'recipient', value: ''),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  recipientIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'recipient', value: ''),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  referenceContractNumberEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'referenceContractNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  referenceContractNumberGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'referenceContractNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  referenceContractNumberLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'referenceContractNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  referenceContractNumberBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'referenceContractNumber',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  referenceContractNumberStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'referenceContractNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  referenceContractNumberEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'referenceContractNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  referenceContractNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'referenceContractNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  referenceContractNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'referenceContractNumber',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  referenceContractNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'referenceContractNumber',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  referenceContractNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'referenceContractNumber',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  registrationDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'registrationDate', value: ''),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  registrationDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'registrationDate', value: ''),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  saveFileEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'saveFile', value: value),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  subjectIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'subject', value: ''),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  subjectIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'subject', value: ''),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  tagsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tags', value: ''),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  tagsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'tags', value: ''),
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  tagsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tags', length, true, length, true);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  tagsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tags', 0, true, 0, true);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  tagsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tags', 0, false, 999999, true);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  tagsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tags', 0, true, length, include);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  tagsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tags', length, include, 999999, true);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
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

extension ContractDocumentDbQueryObject
    on QueryBuilder<ContractDocumentDb, ContractDocumentDb, QFilterCondition> {
  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterFilterCondition>
  attachmentsElement(FilterQuery<ContractAttachmentDocumentDb> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'attachments');
    });
  }
}

extension ContractDocumentDbQueryLinks
    on QueryBuilder<ContractDocumentDb, ContractDocumentDb, QFilterCondition> {}

extension ContractDocumentDbQuerySortBy
    on QueryBuilder<ContractDocumentDb, ContractDocumentDb, QSortBy> {
  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  sortByActionBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionBy', Sort.asc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  sortByActionByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionBy', Sort.desc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  sortByContractSubject() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contractSubject', Sort.asc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  sortByContractSubjectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contractSubject', Sort.desc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  sortByDocumentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentId', Sort.asc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  sortByDocumentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentId', Sort.desc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  sortByFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.asc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  sortByFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.desc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  sortByLetterNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'letterNumber', Sort.asc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  sortByLetterNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'letterNumber', Sort.desc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  sortByOrganization() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'organization', Sort.asc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  sortByOrganizationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'organization', Sort.desc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  sortByRecipient() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipient', Sort.asc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  sortByRecipientDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipient', Sort.desc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  sortByReferenceContractNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceContractNumber', Sort.asc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  sortByReferenceContractNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceContractNumber', Sort.desc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  sortByRegistrationDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationDate', Sort.asc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  sortByRegistrationDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationDate', Sort.desc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  sortBySaveFile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saveFile', Sort.asc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  sortBySaveFileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saveFile', Sort.desc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  sortBySubject() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subject', Sort.asc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  sortBySubjectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subject', Sort.desc);
    });
  }
}

extension ContractDocumentDbQuerySortThenBy
    on QueryBuilder<ContractDocumentDb, ContractDocumentDb, QSortThenBy> {
  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  thenByActionBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionBy', Sort.asc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  thenByActionByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionBy', Sort.desc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  thenByContractSubject() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contractSubject', Sort.asc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  thenByContractSubjectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contractSubject', Sort.desc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  thenByDocumentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentId', Sort.asc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  thenByDocumentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentId', Sort.desc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  thenByFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.asc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  thenByFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.desc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  thenByLetterNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'letterNumber', Sort.asc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  thenByLetterNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'letterNumber', Sort.desc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  thenByOrganization() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'organization', Sort.asc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  thenByOrganizationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'organization', Sort.desc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  thenByRecipient() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipient', Sort.asc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  thenByRecipientDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipient', Sort.desc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  thenByReferenceContractNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceContractNumber', Sort.asc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  thenByReferenceContractNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceContractNumber', Sort.desc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  thenByRegistrationDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationDate', Sort.asc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  thenByRegistrationDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationDate', Sort.desc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  thenBySaveFile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saveFile', Sort.asc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  thenBySaveFileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saveFile', Sort.desc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  thenBySubject() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subject', Sort.asc);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QAfterSortBy>
  thenBySubjectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subject', Sort.desc);
    });
  }
}

extension ContractDocumentDbQueryWhereDistinct
    on QueryBuilder<ContractDocumentDb, ContractDocumentDb, QDistinct> {
  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QDistinct>
  distinctByActionBy({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actionBy', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QDistinct>
  distinctByContractSubject({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'contractSubject',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QDistinct>
  distinctByDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QDistinct>
  distinctByDocumentId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'documentId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QDistinct>
  distinctByFilePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'filePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QDistinct>
  distinctByLetterNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'letterNumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QDistinct>
  distinctByOrganization({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'organization', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QDistinct>
  distinctByRecipient({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recipient', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QDistinct>
  distinctByReferenceContractNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'referenceContractNumber',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QDistinct>
  distinctByRegistrationDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'registrationDate',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QDistinct>
  distinctBySaveFile() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'saveFile');
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QDistinct>
  distinctBySubject({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subject', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ContractDocumentDb, ContractDocumentDb, QDistinct>
  distinctByTags() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tags');
    });
  }
}

extension ContractDocumentDbQueryProperty
    on QueryBuilder<ContractDocumentDb, ContractDocumentDb, QQueryProperty> {
  QueryBuilder<ContractDocumentDb, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ContractDocumentDb, String, QQueryOperations>
  actionByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actionBy');
    });
  }

  QueryBuilder<
    ContractDocumentDb,
    List<ContractAttachmentDocumentDb>,
    QQueryOperations
  >
  attachmentsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'attachments');
    });
  }

  QueryBuilder<ContractDocumentDb, String, QQueryOperations>
  contractSubjectProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contractSubject');
    });
  }

  QueryBuilder<ContractDocumentDb, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ContractDocumentDb, String, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<ContractDocumentDb, String, QQueryOperations>
  documentIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'documentId');
    });
  }

  QueryBuilder<ContractDocumentDb, String?, QQueryOperations>
  filePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'filePath');
    });
  }

  QueryBuilder<ContractDocumentDb, String, QQueryOperations>
  letterNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'letterNumber');
    });
  }

  QueryBuilder<ContractDocumentDb, String, QQueryOperations>
  organizationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'organization');
    });
  }

  QueryBuilder<ContractDocumentDb, String, QQueryOperations>
  recipientProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recipient');
    });
  }

  QueryBuilder<ContractDocumentDb, String, QQueryOperations>
  referenceContractNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'referenceContractNumber');
    });
  }

  QueryBuilder<ContractDocumentDb, String, QQueryOperations>
  registrationDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'registrationDate');
    });
  }

  QueryBuilder<ContractDocumentDb, bool, QQueryOperations> saveFileProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'saveFile');
    });
  }

  QueryBuilder<ContractDocumentDb, String, QQueryOperations> subjectProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subject');
    });
  }

  QueryBuilder<ContractDocumentDb, List<String>, QQueryOperations>
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

const ContractAttachmentDocumentDbSchema = Schema(
  name: r'ContractAttachmentDocumentDb',
  id: -4091645086195164093,
  properties: {
    r'bytes': PropertySchema(id: 0, name: r'bytes', type: IsarType.byteList),
    r'name': PropertySchema(id: 1, name: r'name', type: IsarType.string),
    r'path': PropertySchema(id: 2, name: r'path', type: IsarType.string),
  },
  estimateSize: _contractAttachmentDocumentDbEstimateSize,
  serialize: _contractAttachmentDocumentDbSerialize,
  deserialize: _contractAttachmentDocumentDbDeserialize,
  deserializeProp: _contractAttachmentDocumentDbDeserializeProp,
);

int _contractAttachmentDocumentDbEstimateSize(
  ContractAttachmentDocumentDb object,
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

void _contractAttachmentDocumentDbSerialize(
  ContractAttachmentDocumentDb object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByteList(offsets[0], object.bytes);
  writer.writeString(offsets[1], object.name);
  writer.writeString(offsets[2], object.path);
}

ContractAttachmentDocumentDb _contractAttachmentDocumentDbDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ContractAttachmentDocumentDb();
  object.bytes = reader.readByteList(offsets[0]);
  object.name = reader.readString(offsets[1]);
  object.path = reader.readStringOrNull(offsets[2]);
  return object;
}

P _contractAttachmentDocumentDbDeserializeProp<P>(
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

extension ContractAttachmentDocumentDbQueryFilter
    on
        QueryBuilder<
          ContractAttachmentDocumentDb,
          ContractAttachmentDocumentDb,
          QFilterCondition
        > {
  QueryBuilder<
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
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
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
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
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
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
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
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
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
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
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
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
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
    QAfterFilterCondition
  >
  bytesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'bytes', length, true, length, true);
    });
  }

  QueryBuilder<
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
    QAfterFilterCondition
  >
  bytesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'bytes', 0, true, 0, true);
    });
  }

  QueryBuilder<
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
    QAfterFilterCondition
  >
  bytesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'bytes', 0, false, 999999, true);
    });
  }

  QueryBuilder<
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
    QAfterFilterCondition
  >
  bytesLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'bytes', 0, true, length, include);
    });
  }

  QueryBuilder<
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
    QAfterFilterCondition
  >
  bytesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'bytes', length, include, 999999, true);
    });
  }

  QueryBuilder<
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
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
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
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
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
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
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
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
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
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
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
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
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
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
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
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
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
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
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
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
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
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
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
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
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
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
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
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
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
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
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
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
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
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
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
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
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
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
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
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
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
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
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
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
    ContractAttachmentDocumentDb,
    ContractAttachmentDocumentDb,
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

extension ContractAttachmentDocumentDbQueryObject
    on
        QueryBuilder<
          ContractAttachmentDocumentDb,
          ContractAttachmentDocumentDb,
          QFilterCondition
        > {}
