// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'season.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSeasonCollection on Isar {
  IsarCollection<Season> get seasons => this.collection();
}

const SeasonSchema = CollectionSchema(
  name: r'Season',
  id: 7798637676833157862,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'endYear': PropertySchema(
      id: 1,
      name: r'endYear',
      type: IsarType.long,
    ),
    r'hashCode': PropertySchema(
      id: 2,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'isCurrent': PropertySchema(
      id: 3,
      name: r'isCurrent',
      type: IsarType.bool,
    ),
    r'isFuture': PropertySchema(
      id: 4,
      name: r'isFuture',
      type: IsarType.bool,
    ),
    r'isPast': PropertySchema(
      id: 5,
      name: r'isPast',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 6,
      name: r'name',
      type: IsarType.string,
    ),
    r'startYear': PropertySchema(
      id: 7,
      name: r'startYear',
      type: IsarType.long,
    )
  },
  estimateSize: _seasonEstimateSize,
  serialize: _seasonSerialize,
  deserialize: _seasonDeserialize,
  deserializeProp: _seasonDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _seasonGetId,
  getLinks: _seasonGetLinks,
  attach: _seasonAttach,
  version: '3.1.0+1',
);

int _seasonEstimateSize(
  Season object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _seasonSerialize(
  Season object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeLong(offsets[1], object.endYear);
  writer.writeLong(offsets[2], object.hashCode);
  writer.writeBool(offsets[3], object.isCurrent);
  writer.writeBool(offsets[4], object.isFuture);
  writer.writeBool(offsets[5], object.isPast);
  writer.writeString(offsets[6], object.name);
  writer.writeLong(offsets[7], object.startYear);
}

Season _seasonDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Season(
    createdAt: reader.readDateTime(offsets[0]),
    endYear: reader.readLong(offsets[1]),
    id: id,
    name: reader.readString(offsets[6]),
    startYear: reader.readLong(offsets[7]),
  );
  return object;
}

P _seasonDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _seasonGetId(Season object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _seasonGetLinks(Season object) {
  return [];
}

void _seasonAttach(IsarCollection<dynamic> col, Id id, Season object) {
  object.id = id;
}

extension SeasonQueryWhereSort on QueryBuilder<Season, Season, QWhere> {
  QueryBuilder<Season, Season, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SeasonQueryWhere on QueryBuilder<Season, Season, QWhereClause> {
  QueryBuilder<Season, Season, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Season, Season, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Season, Season, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Season, Season, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Season, Season, QAfterWhereClause> idBetween(
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

extension SeasonQueryFilter on QueryBuilder<Season, Season, QFilterCondition> {
  QueryBuilder<Season, Season, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Season, Season, QAfterFilterCondition> createdAtGreaterThan(
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

  QueryBuilder<Season, Season, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<Season, Season, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<Season, Season, QAfterFilterCondition> endYearEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endYear',
        value: value,
      ));
    });
  }

  QueryBuilder<Season, Season, QAfterFilterCondition> endYearGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endYear',
        value: value,
      ));
    });
  }

  QueryBuilder<Season, Season, QAfterFilterCondition> endYearLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endYear',
        value: value,
      ));
    });
  }

  QueryBuilder<Season, Season, QAfterFilterCondition> endYearBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endYear',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Season, Season, QAfterFilterCondition> hashCodeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<Season, Season, QAfterFilterCondition> hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<Season, Season, QAfterFilterCondition> hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<Season, Season, QAfterFilterCondition> hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Season, Season, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Season, Season, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Season, Season, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Season, Season, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Season, Season, QAfterFilterCondition> isCurrentEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCurrent',
        value: value,
      ));
    });
  }

  QueryBuilder<Season, Season, QAfterFilterCondition> isFutureEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFuture',
        value: value,
      ));
    });
  }

  QueryBuilder<Season, Season, QAfterFilterCondition> isPastEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPast',
        value: value,
      ));
    });
  }

  QueryBuilder<Season, Season, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<Season, Season, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<Season, Season, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<Season, Season, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<Season, Season, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<Season, Season, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<Season, Season, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Season, Season, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Season, Season, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Season, Season, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Season, Season, QAfterFilterCondition> startYearEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startYear',
        value: value,
      ));
    });
  }

  QueryBuilder<Season, Season, QAfterFilterCondition> startYearGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startYear',
        value: value,
      ));
    });
  }

  QueryBuilder<Season, Season, QAfterFilterCondition> startYearLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startYear',
        value: value,
      ));
    });
  }

  QueryBuilder<Season, Season, QAfterFilterCondition> startYearBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startYear',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SeasonQueryObject on QueryBuilder<Season, Season, QFilterCondition> {}

extension SeasonQueryLinks on QueryBuilder<Season, Season, QFilterCondition> {}

extension SeasonQuerySortBy on QueryBuilder<Season, Season, QSortBy> {
  QueryBuilder<Season, Season, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> sortByEndYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endYear', Sort.asc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> sortByEndYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endYear', Sort.desc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> sortByIsCurrent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCurrent', Sort.asc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> sortByIsCurrentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCurrent', Sort.desc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> sortByIsFuture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFuture', Sort.asc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> sortByIsFutureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFuture', Sort.desc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> sortByIsPast() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPast', Sort.asc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> sortByIsPastDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPast', Sort.desc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> sortByStartYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startYear', Sort.asc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> sortByStartYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startYear', Sort.desc);
    });
  }
}

extension SeasonQuerySortThenBy on QueryBuilder<Season, Season, QSortThenBy> {
  QueryBuilder<Season, Season, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> thenByEndYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endYear', Sort.asc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> thenByEndYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endYear', Sort.desc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> thenByIsCurrent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCurrent', Sort.asc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> thenByIsCurrentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCurrent', Sort.desc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> thenByIsFuture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFuture', Sort.asc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> thenByIsFutureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFuture', Sort.desc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> thenByIsPast() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPast', Sort.asc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> thenByIsPastDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPast', Sort.desc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> thenByStartYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startYear', Sort.asc);
    });
  }

  QueryBuilder<Season, Season, QAfterSortBy> thenByStartYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startYear', Sort.desc);
    });
  }
}

extension SeasonQueryWhereDistinct on QueryBuilder<Season, Season, QDistinct> {
  QueryBuilder<Season, Season, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Season, Season, QDistinct> distinctByEndYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endYear');
    });
  }

  QueryBuilder<Season, Season, QDistinct> distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<Season, Season, QDistinct> distinctByIsCurrent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCurrent');
    });
  }

  QueryBuilder<Season, Season, QDistinct> distinctByIsFuture() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFuture');
    });
  }

  QueryBuilder<Season, Season, QDistinct> distinctByIsPast() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPast');
    });
  }

  QueryBuilder<Season, Season, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Season, Season, QDistinct> distinctByStartYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startYear');
    });
  }
}

extension SeasonQueryProperty on QueryBuilder<Season, Season, QQueryProperty> {
  QueryBuilder<Season, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Season, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Season, int, QQueryOperations> endYearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endYear');
    });
  }

  QueryBuilder<Season, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<Season, bool, QQueryOperations> isCurrentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCurrent');
    });
  }

  QueryBuilder<Season, bool, QQueryOperations> isFutureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFuture');
    });
  }

  QueryBuilder<Season, bool, QQueryOperations> isPastProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPast');
    });
  }

  QueryBuilder<Season, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Season, int, QQueryOperations> startYearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startYear');
    });
  }
}
