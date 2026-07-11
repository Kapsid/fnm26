// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $NationsTable extends Nations with TableInfo<$NationsTable, NationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 3,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Confederation, String>
  confederation = GeneratedColumn<String>(
    'confederation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Confederation>($NationsTable.$converterconfederation);
  static const VerificationMeta _rankingMeta = const VerificationMeta(
    'ranking',
  );
  @override
  late final GeneratedColumn<int> ranking = GeneratedColumn<int>(
    'ranking',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isFreeDemoMeta = const VerificationMeta(
    'isFreeDemo',
  );
  @override
  late final GeneratedColumn<bool> isFreeDemo = GeneratedColumn<bool>(
    'is_free_demo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_free_demo" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    code,
    confederation,
    ranking,
    isFreeDemo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nations';
  @override
  VerificationContext validateIntegrity(
    Insertable<NationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('ranking')) {
      context.handle(
        _rankingMeta,
        ranking.isAcceptableOrUnknown(data['ranking']!, _rankingMeta),
      );
    }
    if (data.containsKey('is_free_demo')) {
      context.handle(
        _isFreeDemoMeta,
        isFreeDemo.isAcceptableOrUnknown(
          data['is_free_demo']!,
          _isFreeDemoMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      confederation: $NationsTable.$converterconfederation.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}confederation'],
        )!,
      ),
      ranking: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ranking'],
      )!,
      isFreeDemo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_free_demo'],
      )!,
    );
  }

  @override
  $NationsTable createAlias(String alias) {
    return $NationsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Confederation, String, String>
  $converterconfederation = const EnumNameConverter<Confederation>(
    Confederation.values,
  );
}

class NationRow extends DataClass implements Insertable<NationRow> {
  /// Stable id supplied by the seed data (not auto-incremented).
  final int id;
  final String name;
  final String code;
  final Confederation confederation;
  final int ranking;
  final bool isFreeDemo;
  const NationRow({
    required this.id,
    required this.name,
    required this.code,
    required this.confederation,
    required this.ranking,
    required this.isFreeDemo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['code'] = Variable<String>(code);
    {
      map['confederation'] = Variable<String>(
        $NationsTable.$converterconfederation.toSql(confederation),
      );
    }
    map['ranking'] = Variable<int>(ranking);
    map['is_free_demo'] = Variable<bool>(isFreeDemo);
    return map;
  }

  NationsCompanion toCompanion(bool nullToAbsent) {
    return NationsCompanion(
      id: Value(id),
      name: Value(name),
      code: Value(code),
      confederation: Value(confederation),
      ranking: Value(ranking),
      isFreeDemo: Value(isFreeDemo),
    );
  }

  factory NationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NationRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      code: serializer.fromJson<String>(json['code']),
      confederation: $NationsTable.$converterconfederation.fromJson(
        serializer.fromJson<String>(json['confederation']),
      ),
      ranking: serializer.fromJson<int>(json['ranking']),
      isFreeDemo: serializer.fromJson<bool>(json['isFreeDemo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String>(code),
      'confederation': serializer.toJson<String>(
        $NationsTable.$converterconfederation.toJson(confederation),
      ),
      'ranking': serializer.toJson<int>(ranking),
      'isFreeDemo': serializer.toJson<bool>(isFreeDemo),
    };
  }

  NationRow copyWith({
    int? id,
    String? name,
    String? code,
    Confederation? confederation,
    int? ranking,
    bool? isFreeDemo,
  }) => NationRow(
    id: id ?? this.id,
    name: name ?? this.name,
    code: code ?? this.code,
    confederation: confederation ?? this.confederation,
    ranking: ranking ?? this.ranking,
    isFreeDemo: isFreeDemo ?? this.isFreeDemo,
  );
  NationRow copyWithCompanion(NationsCompanion data) {
    return NationRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      code: data.code.present ? data.code.value : this.code,
      confederation: data.confederation.present
          ? data.confederation.value
          : this.confederation,
      ranking: data.ranking.present ? data.ranking.value : this.ranking,
      isFreeDemo: data.isFreeDemo.present
          ? data.isFreeDemo.value
          : this.isFreeDemo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NationRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('confederation: $confederation, ')
          ..write('ranking: $ranking, ')
          ..write('isFreeDemo: $isFreeDemo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, code, confederation, ranking, isFreeDemo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NationRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.code == this.code &&
          other.confederation == this.confederation &&
          other.ranking == this.ranking &&
          other.isFreeDemo == this.isFreeDemo);
}

class NationsCompanion extends UpdateCompanion<NationRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> code;
  final Value<Confederation> confederation;
  final Value<int> ranking;
  final Value<bool> isFreeDemo;
  const NationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.code = const Value.absent(),
    this.confederation = const Value.absent(),
    this.ranking = const Value.absent(),
    this.isFreeDemo = const Value.absent(),
  });
  NationsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String code,
    required Confederation confederation,
    this.ranking = const Value.absent(),
    this.isFreeDemo = const Value.absent(),
  }) : name = Value(name),
       code = Value(code),
       confederation = Value(confederation);
  static Insertable<NationRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? code,
    Expression<String>? confederation,
    Expression<int>? ranking,
    Expression<bool>? isFreeDemo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (confederation != null) 'confederation': confederation,
      if (ranking != null) 'ranking': ranking,
      if (isFreeDemo != null) 'is_free_demo': isFreeDemo,
    });
  }

  NationsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? code,
    Value<Confederation>? confederation,
    Value<int>? ranking,
    Value<bool>? isFreeDemo,
  }) {
    return NationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      confederation: confederation ?? this.confederation,
      ranking: ranking ?? this.ranking,
      isFreeDemo: isFreeDemo ?? this.isFreeDemo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (confederation.present) {
      map['confederation'] = Variable<String>(
        $NationsTable.$converterconfederation.toSql(confederation.value),
      );
    }
    if (ranking.present) {
      map['ranking'] = Variable<int>(ranking.value);
    }
    if (isFreeDemo.present) {
      map['is_free_demo'] = Variable<bool>(isFreeDemo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('confederation: $confederation, ')
          ..write('ranking: $ranking, ')
          ..write('isFreeDemo: $isFreeDemo')
          ..write(')'))
        .toString();
  }
}

class $PlayersTable extends Players with TableInfo<$PlayersTable, PlayerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nationIdMeta = const VerificationMeta(
    'nationId',
  );
  @override
  late final GeneratedColumn<int> nationId = GeneratedColumn<int>(
    'nation_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES nations (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PlayerPosition, String> position =
      GeneratedColumn<String>(
        'position',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PlayerPosition>($PlayersTable.$converterposition);
  static const VerificationMeta _passingMeta = const VerificationMeta(
    'passing',
  );
  @override
  late final GeneratedColumn<int> passing = GeneratedColumn<int>(
    'passing',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shootingMeta = const VerificationMeta(
    'shooting',
  );
  @override
  late final GeneratedColumn<int> shooting = GeneratedColumn<int>(
    'shooting',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dribblingMeta = const VerificationMeta(
    'dribbling',
  );
  @override
  late final GeneratedColumn<int> dribbling = GeneratedColumn<int>(
    'dribbling',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tacklingMeta = const VerificationMeta(
    'tackling',
  );
  @override
  late final GeneratedColumn<int> tackling = GeneratedColumn<int>(
    'tackling',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positioningMeta = const VerificationMeta(
    'positioning',
  );
  @override
  late final GeneratedColumn<int> positioning = GeneratedColumn<int>(
    'positioning',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _composureMeta = const VerificationMeta(
    'composure',
  );
  @override
  late final GeneratedColumn<int> composure = GeneratedColumn<int>(
    'composure',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _decisionsMeta = const VerificationMeta(
    'decisions',
  );
  @override
  late final GeneratedColumn<int> decisions = GeneratedColumn<int>(
    'decisions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paceMeta = const VerificationMeta('pace');
  @override
  late final GeneratedColumn<int> pace = GeneratedColumn<int>(
    'pace',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _staminaMeta = const VerificationMeta(
    'stamina',
  );
  @override
  late final GeneratedColumn<int> stamina = GeneratedColumn<int>(
    'stamina',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _strengthMeta = const VerificationMeta(
    'strength',
  );
  @override
  late final GeneratedColumn<int> strength = GeneratedColumn<int>(
    'strength',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clubMeta = const VerificationMeta('club');
  @override
  late final GeneratedColumn<String> club = GeneratedColumn<String>(
    'club',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Free agent'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nationId,
    name,
    age,
    position,
    passing,
    shooting,
    dribbling,
    tackling,
    positioning,
    composure,
    decisions,
    pace,
    stamina,
    strength,
    club,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'players';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlayerRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nation_id')) {
      context.handle(
        _nationIdMeta,
        nationId.isAcceptableOrUnknown(data['nation_id']!, _nationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nationIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    } else if (isInserting) {
      context.missing(_ageMeta);
    }
    if (data.containsKey('passing')) {
      context.handle(
        _passingMeta,
        passing.isAcceptableOrUnknown(data['passing']!, _passingMeta),
      );
    } else if (isInserting) {
      context.missing(_passingMeta);
    }
    if (data.containsKey('shooting')) {
      context.handle(
        _shootingMeta,
        shooting.isAcceptableOrUnknown(data['shooting']!, _shootingMeta),
      );
    } else if (isInserting) {
      context.missing(_shootingMeta);
    }
    if (data.containsKey('dribbling')) {
      context.handle(
        _dribblingMeta,
        dribbling.isAcceptableOrUnknown(data['dribbling']!, _dribblingMeta),
      );
    } else if (isInserting) {
      context.missing(_dribblingMeta);
    }
    if (data.containsKey('tackling')) {
      context.handle(
        _tacklingMeta,
        tackling.isAcceptableOrUnknown(data['tackling']!, _tacklingMeta),
      );
    } else if (isInserting) {
      context.missing(_tacklingMeta);
    }
    if (data.containsKey('positioning')) {
      context.handle(
        _positioningMeta,
        positioning.isAcceptableOrUnknown(
          data['positioning']!,
          _positioningMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_positioningMeta);
    }
    if (data.containsKey('composure')) {
      context.handle(
        _composureMeta,
        composure.isAcceptableOrUnknown(data['composure']!, _composureMeta),
      );
    } else if (isInserting) {
      context.missing(_composureMeta);
    }
    if (data.containsKey('decisions')) {
      context.handle(
        _decisionsMeta,
        decisions.isAcceptableOrUnknown(data['decisions']!, _decisionsMeta),
      );
    } else if (isInserting) {
      context.missing(_decisionsMeta);
    }
    if (data.containsKey('pace')) {
      context.handle(
        _paceMeta,
        pace.isAcceptableOrUnknown(data['pace']!, _paceMeta),
      );
    } else if (isInserting) {
      context.missing(_paceMeta);
    }
    if (data.containsKey('stamina')) {
      context.handle(
        _staminaMeta,
        stamina.isAcceptableOrUnknown(data['stamina']!, _staminaMeta),
      );
    } else if (isInserting) {
      context.missing(_staminaMeta);
    }
    if (data.containsKey('strength')) {
      context.handle(
        _strengthMeta,
        strength.isAcceptableOrUnknown(data['strength']!, _strengthMeta),
      );
    } else if (isInserting) {
      context.missing(_strengthMeta);
    }
    if (data.containsKey('club')) {
      context.handle(
        _clubMeta,
        club.isAcceptableOrUnknown(data['club']!, _clubMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayerRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nation_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      )!,
      position: $PlayersTable.$converterposition.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}position'],
        )!,
      ),
      passing: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}passing'],
      )!,
      shooting: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shooting'],
      )!,
      dribbling: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dribbling'],
      )!,
      tackling: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tackling'],
      )!,
      positioning: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}positioning'],
      )!,
      composure: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}composure'],
      )!,
      decisions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}decisions'],
      )!,
      pace: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pace'],
      )!,
      stamina: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stamina'],
      )!,
      strength: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}strength'],
      )!,
      club: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}club'],
      )!,
    );
  }

  @override
  $PlayersTable createAlias(String alias) {
    return $PlayersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PlayerPosition, String, String> $converterposition =
      const EnumNameConverter<PlayerPosition>(PlayerPosition.values);
}

class PlayerRow extends DataClass implements Insertable<PlayerRow> {
  /// Stable id supplied by the seed data.
  final int id;
  final int nationId;
  final String name;
  final int age;
  final PlayerPosition position;
  final int passing;
  final int shooting;
  final int dribbling;
  final int tackling;
  final int positioning;
  final int composure;
  final int decisions;
  final int pace;
  final int stamina;
  final int strength;

  /// The player's club side (display/scouting only).
  final String club;
  const PlayerRow({
    required this.id,
    required this.nationId,
    required this.name,
    required this.age,
    required this.position,
    required this.passing,
    required this.shooting,
    required this.dribbling,
    required this.tackling,
    required this.positioning,
    required this.composure,
    required this.decisions,
    required this.pace,
    required this.stamina,
    required this.strength,
    required this.club,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nation_id'] = Variable<int>(nationId);
    map['name'] = Variable<String>(name);
    map['age'] = Variable<int>(age);
    {
      map['position'] = Variable<String>(
        $PlayersTable.$converterposition.toSql(position),
      );
    }
    map['passing'] = Variable<int>(passing);
    map['shooting'] = Variable<int>(shooting);
    map['dribbling'] = Variable<int>(dribbling);
    map['tackling'] = Variable<int>(tackling);
    map['positioning'] = Variable<int>(positioning);
    map['composure'] = Variable<int>(composure);
    map['decisions'] = Variable<int>(decisions);
    map['pace'] = Variable<int>(pace);
    map['stamina'] = Variable<int>(stamina);
    map['strength'] = Variable<int>(strength);
    map['club'] = Variable<String>(club);
    return map;
  }

  PlayersCompanion toCompanion(bool nullToAbsent) {
    return PlayersCompanion(
      id: Value(id),
      nationId: Value(nationId),
      name: Value(name),
      age: Value(age),
      position: Value(position),
      passing: Value(passing),
      shooting: Value(shooting),
      dribbling: Value(dribbling),
      tackling: Value(tackling),
      positioning: Value(positioning),
      composure: Value(composure),
      decisions: Value(decisions),
      pace: Value(pace),
      stamina: Value(stamina),
      strength: Value(strength),
      club: Value(club),
    );
  }

  factory PlayerRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayerRow(
      id: serializer.fromJson<int>(json['id']),
      nationId: serializer.fromJson<int>(json['nationId']),
      name: serializer.fromJson<String>(json['name']),
      age: serializer.fromJson<int>(json['age']),
      position: $PlayersTable.$converterposition.fromJson(
        serializer.fromJson<String>(json['position']),
      ),
      passing: serializer.fromJson<int>(json['passing']),
      shooting: serializer.fromJson<int>(json['shooting']),
      dribbling: serializer.fromJson<int>(json['dribbling']),
      tackling: serializer.fromJson<int>(json['tackling']),
      positioning: serializer.fromJson<int>(json['positioning']),
      composure: serializer.fromJson<int>(json['composure']),
      decisions: serializer.fromJson<int>(json['decisions']),
      pace: serializer.fromJson<int>(json['pace']),
      stamina: serializer.fromJson<int>(json['stamina']),
      strength: serializer.fromJson<int>(json['strength']),
      club: serializer.fromJson<String>(json['club']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nationId': serializer.toJson<int>(nationId),
      'name': serializer.toJson<String>(name),
      'age': serializer.toJson<int>(age),
      'position': serializer.toJson<String>(
        $PlayersTable.$converterposition.toJson(position),
      ),
      'passing': serializer.toJson<int>(passing),
      'shooting': serializer.toJson<int>(shooting),
      'dribbling': serializer.toJson<int>(dribbling),
      'tackling': serializer.toJson<int>(tackling),
      'positioning': serializer.toJson<int>(positioning),
      'composure': serializer.toJson<int>(composure),
      'decisions': serializer.toJson<int>(decisions),
      'pace': serializer.toJson<int>(pace),
      'stamina': serializer.toJson<int>(stamina),
      'strength': serializer.toJson<int>(strength),
      'club': serializer.toJson<String>(club),
    };
  }

  PlayerRow copyWith({
    int? id,
    int? nationId,
    String? name,
    int? age,
    PlayerPosition? position,
    int? passing,
    int? shooting,
    int? dribbling,
    int? tackling,
    int? positioning,
    int? composure,
    int? decisions,
    int? pace,
    int? stamina,
    int? strength,
    String? club,
  }) => PlayerRow(
    id: id ?? this.id,
    nationId: nationId ?? this.nationId,
    name: name ?? this.name,
    age: age ?? this.age,
    position: position ?? this.position,
    passing: passing ?? this.passing,
    shooting: shooting ?? this.shooting,
    dribbling: dribbling ?? this.dribbling,
    tackling: tackling ?? this.tackling,
    positioning: positioning ?? this.positioning,
    composure: composure ?? this.composure,
    decisions: decisions ?? this.decisions,
    pace: pace ?? this.pace,
    stamina: stamina ?? this.stamina,
    strength: strength ?? this.strength,
    club: club ?? this.club,
  );
  PlayerRow copyWithCompanion(PlayersCompanion data) {
    return PlayerRow(
      id: data.id.present ? data.id.value : this.id,
      nationId: data.nationId.present ? data.nationId.value : this.nationId,
      name: data.name.present ? data.name.value : this.name,
      age: data.age.present ? data.age.value : this.age,
      position: data.position.present ? data.position.value : this.position,
      passing: data.passing.present ? data.passing.value : this.passing,
      shooting: data.shooting.present ? data.shooting.value : this.shooting,
      dribbling: data.dribbling.present ? data.dribbling.value : this.dribbling,
      tackling: data.tackling.present ? data.tackling.value : this.tackling,
      positioning: data.positioning.present
          ? data.positioning.value
          : this.positioning,
      composure: data.composure.present ? data.composure.value : this.composure,
      decisions: data.decisions.present ? data.decisions.value : this.decisions,
      pace: data.pace.present ? data.pace.value : this.pace,
      stamina: data.stamina.present ? data.stamina.value : this.stamina,
      strength: data.strength.present ? data.strength.value : this.strength,
      club: data.club.present ? data.club.value : this.club,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayerRow(')
          ..write('id: $id, ')
          ..write('nationId: $nationId, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('position: $position, ')
          ..write('passing: $passing, ')
          ..write('shooting: $shooting, ')
          ..write('dribbling: $dribbling, ')
          ..write('tackling: $tackling, ')
          ..write('positioning: $positioning, ')
          ..write('composure: $composure, ')
          ..write('decisions: $decisions, ')
          ..write('pace: $pace, ')
          ..write('stamina: $stamina, ')
          ..write('strength: $strength, ')
          ..write('club: $club')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nationId,
    name,
    age,
    position,
    passing,
    shooting,
    dribbling,
    tackling,
    positioning,
    composure,
    decisions,
    pace,
    stamina,
    strength,
    club,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayerRow &&
          other.id == this.id &&
          other.nationId == this.nationId &&
          other.name == this.name &&
          other.age == this.age &&
          other.position == this.position &&
          other.passing == this.passing &&
          other.shooting == this.shooting &&
          other.dribbling == this.dribbling &&
          other.tackling == this.tackling &&
          other.positioning == this.positioning &&
          other.composure == this.composure &&
          other.decisions == this.decisions &&
          other.pace == this.pace &&
          other.stamina == this.stamina &&
          other.strength == this.strength &&
          other.club == this.club);
}

class PlayersCompanion extends UpdateCompanion<PlayerRow> {
  final Value<int> id;
  final Value<int> nationId;
  final Value<String> name;
  final Value<int> age;
  final Value<PlayerPosition> position;
  final Value<int> passing;
  final Value<int> shooting;
  final Value<int> dribbling;
  final Value<int> tackling;
  final Value<int> positioning;
  final Value<int> composure;
  final Value<int> decisions;
  final Value<int> pace;
  final Value<int> stamina;
  final Value<int> strength;
  final Value<String> club;
  const PlayersCompanion({
    this.id = const Value.absent(),
    this.nationId = const Value.absent(),
    this.name = const Value.absent(),
    this.age = const Value.absent(),
    this.position = const Value.absent(),
    this.passing = const Value.absent(),
    this.shooting = const Value.absent(),
    this.dribbling = const Value.absent(),
    this.tackling = const Value.absent(),
    this.positioning = const Value.absent(),
    this.composure = const Value.absent(),
    this.decisions = const Value.absent(),
    this.pace = const Value.absent(),
    this.stamina = const Value.absent(),
    this.strength = const Value.absent(),
    this.club = const Value.absent(),
  });
  PlayersCompanion.insert({
    this.id = const Value.absent(),
    required int nationId,
    required String name,
    required int age,
    required PlayerPosition position,
    required int passing,
    required int shooting,
    required int dribbling,
    required int tackling,
    required int positioning,
    required int composure,
    required int decisions,
    required int pace,
    required int stamina,
    required int strength,
    this.club = const Value.absent(),
  }) : nationId = Value(nationId),
       name = Value(name),
       age = Value(age),
       position = Value(position),
       passing = Value(passing),
       shooting = Value(shooting),
       dribbling = Value(dribbling),
       tackling = Value(tackling),
       positioning = Value(positioning),
       composure = Value(composure),
       decisions = Value(decisions),
       pace = Value(pace),
       stamina = Value(stamina),
       strength = Value(strength);
  static Insertable<PlayerRow> custom({
    Expression<int>? id,
    Expression<int>? nationId,
    Expression<String>? name,
    Expression<int>? age,
    Expression<String>? position,
    Expression<int>? passing,
    Expression<int>? shooting,
    Expression<int>? dribbling,
    Expression<int>? tackling,
    Expression<int>? positioning,
    Expression<int>? composure,
    Expression<int>? decisions,
    Expression<int>? pace,
    Expression<int>? stamina,
    Expression<int>? strength,
    Expression<String>? club,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nationId != null) 'nation_id': nationId,
      if (name != null) 'name': name,
      if (age != null) 'age': age,
      if (position != null) 'position': position,
      if (passing != null) 'passing': passing,
      if (shooting != null) 'shooting': shooting,
      if (dribbling != null) 'dribbling': dribbling,
      if (tackling != null) 'tackling': tackling,
      if (positioning != null) 'positioning': positioning,
      if (composure != null) 'composure': composure,
      if (decisions != null) 'decisions': decisions,
      if (pace != null) 'pace': pace,
      if (stamina != null) 'stamina': stamina,
      if (strength != null) 'strength': strength,
      if (club != null) 'club': club,
    });
  }

  PlayersCompanion copyWith({
    Value<int>? id,
    Value<int>? nationId,
    Value<String>? name,
    Value<int>? age,
    Value<PlayerPosition>? position,
    Value<int>? passing,
    Value<int>? shooting,
    Value<int>? dribbling,
    Value<int>? tackling,
    Value<int>? positioning,
    Value<int>? composure,
    Value<int>? decisions,
    Value<int>? pace,
    Value<int>? stamina,
    Value<int>? strength,
    Value<String>? club,
  }) {
    return PlayersCompanion(
      id: id ?? this.id,
      nationId: nationId ?? this.nationId,
      name: name ?? this.name,
      age: age ?? this.age,
      position: position ?? this.position,
      passing: passing ?? this.passing,
      shooting: shooting ?? this.shooting,
      dribbling: dribbling ?? this.dribbling,
      tackling: tackling ?? this.tackling,
      positioning: positioning ?? this.positioning,
      composure: composure ?? this.composure,
      decisions: decisions ?? this.decisions,
      pace: pace ?? this.pace,
      stamina: stamina ?? this.stamina,
      strength: strength ?? this.strength,
      club: club ?? this.club,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nationId.present) {
      map['nation_id'] = Variable<int>(nationId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (position.present) {
      map['position'] = Variable<String>(
        $PlayersTable.$converterposition.toSql(position.value),
      );
    }
    if (passing.present) {
      map['passing'] = Variable<int>(passing.value);
    }
    if (shooting.present) {
      map['shooting'] = Variable<int>(shooting.value);
    }
    if (dribbling.present) {
      map['dribbling'] = Variable<int>(dribbling.value);
    }
    if (tackling.present) {
      map['tackling'] = Variable<int>(tackling.value);
    }
    if (positioning.present) {
      map['positioning'] = Variable<int>(positioning.value);
    }
    if (composure.present) {
      map['composure'] = Variable<int>(composure.value);
    }
    if (decisions.present) {
      map['decisions'] = Variable<int>(decisions.value);
    }
    if (pace.present) {
      map['pace'] = Variable<int>(pace.value);
    }
    if (stamina.present) {
      map['stamina'] = Variable<int>(stamina.value);
    }
    if (strength.present) {
      map['strength'] = Variable<int>(strength.value);
    }
    if (club.present) {
      map['club'] = Variable<String>(club.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayersCompanion(')
          ..write('id: $id, ')
          ..write('nationId: $nationId, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('position: $position, ')
          ..write('passing: $passing, ')
          ..write('shooting: $shooting, ')
          ..write('dribbling: $dribbling, ')
          ..write('tackling: $tackling, ')
          ..write('positioning: $positioning, ')
          ..write('composure: $composure, ')
          ..write('decisions: $decisions, ')
          ..write('pace: $pace, ')
          ..write('stamina: $stamina, ')
          ..write('strength: $strength, ')
          ..write('club: $club')
          ..write(')'))
        .toString();
  }
}

class $CareersTable extends Careers with TableInfo<$CareersTable, CareerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CareersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _managerNameMeta = const VerificationMeta(
    'managerName',
  );
  @override
  late final GeneratedColumn<String> managerName = GeneratedColumn<String>(
    'manager_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nationIdMeta = const VerificationMeta(
    'nationId',
  );
  @override
  late final GeneratedColumn<int> nationId = GeneratedColumn<int>(
    'nation_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES nations (id)',
    ),
  );
  static const VerificationMeta _rngSeedMeta = const VerificationMeta(
    'rngSeed',
  );
  @override
  late final GeneratedColumn<int> rngSeed = GeneratedColumn<int>(
    'rng_seed',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inGameDateMeta = const VerificationMeta(
    'inGameDate',
  );
  @override
  late final GeneratedColumn<DateTime> inGameDate = GeneratedColumn<DateTime>(
    'in_game_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cyclePointerMeta = const VerificationMeta(
    'cyclePointer',
  );
  @override
  late final GeneratedColumn<int> cyclePointer = GeneratedColumn<int>(
    'cycle_pointer',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    managerName,
    nationId,
    rngSeed,
    createdAt,
    inGameDate,
    cyclePointer,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'careers';
  @override
  VerificationContext validateIntegrity(
    Insertable<CareerRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('manager_name')) {
      context.handle(
        _managerNameMeta,
        managerName.isAcceptableOrUnknown(
          data['manager_name']!,
          _managerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_managerNameMeta);
    }
    if (data.containsKey('nation_id')) {
      context.handle(
        _nationIdMeta,
        nationId.isAcceptableOrUnknown(data['nation_id']!, _nationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nationIdMeta);
    }
    if (data.containsKey('rng_seed')) {
      context.handle(
        _rngSeedMeta,
        rngSeed.isAcceptableOrUnknown(data['rng_seed']!, _rngSeedMeta),
      );
    } else if (isInserting) {
      context.missing(_rngSeedMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('in_game_date')) {
      context.handle(
        _inGameDateMeta,
        inGameDate.isAcceptableOrUnknown(
          data['in_game_date']!,
          _inGameDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inGameDateMeta);
    }
    if (data.containsKey('cycle_pointer')) {
      context.handle(
        _cyclePointerMeta,
        cyclePointer.isAcceptableOrUnknown(
          data['cycle_pointer']!,
          _cyclePointerMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CareerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CareerRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      managerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manager_name'],
      )!,
      nationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nation_id'],
      )!,
      rngSeed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rng_seed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      inGameDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}in_game_date'],
      )!,
      cyclePointer: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_pointer'],
      )!,
    );
  }

  @override
  $CareersTable createAlias(String alias) {
    return $CareersTable(attachedDatabase, alias);
  }
}

class CareerRow extends DataClass implements Insertable<CareerRow> {
  final int id;
  final String managerName;
  final int nationId;
  final int rngSeed;
  final DateTime createdAt;
  final DateTime inGameDate;
  final int cyclePointer;
  const CareerRow({
    required this.id,
    required this.managerName,
    required this.nationId,
    required this.rngSeed,
    required this.createdAt,
    required this.inGameDate,
    required this.cyclePointer,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['manager_name'] = Variable<String>(managerName);
    map['nation_id'] = Variable<int>(nationId);
    map['rng_seed'] = Variable<int>(rngSeed);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['in_game_date'] = Variable<DateTime>(inGameDate);
    map['cycle_pointer'] = Variable<int>(cyclePointer);
    return map;
  }

  CareersCompanion toCompanion(bool nullToAbsent) {
    return CareersCompanion(
      id: Value(id),
      managerName: Value(managerName),
      nationId: Value(nationId),
      rngSeed: Value(rngSeed),
      createdAt: Value(createdAt),
      inGameDate: Value(inGameDate),
      cyclePointer: Value(cyclePointer),
    );
  }

  factory CareerRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CareerRow(
      id: serializer.fromJson<int>(json['id']),
      managerName: serializer.fromJson<String>(json['managerName']),
      nationId: serializer.fromJson<int>(json['nationId']),
      rngSeed: serializer.fromJson<int>(json['rngSeed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      inGameDate: serializer.fromJson<DateTime>(json['inGameDate']),
      cyclePointer: serializer.fromJson<int>(json['cyclePointer']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'managerName': serializer.toJson<String>(managerName),
      'nationId': serializer.toJson<int>(nationId),
      'rngSeed': serializer.toJson<int>(rngSeed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'inGameDate': serializer.toJson<DateTime>(inGameDate),
      'cyclePointer': serializer.toJson<int>(cyclePointer),
    };
  }

  CareerRow copyWith({
    int? id,
    String? managerName,
    int? nationId,
    int? rngSeed,
    DateTime? createdAt,
    DateTime? inGameDate,
    int? cyclePointer,
  }) => CareerRow(
    id: id ?? this.id,
    managerName: managerName ?? this.managerName,
    nationId: nationId ?? this.nationId,
    rngSeed: rngSeed ?? this.rngSeed,
    createdAt: createdAt ?? this.createdAt,
    inGameDate: inGameDate ?? this.inGameDate,
    cyclePointer: cyclePointer ?? this.cyclePointer,
  );
  CareerRow copyWithCompanion(CareersCompanion data) {
    return CareerRow(
      id: data.id.present ? data.id.value : this.id,
      managerName: data.managerName.present
          ? data.managerName.value
          : this.managerName,
      nationId: data.nationId.present ? data.nationId.value : this.nationId,
      rngSeed: data.rngSeed.present ? data.rngSeed.value : this.rngSeed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      inGameDate: data.inGameDate.present
          ? data.inGameDate.value
          : this.inGameDate,
      cyclePointer: data.cyclePointer.present
          ? data.cyclePointer.value
          : this.cyclePointer,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CareerRow(')
          ..write('id: $id, ')
          ..write('managerName: $managerName, ')
          ..write('nationId: $nationId, ')
          ..write('rngSeed: $rngSeed, ')
          ..write('createdAt: $createdAt, ')
          ..write('inGameDate: $inGameDate, ')
          ..write('cyclePointer: $cyclePointer')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    managerName,
    nationId,
    rngSeed,
    createdAt,
    inGameDate,
    cyclePointer,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CareerRow &&
          other.id == this.id &&
          other.managerName == this.managerName &&
          other.nationId == this.nationId &&
          other.rngSeed == this.rngSeed &&
          other.createdAt == this.createdAt &&
          other.inGameDate == this.inGameDate &&
          other.cyclePointer == this.cyclePointer);
}

class CareersCompanion extends UpdateCompanion<CareerRow> {
  final Value<int> id;
  final Value<String> managerName;
  final Value<int> nationId;
  final Value<int> rngSeed;
  final Value<DateTime> createdAt;
  final Value<DateTime> inGameDate;
  final Value<int> cyclePointer;
  const CareersCompanion({
    this.id = const Value.absent(),
    this.managerName = const Value.absent(),
    this.nationId = const Value.absent(),
    this.rngSeed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.inGameDate = const Value.absent(),
    this.cyclePointer = const Value.absent(),
  });
  CareersCompanion.insert({
    this.id = const Value.absent(),
    required String managerName,
    required int nationId,
    required int rngSeed,
    required DateTime createdAt,
    required DateTime inGameDate,
    this.cyclePointer = const Value.absent(),
  }) : managerName = Value(managerName),
       nationId = Value(nationId),
       rngSeed = Value(rngSeed),
       createdAt = Value(createdAt),
       inGameDate = Value(inGameDate);
  static Insertable<CareerRow> custom({
    Expression<int>? id,
    Expression<String>? managerName,
    Expression<int>? nationId,
    Expression<int>? rngSeed,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? inGameDate,
    Expression<int>? cyclePointer,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (managerName != null) 'manager_name': managerName,
      if (nationId != null) 'nation_id': nationId,
      if (rngSeed != null) 'rng_seed': rngSeed,
      if (createdAt != null) 'created_at': createdAt,
      if (inGameDate != null) 'in_game_date': inGameDate,
      if (cyclePointer != null) 'cycle_pointer': cyclePointer,
    });
  }

  CareersCompanion copyWith({
    Value<int>? id,
    Value<String>? managerName,
    Value<int>? nationId,
    Value<int>? rngSeed,
    Value<DateTime>? createdAt,
    Value<DateTime>? inGameDate,
    Value<int>? cyclePointer,
  }) {
    return CareersCompanion(
      id: id ?? this.id,
      managerName: managerName ?? this.managerName,
      nationId: nationId ?? this.nationId,
      rngSeed: rngSeed ?? this.rngSeed,
      createdAt: createdAt ?? this.createdAt,
      inGameDate: inGameDate ?? this.inGameDate,
      cyclePointer: cyclePointer ?? this.cyclePointer,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (managerName.present) {
      map['manager_name'] = Variable<String>(managerName.value);
    }
    if (nationId.present) {
      map['nation_id'] = Variable<int>(nationId.value);
    }
    if (rngSeed.present) {
      map['rng_seed'] = Variable<int>(rngSeed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (inGameDate.present) {
      map['in_game_date'] = Variable<DateTime>(inGameDate.value);
    }
    if (cyclePointer.present) {
      map['cycle_pointer'] = Variable<int>(cyclePointer.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CareersCompanion(')
          ..write('id: $id, ')
          ..write('managerName: $managerName, ')
          ..write('nationId: $nationId, ')
          ..write('rngSeed: $rngSeed, ')
          ..write('createdAt: $createdAt, ')
          ..write('inGameDate: $inGameDate, ')
          ..write('cyclePointer: $cyclePointer')
          ..write(')'))
        .toString();
  }
}

class $CompetitionsTable extends Competitions
    with TableInfo<$CompetitionsTable, CompetitionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompetitionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _careerIdMeta = const VerificationMeta(
    'careerId',
  );
  @override
  late final GeneratedColumn<int> careerId = GeneratedColumn<int>(
    'career_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES careers (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Confederation, String>
  confederation = GeneratedColumn<String>(
    'confederation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Confederation>($CompetitionsTable.$converterconfederation);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CompetitionKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('worldCupQualifying'),
      ).withConverter<CompetitionKind>($CompetitionsTable.$converterkind);
  static const VerificationMeta _cycleMeta = const VerificationMeta('cycle');
  @override
  late final GeneratedColumn<int> cycle = GeneratedColumn<int>(
    'cycle',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    careerId,
    confederation,
    name,
    kind,
    cycle,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'competitions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CompetitionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('career_id')) {
      context.handle(
        _careerIdMeta,
        careerId.isAcceptableOrUnknown(data['career_id']!, _careerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_careerIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('cycle')) {
      context.handle(
        _cycleMeta,
        cycle.isAcceptableOrUnknown(data['cycle']!, _cycleMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CompetitionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompetitionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      careerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}career_id'],
      )!,
      confederation: $CompetitionsTable.$converterconfederation.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}confederation'],
        )!,
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kind: $CompetitionsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      cycle: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle'],
      )!,
    );
  }

  @override
  $CompetitionsTable createAlias(String alias) {
    return $CompetitionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Confederation, String, String>
  $converterconfederation = const EnumNameConverter<Confederation>(
    Confederation.values,
  );
  static JsonTypeConverter2<CompetitionKind, String, String> $converterkind =
      const EnumNameConverter<CompetitionKind>(CompetitionKind.values);
}

class CompetitionRow extends DataClass implements Insertable<CompetitionRow> {
  final int id;
  final int careerId;
  final Confederation confederation;
  final String name;
  final CompetitionKind kind;

  /// The 4-year cycle this competition belongs to (matches Careers.cyclePointer
  /// at creation time), so each endless cycle is queried independently.
  final int cycle;
  const CompetitionRow({
    required this.id,
    required this.careerId,
    required this.confederation,
    required this.name,
    required this.kind,
    required this.cycle,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['career_id'] = Variable<int>(careerId);
    {
      map['confederation'] = Variable<String>(
        $CompetitionsTable.$converterconfederation.toSql(confederation),
      );
    }
    map['name'] = Variable<String>(name);
    {
      map['kind'] = Variable<String>(
        $CompetitionsTable.$converterkind.toSql(kind),
      );
    }
    map['cycle'] = Variable<int>(cycle);
    return map;
  }

  CompetitionsCompanion toCompanion(bool nullToAbsent) {
    return CompetitionsCompanion(
      id: Value(id),
      careerId: Value(careerId),
      confederation: Value(confederation),
      name: Value(name),
      kind: Value(kind),
      cycle: Value(cycle),
    );
  }

  factory CompetitionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompetitionRow(
      id: serializer.fromJson<int>(json['id']),
      careerId: serializer.fromJson<int>(json['careerId']),
      confederation: $CompetitionsTable.$converterconfederation.fromJson(
        serializer.fromJson<String>(json['confederation']),
      ),
      name: serializer.fromJson<String>(json['name']),
      kind: $CompetitionsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      cycle: serializer.fromJson<int>(json['cycle']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'careerId': serializer.toJson<int>(careerId),
      'confederation': serializer.toJson<String>(
        $CompetitionsTable.$converterconfederation.toJson(confederation),
      ),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<String>(
        $CompetitionsTable.$converterkind.toJson(kind),
      ),
      'cycle': serializer.toJson<int>(cycle),
    };
  }

  CompetitionRow copyWith({
    int? id,
    int? careerId,
    Confederation? confederation,
    String? name,
    CompetitionKind? kind,
    int? cycle,
  }) => CompetitionRow(
    id: id ?? this.id,
    careerId: careerId ?? this.careerId,
    confederation: confederation ?? this.confederation,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    cycle: cycle ?? this.cycle,
  );
  CompetitionRow copyWithCompanion(CompetitionsCompanion data) {
    return CompetitionRow(
      id: data.id.present ? data.id.value : this.id,
      careerId: data.careerId.present ? data.careerId.value : this.careerId,
      confederation: data.confederation.present
          ? data.confederation.value
          : this.confederation,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      cycle: data.cycle.present ? data.cycle.value : this.cycle,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompetitionRow(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('confederation: $confederation, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('cycle: $cycle')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, careerId, confederation, name, kind, cycle);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompetitionRow &&
          other.id == this.id &&
          other.careerId == this.careerId &&
          other.confederation == this.confederation &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.cycle == this.cycle);
}

class CompetitionsCompanion extends UpdateCompanion<CompetitionRow> {
  final Value<int> id;
  final Value<int> careerId;
  final Value<Confederation> confederation;
  final Value<String> name;
  final Value<CompetitionKind> kind;
  final Value<int> cycle;
  const CompetitionsCompanion({
    this.id = const Value.absent(),
    this.careerId = const Value.absent(),
    this.confederation = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.cycle = const Value.absent(),
  });
  CompetitionsCompanion.insert({
    this.id = const Value.absent(),
    required int careerId,
    required Confederation confederation,
    required String name,
    this.kind = const Value.absent(),
    this.cycle = const Value.absent(),
  }) : careerId = Value(careerId),
       confederation = Value(confederation),
       name = Value(name);
  static Insertable<CompetitionRow> custom({
    Expression<int>? id,
    Expression<int>? careerId,
    Expression<String>? confederation,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<int>? cycle,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (careerId != null) 'career_id': careerId,
      if (confederation != null) 'confederation': confederation,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (cycle != null) 'cycle': cycle,
    });
  }

  CompetitionsCompanion copyWith({
    Value<int>? id,
    Value<int>? careerId,
    Value<Confederation>? confederation,
    Value<String>? name,
    Value<CompetitionKind>? kind,
    Value<int>? cycle,
  }) {
    return CompetitionsCompanion(
      id: id ?? this.id,
      careerId: careerId ?? this.careerId,
      confederation: confederation ?? this.confederation,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      cycle: cycle ?? this.cycle,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (careerId.present) {
      map['career_id'] = Variable<int>(careerId.value);
    }
    if (confederation.present) {
      map['confederation'] = Variable<String>(
        $CompetitionsTable.$converterconfederation.toSql(confederation.value),
      );
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $CompetitionsTable.$converterkind.toSql(kind.value),
      );
    }
    if (cycle.present) {
      map['cycle'] = Variable<int>(cycle.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompetitionsCompanion(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('confederation: $confederation, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('cycle: $cycle')
          ..write(')'))
        .toString();
  }
}

class $QualifyingGroupsTable extends QualifyingGroups
    with TableInfo<$QualifyingGroupsTable, QualifyingGroupRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QualifyingGroupsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _competitionIdMeta = const VerificationMeta(
    'competitionId',
  );
  @override
  late final GeneratedColumn<int> competitionId = GeneratedColumn<int>(
    'competition_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES competitions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, competitionId, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'qualifying_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<QualifyingGroupRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('competition_id')) {
      context.handle(
        _competitionIdMeta,
        competitionId.isAcceptableOrUnknown(
          data['competition_id']!,
          _competitionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_competitionIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QualifyingGroupRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QualifyingGroupRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      competitionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}competition_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $QualifyingGroupsTable createAlias(String alias) {
    return $QualifyingGroupsTable(attachedDatabase, alias);
  }
}

class QualifyingGroupRow extends DataClass
    implements Insertable<QualifyingGroupRow> {
  final int id;
  final int competitionId;
  final String name;
  const QualifyingGroupRow({
    required this.id,
    required this.competitionId,
    required this.name,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['competition_id'] = Variable<int>(competitionId);
    map['name'] = Variable<String>(name);
    return map;
  }

  QualifyingGroupsCompanion toCompanion(bool nullToAbsent) {
    return QualifyingGroupsCompanion(
      id: Value(id),
      competitionId: Value(competitionId),
      name: Value(name),
    );
  }

  factory QualifyingGroupRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QualifyingGroupRow(
      id: serializer.fromJson<int>(json['id']),
      competitionId: serializer.fromJson<int>(json['competitionId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'competitionId': serializer.toJson<int>(competitionId),
      'name': serializer.toJson<String>(name),
    };
  }

  QualifyingGroupRow copyWith({int? id, int? competitionId, String? name}) =>
      QualifyingGroupRow(
        id: id ?? this.id,
        competitionId: competitionId ?? this.competitionId,
        name: name ?? this.name,
      );
  QualifyingGroupRow copyWithCompanion(QualifyingGroupsCompanion data) {
    return QualifyingGroupRow(
      id: data.id.present ? data.id.value : this.id,
      competitionId: data.competitionId.present
          ? data.competitionId.value
          : this.competitionId,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QualifyingGroupRow(')
          ..write('id: $id, ')
          ..write('competitionId: $competitionId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, competitionId, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QualifyingGroupRow &&
          other.id == this.id &&
          other.competitionId == this.competitionId &&
          other.name == this.name);
}

class QualifyingGroupsCompanion extends UpdateCompanion<QualifyingGroupRow> {
  final Value<int> id;
  final Value<int> competitionId;
  final Value<String> name;
  const QualifyingGroupsCompanion({
    this.id = const Value.absent(),
    this.competitionId = const Value.absent(),
    this.name = const Value.absent(),
  });
  QualifyingGroupsCompanion.insert({
    this.id = const Value.absent(),
    required int competitionId,
    required String name,
  }) : competitionId = Value(competitionId),
       name = Value(name);
  static Insertable<QualifyingGroupRow> custom({
    Expression<int>? id,
    Expression<int>? competitionId,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (competitionId != null) 'competition_id': competitionId,
      if (name != null) 'name': name,
    });
  }

  QualifyingGroupsCompanion copyWith({
    Value<int>? id,
    Value<int>? competitionId,
    Value<String>? name,
  }) {
    return QualifyingGroupsCompanion(
      id: id ?? this.id,
      competitionId: competitionId ?? this.competitionId,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (competitionId.present) {
      map['competition_id'] = Variable<int>(competitionId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QualifyingGroupsCompanion(')
          ..write('id: $id, ')
          ..write('competitionId: $competitionId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $GroupMembersTable extends GroupMembers
    with TableInfo<$GroupMembersTable, GroupMemberRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES qualifying_groups (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nationIdMeta = const VerificationMeta(
    'nationId',
  );
  @override
  late final GeneratedColumn<int> nationId = GeneratedColumn<int>(
    'nation_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [groupId, nationId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroupMemberRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('nation_id')) {
      context.handle(
        _nationIdMeta,
        nationId.isAcceptableOrUnknown(data['nation_id']!, _nationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nationIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {groupId, nationId};
  @override
  GroupMemberRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupMemberRow(
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}group_id'],
      )!,
      nationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nation_id'],
      )!,
    );
  }

  @override
  $GroupMembersTable createAlias(String alias) {
    return $GroupMembersTable(attachedDatabase, alias);
  }
}

class GroupMemberRow extends DataClass implements Insertable<GroupMemberRow> {
  final int groupId;
  final int nationId;
  const GroupMemberRow({required this.groupId, required this.nationId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['group_id'] = Variable<int>(groupId);
    map['nation_id'] = Variable<int>(nationId);
    return map;
  }

  GroupMembersCompanion toCompanion(bool nullToAbsent) {
    return GroupMembersCompanion(
      groupId: Value(groupId),
      nationId: Value(nationId),
    );
  }

  factory GroupMemberRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupMemberRow(
      groupId: serializer.fromJson<int>(json['groupId']),
      nationId: serializer.fromJson<int>(json['nationId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'groupId': serializer.toJson<int>(groupId),
      'nationId': serializer.toJson<int>(nationId),
    };
  }

  GroupMemberRow copyWith({int? groupId, int? nationId}) => GroupMemberRow(
    groupId: groupId ?? this.groupId,
    nationId: nationId ?? this.nationId,
  );
  GroupMemberRow copyWithCompanion(GroupMembersCompanion data) {
    return GroupMemberRow(
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      nationId: data.nationId.present ? data.nationId.value : this.nationId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupMemberRow(')
          ..write('groupId: $groupId, ')
          ..write('nationId: $nationId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(groupId, nationId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupMemberRow &&
          other.groupId == this.groupId &&
          other.nationId == this.nationId);
}

class GroupMembersCompanion extends UpdateCompanion<GroupMemberRow> {
  final Value<int> groupId;
  final Value<int> nationId;
  final Value<int> rowid;
  const GroupMembersCompanion({
    this.groupId = const Value.absent(),
    this.nationId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupMembersCompanion.insert({
    required int groupId,
    required int nationId,
    this.rowid = const Value.absent(),
  }) : groupId = Value(groupId),
       nationId = Value(nationId);
  static Insertable<GroupMemberRow> custom({
    Expression<int>? groupId,
    Expression<int>? nationId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (groupId != null) 'group_id': groupId,
      if (nationId != null) 'nation_id': nationId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupMembersCompanion copyWith({
    Value<int>? groupId,
    Value<int>? nationId,
    Value<int>? rowid,
  }) {
    return GroupMembersCompanion(
      groupId: groupId ?? this.groupId,
      nationId: nationId ?? this.nationId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (nationId.present) {
      map['nation_id'] = Variable<int>(nationId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupMembersCompanion(')
          ..write('groupId: $groupId, ')
          ..write('nationId: $nationId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FixturesTable extends Fixtures
    with TableInfo<$FixturesTable, FixtureRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FixturesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _careerIdMeta = const VerificationMeta(
    'careerId',
  );
  @override
  late final GeneratedColumn<int> careerId = GeneratedColumn<int>(
    'career_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES careers (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _competitionIdMeta = const VerificationMeta(
    'competitionId',
  );
  @override
  late final GeneratedColumn<int> competitionId = GeneratedColumn<int>(
    'competition_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES competitions (id)',
    ),
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
    'group_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES qualifying_groups (id)',
    ),
  );
  static const VerificationMeta _matchdayMeta = const VerificationMeta(
    'matchday',
  );
  @override
  late final GeneratedColumn<int> matchday = GeneratedColumn<int>(
    'matchday',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _homeNationIdMeta = const VerificationMeta(
    'homeNationId',
  );
  @override
  late final GeneratedColumn<int> homeNationId = GeneratedColumn<int>(
    'home_nation_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _awayNationIdMeta = const VerificationMeta(
    'awayNationId',
  );
  @override
  late final GeneratedColumn<int> awayNationId = GeneratedColumn<int>(
    'away_nation_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _homeScoreMeta = const VerificationMeta(
    'homeScore',
  );
  @override
  late final GeneratedColumn<int> homeScore = GeneratedColumn<int>(
    'home_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _awayScoreMeta = const VerificationMeta(
    'awayScore',
  );
  @override
  late final GeneratedColumn<int> awayScore = GeneratedColumn<int>(
    'away_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _playedMeta = const VerificationMeta('played');
  @override
  late final GeneratedColumn<bool> played = GeneratedColumn<bool>(
    'played',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("played" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _roundMeta = const VerificationMeta('round');
  @override
  late final GeneratedColumn<String> round = GeneratedColumn<String>(
    'round',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    careerId,
    competitionId,
    groupId,
    matchday,
    date,
    homeNationId,
    awayNationId,
    homeScore,
    awayScore,
    played,
    round,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fixtures';
  @override
  VerificationContext validateIntegrity(
    Insertable<FixtureRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('career_id')) {
      context.handle(
        _careerIdMeta,
        careerId.isAcceptableOrUnknown(data['career_id']!, _careerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_careerIdMeta);
    }
    if (data.containsKey('competition_id')) {
      context.handle(
        _competitionIdMeta,
        competitionId.isAcceptableOrUnknown(
          data['competition_id']!,
          _competitionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_competitionIdMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    }
    if (data.containsKey('matchday')) {
      context.handle(
        _matchdayMeta,
        matchday.isAcceptableOrUnknown(data['matchday']!, _matchdayMeta),
      );
    } else if (isInserting) {
      context.missing(_matchdayMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('home_nation_id')) {
      context.handle(
        _homeNationIdMeta,
        homeNationId.isAcceptableOrUnknown(
          data['home_nation_id']!,
          _homeNationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_homeNationIdMeta);
    }
    if (data.containsKey('away_nation_id')) {
      context.handle(
        _awayNationIdMeta,
        awayNationId.isAcceptableOrUnknown(
          data['away_nation_id']!,
          _awayNationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_awayNationIdMeta);
    }
    if (data.containsKey('home_score')) {
      context.handle(
        _homeScoreMeta,
        homeScore.isAcceptableOrUnknown(data['home_score']!, _homeScoreMeta),
      );
    }
    if (data.containsKey('away_score')) {
      context.handle(
        _awayScoreMeta,
        awayScore.isAcceptableOrUnknown(data['away_score']!, _awayScoreMeta),
      );
    }
    if (data.containsKey('played')) {
      context.handle(
        _playedMeta,
        played.isAcceptableOrUnknown(data['played']!, _playedMeta),
      );
    }
    if (data.containsKey('round')) {
      context.handle(
        _roundMeta,
        round.isAcceptableOrUnknown(data['round']!, _roundMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FixtureRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FixtureRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      careerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}career_id'],
      )!,
      competitionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}competition_id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}group_id'],
      ),
      matchday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}matchday'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      homeNationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}home_nation_id'],
      )!,
      awayNationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}away_nation_id'],
      )!,
      homeScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}home_score'],
      ),
      awayScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}away_score'],
      ),
      played: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}played'],
      )!,
      round: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}round'],
      ),
    );
  }

  @override
  $FixturesTable createAlias(String alias) {
    return $FixturesTable(attachedDatabase, alias);
  }
}

class FixtureRow extends DataClass implements Insertable<FixtureRow> {
  final int id;
  final int careerId;
  final int competitionId;
  final int? groupId;
  final int matchday;
  final DateTime date;
  final int homeNationId;
  final int awayNationId;
  final int? homeScore;
  final int? awayScore;
  final bool played;

  /// Stage label for finals matches: `GROUP`, `R16`, `QF`, `SF`, `3RD`,
  /// `FINAL`. Null for confederation qualifiers.
  final String? round;
  const FixtureRow({
    required this.id,
    required this.careerId,
    required this.competitionId,
    this.groupId,
    required this.matchday,
    required this.date,
    required this.homeNationId,
    required this.awayNationId,
    this.homeScore,
    this.awayScore,
    required this.played,
    this.round,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['career_id'] = Variable<int>(careerId);
    map['competition_id'] = Variable<int>(competitionId);
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<int>(groupId);
    }
    map['matchday'] = Variable<int>(matchday);
    map['date'] = Variable<DateTime>(date);
    map['home_nation_id'] = Variable<int>(homeNationId);
    map['away_nation_id'] = Variable<int>(awayNationId);
    if (!nullToAbsent || homeScore != null) {
      map['home_score'] = Variable<int>(homeScore);
    }
    if (!nullToAbsent || awayScore != null) {
      map['away_score'] = Variable<int>(awayScore);
    }
    map['played'] = Variable<bool>(played);
    if (!nullToAbsent || round != null) {
      map['round'] = Variable<String>(round);
    }
    return map;
  }

  FixturesCompanion toCompanion(bool nullToAbsent) {
    return FixturesCompanion(
      id: Value(id),
      careerId: Value(careerId),
      competitionId: Value(competitionId),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      matchday: Value(matchday),
      date: Value(date),
      homeNationId: Value(homeNationId),
      awayNationId: Value(awayNationId),
      homeScore: homeScore == null && nullToAbsent
          ? const Value.absent()
          : Value(homeScore),
      awayScore: awayScore == null && nullToAbsent
          ? const Value.absent()
          : Value(awayScore),
      played: Value(played),
      round: round == null && nullToAbsent
          ? const Value.absent()
          : Value(round),
    );
  }

  factory FixtureRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FixtureRow(
      id: serializer.fromJson<int>(json['id']),
      careerId: serializer.fromJson<int>(json['careerId']),
      competitionId: serializer.fromJson<int>(json['competitionId']),
      groupId: serializer.fromJson<int?>(json['groupId']),
      matchday: serializer.fromJson<int>(json['matchday']),
      date: serializer.fromJson<DateTime>(json['date']),
      homeNationId: serializer.fromJson<int>(json['homeNationId']),
      awayNationId: serializer.fromJson<int>(json['awayNationId']),
      homeScore: serializer.fromJson<int?>(json['homeScore']),
      awayScore: serializer.fromJson<int?>(json['awayScore']),
      played: serializer.fromJson<bool>(json['played']),
      round: serializer.fromJson<String?>(json['round']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'careerId': serializer.toJson<int>(careerId),
      'competitionId': serializer.toJson<int>(competitionId),
      'groupId': serializer.toJson<int?>(groupId),
      'matchday': serializer.toJson<int>(matchday),
      'date': serializer.toJson<DateTime>(date),
      'homeNationId': serializer.toJson<int>(homeNationId),
      'awayNationId': serializer.toJson<int>(awayNationId),
      'homeScore': serializer.toJson<int?>(homeScore),
      'awayScore': serializer.toJson<int?>(awayScore),
      'played': serializer.toJson<bool>(played),
      'round': serializer.toJson<String?>(round),
    };
  }

  FixtureRow copyWith({
    int? id,
    int? careerId,
    int? competitionId,
    Value<int?> groupId = const Value.absent(),
    int? matchday,
    DateTime? date,
    int? homeNationId,
    int? awayNationId,
    Value<int?> homeScore = const Value.absent(),
    Value<int?> awayScore = const Value.absent(),
    bool? played,
    Value<String?> round = const Value.absent(),
  }) => FixtureRow(
    id: id ?? this.id,
    careerId: careerId ?? this.careerId,
    competitionId: competitionId ?? this.competitionId,
    groupId: groupId.present ? groupId.value : this.groupId,
    matchday: matchday ?? this.matchday,
    date: date ?? this.date,
    homeNationId: homeNationId ?? this.homeNationId,
    awayNationId: awayNationId ?? this.awayNationId,
    homeScore: homeScore.present ? homeScore.value : this.homeScore,
    awayScore: awayScore.present ? awayScore.value : this.awayScore,
    played: played ?? this.played,
    round: round.present ? round.value : this.round,
  );
  FixtureRow copyWithCompanion(FixturesCompanion data) {
    return FixtureRow(
      id: data.id.present ? data.id.value : this.id,
      careerId: data.careerId.present ? data.careerId.value : this.careerId,
      competitionId: data.competitionId.present
          ? data.competitionId.value
          : this.competitionId,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      matchday: data.matchday.present ? data.matchday.value : this.matchday,
      date: data.date.present ? data.date.value : this.date,
      homeNationId: data.homeNationId.present
          ? data.homeNationId.value
          : this.homeNationId,
      awayNationId: data.awayNationId.present
          ? data.awayNationId.value
          : this.awayNationId,
      homeScore: data.homeScore.present ? data.homeScore.value : this.homeScore,
      awayScore: data.awayScore.present ? data.awayScore.value : this.awayScore,
      played: data.played.present ? data.played.value : this.played,
      round: data.round.present ? data.round.value : this.round,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FixtureRow(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('competitionId: $competitionId, ')
          ..write('groupId: $groupId, ')
          ..write('matchday: $matchday, ')
          ..write('date: $date, ')
          ..write('homeNationId: $homeNationId, ')
          ..write('awayNationId: $awayNationId, ')
          ..write('homeScore: $homeScore, ')
          ..write('awayScore: $awayScore, ')
          ..write('played: $played, ')
          ..write('round: $round')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    careerId,
    competitionId,
    groupId,
    matchday,
    date,
    homeNationId,
    awayNationId,
    homeScore,
    awayScore,
    played,
    round,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FixtureRow &&
          other.id == this.id &&
          other.careerId == this.careerId &&
          other.competitionId == this.competitionId &&
          other.groupId == this.groupId &&
          other.matchday == this.matchday &&
          other.date == this.date &&
          other.homeNationId == this.homeNationId &&
          other.awayNationId == this.awayNationId &&
          other.homeScore == this.homeScore &&
          other.awayScore == this.awayScore &&
          other.played == this.played &&
          other.round == this.round);
}

class FixturesCompanion extends UpdateCompanion<FixtureRow> {
  final Value<int> id;
  final Value<int> careerId;
  final Value<int> competitionId;
  final Value<int?> groupId;
  final Value<int> matchday;
  final Value<DateTime> date;
  final Value<int> homeNationId;
  final Value<int> awayNationId;
  final Value<int?> homeScore;
  final Value<int?> awayScore;
  final Value<bool> played;
  final Value<String?> round;
  const FixturesCompanion({
    this.id = const Value.absent(),
    this.careerId = const Value.absent(),
    this.competitionId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.matchday = const Value.absent(),
    this.date = const Value.absent(),
    this.homeNationId = const Value.absent(),
    this.awayNationId = const Value.absent(),
    this.homeScore = const Value.absent(),
    this.awayScore = const Value.absent(),
    this.played = const Value.absent(),
    this.round = const Value.absent(),
  });
  FixturesCompanion.insert({
    this.id = const Value.absent(),
    required int careerId,
    required int competitionId,
    this.groupId = const Value.absent(),
    required int matchday,
    required DateTime date,
    required int homeNationId,
    required int awayNationId,
    this.homeScore = const Value.absent(),
    this.awayScore = const Value.absent(),
    this.played = const Value.absent(),
    this.round = const Value.absent(),
  }) : careerId = Value(careerId),
       competitionId = Value(competitionId),
       matchday = Value(matchday),
       date = Value(date),
       homeNationId = Value(homeNationId),
       awayNationId = Value(awayNationId);
  static Insertable<FixtureRow> custom({
    Expression<int>? id,
    Expression<int>? careerId,
    Expression<int>? competitionId,
    Expression<int>? groupId,
    Expression<int>? matchday,
    Expression<DateTime>? date,
    Expression<int>? homeNationId,
    Expression<int>? awayNationId,
    Expression<int>? homeScore,
    Expression<int>? awayScore,
    Expression<bool>? played,
    Expression<String>? round,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (careerId != null) 'career_id': careerId,
      if (competitionId != null) 'competition_id': competitionId,
      if (groupId != null) 'group_id': groupId,
      if (matchday != null) 'matchday': matchday,
      if (date != null) 'date': date,
      if (homeNationId != null) 'home_nation_id': homeNationId,
      if (awayNationId != null) 'away_nation_id': awayNationId,
      if (homeScore != null) 'home_score': homeScore,
      if (awayScore != null) 'away_score': awayScore,
      if (played != null) 'played': played,
      if (round != null) 'round': round,
    });
  }

  FixturesCompanion copyWith({
    Value<int>? id,
    Value<int>? careerId,
    Value<int>? competitionId,
    Value<int?>? groupId,
    Value<int>? matchday,
    Value<DateTime>? date,
    Value<int>? homeNationId,
    Value<int>? awayNationId,
    Value<int?>? homeScore,
    Value<int?>? awayScore,
    Value<bool>? played,
    Value<String?>? round,
  }) {
    return FixturesCompanion(
      id: id ?? this.id,
      careerId: careerId ?? this.careerId,
      competitionId: competitionId ?? this.competitionId,
      groupId: groupId ?? this.groupId,
      matchday: matchday ?? this.matchday,
      date: date ?? this.date,
      homeNationId: homeNationId ?? this.homeNationId,
      awayNationId: awayNationId ?? this.awayNationId,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      played: played ?? this.played,
      round: round ?? this.round,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (careerId.present) {
      map['career_id'] = Variable<int>(careerId.value);
    }
    if (competitionId.present) {
      map['competition_id'] = Variable<int>(competitionId.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (matchday.present) {
      map['matchday'] = Variable<int>(matchday.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (homeNationId.present) {
      map['home_nation_id'] = Variable<int>(homeNationId.value);
    }
    if (awayNationId.present) {
      map['away_nation_id'] = Variable<int>(awayNationId.value);
    }
    if (homeScore.present) {
      map['home_score'] = Variable<int>(homeScore.value);
    }
    if (awayScore.present) {
      map['away_score'] = Variable<int>(awayScore.value);
    }
    if (played.present) {
      map['played'] = Variable<bool>(played.value);
    }
    if (round.present) {
      map['round'] = Variable<String>(round.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FixturesCompanion(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('competitionId: $competitionId, ')
          ..write('groupId: $groupId, ')
          ..write('matchday: $matchday, ')
          ..write('date: $date, ')
          ..write('homeNationId: $homeNationId, ')
          ..write('awayNationId: $awayNationId, ')
          ..write('homeScore: $homeScore, ')
          ..write('awayScore: $awayScore, ')
          ..write('played: $played, ')
          ..write('round: $round')
          ..write(')'))
        .toString();
  }
}

class $TacticsTable extends Tactics with TableInfo<$TacticsTable, TacticRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TacticsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _careerIdMeta = const VerificationMeta(
    'careerId',
  );
  @override
  late final GeneratedColumn<int> careerId = GeneratedColumn<int>(
    'career_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES careers (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Formation, String> formation =
      GeneratedColumn<String>(
        'formation',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Formation>($TacticsTable.$converterformation);
  static const VerificationMeta _mentalityMeta = const VerificationMeta(
    'mentality',
  );
  @override
  late final GeneratedColumn<int> mentality = GeneratedColumn<int>(
    'mentality',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(50),
  );
  static const VerificationMeta _pressingMeta = const VerificationMeta(
    'pressing',
  );
  @override
  late final GeneratedColumn<int> pressing = GeneratedColumn<int>(
    'pressing',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(50),
  );
  static const VerificationMeta _tempoMeta = const VerificationMeta('tempo');
  @override
  late final GeneratedColumn<int> tempo = GeneratedColumn<int>(
    'tempo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(50),
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(50),
  );
  static const VerificationMeta _defensiveLineMeta = const VerificationMeta(
    'defensiveLine',
  );
  @override
  late final GeneratedColumn<int> defensiveLine = GeneratedColumn<int>(
    'defensive_line',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(50),
  );
  static const VerificationMeta _directnessMeta = const VerificationMeta(
    'directness',
  );
  @override
  late final GeneratedColumn<int> directness = GeneratedColumn<int>(
    'directness',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(50),
  );
  @override
  List<GeneratedColumn> get $columns => [
    careerId,
    formation,
    mentality,
    pressing,
    tempo,
    width,
    defensiveLine,
    directness,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tactics';
  @override
  VerificationContext validateIntegrity(
    Insertable<TacticRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('career_id')) {
      context.handle(
        _careerIdMeta,
        careerId.isAcceptableOrUnknown(data['career_id']!, _careerIdMeta),
      );
    }
    if (data.containsKey('mentality')) {
      context.handle(
        _mentalityMeta,
        mentality.isAcceptableOrUnknown(data['mentality']!, _mentalityMeta),
      );
    }
    if (data.containsKey('pressing')) {
      context.handle(
        _pressingMeta,
        pressing.isAcceptableOrUnknown(data['pressing']!, _pressingMeta),
      );
    }
    if (data.containsKey('tempo')) {
      context.handle(
        _tempoMeta,
        tempo.isAcceptableOrUnknown(data['tempo']!, _tempoMeta),
      );
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    }
    if (data.containsKey('defensive_line')) {
      context.handle(
        _defensiveLineMeta,
        defensiveLine.isAcceptableOrUnknown(
          data['defensive_line']!,
          _defensiveLineMeta,
        ),
      );
    }
    if (data.containsKey('directness')) {
      context.handle(
        _directnessMeta,
        directness.isAcceptableOrUnknown(data['directness']!, _directnessMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {careerId};
  @override
  TacticRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TacticRow(
      careerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}career_id'],
      )!,
      formation: $TacticsTable.$converterformation.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}formation'],
        )!,
      ),
      mentality: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mentality'],
      )!,
      pressing: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pressing'],
      )!,
      tempo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tempo'],
      )!,
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width'],
      )!,
      defensiveLine: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}defensive_line'],
      )!,
      directness: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}directness'],
      )!,
    );
  }

  @override
  $TacticsTable createAlias(String alias) {
    return $TacticsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Formation, String, String> $converterformation =
      const EnumNameConverter<Formation>(Formation.values);
}

class TacticRow extends DataClass implements Insertable<TacticRow> {
  final int careerId;
  final Formation formation;
  final int mentality;
  final int pressing;
  final int tempo;
  final int width;
  final int defensiveLine;
  final int directness;
  const TacticRow({
    required this.careerId,
    required this.formation,
    required this.mentality,
    required this.pressing,
    required this.tempo,
    required this.width,
    required this.defensiveLine,
    required this.directness,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['career_id'] = Variable<int>(careerId);
    {
      map['formation'] = Variable<String>(
        $TacticsTable.$converterformation.toSql(formation),
      );
    }
    map['mentality'] = Variable<int>(mentality);
    map['pressing'] = Variable<int>(pressing);
    map['tempo'] = Variable<int>(tempo);
    map['width'] = Variable<int>(width);
    map['defensive_line'] = Variable<int>(defensiveLine);
    map['directness'] = Variable<int>(directness);
    return map;
  }

  TacticsCompanion toCompanion(bool nullToAbsent) {
    return TacticsCompanion(
      careerId: Value(careerId),
      formation: Value(formation),
      mentality: Value(mentality),
      pressing: Value(pressing),
      tempo: Value(tempo),
      width: Value(width),
      defensiveLine: Value(defensiveLine),
      directness: Value(directness),
    );
  }

  factory TacticRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TacticRow(
      careerId: serializer.fromJson<int>(json['careerId']),
      formation: $TacticsTable.$converterformation.fromJson(
        serializer.fromJson<String>(json['formation']),
      ),
      mentality: serializer.fromJson<int>(json['mentality']),
      pressing: serializer.fromJson<int>(json['pressing']),
      tempo: serializer.fromJson<int>(json['tempo']),
      width: serializer.fromJson<int>(json['width']),
      defensiveLine: serializer.fromJson<int>(json['defensiveLine']),
      directness: serializer.fromJson<int>(json['directness']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'careerId': serializer.toJson<int>(careerId),
      'formation': serializer.toJson<String>(
        $TacticsTable.$converterformation.toJson(formation),
      ),
      'mentality': serializer.toJson<int>(mentality),
      'pressing': serializer.toJson<int>(pressing),
      'tempo': serializer.toJson<int>(tempo),
      'width': serializer.toJson<int>(width),
      'defensiveLine': serializer.toJson<int>(defensiveLine),
      'directness': serializer.toJson<int>(directness),
    };
  }

  TacticRow copyWith({
    int? careerId,
    Formation? formation,
    int? mentality,
    int? pressing,
    int? tempo,
    int? width,
    int? defensiveLine,
    int? directness,
  }) => TacticRow(
    careerId: careerId ?? this.careerId,
    formation: formation ?? this.formation,
    mentality: mentality ?? this.mentality,
    pressing: pressing ?? this.pressing,
    tempo: tempo ?? this.tempo,
    width: width ?? this.width,
    defensiveLine: defensiveLine ?? this.defensiveLine,
    directness: directness ?? this.directness,
  );
  TacticRow copyWithCompanion(TacticsCompanion data) {
    return TacticRow(
      careerId: data.careerId.present ? data.careerId.value : this.careerId,
      formation: data.formation.present ? data.formation.value : this.formation,
      mentality: data.mentality.present ? data.mentality.value : this.mentality,
      pressing: data.pressing.present ? data.pressing.value : this.pressing,
      tempo: data.tempo.present ? data.tempo.value : this.tempo,
      width: data.width.present ? data.width.value : this.width,
      defensiveLine: data.defensiveLine.present
          ? data.defensiveLine.value
          : this.defensiveLine,
      directness: data.directness.present
          ? data.directness.value
          : this.directness,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TacticRow(')
          ..write('careerId: $careerId, ')
          ..write('formation: $formation, ')
          ..write('mentality: $mentality, ')
          ..write('pressing: $pressing, ')
          ..write('tempo: $tempo, ')
          ..write('width: $width, ')
          ..write('defensiveLine: $defensiveLine, ')
          ..write('directness: $directness')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    careerId,
    formation,
    mentality,
    pressing,
    tempo,
    width,
    defensiveLine,
    directness,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TacticRow &&
          other.careerId == this.careerId &&
          other.formation == this.formation &&
          other.mentality == this.mentality &&
          other.pressing == this.pressing &&
          other.tempo == this.tempo &&
          other.width == this.width &&
          other.defensiveLine == this.defensiveLine &&
          other.directness == this.directness);
}

class TacticsCompanion extends UpdateCompanion<TacticRow> {
  final Value<int> careerId;
  final Value<Formation> formation;
  final Value<int> mentality;
  final Value<int> pressing;
  final Value<int> tempo;
  final Value<int> width;
  final Value<int> defensiveLine;
  final Value<int> directness;
  const TacticsCompanion({
    this.careerId = const Value.absent(),
    this.formation = const Value.absent(),
    this.mentality = const Value.absent(),
    this.pressing = const Value.absent(),
    this.tempo = const Value.absent(),
    this.width = const Value.absent(),
    this.defensiveLine = const Value.absent(),
    this.directness = const Value.absent(),
  });
  TacticsCompanion.insert({
    this.careerId = const Value.absent(),
    required Formation formation,
    this.mentality = const Value.absent(),
    this.pressing = const Value.absent(),
    this.tempo = const Value.absent(),
    this.width = const Value.absent(),
    this.defensiveLine = const Value.absent(),
    this.directness = const Value.absent(),
  }) : formation = Value(formation);
  static Insertable<TacticRow> custom({
    Expression<int>? careerId,
    Expression<String>? formation,
    Expression<int>? mentality,
    Expression<int>? pressing,
    Expression<int>? tempo,
    Expression<int>? width,
    Expression<int>? defensiveLine,
    Expression<int>? directness,
  }) {
    return RawValuesInsertable({
      if (careerId != null) 'career_id': careerId,
      if (formation != null) 'formation': formation,
      if (mentality != null) 'mentality': mentality,
      if (pressing != null) 'pressing': pressing,
      if (tempo != null) 'tempo': tempo,
      if (width != null) 'width': width,
      if (defensiveLine != null) 'defensive_line': defensiveLine,
      if (directness != null) 'directness': directness,
    });
  }

  TacticsCompanion copyWith({
    Value<int>? careerId,
    Value<Formation>? formation,
    Value<int>? mentality,
    Value<int>? pressing,
    Value<int>? tempo,
    Value<int>? width,
    Value<int>? defensiveLine,
    Value<int>? directness,
  }) {
    return TacticsCompanion(
      careerId: careerId ?? this.careerId,
      formation: formation ?? this.formation,
      mentality: mentality ?? this.mentality,
      pressing: pressing ?? this.pressing,
      tempo: tempo ?? this.tempo,
      width: width ?? this.width,
      defensiveLine: defensiveLine ?? this.defensiveLine,
      directness: directness ?? this.directness,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (careerId.present) {
      map['career_id'] = Variable<int>(careerId.value);
    }
    if (formation.present) {
      map['formation'] = Variable<String>(
        $TacticsTable.$converterformation.toSql(formation.value),
      );
    }
    if (mentality.present) {
      map['mentality'] = Variable<int>(mentality.value);
    }
    if (pressing.present) {
      map['pressing'] = Variable<int>(pressing.value);
    }
    if (tempo.present) {
      map['tempo'] = Variable<int>(tempo.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (defensiveLine.present) {
      map['defensive_line'] = Variable<int>(defensiveLine.value);
    }
    if (directness.present) {
      map['directness'] = Variable<int>(directness.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TacticsCompanion(')
          ..write('careerId: $careerId, ')
          ..write('formation: $formation, ')
          ..write('mentality: $mentality, ')
          ..write('pressing: $pressing, ')
          ..write('tempo: $tempo, ')
          ..write('width: $width, ')
          ..write('defensiveLine: $defensiveLine, ')
          ..write('directness: $directness')
          ..write(')'))
        .toString();
  }
}

class $LineupSlotsTable extends LineupSlots
    with TableInfo<$LineupSlotsTable, LineupSlotRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LineupSlotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _careerIdMeta = const VerificationMeta(
    'careerId',
  );
  @override
  late final GeneratedColumn<int> careerId = GeneratedColumn<int>(
    'career_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES careers (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _slotMeta = const VerificationMeta('slot');
  @override
  late final GeneratedColumn<int> slot = GeneratedColumn<int>(
    'slot',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _playerIdMeta = const VerificationMeta(
    'playerId',
  );
  @override
  late final GeneratedColumn<int> playerId = GeneratedColumn<int>(
    'player_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [careerId, slot, playerId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lineup_slots';
  @override
  VerificationContext validateIntegrity(
    Insertable<LineupSlotRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('career_id')) {
      context.handle(
        _careerIdMeta,
        careerId.isAcceptableOrUnknown(data['career_id']!, _careerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_careerIdMeta);
    }
    if (data.containsKey('slot')) {
      context.handle(
        _slotMeta,
        slot.isAcceptableOrUnknown(data['slot']!, _slotMeta),
      );
    } else if (isInserting) {
      context.missing(_slotMeta);
    }
    if (data.containsKey('player_id')) {
      context.handle(
        _playerIdMeta,
        playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {careerId, slot};
  @override
  LineupSlotRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LineupSlotRow(
      careerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}career_id'],
      )!,
      slot: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}slot'],
      )!,
      playerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}player_id'],
      ),
    );
  }

  @override
  $LineupSlotsTable createAlias(String alias) {
    return $LineupSlotsTable(attachedDatabase, alias);
  }
}

class LineupSlotRow extends DataClass implements Insertable<LineupSlotRow> {
  final int careerId;
  final int slot;
  final int? playerId;
  const LineupSlotRow({
    required this.careerId,
    required this.slot,
    this.playerId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['career_id'] = Variable<int>(careerId);
    map['slot'] = Variable<int>(slot);
    if (!nullToAbsent || playerId != null) {
      map['player_id'] = Variable<int>(playerId);
    }
    return map;
  }

  LineupSlotsCompanion toCompanion(bool nullToAbsent) {
    return LineupSlotsCompanion(
      careerId: Value(careerId),
      slot: Value(slot),
      playerId: playerId == null && nullToAbsent
          ? const Value.absent()
          : Value(playerId),
    );
  }

  factory LineupSlotRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LineupSlotRow(
      careerId: serializer.fromJson<int>(json['careerId']),
      slot: serializer.fromJson<int>(json['slot']),
      playerId: serializer.fromJson<int?>(json['playerId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'careerId': serializer.toJson<int>(careerId),
      'slot': serializer.toJson<int>(slot),
      'playerId': serializer.toJson<int?>(playerId),
    };
  }

  LineupSlotRow copyWith({
    int? careerId,
    int? slot,
    Value<int?> playerId = const Value.absent(),
  }) => LineupSlotRow(
    careerId: careerId ?? this.careerId,
    slot: slot ?? this.slot,
    playerId: playerId.present ? playerId.value : this.playerId,
  );
  LineupSlotRow copyWithCompanion(LineupSlotsCompanion data) {
    return LineupSlotRow(
      careerId: data.careerId.present ? data.careerId.value : this.careerId,
      slot: data.slot.present ? data.slot.value : this.slot,
      playerId: data.playerId.present ? data.playerId.value : this.playerId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LineupSlotRow(')
          ..write('careerId: $careerId, ')
          ..write('slot: $slot, ')
          ..write('playerId: $playerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(careerId, slot, playerId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LineupSlotRow &&
          other.careerId == this.careerId &&
          other.slot == this.slot &&
          other.playerId == this.playerId);
}

class LineupSlotsCompanion extends UpdateCompanion<LineupSlotRow> {
  final Value<int> careerId;
  final Value<int> slot;
  final Value<int?> playerId;
  final Value<int> rowid;
  const LineupSlotsCompanion({
    this.careerId = const Value.absent(),
    this.slot = const Value.absent(),
    this.playerId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LineupSlotsCompanion.insert({
    required int careerId,
    required int slot,
    this.playerId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : careerId = Value(careerId),
       slot = Value(slot);
  static Insertable<LineupSlotRow> custom({
    Expression<int>? careerId,
    Expression<int>? slot,
    Expression<int>? playerId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (careerId != null) 'career_id': careerId,
      if (slot != null) 'slot': slot,
      if (playerId != null) 'player_id': playerId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LineupSlotsCompanion copyWith({
    Value<int>? careerId,
    Value<int>? slot,
    Value<int?>? playerId,
    Value<int>? rowid,
  }) {
    return LineupSlotsCompanion(
      careerId: careerId ?? this.careerId,
      slot: slot ?? this.slot,
      playerId: playerId ?? this.playerId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (careerId.present) {
      map['career_id'] = Variable<int>(careerId.value);
    }
    if (slot.present) {
      map['slot'] = Variable<int>(slot.value);
    }
    if (playerId.present) {
      map['player_id'] = Variable<int>(playerId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LineupSlotsCompanion(')
          ..write('careerId: $careerId, ')
          ..write('slot: $slot, ')
          ..write('playerId: $playerId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CallUpsTable extends CallUps with TableInfo<$CallUpsTable, CallUpRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CallUpsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _careerIdMeta = const VerificationMeta(
    'careerId',
  );
  @override
  late final GeneratedColumn<int> careerId = GeneratedColumn<int>(
    'career_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES careers (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _playerIdMeta = const VerificationMeta(
    'playerId',
  );
  @override
  late final GeneratedColumn<int> playerId = GeneratedColumn<int>(
    'player_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [careerId, playerId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'call_ups';
  @override
  VerificationContext validateIntegrity(
    Insertable<CallUpRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('career_id')) {
      context.handle(
        _careerIdMeta,
        careerId.isAcceptableOrUnknown(data['career_id']!, _careerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_careerIdMeta);
    }
    if (data.containsKey('player_id')) {
      context.handle(
        _playerIdMeta,
        playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playerIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {careerId, playerId};
  @override
  CallUpRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CallUpRow(
      careerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}career_id'],
      )!,
      playerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}player_id'],
      )!,
    );
  }

  @override
  $CallUpsTable createAlias(String alias) {
    return $CallUpsTable(attachedDatabase, alias);
  }
}

class CallUpRow extends DataClass implements Insertable<CallUpRow> {
  final int careerId;
  final int playerId;
  const CallUpRow({required this.careerId, required this.playerId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['career_id'] = Variable<int>(careerId);
    map['player_id'] = Variable<int>(playerId);
    return map;
  }

  CallUpsCompanion toCompanion(bool nullToAbsent) {
    return CallUpsCompanion(
      careerId: Value(careerId),
      playerId: Value(playerId),
    );
  }

  factory CallUpRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CallUpRow(
      careerId: serializer.fromJson<int>(json['careerId']),
      playerId: serializer.fromJson<int>(json['playerId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'careerId': serializer.toJson<int>(careerId),
      'playerId': serializer.toJson<int>(playerId),
    };
  }

  CallUpRow copyWith({int? careerId, int? playerId}) => CallUpRow(
    careerId: careerId ?? this.careerId,
    playerId: playerId ?? this.playerId,
  );
  CallUpRow copyWithCompanion(CallUpsCompanion data) {
    return CallUpRow(
      careerId: data.careerId.present ? data.careerId.value : this.careerId,
      playerId: data.playerId.present ? data.playerId.value : this.playerId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CallUpRow(')
          ..write('careerId: $careerId, ')
          ..write('playerId: $playerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(careerId, playerId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CallUpRow &&
          other.careerId == this.careerId &&
          other.playerId == this.playerId);
}

class CallUpsCompanion extends UpdateCompanion<CallUpRow> {
  final Value<int> careerId;
  final Value<int> playerId;
  final Value<int> rowid;
  const CallUpsCompanion({
    this.careerId = const Value.absent(),
    this.playerId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CallUpsCompanion.insert({
    required int careerId,
    required int playerId,
    this.rowid = const Value.absent(),
  }) : careerId = Value(careerId),
       playerId = Value(playerId);
  static Insertable<CallUpRow> custom({
    Expression<int>? careerId,
    Expression<int>? playerId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (careerId != null) 'career_id': careerId,
      if (playerId != null) 'player_id': playerId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CallUpsCompanion copyWith({
    Value<int>? careerId,
    Value<int>? playerId,
    Value<int>? rowid,
  }) {
    return CallUpsCompanion(
      careerId: careerId ?? this.careerId,
      playerId: playerId ?? this.playerId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (careerId.present) {
      map['career_id'] = Variable<int>(careerId.value);
    }
    if (playerId.present) {
      map['player_id'] = Variable<int>(playerId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CallUpsCompanion(')
          ..write('careerId: $careerId, ')
          ..write('playerId: $playerId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalEventsTable extends GoalEvents
    with TableInfo<$GoalEventsTable, GoalEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalEventsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _careerIdMeta = const VerificationMeta(
    'careerId',
  );
  @override
  late final GeneratedColumn<int> careerId = GeneratedColumn<int>(
    'career_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES careers (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _competitionIdMeta = const VerificationMeta(
    'competitionId',
  );
  @override
  late final GeneratedColumn<int> competitionId = GeneratedColumn<int>(
    'competition_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES competitions (id)',
    ),
  );
  static const VerificationMeta _fixtureIdMeta = const VerificationMeta(
    'fixtureId',
  );
  @override
  late final GeneratedColumn<int> fixtureId = GeneratedColumn<int>(
    'fixture_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES fixtures (id)',
    ),
  );
  static const VerificationMeta _nationIdMeta = const VerificationMeta(
    'nationId',
  );
  @override
  late final GeneratedColumn<int> nationId = GeneratedColumn<int>(
    'nation_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _playerIdMeta = const VerificationMeta(
    'playerId',
  );
  @override
  late final GeneratedColumn<int> playerId = GeneratedColumn<int>(
    'player_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minuteMeta = const VerificationMeta('minute');
  @override
  late final GeneratedColumn<int> minute = GeneratedColumn<int>(
    'minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    careerId,
    competitionId,
    fixtureId,
    nationId,
    playerId,
    minute,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goal_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<GoalEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('career_id')) {
      context.handle(
        _careerIdMeta,
        careerId.isAcceptableOrUnknown(data['career_id']!, _careerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_careerIdMeta);
    }
    if (data.containsKey('competition_id')) {
      context.handle(
        _competitionIdMeta,
        competitionId.isAcceptableOrUnknown(
          data['competition_id']!,
          _competitionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_competitionIdMeta);
    }
    if (data.containsKey('fixture_id')) {
      context.handle(
        _fixtureIdMeta,
        fixtureId.isAcceptableOrUnknown(data['fixture_id']!, _fixtureIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fixtureIdMeta);
    }
    if (data.containsKey('nation_id')) {
      context.handle(
        _nationIdMeta,
        nationId.isAcceptableOrUnknown(data['nation_id']!, _nationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nationIdMeta);
    }
    if (data.containsKey('player_id')) {
      context.handle(
        _playerIdMeta,
        playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playerIdMeta);
    }
    if (data.containsKey('minute')) {
      context.handle(
        _minuteMeta,
        minute.isAcceptableOrUnknown(data['minute']!, _minuteMeta),
      );
    } else if (isInserting) {
      context.missing(_minuteMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalEventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      careerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}career_id'],
      )!,
      competitionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}competition_id'],
      )!,
      fixtureId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fixture_id'],
      )!,
      nationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nation_id'],
      )!,
      playerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}player_id'],
      )!,
      minute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minute'],
      )!,
    );
  }

  @override
  $GoalEventsTable createAlias(String alias) {
    return $GoalEventsTable(attachedDatabase, alias);
  }
}

class GoalEventRow extends DataClass implements Insertable<GoalEventRow> {
  final int id;
  final int careerId;
  final int competitionId;
  final int fixtureId;
  final int nationId;
  final int playerId;
  final int minute;
  const GoalEventRow({
    required this.id,
    required this.careerId,
    required this.competitionId,
    required this.fixtureId,
    required this.nationId,
    required this.playerId,
    required this.minute,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['career_id'] = Variable<int>(careerId);
    map['competition_id'] = Variable<int>(competitionId);
    map['fixture_id'] = Variable<int>(fixtureId);
    map['nation_id'] = Variable<int>(nationId);
    map['player_id'] = Variable<int>(playerId);
    map['minute'] = Variable<int>(minute);
    return map;
  }

  GoalEventsCompanion toCompanion(bool nullToAbsent) {
    return GoalEventsCompanion(
      id: Value(id),
      careerId: Value(careerId),
      competitionId: Value(competitionId),
      fixtureId: Value(fixtureId),
      nationId: Value(nationId),
      playerId: Value(playerId),
      minute: Value(minute),
    );
  }

  factory GoalEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalEventRow(
      id: serializer.fromJson<int>(json['id']),
      careerId: serializer.fromJson<int>(json['careerId']),
      competitionId: serializer.fromJson<int>(json['competitionId']),
      fixtureId: serializer.fromJson<int>(json['fixtureId']),
      nationId: serializer.fromJson<int>(json['nationId']),
      playerId: serializer.fromJson<int>(json['playerId']),
      minute: serializer.fromJson<int>(json['minute']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'careerId': serializer.toJson<int>(careerId),
      'competitionId': serializer.toJson<int>(competitionId),
      'fixtureId': serializer.toJson<int>(fixtureId),
      'nationId': serializer.toJson<int>(nationId),
      'playerId': serializer.toJson<int>(playerId),
      'minute': serializer.toJson<int>(minute),
    };
  }

  GoalEventRow copyWith({
    int? id,
    int? careerId,
    int? competitionId,
    int? fixtureId,
    int? nationId,
    int? playerId,
    int? minute,
  }) => GoalEventRow(
    id: id ?? this.id,
    careerId: careerId ?? this.careerId,
    competitionId: competitionId ?? this.competitionId,
    fixtureId: fixtureId ?? this.fixtureId,
    nationId: nationId ?? this.nationId,
    playerId: playerId ?? this.playerId,
    minute: minute ?? this.minute,
  );
  GoalEventRow copyWithCompanion(GoalEventsCompanion data) {
    return GoalEventRow(
      id: data.id.present ? data.id.value : this.id,
      careerId: data.careerId.present ? data.careerId.value : this.careerId,
      competitionId: data.competitionId.present
          ? data.competitionId.value
          : this.competitionId,
      fixtureId: data.fixtureId.present ? data.fixtureId.value : this.fixtureId,
      nationId: data.nationId.present ? data.nationId.value : this.nationId,
      playerId: data.playerId.present ? data.playerId.value : this.playerId,
      minute: data.minute.present ? data.minute.value : this.minute,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalEventRow(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('competitionId: $competitionId, ')
          ..write('fixtureId: $fixtureId, ')
          ..write('nationId: $nationId, ')
          ..write('playerId: $playerId, ')
          ..write('minute: $minute')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    careerId,
    competitionId,
    fixtureId,
    nationId,
    playerId,
    minute,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalEventRow &&
          other.id == this.id &&
          other.careerId == this.careerId &&
          other.competitionId == this.competitionId &&
          other.fixtureId == this.fixtureId &&
          other.nationId == this.nationId &&
          other.playerId == this.playerId &&
          other.minute == this.minute);
}

class GoalEventsCompanion extends UpdateCompanion<GoalEventRow> {
  final Value<int> id;
  final Value<int> careerId;
  final Value<int> competitionId;
  final Value<int> fixtureId;
  final Value<int> nationId;
  final Value<int> playerId;
  final Value<int> minute;
  const GoalEventsCompanion({
    this.id = const Value.absent(),
    this.careerId = const Value.absent(),
    this.competitionId = const Value.absent(),
    this.fixtureId = const Value.absent(),
    this.nationId = const Value.absent(),
    this.playerId = const Value.absent(),
    this.minute = const Value.absent(),
  });
  GoalEventsCompanion.insert({
    this.id = const Value.absent(),
    required int careerId,
    required int competitionId,
    required int fixtureId,
    required int nationId,
    required int playerId,
    required int minute,
  }) : careerId = Value(careerId),
       competitionId = Value(competitionId),
       fixtureId = Value(fixtureId),
       nationId = Value(nationId),
       playerId = Value(playerId),
       minute = Value(minute);
  static Insertable<GoalEventRow> custom({
    Expression<int>? id,
    Expression<int>? careerId,
    Expression<int>? competitionId,
    Expression<int>? fixtureId,
    Expression<int>? nationId,
    Expression<int>? playerId,
    Expression<int>? minute,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (careerId != null) 'career_id': careerId,
      if (competitionId != null) 'competition_id': competitionId,
      if (fixtureId != null) 'fixture_id': fixtureId,
      if (nationId != null) 'nation_id': nationId,
      if (playerId != null) 'player_id': playerId,
      if (minute != null) 'minute': minute,
    });
  }

  GoalEventsCompanion copyWith({
    Value<int>? id,
    Value<int>? careerId,
    Value<int>? competitionId,
    Value<int>? fixtureId,
    Value<int>? nationId,
    Value<int>? playerId,
    Value<int>? minute,
  }) {
    return GoalEventsCompanion(
      id: id ?? this.id,
      careerId: careerId ?? this.careerId,
      competitionId: competitionId ?? this.competitionId,
      fixtureId: fixtureId ?? this.fixtureId,
      nationId: nationId ?? this.nationId,
      playerId: playerId ?? this.playerId,
      minute: minute ?? this.minute,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (careerId.present) {
      map['career_id'] = Variable<int>(careerId.value);
    }
    if (competitionId.present) {
      map['competition_id'] = Variable<int>(competitionId.value);
    }
    if (fixtureId.present) {
      map['fixture_id'] = Variable<int>(fixtureId.value);
    }
    if (nationId.present) {
      map['nation_id'] = Variable<int>(nationId.value);
    }
    if (playerId.present) {
      map['player_id'] = Variable<int>(playerId.value);
    }
    if (minute.present) {
      map['minute'] = Variable<int>(minute.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalEventsCompanion(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('competitionId: $competitionId, ')
          ..write('fixtureId: $fixtureId, ')
          ..write('nationId: $nationId, ')
          ..write('playerId: $playerId, ')
          ..write('minute: $minute')
          ..write(')'))
        .toString();
  }
}

class $HonoursTable extends Honours with TableInfo<$HonoursTable, HonourRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HonoursTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _careerIdMeta = const VerificationMeta(
    'careerId',
  );
  @override
  late final GeneratedColumn<int> careerId = GeneratedColumn<int>(
    'career_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES careers (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _competitionMeta = const VerificationMeta(
    'competition',
  );
  @override
  late final GeneratedColumn<String> competition = GeneratedColumn<String>(
    'competition',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _championIdMeta = const VerificationMeta(
    'championId',
  );
  @override
  late final GeneratedColumn<int> championId = GeneratedColumn<int>(
    'champion_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _runnerUpIdMeta = const VerificationMeta(
    'runnerUpId',
  );
  @override
  late final GeneratedColumn<int> runnerUpId = GeneratedColumn<int>(
    'runner_up_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thirdIdMeta = const VerificationMeta(
    'thirdId',
  );
  @override
  late final GeneratedColumn<int> thirdId = GeneratedColumn<int>(
    'third_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hostIdMeta = const VerificationMeta('hostId');
  @override
  late final GeneratedColumn<int> hostId = GeneratedColumn<int>(
    'host_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _finalHomeScoreMeta = const VerificationMeta(
    'finalHomeScore',
  );
  @override
  late final GeneratedColumn<int> finalHomeScore = GeneratedColumn<int>(
    'final_home_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _finalAwayScoreMeta = const VerificationMeta(
    'finalAwayScore',
  );
  @override
  late final GeneratedColumn<int> finalAwayScore = GeneratedColumn<int>(
    'final_away_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _topScorerNameMeta = const VerificationMeta(
    'topScorerName',
  );
  @override
  late final GeneratedColumn<String> topScorerName = GeneratedColumn<String>(
    'top_scorer_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _topScorerGoalsMeta = const VerificationMeta(
    'topScorerGoals',
  );
  @override
  late final GeneratedColumn<int> topScorerGoals = GeneratedColumn<int>(
    'top_scorer_goals',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    careerId,
    year,
    competition,
    championId,
    runnerUpId,
    thirdId,
    hostId,
    finalHomeScore,
    finalAwayScore,
    topScorerName,
    topScorerGoals,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'honours';
  @override
  VerificationContext validateIntegrity(
    Insertable<HonourRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('career_id')) {
      context.handle(
        _careerIdMeta,
        careerId.isAcceptableOrUnknown(data['career_id']!, _careerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_careerIdMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('competition')) {
      context.handle(
        _competitionMeta,
        competition.isAcceptableOrUnknown(
          data['competition']!,
          _competitionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_competitionMeta);
    }
    if (data.containsKey('champion_id')) {
      context.handle(
        _championIdMeta,
        championId.isAcceptableOrUnknown(data['champion_id']!, _championIdMeta),
      );
    } else if (isInserting) {
      context.missing(_championIdMeta);
    }
    if (data.containsKey('runner_up_id')) {
      context.handle(
        _runnerUpIdMeta,
        runnerUpId.isAcceptableOrUnknown(
          data['runner_up_id']!,
          _runnerUpIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_runnerUpIdMeta);
    }
    if (data.containsKey('third_id')) {
      context.handle(
        _thirdIdMeta,
        thirdId.isAcceptableOrUnknown(data['third_id']!, _thirdIdMeta),
      );
    }
    if (data.containsKey('host_id')) {
      context.handle(
        _hostIdMeta,
        hostId.isAcceptableOrUnknown(data['host_id']!, _hostIdMeta),
      );
    }
    if (data.containsKey('final_home_score')) {
      context.handle(
        _finalHomeScoreMeta,
        finalHomeScore.isAcceptableOrUnknown(
          data['final_home_score']!,
          _finalHomeScoreMeta,
        ),
      );
    }
    if (data.containsKey('final_away_score')) {
      context.handle(
        _finalAwayScoreMeta,
        finalAwayScore.isAcceptableOrUnknown(
          data['final_away_score']!,
          _finalAwayScoreMeta,
        ),
      );
    }
    if (data.containsKey('top_scorer_name')) {
      context.handle(
        _topScorerNameMeta,
        topScorerName.isAcceptableOrUnknown(
          data['top_scorer_name']!,
          _topScorerNameMeta,
        ),
      );
    }
    if (data.containsKey('top_scorer_goals')) {
      context.handle(
        _topScorerGoalsMeta,
        topScorerGoals.isAcceptableOrUnknown(
          data['top_scorer_goals']!,
          _topScorerGoalsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HonourRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HonourRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      careerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}career_id'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      competition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}competition'],
      )!,
      championId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}champion_id'],
      )!,
      runnerUpId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}runner_up_id'],
      )!,
      thirdId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}third_id'],
      ),
      hostId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}host_id'],
      ),
      finalHomeScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}final_home_score'],
      ),
      finalAwayScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}final_away_score'],
      ),
      topScorerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}top_scorer_name'],
      ),
      topScorerGoals: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}top_scorer_goals'],
      ),
    );
  }

  @override
  $HonoursTable createAlias(String alias) {
    return $HonoursTable(attachedDatabase, alias);
  }
}

class HonourRow extends DataClass implements Insertable<HonourRow> {
  final int id;
  final int careerId;

  /// The tournament year (e.g. finals year).
  final int year;
  final String competition;
  final int championId;
  final int runnerUpId;
  final int? thirdId;

  /// Host nation, final scoreline, and golden-boot winner.
  final int? hostId;
  final int? finalHomeScore;
  final int? finalAwayScore;
  final String? topScorerName;
  final int? topScorerGoals;
  const HonourRow({
    required this.id,
    required this.careerId,
    required this.year,
    required this.competition,
    required this.championId,
    required this.runnerUpId,
    this.thirdId,
    this.hostId,
    this.finalHomeScore,
    this.finalAwayScore,
    this.topScorerName,
    this.topScorerGoals,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['career_id'] = Variable<int>(careerId);
    map['year'] = Variable<int>(year);
    map['competition'] = Variable<String>(competition);
    map['champion_id'] = Variable<int>(championId);
    map['runner_up_id'] = Variable<int>(runnerUpId);
    if (!nullToAbsent || thirdId != null) {
      map['third_id'] = Variable<int>(thirdId);
    }
    if (!nullToAbsent || hostId != null) {
      map['host_id'] = Variable<int>(hostId);
    }
    if (!nullToAbsent || finalHomeScore != null) {
      map['final_home_score'] = Variable<int>(finalHomeScore);
    }
    if (!nullToAbsent || finalAwayScore != null) {
      map['final_away_score'] = Variable<int>(finalAwayScore);
    }
    if (!nullToAbsent || topScorerName != null) {
      map['top_scorer_name'] = Variable<String>(topScorerName);
    }
    if (!nullToAbsent || topScorerGoals != null) {
      map['top_scorer_goals'] = Variable<int>(topScorerGoals);
    }
    return map;
  }

  HonoursCompanion toCompanion(bool nullToAbsent) {
    return HonoursCompanion(
      id: Value(id),
      careerId: Value(careerId),
      year: Value(year),
      competition: Value(competition),
      championId: Value(championId),
      runnerUpId: Value(runnerUpId),
      thirdId: thirdId == null && nullToAbsent
          ? const Value.absent()
          : Value(thirdId),
      hostId: hostId == null && nullToAbsent
          ? const Value.absent()
          : Value(hostId),
      finalHomeScore: finalHomeScore == null && nullToAbsent
          ? const Value.absent()
          : Value(finalHomeScore),
      finalAwayScore: finalAwayScore == null && nullToAbsent
          ? const Value.absent()
          : Value(finalAwayScore),
      topScorerName: topScorerName == null && nullToAbsent
          ? const Value.absent()
          : Value(topScorerName),
      topScorerGoals: topScorerGoals == null && nullToAbsent
          ? const Value.absent()
          : Value(topScorerGoals),
    );
  }

  factory HonourRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HonourRow(
      id: serializer.fromJson<int>(json['id']),
      careerId: serializer.fromJson<int>(json['careerId']),
      year: serializer.fromJson<int>(json['year']),
      competition: serializer.fromJson<String>(json['competition']),
      championId: serializer.fromJson<int>(json['championId']),
      runnerUpId: serializer.fromJson<int>(json['runnerUpId']),
      thirdId: serializer.fromJson<int?>(json['thirdId']),
      hostId: serializer.fromJson<int?>(json['hostId']),
      finalHomeScore: serializer.fromJson<int?>(json['finalHomeScore']),
      finalAwayScore: serializer.fromJson<int?>(json['finalAwayScore']),
      topScorerName: serializer.fromJson<String?>(json['topScorerName']),
      topScorerGoals: serializer.fromJson<int?>(json['topScorerGoals']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'careerId': serializer.toJson<int>(careerId),
      'year': serializer.toJson<int>(year),
      'competition': serializer.toJson<String>(competition),
      'championId': serializer.toJson<int>(championId),
      'runnerUpId': serializer.toJson<int>(runnerUpId),
      'thirdId': serializer.toJson<int?>(thirdId),
      'hostId': serializer.toJson<int?>(hostId),
      'finalHomeScore': serializer.toJson<int?>(finalHomeScore),
      'finalAwayScore': serializer.toJson<int?>(finalAwayScore),
      'topScorerName': serializer.toJson<String?>(topScorerName),
      'topScorerGoals': serializer.toJson<int?>(topScorerGoals),
    };
  }

  HonourRow copyWith({
    int? id,
    int? careerId,
    int? year,
    String? competition,
    int? championId,
    int? runnerUpId,
    Value<int?> thirdId = const Value.absent(),
    Value<int?> hostId = const Value.absent(),
    Value<int?> finalHomeScore = const Value.absent(),
    Value<int?> finalAwayScore = const Value.absent(),
    Value<String?> topScorerName = const Value.absent(),
    Value<int?> topScorerGoals = const Value.absent(),
  }) => HonourRow(
    id: id ?? this.id,
    careerId: careerId ?? this.careerId,
    year: year ?? this.year,
    competition: competition ?? this.competition,
    championId: championId ?? this.championId,
    runnerUpId: runnerUpId ?? this.runnerUpId,
    thirdId: thirdId.present ? thirdId.value : this.thirdId,
    hostId: hostId.present ? hostId.value : this.hostId,
    finalHomeScore: finalHomeScore.present
        ? finalHomeScore.value
        : this.finalHomeScore,
    finalAwayScore: finalAwayScore.present
        ? finalAwayScore.value
        : this.finalAwayScore,
    topScorerName: topScorerName.present
        ? topScorerName.value
        : this.topScorerName,
    topScorerGoals: topScorerGoals.present
        ? topScorerGoals.value
        : this.topScorerGoals,
  );
  HonourRow copyWithCompanion(HonoursCompanion data) {
    return HonourRow(
      id: data.id.present ? data.id.value : this.id,
      careerId: data.careerId.present ? data.careerId.value : this.careerId,
      year: data.year.present ? data.year.value : this.year,
      competition: data.competition.present
          ? data.competition.value
          : this.competition,
      championId: data.championId.present
          ? data.championId.value
          : this.championId,
      runnerUpId: data.runnerUpId.present
          ? data.runnerUpId.value
          : this.runnerUpId,
      thirdId: data.thirdId.present ? data.thirdId.value : this.thirdId,
      hostId: data.hostId.present ? data.hostId.value : this.hostId,
      finalHomeScore: data.finalHomeScore.present
          ? data.finalHomeScore.value
          : this.finalHomeScore,
      finalAwayScore: data.finalAwayScore.present
          ? data.finalAwayScore.value
          : this.finalAwayScore,
      topScorerName: data.topScorerName.present
          ? data.topScorerName.value
          : this.topScorerName,
      topScorerGoals: data.topScorerGoals.present
          ? data.topScorerGoals.value
          : this.topScorerGoals,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HonourRow(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('year: $year, ')
          ..write('competition: $competition, ')
          ..write('championId: $championId, ')
          ..write('runnerUpId: $runnerUpId, ')
          ..write('thirdId: $thirdId, ')
          ..write('hostId: $hostId, ')
          ..write('finalHomeScore: $finalHomeScore, ')
          ..write('finalAwayScore: $finalAwayScore, ')
          ..write('topScorerName: $topScorerName, ')
          ..write('topScorerGoals: $topScorerGoals')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    careerId,
    year,
    competition,
    championId,
    runnerUpId,
    thirdId,
    hostId,
    finalHomeScore,
    finalAwayScore,
    topScorerName,
    topScorerGoals,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HonourRow &&
          other.id == this.id &&
          other.careerId == this.careerId &&
          other.year == this.year &&
          other.competition == this.competition &&
          other.championId == this.championId &&
          other.runnerUpId == this.runnerUpId &&
          other.thirdId == this.thirdId &&
          other.hostId == this.hostId &&
          other.finalHomeScore == this.finalHomeScore &&
          other.finalAwayScore == this.finalAwayScore &&
          other.topScorerName == this.topScorerName &&
          other.topScorerGoals == this.topScorerGoals);
}

class HonoursCompanion extends UpdateCompanion<HonourRow> {
  final Value<int> id;
  final Value<int> careerId;
  final Value<int> year;
  final Value<String> competition;
  final Value<int> championId;
  final Value<int> runnerUpId;
  final Value<int?> thirdId;
  final Value<int?> hostId;
  final Value<int?> finalHomeScore;
  final Value<int?> finalAwayScore;
  final Value<String?> topScorerName;
  final Value<int?> topScorerGoals;
  const HonoursCompanion({
    this.id = const Value.absent(),
    this.careerId = const Value.absent(),
    this.year = const Value.absent(),
    this.competition = const Value.absent(),
    this.championId = const Value.absent(),
    this.runnerUpId = const Value.absent(),
    this.thirdId = const Value.absent(),
    this.hostId = const Value.absent(),
    this.finalHomeScore = const Value.absent(),
    this.finalAwayScore = const Value.absent(),
    this.topScorerName = const Value.absent(),
    this.topScorerGoals = const Value.absent(),
  });
  HonoursCompanion.insert({
    this.id = const Value.absent(),
    required int careerId,
    required int year,
    required String competition,
    required int championId,
    required int runnerUpId,
    this.thirdId = const Value.absent(),
    this.hostId = const Value.absent(),
    this.finalHomeScore = const Value.absent(),
    this.finalAwayScore = const Value.absent(),
    this.topScorerName = const Value.absent(),
    this.topScorerGoals = const Value.absent(),
  }) : careerId = Value(careerId),
       year = Value(year),
       competition = Value(competition),
       championId = Value(championId),
       runnerUpId = Value(runnerUpId);
  static Insertable<HonourRow> custom({
    Expression<int>? id,
    Expression<int>? careerId,
    Expression<int>? year,
    Expression<String>? competition,
    Expression<int>? championId,
    Expression<int>? runnerUpId,
    Expression<int>? thirdId,
    Expression<int>? hostId,
    Expression<int>? finalHomeScore,
    Expression<int>? finalAwayScore,
    Expression<String>? topScorerName,
    Expression<int>? topScorerGoals,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (careerId != null) 'career_id': careerId,
      if (year != null) 'year': year,
      if (competition != null) 'competition': competition,
      if (championId != null) 'champion_id': championId,
      if (runnerUpId != null) 'runner_up_id': runnerUpId,
      if (thirdId != null) 'third_id': thirdId,
      if (hostId != null) 'host_id': hostId,
      if (finalHomeScore != null) 'final_home_score': finalHomeScore,
      if (finalAwayScore != null) 'final_away_score': finalAwayScore,
      if (topScorerName != null) 'top_scorer_name': topScorerName,
      if (topScorerGoals != null) 'top_scorer_goals': topScorerGoals,
    });
  }

  HonoursCompanion copyWith({
    Value<int>? id,
    Value<int>? careerId,
    Value<int>? year,
    Value<String>? competition,
    Value<int>? championId,
    Value<int>? runnerUpId,
    Value<int?>? thirdId,
    Value<int?>? hostId,
    Value<int?>? finalHomeScore,
    Value<int?>? finalAwayScore,
    Value<String?>? topScorerName,
    Value<int?>? topScorerGoals,
  }) {
    return HonoursCompanion(
      id: id ?? this.id,
      careerId: careerId ?? this.careerId,
      year: year ?? this.year,
      competition: competition ?? this.competition,
      championId: championId ?? this.championId,
      runnerUpId: runnerUpId ?? this.runnerUpId,
      thirdId: thirdId ?? this.thirdId,
      hostId: hostId ?? this.hostId,
      finalHomeScore: finalHomeScore ?? this.finalHomeScore,
      finalAwayScore: finalAwayScore ?? this.finalAwayScore,
      topScorerName: topScorerName ?? this.topScorerName,
      topScorerGoals: topScorerGoals ?? this.topScorerGoals,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (careerId.present) {
      map['career_id'] = Variable<int>(careerId.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (competition.present) {
      map['competition'] = Variable<String>(competition.value);
    }
    if (championId.present) {
      map['champion_id'] = Variable<int>(championId.value);
    }
    if (runnerUpId.present) {
      map['runner_up_id'] = Variable<int>(runnerUpId.value);
    }
    if (thirdId.present) {
      map['third_id'] = Variable<int>(thirdId.value);
    }
    if (hostId.present) {
      map['host_id'] = Variable<int>(hostId.value);
    }
    if (finalHomeScore.present) {
      map['final_home_score'] = Variable<int>(finalHomeScore.value);
    }
    if (finalAwayScore.present) {
      map['final_away_score'] = Variable<int>(finalAwayScore.value);
    }
    if (topScorerName.present) {
      map['top_scorer_name'] = Variable<String>(topScorerName.value);
    }
    if (topScorerGoals.present) {
      map['top_scorer_goals'] = Variable<int>(topScorerGoals.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HonoursCompanion(')
          ..write('id: $id, ')
          ..write('careerId: $careerId, ')
          ..write('year: $year, ')
          ..write('competition: $competition, ')
          ..write('championId: $championId, ')
          ..write('runnerUpId: $runnerUpId, ')
          ..write('thirdId: $thirdId, ')
          ..write('hostId: $hostId, ')
          ..write('finalHomeScore: $finalHomeScore, ')
          ..write('finalAwayScore: $finalAwayScore, ')
          ..write('topScorerName: $topScorerName, ')
          ..write('topScorerGoals: $topScorerGoals')
          ..write(')'))
        .toString();
  }
}

class $DrawsWatchedTable extends DrawsWatched
    with TableInfo<$DrawsWatchedTable, DrawWatchedRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DrawsWatchedTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _careerIdMeta = const VerificationMeta(
    'careerId',
  );
  @override
  late final GeneratedColumn<int> careerId = GeneratedColumn<int>(
    'career_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES careers (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _cycleMeta = const VerificationMeta('cycle');
  @override
  late final GeneratedColumn<int> cycle = GeneratedColumn<int>(
    'cycle',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [careerId, cycle, kind];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'draws_watched';
  @override
  VerificationContext validateIntegrity(
    Insertable<DrawWatchedRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('career_id')) {
      context.handle(
        _careerIdMeta,
        careerId.isAcceptableOrUnknown(data['career_id']!, _careerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_careerIdMeta);
    }
    if (data.containsKey('cycle')) {
      context.handle(
        _cycleMeta,
        cycle.isAcceptableOrUnknown(data['cycle']!, _cycleMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {careerId, cycle, kind};
  @override
  DrawWatchedRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DrawWatchedRow(
      careerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}career_id'],
      )!,
      cycle: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
    );
  }

  @override
  $DrawsWatchedTable createAlias(String alias) {
    return $DrawsWatchedTable(attachedDatabase, alias);
  }
}

class DrawWatchedRow extends DataClass implements Insertable<DrawWatchedRow> {
  final int careerId;
  final int cycle;

  /// Which draw: 'worldCupFinals', or a confederation name for a continental.
  final String kind;
  const DrawWatchedRow({
    required this.careerId,
    required this.cycle,
    required this.kind,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['career_id'] = Variable<int>(careerId);
    map['cycle'] = Variable<int>(cycle);
    map['kind'] = Variable<String>(kind);
    return map;
  }

  DrawsWatchedCompanion toCompanion(bool nullToAbsent) {
    return DrawsWatchedCompanion(
      careerId: Value(careerId),
      cycle: Value(cycle),
      kind: Value(kind),
    );
  }

  factory DrawWatchedRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DrawWatchedRow(
      careerId: serializer.fromJson<int>(json['careerId']),
      cycle: serializer.fromJson<int>(json['cycle']),
      kind: serializer.fromJson<String>(json['kind']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'careerId': serializer.toJson<int>(careerId),
      'cycle': serializer.toJson<int>(cycle),
      'kind': serializer.toJson<String>(kind),
    };
  }

  DrawWatchedRow copyWith({int? careerId, int? cycle, String? kind}) =>
      DrawWatchedRow(
        careerId: careerId ?? this.careerId,
        cycle: cycle ?? this.cycle,
        kind: kind ?? this.kind,
      );
  DrawWatchedRow copyWithCompanion(DrawsWatchedCompanion data) {
    return DrawWatchedRow(
      careerId: data.careerId.present ? data.careerId.value : this.careerId,
      cycle: data.cycle.present ? data.cycle.value : this.cycle,
      kind: data.kind.present ? data.kind.value : this.kind,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DrawWatchedRow(')
          ..write('careerId: $careerId, ')
          ..write('cycle: $cycle, ')
          ..write('kind: $kind')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(careerId, cycle, kind);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DrawWatchedRow &&
          other.careerId == this.careerId &&
          other.cycle == this.cycle &&
          other.kind == this.kind);
}

class DrawsWatchedCompanion extends UpdateCompanion<DrawWatchedRow> {
  final Value<int> careerId;
  final Value<int> cycle;
  final Value<String> kind;
  final Value<int> rowid;
  const DrawsWatchedCompanion({
    this.careerId = const Value.absent(),
    this.cycle = const Value.absent(),
    this.kind = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DrawsWatchedCompanion.insert({
    required int careerId,
    required int cycle,
    required String kind,
    this.rowid = const Value.absent(),
  }) : careerId = Value(careerId),
       cycle = Value(cycle),
       kind = Value(kind);
  static Insertable<DrawWatchedRow> custom({
    Expression<int>? careerId,
    Expression<int>? cycle,
    Expression<String>? kind,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (careerId != null) 'career_id': careerId,
      if (cycle != null) 'cycle': cycle,
      if (kind != null) 'kind': kind,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DrawsWatchedCompanion copyWith({
    Value<int>? careerId,
    Value<int>? cycle,
    Value<String>? kind,
    Value<int>? rowid,
  }) {
    return DrawsWatchedCompanion(
      careerId: careerId ?? this.careerId,
      cycle: cycle ?? this.cycle,
      kind: kind ?? this.kind,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (careerId.present) {
      map['career_id'] = Variable<int>(careerId.value);
    }
    if (cycle.present) {
      map['cycle'] = Variable<int>(cycle.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DrawsWatchedCompanion(')
          ..write('careerId: $careerId, ')
          ..write('cycle: $cycle, ')
          ..write('kind: $kind, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlayerAbsencesTable extends PlayerAbsences
    with TableInfo<$PlayerAbsencesTable, PlayerAbsenceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayerAbsencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _careerIdMeta = const VerificationMeta(
    'careerId',
  );
  @override
  late final GeneratedColumn<int> careerId = GeneratedColumn<int>(
    'career_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES careers (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _playerIdMeta = const VerificationMeta(
    'playerId',
  );
  @override
  late final GeneratedColumn<int> playerId = GeneratedColumn<int>(
    'player_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yellowsMeta = const VerificationMeta(
    'yellows',
  );
  @override
  late final GeneratedColumn<int> yellows = GeneratedColumn<int>(
    'yellows',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _banMatchesMeta = const VerificationMeta(
    'banMatches',
  );
  @override
  late final GeneratedColumn<int> banMatches = GeneratedColumn<int>(
    'ban_matches',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _injuryMatchesMeta = const VerificationMeta(
    'injuryMatches',
  );
  @override
  late final GeneratedColumn<int> injuryMatches = GeneratedColumn<int>(
    'injury_matches',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    careerId,
    playerId,
    yellows,
    banMatches,
    injuryMatches,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'player_absences';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlayerAbsenceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('career_id')) {
      context.handle(
        _careerIdMeta,
        careerId.isAcceptableOrUnknown(data['career_id']!, _careerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_careerIdMeta);
    }
    if (data.containsKey('player_id')) {
      context.handle(
        _playerIdMeta,
        playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playerIdMeta);
    }
    if (data.containsKey('yellows')) {
      context.handle(
        _yellowsMeta,
        yellows.isAcceptableOrUnknown(data['yellows']!, _yellowsMeta),
      );
    }
    if (data.containsKey('ban_matches')) {
      context.handle(
        _banMatchesMeta,
        banMatches.isAcceptableOrUnknown(data['ban_matches']!, _banMatchesMeta),
      );
    }
    if (data.containsKey('injury_matches')) {
      context.handle(
        _injuryMatchesMeta,
        injuryMatches.isAcceptableOrUnknown(
          data['injury_matches']!,
          _injuryMatchesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {careerId, playerId};
  @override
  PlayerAbsenceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayerAbsenceRow(
      careerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}career_id'],
      )!,
      playerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}player_id'],
      )!,
      yellows: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}yellows'],
      )!,
      banMatches: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ban_matches'],
      )!,
      injuryMatches: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}injury_matches'],
      )!,
    );
  }

  @override
  $PlayerAbsencesTable createAlias(String alias) {
    return $PlayerAbsencesTable(attachedDatabase, alias);
  }
}

class PlayerAbsenceRow extends DataClass
    implements Insertable<PlayerAbsenceRow> {
  final int careerId;
  final int playerId;

  /// Yellow cards accumulated toward the next suspension.
  final int yellows;

  /// Matches still to be served on a suspension.
  final int banMatches;

  /// Matches the player is still sidelined by injury.
  final int injuryMatches;
  const PlayerAbsenceRow({
    required this.careerId,
    required this.playerId,
    required this.yellows,
    required this.banMatches,
    required this.injuryMatches,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['career_id'] = Variable<int>(careerId);
    map['player_id'] = Variable<int>(playerId);
    map['yellows'] = Variable<int>(yellows);
    map['ban_matches'] = Variable<int>(banMatches);
    map['injury_matches'] = Variable<int>(injuryMatches);
    return map;
  }

  PlayerAbsencesCompanion toCompanion(bool nullToAbsent) {
    return PlayerAbsencesCompanion(
      careerId: Value(careerId),
      playerId: Value(playerId),
      yellows: Value(yellows),
      banMatches: Value(banMatches),
      injuryMatches: Value(injuryMatches),
    );
  }

  factory PlayerAbsenceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayerAbsenceRow(
      careerId: serializer.fromJson<int>(json['careerId']),
      playerId: serializer.fromJson<int>(json['playerId']),
      yellows: serializer.fromJson<int>(json['yellows']),
      banMatches: serializer.fromJson<int>(json['banMatches']),
      injuryMatches: serializer.fromJson<int>(json['injuryMatches']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'careerId': serializer.toJson<int>(careerId),
      'playerId': serializer.toJson<int>(playerId),
      'yellows': serializer.toJson<int>(yellows),
      'banMatches': serializer.toJson<int>(banMatches),
      'injuryMatches': serializer.toJson<int>(injuryMatches),
    };
  }

  PlayerAbsenceRow copyWith({
    int? careerId,
    int? playerId,
    int? yellows,
    int? banMatches,
    int? injuryMatches,
  }) => PlayerAbsenceRow(
    careerId: careerId ?? this.careerId,
    playerId: playerId ?? this.playerId,
    yellows: yellows ?? this.yellows,
    banMatches: banMatches ?? this.banMatches,
    injuryMatches: injuryMatches ?? this.injuryMatches,
  );
  PlayerAbsenceRow copyWithCompanion(PlayerAbsencesCompanion data) {
    return PlayerAbsenceRow(
      careerId: data.careerId.present ? data.careerId.value : this.careerId,
      playerId: data.playerId.present ? data.playerId.value : this.playerId,
      yellows: data.yellows.present ? data.yellows.value : this.yellows,
      banMatches: data.banMatches.present
          ? data.banMatches.value
          : this.banMatches,
      injuryMatches: data.injuryMatches.present
          ? data.injuryMatches.value
          : this.injuryMatches,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayerAbsenceRow(')
          ..write('careerId: $careerId, ')
          ..write('playerId: $playerId, ')
          ..write('yellows: $yellows, ')
          ..write('banMatches: $banMatches, ')
          ..write('injuryMatches: $injuryMatches')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(careerId, playerId, yellows, banMatches, injuryMatches);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayerAbsenceRow &&
          other.careerId == this.careerId &&
          other.playerId == this.playerId &&
          other.yellows == this.yellows &&
          other.banMatches == this.banMatches &&
          other.injuryMatches == this.injuryMatches);
}

class PlayerAbsencesCompanion extends UpdateCompanion<PlayerAbsenceRow> {
  final Value<int> careerId;
  final Value<int> playerId;
  final Value<int> yellows;
  final Value<int> banMatches;
  final Value<int> injuryMatches;
  final Value<int> rowid;
  const PlayerAbsencesCompanion({
    this.careerId = const Value.absent(),
    this.playerId = const Value.absent(),
    this.yellows = const Value.absent(),
    this.banMatches = const Value.absent(),
    this.injuryMatches = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlayerAbsencesCompanion.insert({
    required int careerId,
    required int playerId,
    this.yellows = const Value.absent(),
    this.banMatches = const Value.absent(),
    this.injuryMatches = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : careerId = Value(careerId),
       playerId = Value(playerId);
  static Insertable<PlayerAbsenceRow> custom({
    Expression<int>? careerId,
    Expression<int>? playerId,
    Expression<int>? yellows,
    Expression<int>? banMatches,
    Expression<int>? injuryMatches,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (careerId != null) 'career_id': careerId,
      if (playerId != null) 'player_id': playerId,
      if (yellows != null) 'yellows': yellows,
      if (banMatches != null) 'ban_matches': banMatches,
      if (injuryMatches != null) 'injury_matches': injuryMatches,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlayerAbsencesCompanion copyWith({
    Value<int>? careerId,
    Value<int>? playerId,
    Value<int>? yellows,
    Value<int>? banMatches,
    Value<int>? injuryMatches,
    Value<int>? rowid,
  }) {
    return PlayerAbsencesCompanion(
      careerId: careerId ?? this.careerId,
      playerId: playerId ?? this.playerId,
      yellows: yellows ?? this.yellows,
      banMatches: banMatches ?? this.banMatches,
      injuryMatches: injuryMatches ?? this.injuryMatches,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (careerId.present) {
      map['career_id'] = Variable<int>(careerId.value);
    }
    if (playerId.present) {
      map['player_id'] = Variable<int>(playerId.value);
    }
    if (yellows.present) {
      map['yellows'] = Variable<int>(yellows.value);
    }
    if (banMatches.present) {
      map['ban_matches'] = Variable<int>(banMatches.value);
    }
    if (injuryMatches.present) {
      map['injury_matches'] = Variable<int>(injuryMatches.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayerAbsencesCompanion(')
          ..write('careerId: $careerId, ')
          ..write('playerId: $playerId, ')
          ..write('yellows: $yellows, ')
          ..write('banMatches: $banMatches, ')
          ..write('injuryMatches: $injuryMatches, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RankPointsTable extends RankPoints
    with TableInfo<$RankPointsTable, RankPointRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RankPointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _careerIdMeta = const VerificationMeta(
    'careerId',
  );
  @override
  late final GeneratedColumn<int> careerId = GeneratedColumn<int>(
    'career_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES careers (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nationIdMeta = const VerificationMeta(
    'nationId',
  );
  @override
  late final GeneratedColumn<int> nationId = GeneratedColumn<int>(
    'nation_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<int> points = GeneratedColumn<int>(
    'points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [careerId, nationId, points];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rank_points';
  @override
  VerificationContext validateIntegrity(
    Insertable<RankPointRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('career_id')) {
      context.handle(
        _careerIdMeta,
        careerId.isAcceptableOrUnknown(data['career_id']!, _careerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_careerIdMeta);
    }
    if (data.containsKey('nation_id')) {
      context.handle(
        _nationIdMeta,
        nationId.isAcceptableOrUnknown(data['nation_id']!, _nationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nationIdMeta);
    }
    if (data.containsKey('points')) {
      context.handle(
        _pointsMeta,
        points.isAcceptableOrUnknown(data['points']!, _pointsMeta),
      );
    } else if (isInserting) {
      context.missing(_pointsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {careerId, nationId};
  @override
  RankPointRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RankPointRow(
      careerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}career_id'],
      )!,
      nationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nation_id'],
      )!,
      points: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points'],
      )!,
    );
  }

  @override
  $RankPointsTable createAlias(String alias) {
    return $RankPointsTable(attachedDatabase, alias);
  }
}

class RankPointRow extends DataClass implements Insertable<RankPointRow> {
  final int careerId;
  final int nationId;
  final int points;
  const RankPointRow({
    required this.careerId,
    required this.nationId,
    required this.points,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['career_id'] = Variable<int>(careerId);
    map['nation_id'] = Variable<int>(nationId);
    map['points'] = Variable<int>(points);
    return map;
  }

  RankPointsCompanion toCompanion(bool nullToAbsent) {
    return RankPointsCompanion(
      careerId: Value(careerId),
      nationId: Value(nationId),
      points: Value(points),
    );
  }

  factory RankPointRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RankPointRow(
      careerId: serializer.fromJson<int>(json['careerId']),
      nationId: serializer.fromJson<int>(json['nationId']),
      points: serializer.fromJson<int>(json['points']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'careerId': serializer.toJson<int>(careerId),
      'nationId': serializer.toJson<int>(nationId),
      'points': serializer.toJson<int>(points),
    };
  }

  RankPointRow copyWith({int? careerId, int? nationId, int? points}) =>
      RankPointRow(
        careerId: careerId ?? this.careerId,
        nationId: nationId ?? this.nationId,
        points: points ?? this.points,
      );
  RankPointRow copyWithCompanion(RankPointsCompanion data) {
    return RankPointRow(
      careerId: data.careerId.present ? data.careerId.value : this.careerId,
      nationId: data.nationId.present ? data.nationId.value : this.nationId,
      points: data.points.present ? data.points.value : this.points,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RankPointRow(')
          ..write('careerId: $careerId, ')
          ..write('nationId: $nationId, ')
          ..write('points: $points')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(careerId, nationId, points);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RankPointRow &&
          other.careerId == this.careerId &&
          other.nationId == this.nationId &&
          other.points == this.points);
}

class RankPointsCompanion extends UpdateCompanion<RankPointRow> {
  final Value<int> careerId;
  final Value<int> nationId;
  final Value<int> points;
  final Value<int> rowid;
  const RankPointsCompanion({
    this.careerId = const Value.absent(),
    this.nationId = const Value.absent(),
    this.points = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RankPointsCompanion.insert({
    required int careerId,
    required int nationId,
    required int points,
    this.rowid = const Value.absent(),
  }) : careerId = Value(careerId),
       nationId = Value(nationId),
       points = Value(points);
  static Insertable<RankPointRow> custom({
    Expression<int>? careerId,
    Expression<int>? nationId,
    Expression<int>? points,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (careerId != null) 'career_id': careerId,
      if (nationId != null) 'nation_id': nationId,
      if (points != null) 'points': points,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RankPointsCompanion copyWith({
    Value<int>? careerId,
    Value<int>? nationId,
    Value<int>? points,
    Value<int>? rowid,
  }) {
    return RankPointsCompanion(
      careerId: careerId ?? this.careerId,
      nationId: nationId ?? this.nationId,
      points: points ?? this.points,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (careerId.present) {
      map['career_id'] = Variable<int>(careerId.value);
    }
    if (nationId.present) {
      map['nation_id'] = Variable<int>(nationId.value);
    }
    if (points.present) {
      map['points'] = Variable<int>(points.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RankPointsCompanion(')
          ..write('careerId: $careerId, ')
          ..write('nationId: $nationId, ')
          ..write('points: $points, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SeedRankingsTable extends SeedRankings
    with TableInfo<$SeedRankingsTable, SeedRankingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SeedRankingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _careerIdMeta = const VerificationMeta(
    'careerId',
  );
  @override
  late final GeneratedColumn<int> careerId = GeneratedColumn<int>(
    'career_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES careers (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _cycleMeta = const VerificationMeta('cycle');
  @override
  late final GeneratedColumn<int> cycle = GeneratedColumn<int>(
    'cycle',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nationIdMeta = const VerificationMeta(
    'nationId',
  );
  @override
  late final GeneratedColumn<int> nationId = GeneratedColumn<int>(
    'nation_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rankMeta = const VerificationMeta('rank');
  @override
  late final GeneratedColumn<int> rank = GeneratedColumn<int>(
    'rank',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [careerId, cycle, nationId, rank];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'seed_rankings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SeedRankingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('career_id')) {
      context.handle(
        _careerIdMeta,
        careerId.isAcceptableOrUnknown(data['career_id']!, _careerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_careerIdMeta);
    }
    if (data.containsKey('cycle')) {
      context.handle(
        _cycleMeta,
        cycle.isAcceptableOrUnknown(data['cycle']!, _cycleMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleMeta);
    }
    if (data.containsKey('nation_id')) {
      context.handle(
        _nationIdMeta,
        nationId.isAcceptableOrUnknown(data['nation_id']!, _nationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nationIdMeta);
    }
    if (data.containsKey('rank')) {
      context.handle(
        _rankMeta,
        rank.isAcceptableOrUnknown(data['rank']!, _rankMeta),
      );
    } else if (isInserting) {
      context.missing(_rankMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {careerId, cycle, nationId};
  @override
  SeedRankingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SeedRankingRow(
      careerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}career_id'],
      )!,
      cycle: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle'],
      )!,
      nationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nation_id'],
      )!,
      rank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rank'],
      )!,
    );
  }

  @override
  $SeedRankingsTable createAlias(String alias) {
    return $SeedRankingsTable(attachedDatabase, alias);
  }
}

class SeedRankingRow extends DataClass implements Insertable<SeedRankingRow> {
  final int careerId;
  final int cycle;
  final int nationId;

  /// The nation's world position (1 = top) at the cycle's start.
  final int rank;
  const SeedRankingRow({
    required this.careerId,
    required this.cycle,
    required this.nationId,
    required this.rank,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['career_id'] = Variable<int>(careerId);
    map['cycle'] = Variable<int>(cycle);
    map['nation_id'] = Variable<int>(nationId);
    map['rank'] = Variable<int>(rank);
    return map;
  }

  SeedRankingsCompanion toCompanion(bool nullToAbsent) {
    return SeedRankingsCompanion(
      careerId: Value(careerId),
      cycle: Value(cycle),
      nationId: Value(nationId),
      rank: Value(rank),
    );
  }

  factory SeedRankingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SeedRankingRow(
      careerId: serializer.fromJson<int>(json['careerId']),
      cycle: serializer.fromJson<int>(json['cycle']),
      nationId: serializer.fromJson<int>(json['nationId']),
      rank: serializer.fromJson<int>(json['rank']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'careerId': serializer.toJson<int>(careerId),
      'cycle': serializer.toJson<int>(cycle),
      'nationId': serializer.toJson<int>(nationId),
      'rank': serializer.toJson<int>(rank),
    };
  }

  SeedRankingRow copyWith({
    int? careerId,
    int? cycle,
    int? nationId,
    int? rank,
  }) => SeedRankingRow(
    careerId: careerId ?? this.careerId,
    cycle: cycle ?? this.cycle,
    nationId: nationId ?? this.nationId,
    rank: rank ?? this.rank,
  );
  SeedRankingRow copyWithCompanion(SeedRankingsCompanion data) {
    return SeedRankingRow(
      careerId: data.careerId.present ? data.careerId.value : this.careerId,
      cycle: data.cycle.present ? data.cycle.value : this.cycle,
      nationId: data.nationId.present ? data.nationId.value : this.nationId,
      rank: data.rank.present ? data.rank.value : this.rank,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SeedRankingRow(')
          ..write('careerId: $careerId, ')
          ..write('cycle: $cycle, ')
          ..write('nationId: $nationId, ')
          ..write('rank: $rank')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(careerId, cycle, nationId, rank);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SeedRankingRow &&
          other.careerId == this.careerId &&
          other.cycle == this.cycle &&
          other.nationId == this.nationId &&
          other.rank == this.rank);
}

class SeedRankingsCompanion extends UpdateCompanion<SeedRankingRow> {
  final Value<int> careerId;
  final Value<int> cycle;
  final Value<int> nationId;
  final Value<int> rank;
  final Value<int> rowid;
  const SeedRankingsCompanion({
    this.careerId = const Value.absent(),
    this.cycle = const Value.absent(),
    this.nationId = const Value.absent(),
    this.rank = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SeedRankingsCompanion.insert({
    required int careerId,
    required int cycle,
    required int nationId,
    required int rank,
    this.rowid = const Value.absent(),
  }) : careerId = Value(careerId),
       cycle = Value(cycle),
       nationId = Value(nationId),
       rank = Value(rank);
  static Insertable<SeedRankingRow> custom({
    Expression<int>? careerId,
    Expression<int>? cycle,
    Expression<int>? nationId,
    Expression<int>? rank,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (careerId != null) 'career_id': careerId,
      if (cycle != null) 'cycle': cycle,
      if (nationId != null) 'nation_id': nationId,
      if (rank != null) 'rank': rank,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SeedRankingsCompanion copyWith({
    Value<int>? careerId,
    Value<int>? cycle,
    Value<int>? nationId,
    Value<int>? rank,
    Value<int>? rowid,
  }) {
    return SeedRankingsCompanion(
      careerId: careerId ?? this.careerId,
      cycle: cycle ?? this.cycle,
      nationId: nationId ?? this.nationId,
      rank: rank ?? this.rank,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (careerId.present) {
      map['career_id'] = Variable<int>(careerId.value);
    }
    if (cycle.present) {
      map['cycle'] = Variable<int>(cycle.value);
    }
    if (nationId.present) {
      map['nation_id'] = Variable<int>(nationId.value);
    }
    if (rank.present) {
      map['rank'] = Variable<int>(rank.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SeedRankingsCompanion(')
          ..write('careerId: $careerId, ')
          ..write('cycle: $cycle, ')
          ..write('nationId: $nationId, ')
          ..write('rank: $rank, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NationsTable nations = $NationsTable(this);
  late final $PlayersTable players = $PlayersTable(this);
  late final $CareersTable careers = $CareersTable(this);
  late final $CompetitionsTable competitions = $CompetitionsTable(this);
  late final $QualifyingGroupsTable qualifyingGroups = $QualifyingGroupsTable(
    this,
  );
  late final $GroupMembersTable groupMembers = $GroupMembersTable(this);
  late final $FixturesTable fixtures = $FixturesTable(this);
  late final $TacticsTable tactics = $TacticsTable(this);
  late final $LineupSlotsTable lineupSlots = $LineupSlotsTable(this);
  late final $CallUpsTable callUps = $CallUpsTable(this);
  late final $GoalEventsTable goalEvents = $GoalEventsTable(this);
  late final $HonoursTable honours = $HonoursTable(this);
  late final $DrawsWatchedTable drawsWatched = $DrawsWatchedTable(this);
  late final $PlayerAbsencesTable playerAbsences = $PlayerAbsencesTable(this);
  late final $RankPointsTable rankPoints = $RankPointsTable(this);
  late final $SeedRankingsTable seedRankings = $SeedRankingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    nations,
    players,
    careers,
    competitions,
    qualifyingGroups,
    groupMembers,
    fixtures,
    tactics,
    lineupSlots,
    callUps,
    goalEvents,
    honours,
    drawsWatched,
    playerAbsences,
    rankPoints,
    seedRankings,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'nations',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('players', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'careers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('competitions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'competitions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('qualifying_groups', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'qualifying_groups',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('group_members', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'careers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('fixtures', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'careers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('tactics', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'careers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('lineup_slots', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'careers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('call_ups', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'careers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('goal_events', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'careers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('honours', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'careers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('draws_watched', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'careers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('player_absences', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'careers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('rank_points', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'careers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('seed_rankings', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$NationsTableCreateCompanionBuilder =
    NationsCompanion Function({
      Value<int> id,
      required String name,
      required String code,
      required Confederation confederation,
      Value<int> ranking,
      Value<bool> isFreeDemo,
    });
typedef $$NationsTableUpdateCompanionBuilder =
    NationsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> code,
      Value<Confederation> confederation,
      Value<int> ranking,
      Value<bool> isFreeDemo,
    });

final class $$NationsTableReferences
    extends BaseReferences<_$AppDatabase, $NationsTable, NationRow> {
  $$NationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlayersTable, List<PlayerRow>> _playersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.players,
    aliasName: 'nations__id__players__nation_id',
  );

  $$PlayersTableProcessedTableManager get playersRefs {
    final manager = $$PlayersTableTableManager(
      $_db,
      $_db.players,
    ).filter((f) => f.nationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_playersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CareersTable, List<CareerRow>> _careersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.careers,
    aliasName: 'nations__id__careers__nation_id',
  );

  $$CareersTableProcessedTableManager get careersRefs {
    final manager = $$CareersTableTableManager(
      $_db,
      $_db.careers,
    ).filter((f) => f.nationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_careersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$NationsTableFilterComposer
    extends Composer<_$AppDatabase, $NationsTable> {
  $$NationsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Confederation, Confederation, String>
  get confederation => $composableBuilder(
    column: $table.confederation,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get ranking => $composableBuilder(
    column: $table.ranking,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFreeDemo => $composableBuilder(
    column: $table.isFreeDemo,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> playersRefs(
    Expression<bool> Function($$PlayersTableFilterComposer f) f,
  ) {
    final $$PlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.nationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableFilterComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> careersRefs(
    Expression<bool> Function($$CareersTableFilterComposer f) f,
  ) {
    final $$CareersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.nationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableFilterComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NationsTableOrderingComposer
    extends Composer<_$AppDatabase, $NationsTable> {
  $$NationsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confederation => $composableBuilder(
    column: $table.confederation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ranking => $composableBuilder(
    column: $table.ranking,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFreeDemo => $composableBuilder(
    column: $table.isFreeDemo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NationsTable> {
  $$NationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Confederation, String> get confederation =>
      $composableBuilder(
        column: $table.confederation,
        builder: (column) => column,
      );

  GeneratedColumn<int> get ranking =>
      $composableBuilder(column: $table.ranking, builder: (column) => column);

  GeneratedColumn<bool> get isFreeDemo => $composableBuilder(
    column: $table.isFreeDemo,
    builder: (column) => column,
  );

  Expression<T> playersRefs<T extends Object>(
    Expression<T> Function($$PlayersTableAnnotationComposer a) f,
  ) {
    final $$PlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.nationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> careersRefs<T extends Object>(
    Expression<T> Function($$CareersTableAnnotationComposer a) f,
  ) {
    final $$CareersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.nationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableAnnotationComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NationsTable,
          NationRow,
          $$NationsTableFilterComposer,
          $$NationsTableOrderingComposer,
          $$NationsTableAnnotationComposer,
          $$NationsTableCreateCompanionBuilder,
          $$NationsTableUpdateCompanionBuilder,
          (NationRow, $$NationsTableReferences),
          NationRow,
          PrefetchHooks Function({bool playersRefs, bool careersRefs})
        > {
  $$NationsTableTableManager(_$AppDatabase db, $NationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<Confederation> confederation = const Value.absent(),
                Value<int> ranking = const Value.absent(),
                Value<bool> isFreeDemo = const Value.absent(),
              }) => NationsCompanion(
                id: id,
                name: name,
                code: code,
                confederation: confederation,
                ranking: ranking,
                isFreeDemo: isFreeDemo,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String code,
                required Confederation confederation,
                Value<int> ranking = const Value.absent(),
                Value<bool> isFreeDemo = const Value.absent(),
              }) => NationsCompanion.insert(
                id: id,
                name: name,
                code: code,
                confederation: confederation,
                ranking: ranking,
                isFreeDemo: isFreeDemo,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$NationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({playersRefs = false, careersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (playersRefs) db.players,
                if (careersRefs) db.careers,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (playersRefs)
                    await $_getPrefetchedData<
                      NationRow,
                      $NationsTable,
                      PlayerRow
                    >(
                      currentTable: table,
                      referencedTable: $$NationsTableReferences
                          ._playersRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$NationsTableReferences(db, table, p0).playersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.nationId == item.id),
                      typedResults: items,
                    ),
                  if (careersRefs)
                    await $_getPrefetchedData<
                      NationRow,
                      $NationsTable,
                      CareerRow
                    >(
                      currentTable: table,
                      referencedTable: $$NationsTableReferences
                          ._careersRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$NationsTableReferences(db, table, p0).careersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.nationId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$NationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NationsTable,
      NationRow,
      $$NationsTableFilterComposer,
      $$NationsTableOrderingComposer,
      $$NationsTableAnnotationComposer,
      $$NationsTableCreateCompanionBuilder,
      $$NationsTableUpdateCompanionBuilder,
      (NationRow, $$NationsTableReferences),
      NationRow,
      PrefetchHooks Function({bool playersRefs, bool careersRefs})
    >;
typedef $$PlayersTableCreateCompanionBuilder =
    PlayersCompanion Function({
      Value<int> id,
      required int nationId,
      required String name,
      required int age,
      required PlayerPosition position,
      required int passing,
      required int shooting,
      required int dribbling,
      required int tackling,
      required int positioning,
      required int composure,
      required int decisions,
      required int pace,
      required int stamina,
      required int strength,
      Value<String> club,
    });
typedef $$PlayersTableUpdateCompanionBuilder =
    PlayersCompanion Function({
      Value<int> id,
      Value<int> nationId,
      Value<String> name,
      Value<int> age,
      Value<PlayerPosition> position,
      Value<int> passing,
      Value<int> shooting,
      Value<int> dribbling,
      Value<int> tackling,
      Value<int> positioning,
      Value<int> composure,
      Value<int> decisions,
      Value<int> pace,
      Value<int> stamina,
      Value<int> strength,
      Value<String> club,
    });

final class $$PlayersTableReferences
    extends BaseReferences<_$AppDatabase, $PlayersTable, PlayerRow> {
  $$PlayersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NationsTable _nationIdTable(_$AppDatabase db) =>
      db.nations.createAlias('players__nation_id__nations__id');

  $$NationsTableProcessedTableManager get nationId {
    final $_column = $_itemColumn<int>('nation_id')!;

    final manager = $$NationsTableTableManager(
      $_db,
      $_db.nations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_nationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlayersTableFilterComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PlayerPosition, PlayerPosition, String>
  get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get passing => $composableBuilder(
    column: $table.passing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shooting => $composableBuilder(
    column: $table.shooting,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dribbling => $composableBuilder(
    column: $table.dribbling,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tackling => $composableBuilder(
    column: $table.tackling,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get positioning => $composableBuilder(
    column: $table.positioning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get composure => $composableBuilder(
    column: $table.composure,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get decisions => $composableBuilder(
    column: $table.decisions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pace => $composableBuilder(
    column: $table.pace,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stamina => $composableBuilder(
    column: $table.stamina,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get club => $composableBuilder(
    column: $table.club,
    builder: (column) => ColumnFilters(column),
  );

  $$NationsTableFilterComposer get nationId {
    final $$NationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nationId,
      referencedTable: $db.nations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NationsTableFilterComposer(
            $db: $db,
            $table: $db.nations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayersTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get passing => $composableBuilder(
    column: $table.passing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shooting => $composableBuilder(
    column: $table.shooting,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dribbling => $composableBuilder(
    column: $table.dribbling,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tackling => $composableBuilder(
    column: $table.tackling,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get positioning => $composableBuilder(
    column: $table.positioning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get composure => $composableBuilder(
    column: $table.composure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get decisions => $composableBuilder(
    column: $table.decisions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pace => $composableBuilder(
    column: $table.pace,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stamina => $composableBuilder(
    column: $table.stamina,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get club => $composableBuilder(
    column: $table.club,
    builder: (column) => ColumnOrderings(column),
  );

  $$NationsTableOrderingComposer get nationId {
    final $$NationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nationId,
      referencedTable: $db.nations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NationsTableOrderingComposer(
            $db: $db,
            $table: $db.nations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PlayerPosition, String> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get passing =>
      $composableBuilder(column: $table.passing, builder: (column) => column);

  GeneratedColumn<int> get shooting =>
      $composableBuilder(column: $table.shooting, builder: (column) => column);

  GeneratedColumn<int> get dribbling =>
      $composableBuilder(column: $table.dribbling, builder: (column) => column);

  GeneratedColumn<int> get tackling =>
      $composableBuilder(column: $table.tackling, builder: (column) => column);

  GeneratedColumn<int> get positioning => $composableBuilder(
    column: $table.positioning,
    builder: (column) => column,
  );

  GeneratedColumn<int> get composure =>
      $composableBuilder(column: $table.composure, builder: (column) => column);

  GeneratedColumn<int> get decisions =>
      $composableBuilder(column: $table.decisions, builder: (column) => column);

  GeneratedColumn<int> get pace =>
      $composableBuilder(column: $table.pace, builder: (column) => column);

  GeneratedColumn<int> get stamina =>
      $composableBuilder(column: $table.stamina, builder: (column) => column);

  GeneratedColumn<int> get strength =>
      $composableBuilder(column: $table.strength, builder: (column) => column);

  GeneratedColumn<String> get club =>
      $composableBuilder(column: $table.club, builder: (column) => column);

  $$NationsTableAnnotationComposer get nationId {
    final $$NationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nationId,
      referencedTable: $db.nations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NationsTableAnnotationComposer(
            $db: $db,
            $table: $db.nations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayersTable,
          PlayerRow,
          $$PlayersTableFilterComposer,
          $$PlayersTableOrderingComposer,
          $$PlayersTableAnnotationComposer,
          $$PlayersTableCreateCompanionBuilder,
          $$PlayersTableUpdateCompanionBuilder,
          (PlayerRow, $$PlayersTableReferences),
          PlayerRow,
          PrefetchHooks Function({bool nationId})
        > {
  $$PlayersTableTableManager(_$AppDatabase db, $PlayersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> nationId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> age = const Value.absent(),
                Value<PlayerPosition> position = const Value.absent(),
                Value<int> passing = const Value.absent(),
                Value<int> shooting = const Value.absent(),
                Value<int> dribbling = const Value.absent(),
                Value<int> tackling = const Value.absent(),
                Value<int> positioning = const Value.absent(),
                Value<int> composure = const Value.absent(),
                Value<int> decisions = const Value.absent(),
                Value<int> pace = const Value.absent(),
                Value<int> stamina = const Value.absent(),
                Value<int> strength = const Value.absent(),
                Value<String> club = const Value.absent(),
              }) => PlayersCompanion(
                id: id,
                nationId: nationId,
                name: name,
                age: age,
                position: position,
                passing: passing,
                shooting: shooting,
                dribbling: dribbling,
                tackling: tackling,
                positioning: positioning,
                composure: composure,
                decisions: decisions,
                pace: pace,
                stamina: stamina,
                strength: strength,
                club: club,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int nationId,
                required String name,
                required int age,
                required PlayerPosition position,
                required int passing,
                required int shooting,
                required int dribbling,
                required int tackling,
                required int positioning,
                required int composure,
                required int decisions,
                required int pace,
                required int stamina,
                required int strength,
                Value<String> club = const Value.absent(),
              }) => PlayersCompanion.insert(
                id: id,
                nationId: nationId,
                name: name,
                age: age,
                position: position,
                passing: passing,
                shooting: shooting,
                dribbling: dribbling,
                tackling: tackling,
                positioning: positioning,
                composure: composure,
                decisions: decisions,
                pace: pace,
                stamina: stamina,
                strength: strength,
                club: club,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlayersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({nationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (nationId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.nationId,
                                referencedTable: $$PlayersTableReferences
                                    ._nationIdTable(db),
                                referencedColumn: $$PlayersTableReferences
                                    ._nationIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlayersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayersTable,
      PlayerRow,
      $$PlayersTableFilterComposer,
      $$PlayersTableOrderingComposer,
      $$PlayersTableAnnotationComposer,
      $$PlayersTableCreateCompanionBuilder,
      $$PlayersTableUpdateCompanionBuilder,
      (PlayerRow, $$PlayersTableReferences),
      PlayerRow,
      PrefetchHooks Function({bool nationId})
    >;
typedef $$CareersTableCreateCompanionBuilder =
    CareersCompanion Function({
      Value<int> id,
      required String managerName,
      required int nationId,
      required int rngSeed,
      required DateTime createdAt,
      required DateTime inGameDate,
      Value<int> cyclePointer,
    });
typedef $$CareersTableUpdateCompanionBuilder =
    CareersCompanion Function({
      Value<int> id,
      Value<String> managerName,
      Value<int> nationId,
      Value<int> rngSeed,
      Value<DateTime> createdAt,
      Value<DateTime> inGameDate,
      Value<int> cyclePointer,
    });

final class $$CareersTableReferences
    extends BaseReferences<_$AppDatabase, $CareersTable, CareerRow> {
  $$CareersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NationsTable _nationIdTable(_$AppDatabase db) =>
      db.nations.createAlias('careers__nation_id__nations__id');

  $$NationsTableProcessedTableManager get nationId {
    final $_column = $_itemColumn<int>('nation_id')!;

    final manager = $$NationsTableTableManager(
      $_db,
      $_db.nations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_nationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CompetitionsTable, List<CompetitionRow>>
  _competitionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.competitions,
    aliasName: 'careers__id__competitions__career_id',
  );

  $$CompetitionsTableProcessedTableManager get competitionsRefs {
    final manager = $$CompetitionsTableTableManager(
      $_db,
      $_db.competitions,
    ).filter((f) => f.careerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_competitionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FixturesTable, List<FixtureRow>>
  _fixturesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.fixtures,
    aliasName: 'careers__id__fixtures__career_id',
  );

  $$FixturesTableProcessedTableManager get fixturesRefs {
    final manager = $$FixturesTableTableManager(
      $_db,
      $_db.fixtures,
    ).filter((f) => f.careerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_fixturesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TacticsTable, List<TacticRow>> _tacticsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tactics,
    aliasName: 'careers__id__tactics__career_id',
  );

  $$TacticsTableProcessedTableManager get tacticsRefs {
    final manager = $$TacticsTableTableManager(
      $_db,
      $_db.tactics,
    ).filter((f) => f.careerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tacticsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LineupSlotsTable, List<LineupSlotRow>>
  _lineupSlotsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.lineupSlots,
    aliasName: 'careers__id__lineup_slots__career_id',
  );

  $$LineupSlotsTableProcessedTableManager get lineupSlotsRefs {
    final manager = $$LineupSlotsTableTableManager(
      $_db,
      $_db.lineupSlots,
    ).filter((f) => f.careerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_lineupSlotsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CallUpsTable, List<CallUpRow>> _callUpsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.callUps,
    aliasName: 'careers__id__call_ups__career_id',
  );

  $$CallUpsTableProcessedTableManager get callUpsRefs {
    final manager = $$CallUpsTableTableManager(
      $_db,
      $_db.callUps,
    ).filter((f) => f.careerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_callUpsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GoalEventsTable, List<GoalEventRow>>
  _goalEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.goalEvents,
    aliasName: 'careers__id__goal_events__career_id',
  );

  $$GoalEventsTableProcessedTableManager get goalEventsRefs {
    final manager = $$GoalEventsTableTableManager(
      $_db,
      $_db.goalEvents,
    ).filter((f) => f.careerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_goalEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$HonoursTable, List<HonourRow>> _honoursRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.honours,
    aliasName: 'careers__id__honours__career_id',
  );

  $$HonoursTableProcessedTableManager get honoursRefs {
    final manager = $$HonoursTableTableManager(
      $_db,
      $_db.honours,
    ).filter((f) => f.careerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_honoursRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DrawsWatchedTable, List<DrawWatchedRow>>
  _drawsWatchedRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.drawsWatched,
    aliasName: 'careers__id__draws_watched__career_id',
  );

  $$DrawsWatchedTableProcessedTableManager get drawsWatchedRefs {
    final manager = $$DrawsWatchedTableTableManager(
      $_db,
      $_db.drawsWatched,
    ).filter((f) => f.careerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_drawsWatchedRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PlayerAbsencesTable, List<PlayerAbsenceRow>>
  _playerAbsencesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.playerAbsences,
    aliasName: 'careers__id__player_absences__career_id',
  );

  $$PlayerAbsencesTableProcessedTableManager get playerAbsencesRefs {
    final manager = $$PlayerAbsencesTableTableManager(
      $_db,
      $_db.playerAbsences,
    ).filter((f) => f.careerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_playerAbsencesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RankPointsTable, List<RankPointRow>>
  _rankPointsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.rankPoints,
    aliasName: 'careers__id__rank_points__career_id',
  );

  $$RankPointsTableProcessedTableManager get rankPointsRefs {
    final manager = $$RankPointsTableTableManager(
      $_db,
      $_db.rankPoints,
    ).filter((f) => f.careerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_rankPointsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SeedRankingsTable, List<SeedRankingRow>>
  _seedRankingsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.seedRankings,
    aliasName: 'careers__id__seed_rankings__career_id',
  );

  $$SeedRankingsTableProcessedTableManager get seedRankingsRefs {
    final manager = $$SeedRankingsTableTableManager(
      $_db,
      $_db.seedRankings,
    ).filter((f) => f.careerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_seedRankingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CareersTableFilterComposer
    extends Composer<_$AppDatabase, $CareersTable> {
  $$CareersTableFilterComposer({
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

  ColumnFilters<String> get managerName => $composableBuilder(
    column: $table.managerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rngSeed => $composableBuilder(
    column: $table.rngSeed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get inGameDate => $composableBuilder(
    column: $table.inGameDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cyclePointer => $composableBuilder(
    column: $table.cyclePointer,
    builder: (column) => ColumnFilters(column),
  );

  $$NationsTableFilterComposer get nationId {
    final $$NationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nationId,
      referencedTable: $db.nations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NationsTableFilterComposer(
            $db: $db,
            $table: $db.nations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> competitionsRefs(
    Expression<bool> Function($$CompetitionsTableFilterComposer f) f,
  ) {
    final $$CompetitionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.competitions,
      getReferencedColumn: (t) => t.careerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompetitionsTableFilterComposer(
            $db: $db,
            $table: $db.competitions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> fixturesRefs(
    Expression<bool> Function($$FixturesTableFilterComposer f) f,
  ) {
    final $$FixturesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fixtures,
      getReferencedColumn: (t) => t.careerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FixturesTableFilterComposer(
            $db: $db,
            $table: $db.fixtures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tacticsRefs(
    Expression<bool> Function($$TacticsTableFilterComposer f) f,
  ) {
    final $$TacticsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tactics,
      getReferencedColumn: (t) => t.careerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TacticsTableFilterComposer(
            $db: $db,
            $table: $db.tactics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> lineupSlotsRefs(
    Expression<bool> Function($$LineupSlotsTableFilterComposer f) f,
  ) {
    final $$LineupSlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lineupSlots,
      getReferencedColumn: (t) => t.careerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LineupSlotsTableFilterComposer(
            $db: $db,
            $table: $db.lineupSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> callUpsRefs(
    Expression<bool> Function($$CallUpsTableFilterComposer f) f,
  ) {
    final $$CallUpsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.callUps,
      getReferencedColumn: (t) => t.careerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CallUpsTableFilterComposer(
            $db: $db,
            $table: $db.callUps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> goalEventsRefs(
    Expression<bool> Function($$GoalEventsTableFilterComposer f) f,
  ) {
    final $$GoalEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goalEvents,
      getReferencedColumn: (t) => t.careerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalEventsTableFilterComposer(
            $db: $db,
            $table: $db.goalEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> honoursRefs(
    Expression<bool> Function($$HonoursTableFilterComposer f) f,
  ) {
    final $$HonoursTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.honours,
      getReferencedColumn: (t) => t.careerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HonoursTableFilterComposer(
            $db: $db,
            $table: $db.honours,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> drawsWatchedRefs(
    Expression<bool> Function($$DrawsWatchedTableFilterComposer f) f,
  ) {
    final $$DrawsWatchedTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.drawsWatched,
      getReferencedColumn: (t) => t.careerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DrawsWatchedTableFilterComposer(
            $db: $db,
            $table: $db.drawsWatched,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> playerAbsencesRefs(
    Expression<bool> Function($$PlayerAbsencesTableFilterComposer f) f,
  ) {
    final $$PlayerAbsencesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playerAbsences,
      getReferencedColumn: (t) => t.careerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayerAbsencesTableFilterComposer(
            $db: $db,
            $table: $db.playerAbsences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> rankPointsRefs(
    Expression<bool> Function($$RankPointsTableFilterComposer f) f,
  ) {
    final $$RankPointsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rankPoints,
      getReferencedColumn: (t) => t.careerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RankPointsTableFilterComposer(
            $db: $db,
            $table: $db.rankPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> seedRankingsRefs(
    Expression<bool> Function($$SeedRankingsTableFilterComposer f) f,
  ) {
    final $$SeedRankingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.seedRankings,
      getReferencedColumn: (t) => t.careerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeedRankingsTableFilterComposer(
            $db: $db,
            $table: $db.seedRankings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CareersTableOrderingComposer
    extends Composer<_$AppDatabase, $CareersTable> {
  $$CareersTableOrderingComposer({
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

  ColumnOrderings<String> get managerName => $composableBuilder(
    column: $table.managerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rngSeed => $composableBuilder(
    column: $table.rngSeed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get inGameDate => $composableBuilder(
    column: $table.inGameDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cyclePointer => $composableBuilder(
    column: $table.cyclePointer,
    builder: (column) => ColumnOrderings(column),
  );

  $$NationsTableOrderingComposer get nationId {
    final $$NationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nationId,
      referencedTable: $db.nations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NationsTableOrderingComposer(
            $db: $db,
            $table: $db.nations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CareersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CareersTable> {
  $$CareersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get managerName => $composableBuilder(
    column: $table.managerName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rngSeed =>
      $composableBuilder(column: $table.rngSeed, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get inGameDate => $composableBuilder(
    column: $table.inGameDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cyclePointer => $composableBuilder(
    column: $table.cyclePointer,
    builder: (column) => column,
  );

  $$NationsTableAnnotationComposer get nationId {
    final $$NationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nationId,
      referencedTable: $db.nations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NationsTableAnnotationComposer(
            $db: $db,
            $table: $db.nations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> competitionsRefs<T extends Object>(
    Expression<T> Function($$CompetitionsTableAnnotationComposer a) f,
  ) {
    final $$CompetitionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.competitions,
      getReferencedColumn: (t) => t.careerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompetitionsTableAnnotationComposer(
            $db: $db,
            $table: $db.competitions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> fixturesRefs<T extends Object>(
    Expression<T> Function($$FixturesTableAnnotationComposer a) f,
  ) {
    final $$FixturesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fixtures,
      getReferencedColumn: (t) => t.careerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FixturesTableAnnotationComposer(
            $db: $db,
            $table: $db.fixtures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tacticsRefs<T extends Object>(
    Expression<T> Function($$TacticsTableAnnotationComposer a) f,
  ) {
    final $$TacticsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tactics,
      getReferencedColumn: (t) => t.careerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TacticsTableAnnotationComposer(
            $db: $db,
            $table: $db.tactics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> lineupSlotsRefs<T extends Object>(
    Expression<T> Function($$LineupSlotsTableAnnotationComposer a) f,
  ) {
    final $$LineupSlotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lineupSlots,
      getReferencedColumn: (t) => t.careerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LineupSlotsTableAnnotationComposer(
            $db: $db,
            $table: $db.lineupSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> callUpsRefs<T extends Object>(
    Expression<T> Function($$CallUpsTableAnnotationComposer a) f,
  ) {
    final $$CallUpsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.callUps,
      getReferencedColumn: (t) => t.careerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CallUpsTableAnnotationComposer(
            $db: $db,
            $table: $db.callUps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> goalEventsRefs<T extends Object>(
    Expression<T> Function($$GoalEventsTableAnnotationComposer a) f,
  ) {
    final $$GoalEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goalEvents,
      getReferencedColumn: (t) => t.careerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.goalEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> honoursRefs<T extends Object>(
    Expression<T> Function($$HonoursTableAnnotationComposer a) f,
  ) {
    final $$HonoursTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.honours,
      getReferencedColumn: (t) => t.careerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HonoursTableAnnotationComposer(
            $db: $db,
            $table: $db.honours,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> drawsWatchedRefs<T extends Object>(
    Expression<T> Function($$DrawsWatchedTableAnnotationComposer a) f,
  ) {
    final $$DrawsWatchedTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.drawsWatched,
      getReferencedColumn: (t) => t.careerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DrawsWatchedTableAnnotationComposer(
            $db: $db,
            $table: $db.drawsWatched,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> playerAbsencesRefs<T extends Object>(
    Expression<T> Function($$PlayerAbsencesTableAnnotationComposer a) f,
  ) {
    final $$PlayerAbsencesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playerAbsences,
      getReferencedColumn: (t) => t.careerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayerAbsencesTableAnnotationComposer(
            $db: $db,
            $table: $db.playerAbsences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> rankPointsRefs<T extends Object>(
    Expression<T> Function($$RankPointsTableAnnotationComposer a) f,
  ) {
    final $$RankPointsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rankPoints,
      getReferencedColumn: (t) => t.careerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RankPointsTableAnnotationComposer(
            $db: $db,
            $table: $db.rankPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> seedRankingsRefs<T extends Object>(
    Expression<T> Function($$SeedRankingsTableAnnotationComposer a) f,
  ) {
    final $$SeedRankingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.seedRankings,
      getReferencedColumn: (t) => t.careerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeedRankingsTableAnnotationComposer(
            $db: $db,
            $table: $db.seedRankings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CareersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CareersTable,
          CareerRow,
          $$CareersTableFilterComposer,
          $$CareersTableOrderingComposer,
          $$CareersTableAnnotationComposer,
          $$CareersTableCreateCompanionBuilder,
          $$CareersTableUpdateCompanionBuilder,
          (CareerRow, $$CareersTableReferences),
          CareerRow,
          PrefetchHooks Function({
            bool nationId,
            bool competitionsRefs,
            bool fixturesRefs,
            bool tacticsRefs,
            bool lineupSlotsRefs,
            bool callUpsRefs,
            bool goalEventsRefs,
            bool honoursRefs,
            bool drawsWatchedRefs,
            bool playerAbsencesRefs,
            bool rankPointsRefs,
            bool seedRankingsRefs,
          })
        > {
  $$CareersTableTableManager(_$AppDatabase db, $CareersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CareersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CareersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CareersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> managerName = const Value.absent(),
                Value<int> nationId = const Value.absent(),
                Value<int> rngSeed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> inGameDate = const Value.absent(),
                Value<int> cyclePointer = const Value.absent(),
              }) => CareersCompanion(
                id: id,
                managerName: managerName,
                nationId: nationId,
                rngSeed: rngSeed,
                createdAt: createdAt,
                inGameDate: inGameDate,
                cyclePointer: cyclePointer,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String managerName,
                required int nationId,
                required int rngSeed,
                required DateTime createdAt,
                required DateTime inGameDate,
                Value<int> cyclePointer = const Value.absent(),
              }) => CareersCompanion.insert(
                id: id,
                managerName: managerName,
                nationId: nationId,
                rngSeed: rngSeed,
                createdAt: createdAt,
                inGameDate: inGameDate,
                cyclePointer: cyclePointer,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CareersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                nationId = false,
                competitionsRefs = false,
                fixturesRefs = false,
                tacticsRefs = false,
                lineupSlotsRefs = false,
                callUpsRefs = false,
                goalEventsRefs = false,
                honoursRefs = false,
                drawsWatchedRefs = false,
                playerAbsencesRefs = false,
                rankPointsRefs = false,
                seedRankingsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (competitionsRefs) db.competitions,
                    if (fixturesRefs) db.fixtures,
                    if (tacticsRefs) db.tactics,
                    if (lineupSlotsRefs) db.lineupSlots,
                    if (callUpsRefs) db.callUps,
                    if (goalEventsRefs) db.goalEvents,
                    if (honoursRefs) db.honours,
                    if (drawsWatchedRefs) db.drawsWatched,
                    if (playerAbsencesRefs) db.playerAbsences,
                    if (rankPointsRefs) db.rankPoints,
                    if (seedRankingsRefs) db.seedRankings,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (nationId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.nationId,
                                    referencedTable: $$CareersTableReferences
                                        ._nationIdTable(db),
                                    referencedColumn: $$CareersTableReferences
                                        ._nationIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (competitionsRefs)
                        await $_getPrefetchedData<
                          CareerRow,
                          $CareersTable,
                          CompetitionRow
                        >(
                          currentTable: table,
                          referencedTable: $$CareersTableReferences
                              ._competitionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CareersTableReferences(
                                db,
                                table,
                                p0,
                              ).competitionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.careerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (fixturesRefs)
                        await $_getPrefetchedData<
                          CareerRow,
                          $CareersTable,
                          FixtureRow
                        >(
                          currentTable: table,
                          referencedTable: $$CareersTableReferences
                              ._fixturesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CareersTableReferences(
                                db,
                                table,
                                p0,
                              ).fixturesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.careerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tacticsRefs)
                        await $_getPrefetchedData<
                          CareerRow,
                          $CareersTable,
                          TacticRow
                        >(
                          currentTable: table,
                          referencedTable: $$CareersTableReferences
                              ._tacticsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CareersTableReferences(
                                db,
                                table,
                                p0,
                              ).tacticsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.careerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (lineupSlotsRefs)
                        await $_getPrefetchedData<
                          CareerRow,
                          $CareersTable,
                          LineupSlotRow
                        >(
                          currentTable: table,
                          referencedTable: $$CareersTableReferences
                              ._lineupSlotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CareersTableReferences(
                                db,
                                table,
                                p0,
                              ).lineupSlotsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.careerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (callUpsRefs)
                        await $_getPrefetchedData<
                          CareerRow,
                          $CareersTable,
                          CallUpRow
                        >(
                          currentTable: table,
                          referencedTable: $$CareersTableReferences
                              ._callUpsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CareersTableReferences(
                                db,
                                table,
                                p0,
                              ).callUpsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.careerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (goalEventsRefs)
                        await $_getPrefetchedData<
                          CareerRow,
                          $CareersTable,
                          GoalEventRow
                        >(
                          currentTable: table,
                          referencedTable: $$CareersTableReferences
                              ._goalEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CareersTableReferences(
                                db,
                                table,
                                p0,
                              ).goalEventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.careerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (honoursRefs)
                        await $_getPrefetchedData<
                          CareerRow,
                          $CareersTable,
                          HonourRow
                        >(
                          currentTable: table,
                          referencedTable: $$CareersTableReferences
                              ._honoursRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CareersTableReferences(
                                db,
                                table,
                                p0,
                              ).honoursRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.careerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (drawsWatchedRefs)
                        await $_getPrefetchedData<
                          CareerRow,
                          $CareersTable,
                          DrawWatchedRow
                        >(
                          currentTable: table,
                          referencedTable: $$CareersTableReferences
                              ._drawsWatchedRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CareersTableReferences(
                                db,
                                table,
                                p0,
                              ).drawsWatchedRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.careerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (playerAbsencesRefs)
                        await $_getPrefetchedData<
                          CareerRow,
                          $CareersTable,
                          PlayerAbsenceRow
                        >(
                          currentTable: table,
                          referencedTable: $$CareersTableReferences
                              ._playerAbsencesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CareersTableReferences(
                                db,
                                table,
                                p0,
                              ).playerAbsencesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.careerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (rankPointsRefs)
                        await $_getPrefetchedData<
                          CareerRow,
                          $CareersTable,
                          RankPointRow
                        >(
                          currentTable: table,
                          referencedTable: $$CareersTableReferences
                              ._rankPointsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CareersTableReferences(
                                db,
                                table,
                                p0,
                              ).rankPointsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.careerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (seedRankingsRefs)
                        await $_getPrefetchedData<
                          CareerRow,
                          $CareersTable,
                          SeedRankingRow
                        >(
                          currentTable: table,
                          referencedTable: $$CareersTableReferences
                              ._seedRankingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CareersTableReferences(
                                db,
                                table,
                                p0,
                              ).seedRankingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.careerId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CareersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CareersTable,
      CareerRow,
      $$CareersTableFilterComposer,
      $$CareersTableOrderingComposer,
      $$CareersTableAnnotationComposer,
      $$CareersTableCreateCompanionBuilder,
      $$CareersTableUpdateCompanionBuilder,
      (CareerRow, $$CareersTableReferences),
      CareerRow,
      PrefetchHooks Function({
        bool nationId,
        bool competitionsRefs,
        bool fixturesRefs,
        bool tacticsRefs,
        bool lineupSlotsRefs,
        bool callUpsRefs,
        bool goalEventsRefs,
        bool honoursRefs,
        bool drawsWatchedRefs,
        bool playerAbsencesRefs,
        bool rankPointsRefs,
        bool seedRankingsRefs,
      })
    >;
typedef $$CompetitionsTableCreateCompanionBuilder =
    CompetitionsCompanion Function({
      Value<int> id,
      required int careerId,
      required Confederation confederation,
      required String name,
      Value<CompetitionKind> kind,
      Value<int> cycle,
    });
typedef $$CompetitionsTableUpdateCompanionBuilder =
    CompetitionsCompanion Function({
      Value<int> id,
      Value<int> careerId,
      Value<Confederation> confederation,
      Value<String> name,
      Value<CompetitionKind> kind,
      Value<int> cycle,
    });

final class $$CompetitionsTableReferences
    extends BaseReferences<_$AppDatabase, $CompetitionsTable, CompetitionRow> {
  $$CompetitionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CareersTable _careerIdTable(_$AppDatabase db) =>
      db.careers.createAlias('competitions__career_id__careers__id');

  $$CareersTableProcessedTableManager get careerId {
    final $_column = $_itemColumn<int>('career_id')!;

    final manager = $$CareersTableTableManager(
      $_db,
      $_db.careers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_careerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$QualifyingGroupsTable, List<QualifyingGroupRow>>
  _qualifyingGroupsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.qualifyingGroups,
    aliasName: 'competitions__id__qualifying_groups__competition_id',
  );

  $$QualifyingGroupsTableProcessedTableManager get qualifyingGroupsRefs {
    final manager = $$QualifyingGroupsTableTableManager(
      $_db,
      $_db.qualifyingGroups,
    ).filter((f) => f.competitionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _qualifyingGroupsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FixturesTable, List<FixtureRow>>
  _fixturesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.fixtures,
    aliasName: 'competitions__id__fixtures__competition_id',
  );

  $$FixturesTableProcessedTableManager get fixturesRefs {
    final manager = $$FixturesTableTableManager(
      $_db,
      $_db.fixtures,
    ).filter((f) => f.competitionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_fixturesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GoalEventsTable, List<GoalEventRow>>
  _goalEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.goalEvents,
    aliasName: 'competitions__id__goal_events__competition_id',
  );

  $$GoalEventsTableProcessedTableManager get goalEventsRefs {
    final manager = $$GoalEventsTableTableManager(
      $_db,
      $_db.goalEvents,
    ).filter((f) => f.competitionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_goalEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CompetitionsTableFilterComposer
    extends Composer<_$AppDatabase, $CompetitionsTable> {
  $$CompetitionsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<Confederation, Confederation, String>
  get confederation => $composableBuilder(
    column: $table.confederation,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CompetitionKind, CompetitionKind, String>
  get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get cycle => $composableBuilder(
    column: $table.cycle,
    builder: (column) => ColumnFilters(column),
  );

  $$CareersTableFilterComposer get careerId {
    final $$CareersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableFilterComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> qualifyingGroupsRefs(
    Expression<bool> Function($$QualifyingGroupsTableFilterComposer f) f,
  ) {
    final $$QualifyingGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.qualifyingGroups,
      getReferencedColumn: (t) => t.competitionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QualifyingGroupsTableFilterComposer(
            $db: $db,
            $table: $db.qualifyingGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> fixturesRefs(
    Expression<bool> Function($$FixturesTableFilterComposer f) f,
  ) {
    final $$FixturesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fixtures,
      getReferencedColumn: (t) => t.competitionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FixturesTableFilterComposer(
            $db: $db,
            $table: $db.fixtures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> goalEventsRefs(
    Expression<bool> Function($$GoalEventsTableFilterComposer f) f,
  ) {
    final $$GoalEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goalEvents,
      getReferencedColumn: (t) => t.competitionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalEventsTableFilterComposer(
            $db: $db,
            $table: $db.goalEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CompetitionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CompetitionsTable> {
  $$CompetitionsTableOrderingComposer({
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

  ColumnOrderings<String> get confederation => $composableBuilder(
    column: $table.confederation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cycle => $composableBuilder(
    column: $table.cycle,
    builder: (column) => ColumnOrderings(column),
  );

  $$CareersTableOrderingComposer get careerId {
    final $$CareersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableOrderingComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CompetitionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompetitionsTable> {
  $$CompetitionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Confederation, String> get confederation =>
      $composableBuilder(
        column: $table.confederation,
        builder: (column) => column,
      );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CompetitionKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get cycle =>
      $composableBuilder(column: $table.cycle, builder: (column) => column);

  $$CareersTableAnnotationComposer get careerId {
    final $$CareersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableAnnotationComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> qualifyingGroupsRefs<T extends Object>(
    Expression<T> Function($$QualifyingGroupsTableAnnotationComposer a) f,
  ) {
    final $$QualifyingGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.qualifyingGroups,
      getReferencedColumn: (t) => t.competitionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QualifyingGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.qualifyingGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> fixturesRefs<T extends Object>(
    Expression<T> Function($$FixturesTableAnnotationComposer a) f,
  ) {
    final $$FixturesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fixtures,
      getReferencedColumn: (t) => t.competitionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FixturesTableAnnotationComposer(
            $db: $db,
            $table: $db.fixtures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> goalEventsRefs<T extends Object>(
    Expression<T> Function($$GoalEventsTableAnnotationComposer a) f,
  ) {
    final $$GoalEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goalEvents,
      getReferencedColumn: (t) => t.competitionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.goalEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CompetitionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CompetitionsTable,
          CompetitionRow,
          $$CompetitionsTableFilterComposer,
          $$CompetitionsTableOrderingComposer,
          $$CompetitionsTableAnnotationComposer,
          $$CompetitionsTableCreateCompanionBuilder,
          $$CompetitionsTableUpdateCompanionBuilder,
          (CompetitionRow, $$CompetitionsTableReferences),
          CompetitionRow,
          PrefetchHooks Function({
            bool careerId,
            bool qualifyingGroupsRefs,
            bool fixturesRefs,
            bool goalEventsRefs,
          })
        > {
  $$CompetitionsTableTableManager(_$AppDatabase db, $CompetitionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompetitionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompetitionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompetitionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> careerId = const Value.absent(),
                Value<Confederation> confederation = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<CompetitionKind> kind = const Value.absent(),
                Value<int> cycle = const Value.absent(),
              }) => CompetitionsCompanion(
                id: id,
                careerId: careerId,
                confederation: confederation,
                name: name,
                kind: kind,
                cycle: cycle,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int careerId,
                required Confederation confederation,
                required String name,
                Value<CompetitionKind> kind = const Value.absent(),
                Value<int> cycle = const Value.absent(),
              }) => CompetitionsCompanion.insert(
                id: id,
                careerId: careerId,
                confederation: confederation,
                name: name,
                kind: kind,
                cycle: cycle,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CompetitionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                careerId = false,
                qualifyingGroupsRefs = false,
                fixturesRefs = false,
                goalEventsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (qualifyingGroupsRefs) db.qualifyingGroups,
                    if (fixturesRefs) db.fixtures,
                    if (goalEventsRefs) db.goalEvents,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (careerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.careerId,
                                    referencedTable:
                                        $$CompetitionsTableReferences
                                            ._careerIdTable(db),
                                    referencedColumn:
                                        $$CompetitionsTableReferences
                                            ._careerIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (qualifyingGroupsRefs)
                        await $_getPrefetchedData<
                          CompetitionRow,
                          $CompetitionsTable,
                          QualifyingGroupRow
                        >(
                          currentTable: table,
                          referencedTable: $$CompetitionsTableReferences
                              ._qualifyingGroupsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CompetitionsTableReferences(
                                db,
                                table,
                                p0,
                              ).qualifyingGroupsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.competitionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (fixturesRefs)
                        await $_getPrefetchedData<
                          CompetitionRow,
                          $CompetitionsTable,
                          FixtureRow
                        >(
                          currentTable: table,
                          referencedTable: $$CompetitionsTableReferences
                              ._fixturesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CompetitionsTableReferences(
                                db,
                                table,
                                p0,
                              ).fixturesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.competitionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (goalEventsRefs)
                        await $_getPrefetchedData<
                          CompetitionRow,
                          $CompetitionsTable,
                          GoalEventRow
                        >(
                          currentTable: table,
                          referencedTable: $$CompetitionsTableReferences
                              ._goalEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CompetitionsTableReferences(
                                db,
                                table,
                                p0,
                              ).goalEventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.competitionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CompetitionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CompetitionsTable,
      CompetitionRow,
      $$CompetitionsTableFilterComposer,
      $$CompetitionsTableOrderingComposer,
      $$CompetitionsTableAnnotationComposer,
      $$CompetitionsTableCreateCompanionBuilder,
      $$CompetitionsTableUpdateCompanionBuilder,
      (CompetitionRow, $$CompetitionsTableReferences),
      CompetitionRow,
      PrefetchHooks Function({
        bool careerId,
        bool qualifyingGroupsRefs,
        bool fixturesRefs,
        bool goalEventsRefs,
      })
    >;
typedef $$QualifyingGroupsTableCreateCompanionBuilder =
    QualifyingGroupsCompanion Function({
      Value<int> id,
      required int competitionId,
      required String name,
    });
typedef $$QualifyingGroupsTableUpdateCompanionBuilder =
    QualifyingGroupsCompanion Function({
      Value<int> id,
      Value<int> competitionId,
      Value<String> name,
    });

final class $$QualifyingGroupsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $QualifyingGroupsTable,
          QualifyingGroupRow
        > {
  $$QualifyingGroupsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CompetitionsTable _competitionIdTable(_$AppDatabase db) => db
      .competitions
      .createAlias('qualifying_groups__competition_id__competitions__id');

  $$CompetitionsTableProcessedTableManager get competitionId {
    final $_column = $_itemColumn<int>('competition_id')!;

    final manager = $$CompetitionsTableTableManager(
      $_db,
      $_db.competitions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_competitionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$GroupMembersTable, List<GroupMemberRow>>
  _groupMembersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.groupMembers,
    aliasName: 'qualifying_groups__id__group_members__group_id',
  );

  $$GroupMembersTableProcessedTableManager get groupMembersRefs {
    final manager = $$GroupMembersTableTableManager(
      $_db,
      $_db.groupMembers,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_groupMembersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FixturesTable, List<FixtureRow>>
  _fixturesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.fixtures,
    aliasName: 'qualifying_groups__id__fixtures__group_id',
  );

  $$FixturesTableProcessedTableManager get fixturesRefs {
    final manager = $$FixturesTableTableManager(
      $_db,
      $_db.fixtures,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_fixturesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$QualifyingGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $QualifyingGroupsTable> {
  $$QualifyingGroupsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  $$CompetitionsTableFilterComposer get competitionId {
    final $$CompetitionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.competitionId,
      referencedTable: $db.competitions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompetitionsTableFilterComposer(
            $db: $db,
            $table: $db.competitions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> groupMembersRefs(
    Expression<bool> Function($$GroupMembersTableFilterComposer f) f,
  ) {
    final $$GroupMembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupMembers,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupMembersTableFilterComposer(
            $db: $db,
            $table: $db.groupMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> fixturesRefs(
    Expression<bool> Function($$FixturesTableFilterComposer f) f,
  ) {
    final $$FixturesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fixtures,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FixturesTableFilterComposer(
            $db: $db,
            $table: $db.fixtures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QualifyingGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $QualifyingGroupsTable> {
  $$QualifyingGroupsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  $$CompetitionsTableOrderingComposer get competitionId {
    final $$CompetitionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.competitionId,
      referencedTable: $db.competitions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompetitionsTableOrderingComposer(
            $db: $db,
            $table: $db.competitions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QualifyingGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QualifyingGroupsTable> {
  $$QualifyingGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  $$CompetitionsTableAnnotationComposer get competitionId {
    final $$CompetitionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.competitionId,
      referencedTable: $db.competitions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompetitionsTableAnnotationComposer(
            $db: $db,
            $table: $db.competitions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> groupMembersRefs<T extends Object>(
    Expression<T> Function($$GroupMembersTableAnnotationComposer a) f,
  ) {
    final $$GroupMembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupMembers,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupMembersTableAnnotationComposer(
            $db: $db,
            $table: $db.groupMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> fixturesRefs<T extends Object>(
    Expression<T> Function($$FixturesTableAnnotationComposer a) f,
  ) {
    final $$FixturesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fixtures,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FixturesTableAnnotationComposer(
            $db: $db,
            $table: $db.fixtures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QualifyingGroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QualifyingGroupsTable,
          QualifyingGroupRow,
          $$QualifyingGroupsTableFilterComposer,
          $$QualifyingGroupsTableOrderingComposer,
          $$QualifyingGroupsTableAnnotationComposer,
          $$QualifyingGroupsTableCreateCompanionBuilder,
          $$QualifyingGroupsTableUpdateCompanionBuilder,
          (QualifyingGroupRow, $$QualifyingGroupsTableReferences),
          QualifyingGroupRow,
          PrefetchHooks Function({
            bool competitionId,
            bool groupMembersRefs,
            bool fixturesRefs,
          })
        > {
  $$QualifyingGroupsTableTableManager(
    _$AppDatabase db,
    $QualifyingGroupsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QualifyingGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QualifyingGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QualifyingGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> competitionId = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => QualifyingGroupsCompanion(
                id: id,
                competitionId: competitionId,
                name: name,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int competitionId,
                required String name,
              }) => QualifyingGroupsCompanion.insert(
                id: id,
                competitionId: competitionId,
                name: name,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QualifyingGroupsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                competitionId = false,
                groupMembersRefs = false,
                fixturesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (groupMembersRefs) db.groupMembers,
                    if (fixturesRefs) db.fixtures,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (competitionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.competitionId,
                                    referencedTable:
                                        $$QualifyingGroupsTableReferences
                                            ._competitionIdTable(db),
                                    referencedColumn:
                                        $$QualifyingGroupsTableReferences
                                            ._competitionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (groupMembersRefs)
                        await $_getPrefetchedData<
                          QualifyingGroupRow,
                          $QualifyingGroupsTable,
                          GroupMemberRow
                        >(
                          currentTable: table,
                          referencedTable: $$QualifyingGroupsTableReferences
                              ._groupMembersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QualifyingGroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).groupMembersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (fixturesRefs)
                        await $_getPrefetchedData<
                          QualifyingGroupRow,
                          $QualifyingGroupsTable,
                          FixtureRow
                        >(
                          currentTable: table,
                          referencedTable: $$QualifyingGroupsTableReferences
                              ._fixturesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QualifyingGroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).fixturesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$QualifyingGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QualifyingGroupsTable,
      QualifyingGroupRow,
      $$QualifyingGroupsTableFilterComposer,
      $$QualifyingGroupsTableOrderingComposer,
      $$QualifyingGroupsTableAnnotationComposer,
      $$QualifyingGroupsTableCreateCompanionBuilder,
      $$QualifyingGroupsTableUpdateCompanionBuilder,
      (QualifyingGroupRow, $$QualifyingGroupsTableReferences),
      QualifyingGroupRow,
      PrefetchHooks Function({
        bool competitionId,
        bool groupMembersRefs,
        bool fixturesRefs,
      })
    >;
typedef $$GroupMembersTableCreateCompanionBuilder =
    GroupMembersCompanion Function({
      required int groupId,
      required int nationId,
      Value<int> rowid,
    });
typedef $$GroupMembersTableUpdateCompanionBuilder =
    GroupMembersCompanion Function({
      Value<int> groupId,
      Value<int> nationId,
      Value<int> rowid,
    });

final class $$GroupMembersTableReferences
    extends BaseReferences<_$AppDatabase, $GroupMembersTable, GroupMemberRow> {
  $$GroupMembersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $QualifyingGroupsTable _groupIdTable(_$AppDatabase db) => db
      .qualifyingGroups
      .createAlias('group_members__group_id__qualifying_groups__id');

  $$QualifyingGroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<int>('group_id')!;

    final manager = $$QualifyingGroupsTableTableManager(
      $_db,
      $_db.qualifyingGroups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GroupMembersTableFilterComposer
    extends Composer<_$AppDatabase, $GroupMembersTable> {
  $$GroupMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get nationId => $composableBuilder(
    column: $table.nationId,
    builder: (column) => ColumnFilters(column),
  );

  $$QualifyingGroupsTableFilterComposer get groupId {
    final $$QualifyingGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.qualifyingGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QualifyingGroupsTableFilterComposer(
            $db: $db,
            $table: $db.qualifyingGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupMembersTable> {
  $$GroupMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get nationId => $composableBuilder(
    column: $table.nationId,
    builder: (column) => ColumnOrderings(column),
  );

  $$QualifyingGroupsTableOrderingComposer get groupId {
    final $$QualifyingGroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.qualifyingGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QualifyingGroupsTableOrderingComposer(
            $db: $db,
            $table: $db.qualifyingGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupMembersTable> {
  $$GroupMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get nationId =>
      $composableBuilder(column: $table.nationId, builder: (column) => column);

  $$QualifyingGroupsTableAnnotationComposer get groupId {
    final $$QualifyingGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.qualifyingGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QualifyingGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.qualifyingGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupMembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupMembersTable,
          GroupMemberRow,
          $$GroupMembersTableFilterComposer,
          $$GroupMembersTableOrderingComposer,
          $$GroupMembersTableAnnotationComposer,
          $$GroupMembersTableCreateCompanionBuilder,
          $$GroupMembersTableUpdateCompanionBuilder,
          (GroupMemberRow, $$GroupMembersTableReferences),
          GroupMemberRow,
          PrefetchHooks Function({bool groupId})
        > {
  $$GroupMembersTableTableManager(_$AppDatabase db, $GroupMembersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> groupId = const Value.absent(),
                Value<int> nationId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupMembersCompanion(
                groupId: groupId,
                nationId: nationId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int groupId,
                required int nationId,
                Value<int> rowid = const Value.absent(),
              }) => GroupMembersCompanion.insert(
                groupId: groupId,
                nationId: nationId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GroupMembersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (groupId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.groupId,
                                referencedTable: $$GroupMembersTableReferences
                                    ._groupIdTable(db),
                                referencedColumn: $$GroupMembersTableReferences
                                    ._groupIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GroupMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupMembersTable,
      GroupMemberRow,
      $$GroupMembersTableFilterComposer,
      $$GroupMembersTableOrderingComposer,
      $$GroupMembersTableAnnotationComposer,
      $$GroupMembersTableCreateCompanionBuilder,
      $$GroupMembersTableUpdateCompanionBuilder,
      (GroupMemberRow, $$GroupMembersTableReferences),
      GroupMemberRow,
      PrefetchHooks Function({bool groupId})
    >;
typedef $$FixturesTableCreateCompanionBuilder =
    FixturesCompanion Function({
      Value<int> id,
      required int careerId,
      required int competitionId,
      Value<int?> groupId,
      required int matchday,
      required DateTime date,
      required int homeNationId,
      required int awayNationId,
      Value<int?> homeScore,
      Value<int?> awayScore,
      Value<bool> played,
      Value<String?> round,
    });
typedef $$FixturesTableUpdateCompanionBuilder =
    FixturesCompanion Function({
      Value<int> id,
      Value<int> careerId,
      Value<int> competitionId,
      Value<int?> groupId,
      Value<int> matchday,
      Value<DateTime> date,
      Value<int> homeNationId,
      Value<int> awayNationId,
      Value<int?> homeScore,
      Value<int?> awayScore,
      Value<bool> played,
      Value<String?> round,
    });

final class $$FixturesTableReferences
    extends BaseReferences<_$AppDatabase, $FixturesTable, FixtureRow> {
  $$FixturesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CareersTable _careerIdTable(_$AppDatabase db) =>
      db.careers.createAlias('fixtures__career_id__careers__id');

  $$CareersTableProcessedTableManager get careerId {
    final $_column = $_itemColumn<int>('career_id')!;

    final manager = $$CareersTableTableManager(
      $_db,
      $_db.careers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_careerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CompetitionsTable _competitionIdTable(_$AppDatabase db) =>
      db.competitions.createAlias('fixtures__competition_id__competitions__id');

  $$CompetitionsTableProcessedTableManager get competitionId {
    final $_column = $_itemColumn<int>('competition_id')!;

    final manager = $$CompetitionsTableTableManager(
      $_db,
      $_db.competitions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_competitionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $QualifyingGroupsTable _groupIdTable(_$AppDatabase db) => db
      .qualifyingGroups
      .createAlias('fixtures__group_id__qualifying_groups__id');

  $$QualifyingGroupsTableProcessedTableManager? get groupId {
    final $_column = $_itemColumn<int>('group_id');
    if ($_column == null) return null;
    final manager = $$QualifyingGroupsTableTableManager(
      $_db,
      $_db.qualifyingGroups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$GoalEventsTable, List<GoalEventRow>>
  _goalEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.goalEvents,
    aliasName: 'fixtures__id__goal_events__fixture_id',
  );

  $$GoalEventsTableProcessedTableManager get goalEventsRefs {
    final manager = $$GoalEventsTableTableManager(
      $_db,
      $_db.goalEvents,
    ).filter((f) => f.fixtureId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_goalEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FixturesTableFilterComposer
    extends Composer<_$AppDatabase, $FixturesTable> {
  $$FixturesTableFilterComposer({
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

  ColumnFilters<int> get matchday => $composableBuilder(
    column: $table.matchday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get homeNationId => $composableBuilder(
    column: $table.homeNationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get awayNationId => $composableBuilder(
    column: $table.awayNationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get homeScore => $composableBuilder(
    column: $table.homeScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get awayScore => $composableBuilder(
    column: $table.awayScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get played => $composableBuilder(
    column: $table.played,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get round => $composableBuilder(
    column: $table.round,
    builder: (column) => ColumnFilters(column),
  );

  $$CareersTableFilterComposer get careerId {
    final $$CareersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableFilterComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CompetitionsTableFilterComposer get competitionId {
    final $$CompetitionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.competitionId,
      referencedTable: $db.competitions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompetitionsTableFilterComposer(
            $db: $db,
            $table: $db.competitions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$QualifyingGroupsTableFilterComposer get groupId {
    final $$QualifyingGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.qualifyingGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QualifyingGroupsTableFilterComposer(
            $db: $db,
            $table: $db.qualifyingGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> goalEventsRefs(
    Expression<bool> Function($$GoalEventsTableFilterComposer f) f,
  ) {
    final $$GoalEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goalEvents,
      getReferencedColumn: (t) => t.fixtureId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalEventsTableFilterComposer(
            $db: $db,
            $table: $db.goalEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FixturesTableOrderingComposer
    extends Composer<_$AppDatabase, $FixturesTable> {
  $$FixturesTableOrderingComposer({
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

  ColumnOrderings<int> get matchday => $composableBuilder(
    column: $table.matchday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get homeNationId => $composableBuilder(
    column: $table.homeNationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get awayNationId => $composableBuilder(
    column: $table.awayNationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get homeScore => $composableBuilder(
    column: $table.homeScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get awayScore => $composableBuilder(
    column: $table.awayScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get played => $composableBuilder(
    column: $table.played,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get round => $composableBuilder(
    column: $table.round,
    builder: (column) => ColumnOrderings(column),
  );

  $$CareersTableOrderingComposer get careerId {
    final $$CareersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableOrderingComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CompetitionsTableOrderingComposer get competitionId {
    final $$CompetitionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.competitionId,
      referencedTable: $db.competitions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompetitionsTableOrderingComposer(
            $db: $db,
            $table: $db.competitions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$QualifyingGroupsTableOrderingComposer get groupId {
    final $$QualifyingGroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.qualifyingGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QualifyingGroupsTableOrderingComposer(
            $db: $db,
            $table: $db.qualifyingGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FixturesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FixturesTable> {
  $$FixturesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get matchday =>
      $composableBuilder(column: $table.matchday, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get homeNationId => $composableBuilder(
    column: $table.homeNationId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get awayNationId => $composableBuilder(
    column: $table.awayNationId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get homeScore =>
      $composableBuilder(column: $table.homeScore, builder: (column) => column);

  GeneratedColumn<int> get awayScore =>
      $composableBuilder(column: $table.awayScore, builder: (column) => column);

  GeneratedColumn<bool> get played =>
      $composableBuilder(column: $table.played, builder: (column) => column);

  GeneratedColumn<String> get round =>
      $composableBuilder(column: $table.round, builder: (column) => column);

  $$CareersTableAnnotationComposer get careerId {
    final $$CareersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableAnnotationComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CompetitionsTableAnnotationComposer get competitionId {
    final $$CompetitionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.competitionId,
      referencedTable: $db.competitions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompetitionsTableAnnotationComposer(
            $db: $db,
            $table: $db.competitions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$QualifyingGroupsTableAnnotationComposer get groupId {
    final $$QualifyingGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.qualifyingGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QualifyingGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.qualifyingGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> goalEventsRefs<T extends Object>(
    Expression<T> Function($$GoalEventsTableAnnotationComposer a) f,
  ) {
    final $$GoalEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goalEvents,
      getReferencedColumn: (t) => t.fixtureId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.goalEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FixturesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FixturesTable,
          FixtureRow,
          $$FixturesTableFilterComposer,
          $$FixturesTableOrderingComposer,
          $$FixturesTableAnnotationComposer,
          $$FixturesTableCreateCompanionBuilder,
          $$FixturesTableUpdateCompanionBuilder,
          (FixtureRow, $$FixturesTableReferences),
          FixtureRow,
          PrefetchHooks Function({
            bool careerId,
            bool competitionId,
            bool groupId,
            bool goalEventsRefs,
          })
        > {
  $$FixturesTableTableManager(_$AppDatabase db, $FixturesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FixturesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FixturesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FixturesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> careerId = const Value.absent(),
                Value<int> competitionId = const Value.absent(),
                Value<int?> groupId = const Value.absent(),
                Value<int> matchday = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> homeNationId = const Value.absent(),
                Value<int> awayNationId = const Value.absent(),
                Value<int?> homeScore = const Value.absent(),
                Value<int?> awayScore = const Value.absent(),
                Value<bool> played = const Value.absent(),
                Value<String?> round = const Value.absent(),
              }) => FixturesCompanion(
                id: id,
                careerId: careerId,
                competitionId: competitionId,
                groupId: groupId,
                matchday: matchday,
                date: date,
                homeNationId: homeNationId,
                awayNationId: awayNationId,
                homeScore: homeScore,
                awayScore: awayScore,
                played: played,
                round: round,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int careerId,
                required int competitionId,
                Value<int?> groupId = const Value.absent(),
                required int matchday,
                required DateTime date,
                required int homeNationId,
                required int awayNationId,
                Value<int?> homeScore = const Value.absent(),
                Value<int?> awayScore = const Value.absent(),
                Value<bool> played = const Value.absent(),
                Value<String?> round = const Value.absent(),
              }) => FixturesCompanion.insert(
                id: id,
                careerId: careerId,
                competitionId: competitionId,
                groupId: groupId,
                matchday: matchday,
                date: date,
                homeNationId: homeNationId,
                awayNationId: awayNationId,
                homeScore: homeScore,
                awayScore: awayScore,
                played: played,
                round: round,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FixturesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                careerId = false,
                competitionId = false,
                groupId = false,
                goalEventsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (goalEventsRefs) db.goalEvents],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (careerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.careerId,
                                    referencedTable: $$FixturesTableReferences
                                        ._careerIdTable(db),
                                    referencedColumn: $$FixturesTableReferences
                                        ._careerIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (competitionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.competitionId,
                                    referencedTable: $$FixturesTableReferences
                                        ._competitionIdTable(db),
                                    referencedColumn: $$FixturesTableReferences
                                        ._competitionIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (groupId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.groupId,
                                    referencedTable: $$FixturesTableReferences
                                        ._groupIdTable(db),
                                    referencedColumn: $$FixturesTableReferences
                                        ._groupIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (goalEventsRefs)
                        await $_getPrefetchedData<
                          FixtureRow,
                          $FixturesTable,
                          GoalEventRow
                        >(
                          currentTable: table,
                          referencedTable: $$FixturesTableReferences
                              ._goalEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FixturesTableReferences(
                                db,
                                table,
                                p0,
                              ).goalEventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.fixtureId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$FixturesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FixturesTable,
      FixtureRow,
      $$FixturesTableFilterComposer,
      $$FixturesTableOrderingComposer,
      $$FixturesTableAnnotationComposer,
      $$FixturesTableCreateCompanionBuilder,
      $$FixturesTableUpdateCompanionBuilder,
      (FixtureRow, $$FixturesTableReferences),
      FixtureRow,
      PrefetchHooks Function({
        bool careerId,
        bool competitionId,
        bool groupId,
        bool goalEventsRefs,
      })
    >;
typedef $$TacticsTableCreateCompanionBuilder =
    TacticsCompanion Function({
      Value<int> careerId,
      required Formation formation,
      Value<int> mentality,
      Value<int> pressing,
      Value<int> tempo,
      Value<int> width,
      Value<int> defensiveLine,
      Value<int> directness,
    });
typedef $$TacticsTableUpdateCompanionBuilder =
    TacticsCompanion Function({
      Value<int> careerId,
      Value<Formation> formation,
      Value<int> mentality,
      Value<int> pressing,
      Value<int> tempo,
      Value<int> width,
      Value<int> defensiveLine,
      Value<int> directness,
    });

final class $$TacticsTableReferences
    extends BaseReferences<_$AppDatabase, $TacticsTable, TacticRow> {
  $$TacticsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CareersTable _careerIdTable(_$AppDatabase db) =>
      db.careers.createAlias('tactics__career_id__careers__id');

  $$CareersTableProcessedTableManager get careerId {
    final $_column = $_itemColumn<int>('career_id')!;

    final manager = $$CareersTableTableManager(
      $_db,
      $_db.careers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_careerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TacticsTableFilterComposer
    extends Composer<_$AppDatabase, $TacticsTable> {
  $$TacticsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<Formation, Formation, String> get formation =>
      $composableBuilder(
        column: $table.formation,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get mentality => $composableBuilder(
    column: $table.mentality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pressing => $composableBuilder(
    column: $table.pressing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tempo => $composableBuilder(
    column: $table.tempo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defensiveLine => $composableBuilder(
    column: $table.defensiveLine,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get directness => $composableBuilder(
    column: $table.directness,
    builder: (column) => ColumnFilters(column),
  );

  $$CareersTableFilterComposer get careerId {
    final $$CareersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableFilterComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TacticsTableOrderingComposer
    extends Composer<_$AppDatabase, $TacticsTable> {
  $$TacticsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get formation => $composableBuilder(
    column: $table.formation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mentality => $composableBuilder(
    column: $table.mentality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pressing => $composableBuilder(
    column: $table.pressing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tempo => $composableBuilder(
    column: $table.tempo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defensiveLine => $composableBuilder(
    column: $table.defensiveLine,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get directness => $composableBuilder(
    column: $table.directness,
    builder: (column) => ColumnOrderings(column),
  );

  $$CareersTableOrderingComposer get careerId {
    final $$CareersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableOrderingComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TacticsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TacticsTable> {
  $$TacticsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<Formation, String> get formation =>
      $composableBuilder(column: $table.formation, builder: (column) => column);

  GeneratedColumn<int> get mentality =>
      $composableBuilder(column: $table.mentality, builder: (column) => column);

  GeneratedColumn<int> get pressing =>
      $composableBuilder(column: $table.pressing, builder: (column) => column);

  GeneratedColumn<int> get tempo =>
      $composableBuilder(column: $table.tempo, builder: (column) => column);

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get defensiveLine => $composableBuilder(
    column: $table.defensiveLine,
    builder: (column) => column,
  );

  GeneratedColumn<int> get directness => $composableBuilder(
    column: $table.directness,
    builder: (column) => column,
  );

  $$CareersTableAnnotationComposer get careerId {
    final $$CareersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableAnnotationComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TacticsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TacticsTable,
          TacticRow,
          $$TacticsTableFilterComposer,
          $$TacticsTableOrderingComposer,
          $$TacticsTableAnnotationComposer,
          $$TacticsTableCreateCompanionBuilder,
          $$TacticsTableUpdateCompanionBuilder,
          (TacticRow, $$TacticsTableReferences),
          TacticRow,
          PrefetchHooks Function({bool careerId})
        > {
  $$TacticsTableTableManager(_$AppDatabase db, $TacticsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TacticsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TacticsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TacticsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> careerId = const Value.absent(),
                Value<Formation> formation = const Value.absent(),
                Value<int> mentality = const Value.absent(),
                Value<int> pressing = const Value.absent(),
                Value<int> tempo = const Value.absent(),
                Value<int> width = const Value.absent(),
                Value<int> defensiveLine = const Value.absent(),
                Value<int> directness = const Value.absent(),
              }) => TacticsCompanion(
                careerId: careerId,
                formation: formation,
                mentality: mentality,
                pressing: pressing,
                tempo: tempo,
                width: width,
                defensiveLine: defensiveLine,
                directness: directness,
              ),
          createCompanionCallback:
              ({
                Value<int> careerId = const Value.absent(),
                required Formation formation,
                Value<int> mentality = const Value.absent(),
                Value<int> pressing = const Value.absent(),
                Value<int> tempo = const Value.absent(),
                Value<int> width = const Value.absent(),
                Value<int> defensiveLine = const Value.absent(),
                Value<int> directness = const Value.absent(),
              }) => TacticsCompanion.insert(
                careerId: careerId,
                formation: formation,
                mentality: mentality,
                pressing: pressing,
                tempo: tempo,
                width: width,
                defensiveLine: defensiveLine,
                directness: directness,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TacticsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({careerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (careerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.careerId,
                                referencedTable: $$TacticsTableReferences
                                    ._careerIdTable(db),
                                referencedColumn: $$TacticsTableReferences
                                    ._careerIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TacticsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TacticsTable,
      TacticRow,
      $$TacticsTableFilterComposer,
      $$TacticsTableOrderingComposer,
      $$TacticsTableAnnotationComposer,
      $$TacticsTableCreateCompanionBuilder,
      $$TacticsTableUpdateCompanionBuilder,
      (TacticRow, $$TacticsTableReferences),
      TacticRow,
      PrefetchHooks Function({bool careerId})
    >;
typedef $$LineupSlotsTableCreateCompanionBuilder =
    LineupSlotsCompanion Function({
      required int careerId,
      required int slot,
      Value<int?> playerId,
      Value<int> rowid,
    });
typedef $$LineupSlotsTableUpdateCompanionBuilder =
    LineupSlotsCompanion Function({
      Value<int> careerId,
      Value<int> slot,
      Value<int?> playerId,
      Value<int> rowid,
    });

final class $$LineupSlotsTableReferences
    extends BaseReferences<_$AppDatabase, $LineupSlotsTable, LineupSlotRow> {
  $$LineupSlotsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CareersTable _careerIdTable(_$AppDatabase db) =>
      db.careers.createAlias('lineup_slots__career_id__careers__id');

  $$CareersTableProcessedTableManager get careerId {
    final $_column = $_itemColumn<int>('career_id')!;

    final manager = $$CareersTableTableManager(
      $_db,
      $_db.careers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_careerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LineupSlotsTableFilterComposer
    extends Composer<_$AppDatabase, $LineupSlotsTable> {
  $$LineupSlotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get playerId => $composableBuilder(
    column: $table.playerId,
    builder: (column) => ColumnFilters(column),
  );

  $$CareersTableFilterComposer get careerId {
    final $$CareersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableFilterComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LineupSlotsTableOrderingComposer
    extends Composer<_$AppDatabase, $LineupSlotsTable> {
  $$LineupSlotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get playerId => $composableBuilder(
    column: $table.playerId,
    builder: (column) => ColumnOrderings(column),
  );

  $$CareersTableOrderingComposer get careerId {
    final $$CareersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableOrderingComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LineupSlotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LineupSlotsTable> {
  $$LineupSlotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get slot =>
      $composableBuilder(column: $table.slot, builder: (column) => column);

  GeneratedColumn<int> get playerId =>
      $composableBuilder(column: $table.playerId, builder: (column) => column);

  $$CareersTableAnnotationComposer get careerId {
    final $$CareersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableAnnotationComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LineupSlotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LineupSlotsTable,
          LineupSlotRow,
          $$LineupSlotsTableFilterComposer,
          $$LineupSlotsTableOrderingComposer,
          $$LineupSlotsTableAnnotationComposer,
          $$LineupSlotsTableCreateCompanionBuilder,
          $$LineupSlotsTableUpdateCompanionBuilder,
          (LineupSlotRow, $$LineupSlotsTableReferences),
          LineupSlotRow,
          PrefetchHooks Function({bool careerId})
        > {
  $$LineupSlotsTableTableManager(_$AppDatabase db, $LineupSlotsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LineupSlotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LineupSlotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LineupSlotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> careerId = const Value.absent(),
                Value<int> slot = const Value.absent(),
                Value<int?> playerId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LineupSlotsCompanion(
                careerId: careerId,
                slot: slot,
                playerId: playerId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int careerId,
                required int slot,
                Value<int?> playerId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LineupSlotsCompanion.insert(
                careerId: careerId,
                slot: slot,
                playerId: playerId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LineupSlotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({careerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (careerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.careerId,
                                referencedTable: $$LineupSlotsTableReferences
                                    ._careerIdTable(db),
                                referencedColumn: $$LineupSlotsTableReferences
                                    ._careerIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LineupSlotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LineupSlotsTable,
      LineupSlotRow,
      $$LineupSlotsTableFilterComposer,
      $$LineupSlotsTableOrderingComposer,
      $$LineupSlotsTableAnnotationComposer,
      $$LineupSlotsTableCreateCompanionBuilder,
      $$LineupSlotsTableUpdateCompanionBuilder,
      (LineupSlotRow, $$LineupSlotsTableReferences),
      LineupSlotRow,
      PrefetchHooks Function({bool careerId})
    >;
typedef $$CallUpsTableCreateCompanionBuilder =
    CallUpsCompanion Function({
      required int careerId,
      required int playerId,
      Value<int> rowid,
    });
typedef $$CallUpsTableUpdateCompanionBuilder =
    CallUpsCompanion Function({
      Value<int> careerId,
      Value<int> playerId,
      Value<int> rowid,
    });

final class $$CallUpsTableReferences
    extends BaseReferences<_$AppDatabase, $CallUpsTable, CallUpRow> {
  $$CallUpsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CareersTable _careerIdTable(_$AppDatabase db) =>
      db.careers.createAlias('call_ups__career_id__careers__id');

  $$CareersTableProcessedTableManager get careerId {
    final $_column = $_itemColumn<int>('career_id')!;

    final manager = $$CareersTableTableManager(
      $_db,
      $_db.careers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_careerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CallUpsTableFilterComposer
    extends Composer<_$AppDatabase, $CallUpsTable> {
  $$CallUpsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get playerId => $composableBuilder(
    column: $table.playerId,
    builder: (column) => ColumnFilters(column),
  );

  $$CareersTableFilterComposer get careerId {
    final $$CareersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableFilterComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CallUpsTableOrderingComposer
    extends Composer<_$AppDatabase, $CallUpsTable> {
  $$CallUpsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get playerId => $composableBuilder(
    column: $table.playerId,
    builder: (column) => ColumnOrderings(column),
  );

  $$CareersTableOrderingComposer get careerId {
    final $$CareersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableOrderingComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CallUpsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CallUpsTable> {
  $$CallUpsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get playerId =>
      $composableBuilder(column: $table.playerId, builder: (column) => column);

  $$CareersTableAnnotationComposer get careerId {
    final $$CareersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableAnnotationComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CallUpsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CallUpsTable,
          CallUpRow,
          $$CallUpsTableFilterComposer,
          $$CallUpsTableOrderingComposer,
          $$CallUpsTableAnnotationComposer,
          $$CallUpsTableCreateCompanionBuilder,
          $$CallUpsTableUpdateCompanionBuilder,
          (CallUpRow, $$CallUpsTableReferences),
          CallUpRow,
          PrefetchHooks Function({bool careerId})
        > {
  $$CallUpsTableTableManager(_$AppDatabase db, $CallUpsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CallUpsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CallUpsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CallUpsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> careerId = const Value.absent(),
                Value<int> playerId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CallUpsCompanion(
                careerId: careerId,
                playerId: playerId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int careerId,
                required int playerId,
                Value<int> rowid = const Value.absent(),
              }) => CallUpsCompanion.insert(
                careerId: careerId,
                playerId: playerId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CallUpsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({careerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (careerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.careerId,
                                referencedTable: $$CallUpsTableReferences
                                    ._careerIdTable(db),
                                referencedColumn: $$CallUpsTableReferences
                                    ._careerIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CallUpsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CallUpsTable,
      CallUpRow,
      $$CallUpsTableFilterComposer,
      $$CallUpsTableOrderingComposer,
      $$CallUpsTableAnnotationComposer,
      $$CallUpsTableCreateCompanionBuilder,
      $$CallUpsTableUpdateCompanionBuilder,
      (CallUpRow, $$CallUpsTableReferences),
      CallUpRow,
      PrefetchHooks Function({bool careerId})
    >;
typedef $$GoalEventsTableCreateCompanionBuilder =
    GoalEventsCompanion Function({
      Value<int> id,
      required int careerId,
      required int competitionId,
      required int fixtureId,
      required int nationId,
      required int playerId,
      required int minute,
    });
typedef $$GoalEventsTableUpdateCompanionBuilder =
    GoalEventsCompanion Function({
      Value<int> id,
      Value<int> careerId,
      Value<int> competitionId,
      Value<int> fixtureId,
      Value<int> nationId,
      Value<int> playerId,
      Value<int> minute,
    });

final class $$GoalEventsTableReferences
    extends BaseReferences<_$AppDatabase, $GoalEventsTable, GoalEventRow> {
  $$GoalEventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CareersTable _careerIdTable(_$AppDatabase db) =>
      db.careers.createAlias('goal_events__career_id__careers__id');

  $$CareersTableProcessedTableManager get careerId {
    final $_column = $_itemColumn<int>('career_id')!;

    final manager = $$CareersTableTableManager(
      $_db,
      $_db.careers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_careerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CompetitionsTable _competitionIdTable(_$AppDatabase db) => db
      .competitions
      .createAlias('goal_events__competition_id__competitions__id');

  $$CompetitionsTableProcessedTableManager get competitionId {
    final $_column = $_itemColumn<int>('competition_id')!;

    final manager = $$CompetitionsTableTableManager(
      $_db,
      $_db.competitions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_competitionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FixturesTable _fixtureIdTable(_$AppDatabase db) =>
      db.fixtures.createAlias('goal_events__fixture_id__fixtures__id');

  $$FixturesTableProcessedTableManager get fixtureId {
    final $_column = $_itemColumn<int>('fixture_id')!;

    final manager = $$FixturesTableTableManager(
      $_db,
      $_db.fixtures,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fixtureIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GoalEventsTableFilterComposer
    extends Composer<_$AppDatabase, $GoalEventsTable> {
  $$GoalEventsTableFilterComposer({
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

  ColumnFilters<int> get nationId => $composableBuilder(
    column: $table.nationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get playerId => $composableBuilder(
    column: $table.playerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minute => $composableBuilder(
    column: $table.minute,
    builder: (column) => ColumnFilters(column),
  );

  $$CareersTableFilterComposer get careerId {
    final $$CareersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableFilterComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CompetitionsTableFilterComposer get competitionId {
    final $$CompetitionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.competitionId,
      referencedTable: $db.competitions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompetitionsTableFilterComposer(
            $db: $db,
            $table: $db.competitions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FixturesTableFilterComposer get fixtureId {
    final $$FixturesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fixtureId,
      referencedTable: $db.fixtures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FixturesTableFilterComposer(
            $db: $db,
            $table: $db.fixtures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalEventsTable> {
  $$GoalEventsTableOrderingComposer({
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

  ColumnOrderings<int> get nationId => $composableBuilder(
    column: $table.nationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get playerId => $composableBuilder(
    column: $table.playerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minute => $composableBuilder(
    column: $table.minute,
    builder: (column) => ColumnOrderings(column),
  );

  $$CareersTableOrderingComposer get careerId {
    final $$CareersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableOrderingComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CompetitionsTableOrderingComposer get competitionId {
    final $$CompetitionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.competitionId,
      referencedTable: $db.competitions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompetitionsTableOrderingComposer(
            $db: $db,
            $table: $db.competitions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FixturesTableOrderingComposer get fixtureId {
    final $$FixturesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fixtureId,
      referencedTable: $db.fixtures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FixturesTableOrderingComposer(
            $db: $db,
            $table: $db.fixtures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalEventsTable> {
  $$GoalEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get nationId =>
      $composableBuilder(column: $table.nationId, builder: (column) => column);

  GeneratedColumn<int> get playerId =>
      $composableBuilder(column: $table.playerId, builder: (column) => column);

  GeneratedColumn<int> get minute =>
      $composableBuilder(column: $table.minute, builder: (column) => column);

  $$CareersTableAnnotationComposer get careerId {
    final $$CareersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableAnnotationComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CompetitionsTableAnnotationComposer get competitionId {
    final $$CompetitionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.competitionId,
      referencedTable: $db.competitions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompetitionsTableAnnotationComposer(
            $db: $db,
            $table: $db.competitions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FixturesTableAnnotationComposer get fixtureId {
    final $$FixturesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fixtureId,
      referencedTable: $db.fixtures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FixturesTableAnnotationComposer(
            $db: $db,
            $table: $db.fixtures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalEventsTable,
          GoalEventRow,
          $$GoalEventsTableFilterComposer,
          $$GoalEventsTableOrderingComposer,
          $$GoalEventsTableAnnotationComposer,
          $$GoalEventsTableCreateCompanionBuilder,
          $$GoalEventsTableUpdateCompanionBuilder,
          (GoalEventRow, $$GoalEventsTableReferences),
          GoalEventRow,
          PrefetchHooks Function({
            bool careerId,
            bool competitionId,
            bool fixtureId,
          })
        > {
  $$GoalEventsTableTableManager(_$AppDatabase db, $GoalEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> careerId = const Value.absent(),
                Value<int> competitionId = const Value.absent(),
                Value<int> fixtureId = const Value.absent(),
                Value<int> nationId = const Value.absent(),
                Value<int> playerId = const Value.absent(),
                Value<int> minute = const Value.absent(),
              }) => GoalEventsCompanion(
                id: id,
                careerId: careerId,
                competitionId: competitionId,
                fixtureId: fixtureId,
                nationId: nationId,
                playerId: playerId,
                minute: minute,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int careerId,
                required int competitionId,
                required int fixtureId,
                required int nationId,
                required int playerId,
                required int minute,
              }) => GoalEventsCompanion.insert(
                id: id,
                careerId: careerId,
                competitionId: competitionId,
                fixtureId: fixtureId,
                nationId: nationId,
                playerId: playerId,
                minute: minute,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GoalEventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({careerId = false, competitionId = false, fixtureId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (careerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.careerId,
                                    referencedTable: $$GoalEventsTableReferences
                                        ._careerIdTable(db),
                                    referencedColumn:
                                        $$GoalEventsTableReferences
                                            ._careerIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (competitionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.competitionId,
                                    referencedTable: $$GoalEventsTableReferences
                                        ._competitionIdTable(db),
                                    referencedColumn:
                                        $$GoalEventsTableReferences
                                            ._competitionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (fixtureId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.fixtureId,
                                    referencedTable: $$GoalEventsTableReferences
                                        ._fixtureIdTable(db),
                                    referencedColumn:
                                        $$GoalEventsTableReferences
                                            ._fixtureIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$GoalEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalEventsTable,
      GoalEventRow,
      $$GoalEventsTableFilterComposer,
      $$GoalEventsTableOrderingComposer,
      $$GoalEventsTableAnnotationComposer,
      $$GoalEventsTableCreateCompanionBuilder,
      $$GoalEventsTableUpdateCompanionBuilder,
      (GoalEventRow, $$GoalEventsTableReferences),
      GoalEventRow,
      PrefetchHooks Function({
        bool careerId,
        bool competitionId,
        bool fixtureId,
      })
    >;
typedef $$HonoursTableCreateCompanionBuilder =
    HonoursCompanion Function({
      Value<int> id,
      required int careerId,
      required int year,
      required String competition,
      required int championId,
      required int runnerUpId,
      Value<int?> thirdId,
      Value<int?> hostId,
      Value<int?> finalHomeScore,
      Value<int?> finalAwayScore,
      Value<String?> topScorerName,
      Value<int?> topScorerGoals,
    });
typedef $$HonoursTableUpdateCompanionBuilder =
    HonoursCompanion Function({
      Value<int> id,
      Value<int> careerId,
      Value<int> year,
      Value<String> competition,
      Value<int> championId,
      Value<int> runnerUpId,
      Value<int?> thirdId,
      Value<int?> hostId,
      Value<int?> finalHomeScore,
      Value<int?> finalAwayScore,
      Value<String?> topScorerName,
      Value<int?> topScorerGoals,
    });

final class $$HonoursTableReferences
    extends BaseReferences<_$AppDatabase, $HonoursTable, HonourRow> {
  $$HonoursTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CareersTable _careerIdTable(_$AppDatabase db) =>
      db.careers.createAlias('honours__career_id__careers__id');

  $$CareersTableProcessedTableManager get careerId {
    final $_column = $_itemColumn<int>('career_id')!;

    final manager = $$CareersTableTableManager(
      $_db,
      $_db.careers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_careerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HonoursTableFilterComposer
    extends Composer<_$AppDatabase, $HonoursTable> {
  $$HonoursTableFilterComposer({
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

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get competition => $composableBuilder(
    column: $table.competition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get championId => $composableBuilder(
    column: $table.championId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get runnerUpId => $composableBuilder(
    column: $table.runnerUpId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get thirdId => $composableBuilder(
    column: $table.thirdId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hostId => $composableBuilder(
    column: $table.hostId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get finalHomeScore => $composableBuilder(
    column: $table.finalHomeScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get finalAwayScore => $composableBuilder(
    column: $table.finalAwayScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topScorerName => $composableBuilder(
    column: $table.topScorerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get topScorerGoals => $composableBuilder(
    column: $table.topScorerGoals,
    builder: (column) => ColumnFilters(column),
  );

  $$CareersTableFilterComposer get careerId {
    final $$CareersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableFilterComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HonoursTableOrderingComposer
    extends Composer<_$AppDatabase, $HonoursTable> {
  $$HonoursTableOrderingComposer({
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

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get competition => $composableBuilder(
    column: $table.competition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get championId => $composableBuilder(
    column: $table.championId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get runnerUpId => $composableBuilder(
    column: $table.runnerUpId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get thirdId => $composableBuilder(
    column: $table.thirdId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hostId => $composableBuilder(
    column: $table.hostId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get finalHomeScore => $composableBuilder(
    column: $table.finalHomeScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get finalAwayScore => $composableBuilder(
    column: $table.finalAwayScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topScorerName => $composableBuilder(
    column: $table.topScorerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get topScorerGoals => $composableBuilder(
    column: $table.topScorerGoals,
    builder: (column) => ColumnOrderings(column),
  );

  $$CareersTableOrderingComposer get careerId {
    final $$CareersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableOrderingComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HonoursTableAnnotationComposer
    extends Composer<_$AppDatabase, $HonoursTable> {
  $$HonoursTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get competition => $composableBuilder(
    column: $table.competition,
    builder: (column) => column,
  );

  GeneratedColumn<int> get championId => $composableBuilder(
    column: $table.championId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get runnerUpId => $composableBuilder(
    column: $table.runnerUpId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get thirdId =>
      $composableBuilder(column: $table.thirdId, builder: (column) => column);

  GeneratedColumn<int> get hostId =>
      $composableBuilder(column: $table.hostId, builder: (column) => column);

  GeneratedColumn<int> get finalHomeScore => $composableBuilder(
    column: $table.finalHomeScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get finalAwayScore => $composableBuilder(
    column: $table.finalAwayScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get topScorerName => $composableBuilder(
    column: $table.topScorerName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get topScorerGoals => $composableBuilder(
    column: $table.topScorerGoals,
    builder: (column) => column,
  );

  $$CareersTableAnnotationComposer get careerId {
    final $$CareersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableAnnotationComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HonoursTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HonoursTable,
          HonourRow,
          $$HonoursTableFilterComposer,
          $$HonoursTableOrderingComposer,
          $$HonoursTableAnnotationComposer,
          $$HonoursTableCreateCompanionBuilder,
          $$HonoursTableUpdateCompanionBuilder,
          (HonourRow, $$HonoursTableReferences),
          HonourRow,
          PrefetchHooks Function({bool careerId})
        > {
  $$HonoursTableTableManager(_$AppDatabase db, $HonoursTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HonoursTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HonoursTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HonoursTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> careerId = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<String> competition = const Value.absent(),
                Value<int> championId = const Value.absent(),
                Value<int> runnerUpId = const Value.absent(),
                Value<int?> thirdId = const Value.absent(),
                Value<int?> hostId = const Value.absent(),
                Value<int?> finalHomeScore = const Value.absent(),
                Value<int?> finalAwayScore = const Value.absent(),
                Value<String?> topScorerName = const Value.absent(),
                Value<int?> topScorerGoals = const Value.absent(),
              }) => HonoursCompanion(
                id: id,
                careerId: careerId,
                year: year,
                competition: competition,
                championId: championId,
                runnerUpId: runnerUpId,
                thirdId: thirdId,
                hostId: hostId,
                finalHomeScore: finalHomeScore,
                finalAwayScore: finalAwayScore,
                topScorerName: topScorerName,
                topScorerGoals: topScorerGoals,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int careerId,
                required int year,
                required String competition,
                required int championId,
                required int runnerUpId,
                Value<int?> thirdId = const Value.absent(),
                Value<int?> hostId = const Value.absent(),
                Value<int?> finalHomeScore = const Value.absent(),
                Value<int?> finalAwayScore = const Value.absent(),
                Value<String?> topScorerName = const Value.absent(),
                Value<int?> topScorerGoals = const Value.absent(),
              }) => HonoursCompanion.insert(
                id: id,
                careerId: careerId,
                year: year,
                competition: competition,
                championId: championId,
                runnerUpId: runnerUpId,
                thirdId: thirdId,
                hostId: hostId,
                finalHomeScore: finalHomeScore,
                finalAwayScore: finalAwayScore,
                topScorerName: topScorerName,
                topScorerGoals: topScorerGoals,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HonoursTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({careerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (careerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.careerId,
                                referencedTable: $$HonoursTableReferences
                                    ._careerIdTable(db),
                                referencedColumn: $$HonoursTableReferences
                                    ._careerIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$HonoursTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HonoursTable,
      HonourRow,
      $$HonoursTableFilterComposer,
      $$HonoursTableOrderingComposer,
      $$HonoursTableAnnotationComposer,
      $$HonoursTableCreateCompanionBuilder,
      $$HonoursTableUpdateCompanionBuilder,
      (HonourRow, $$HonoursTableReferences),
      HonourRow,
      PrefetchHooks Function({bool careerId})
    >;
typedef $$DrawsWatchedTableCreateCompanionBuilder =
    DrawsWatchedCompanion Function({
      required int careerId,
      required int cycle,
      required String kind,
      Value<int> rowid,
    });
typedef $$DrawsWatchedTableUpdateCompanionBuilder =
    DrawsWatchedCompanion Function({
      Value<int> careerId,
      Value<int> cycle,
      Value<String> kind,
      Value<int> rowid,
    });

final class $$DrawsWatchedTableReferences
    extends BaseReferences<_$AppDatabase, $DrawsWatchedTable, DrawWatchedRow> {
  $$DrawsWatchedTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CareersTable _careerIdTable(_$AppDatabase db) =>
      db.careers.createAlias('draws_watched__career_id__careers__id');

  $$CareersTableProcessedTableManager get careerId {
    final $_column = $_itemColumn<int>('career_id')!;

    final manager = $$CareersTableTableManager(
      $_db,
      $_db.careers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_careerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DrawsWatchedTableFilterComposer
    extends Composer<_$AppDatabase, $DrawsWatchedTable> {
  $$DrawsWatchedTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get cycle => $composableBuilder(
    column: $table.cycle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  $$CareersTableFilterComposer get careerId {
    final $$CareersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableFilterComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DrawsWatchedTableOrderingComposer
    extends Composer<_$AppDatabase, $DrawsWatchedTable> {
  $$DrawsWatchedTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get cycle => $composableBuilder(
    column: $table.cycle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  $$CareersTableOrderingComposer get careerId {
    final $$CareersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableOrderingComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DrawsWatchedTableAnnotationComposer
    extends Composer<_$AppDatabase, $DrawsWatchedTable> {
  $$DrawsWatchedTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get cycle =>
      $composableBuilder(column: $table.cycle, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  $$CareersTableAnnotationComposer get careerId {
    final $$CareersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableAnnotationComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DrawsWatchedTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DrawsWatchedTable,
          DrawWatchedRow,
          $$DrawsWatchedTableFilterComposer,
          $$DrawsWatchedTableOrderingComposer,
          $$DrawsWatchedTableAnnotationComposer,
          $$DrawsWatchedTableCreateCompanionBuilder,
          $$DrawsWatchedTableUpdateCompanionBuilder,
          (DrawWatchedRow, $$DrawsWatchedTableReferences),
          DrawWatchedRow,
          PrefetchHooks Function({bool careerId})
        > {
  $$DrawsWatchedTableTableManager(_$AppDatabase db, $DrawsWatchedTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DrawsWatchedTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DrawsWatchedTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DrawsWatchedTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> careerId = const Value.absent(),
                Value<int> cycle = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DrawsWatchedCompanion(
                careerId: careerId,
                cycle: cycle,
                kind: kind,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int careerId,
                required int cycle,
                required String kind,
                Value<int> rowid = const Value.absent(),
              }) => DrawsWatchedCompanion.insert(
                careerId: careerId,
                cycle: cycle,
                kind: kind,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DrawsWatchedTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({careerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (careerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.careerId,
                                referencedTable: $$DrawsWatchedTableReferences
                                    ._careerIdTable(db),
                                referencedColumn: $$DrawsWatchedTableReferences
                                    ._careerIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DrawsWatchedTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DrawsWatchedTable,
      DrawWatchedRow,
      $$DrawsWatchedTableFilterComposer,
      $$DrawsWatchedTableOrderingComposer,
      $$DrawsWatchedTableAnnotationComposer,
      $$DrawsWatchedTableCreateCompanionBuilder,
      $$DrawsWatchedTableUpdateCompanionBuilder,
      (DrawWatchedRow, $$DrawsWatchedTableReferences),
      DrawWatchedRow,
      PrefetchHooks Function({bool careerId})
    >;
typedef $$PlayerAbsencesTableCreateCompanionBuilder =
    PlayerAbsencesCompanion Function({
      required int careerId,
      required int playerId,
      Value<int> yellows,
      Value<int> banMatches,
      Value<int> injuryMatches,
      Value<int> rowid,
    });
typedef $$PlayerAbsencesTableUpdateCompanionBuilder =
    PlayerAbsencesCompanion Function({
      Value<int> careerId,
      Value<int> playerId,
      Value<int> yellows,
      Value<int> banMatches,
      Value<int> injuryMatches,
      Value<int> rowid,
    });

final class $$PlayerAbsencesTableReferences
    extends
        BaseReferences<_$AppDatabase, $PlayerAbsencesTable, PlayerAbsenceRow> {
  $$PlayerAbsencesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CareersTable _careerIdTable(_$AppDatabase db) =>
      db.careers.createAlias('player_absences__career_id__careers__id');

  $$CareersTableProcessedTableManager get careerId {
    final $_column = $_itemColumn<int>('career_id')!;

    final manager = $$CareersTableTableManager(
      $_db,
      $_db.careers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_careerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlayerAbsencesTableFilterComposer
    extends Composer<_$AppDatabase, $PlayerAbsencesTable> {
  $$PlayerAbsencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get playerId => $composableBuilder(
    column: $table.playerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get yellows => $composableBuilder(
    column: $table.yellows,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get banMatches => $composableBuilder(
    column: $table.banMatches,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get injuryMatches => $composableBuilder(
    column: $table.injuryMatches,
    builder: (column) => ColumnFilters(column),
  );

  $$CareersTableFilterComposer get careerId {
    final $$CareersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableFilterComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayerAbsencesTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayerAbsencesTable> {
  $$PlayerAbsencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get playerId => $composableBuilder(
    column: $table.playerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get yellows => $composableBuilder(
    column: $table.yellows,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get banMatches => $composableBuilder(
    column: $table.banMatches,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get injuryMatches => $composableBuilder(
    column: $table.injuryMatches,
    builder: (column) => ColumnOrderings(column),
  );

  $$CareersTableOrderingComposer get careerId {
    final $$CareersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableOrderingComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayerAbsencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayerAbsencesTable> {
  $$PlayerAbsencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get playerId =>
      $composableBuilder(column: $table.playerId, builder: (column) => column);

  GeneratedColumn<int> get yellows =>
      $composableBuilder(column: $table.yellows, builder: (column) => column);

  GeneratedColumn<int> get banMatches => $composableBuilder(
    column: $table.banMatches,
    builder: (column) => column,
  );

  GeneratedColumn<int> get injuryMatches => $composableBuilder(
    column: $table.injuryMatches,
    builder: (column) => column,
  );

  $$CareersTableAnnotationComposer get careerId {
    final $$CareersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableAnnotationComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayerAbsencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayerAbsencesTable,
          PlayerAbsenceRow,
          $$PlayerAbsencesTableFilterComposer,
          $$PlayerAbsencesTableOrderingComposer,
          $$PlayerAbsencesTableAnnotationComposer,
          $$PlayerAbsencesTableCreateCompanionBuilder,
          $$PlayerAbsencesTableUpdateCompanionBuilder,
          (PlayerAbsenceRow, $$PlayerAbsencesTableReferences),
          PlayerAbsenceRow,
          PrefetchHooks Function({bool careerId})
        > {
  $$PlayerAbsencesTableTableManager(
    _$AppDatabase db,
    $PlayerAbsencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayerAbsencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayerAbsencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayerAbsencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> careerId = const Value.absent(),
                Value<int> playerId = const Value.absent(),
                Value<int> yellows = const Value.absent(),
                Value<int> banMatches = const Value.absent(),
                Value<int> injuryMatches = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlayerAbsencesCompanion(
                careerId: careerId,
                playerId: playerId,
                yellows: yellows,
                banMatches: banMatches,
                injuryMatches: injuryMatches,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int careerId,
                required int playerId,
                Value<int> yellows = const Value.absent(),
                Value<int> banMatches = const Value.absent(),
                Value<int> injuryMatches = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlayerAbsencesCompanion.insert(
                careerId: careerId,
                playerId: playerId,
                yellows: yellows,
                banMatches: banMatches,
                injuryMatches: injuryMatches,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlayerAbsencesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({careerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (careerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.careerId,
                                referencedTable: $$PlayerAbsencesTableReferences
                                    ._careerIdTable(db),
                                referencedColumn:
                                    $$PlayerAbsencesTableReferences
                                        ._careerIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlayerAbsencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayerAbsencesTable,
      PlayerAbsenceRow,
      $$PlayerAbsencesTableFilterComposer,
      $$PlayerAbsencesTableOrderingComposer,
      $$PlayerAbsencesTableAnnotationComposer,
      $$PlayerAbsencesTableCreateCompanionBuilder,
      $$PlayerAbsencesTableUpdateCompanionBuilder,
      (PlayerAbsenceRow, $$PlayerAbsencesTableReferences),
      PlayerAbsenceRow,
      PrefetchHooks Function({bool careerId})
    >;
typedef $$RankPointsTableCreateCompanionBuilder =
    RankPointsCompanion Function({
      required int careerId,
      required int nationId,
      required int points,
      Value<int> rowid,
    });
typedef $$RankPointsTableUpdateCompanionBuilder =
    RankPointsCompanion Function({
      Value<int> careerId,
      Value<int> nationId,
      Value<int> points,
      Value<int> rowid,
    });

final class $$RankPointsTableReferences
    extends BaseReferences<_$AppDatabase, $RankPointsTable, RankPointRow> {
  $$RankPointsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CareersTable _careerIdTable(_$AppDatabase db) =>
      db.careers.createAlias('rank_points__career_id__careers__id');

  $$CareersTableProcessedTableManager get careerId {
    final $_column = $_itemColumn<int>('career_id')!;

    final manager = $$CareersTableTableManager(
      $_db,
      $_db.careers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_careerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RankPointsTableFilterComposer
    extends Composer<_$AppDatabase, $RankPointsTable> {
  $$RankPointsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get nationId => $composableBuilder(
    column: $table.nationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnFilters(column),
  );

  $$CareersTableFilterComposer get careerId {
    final $$CareersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableFilterComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RankPointsTableOrderingComposer
    extends Composer<_$AppDatabase, $RankPointsTable> {
  $$RankPointsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get nationId => $composableBuilder(
    column: $table.nationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnOrderings(column),
  );

  $$CareersTableOrderingComposer get careerId {
    final $$CareersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableOrderingComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RankPointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RankPointsTable> {
  $$RankPointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get nationId =>
      $composableBuilder(column: $table.nationId, builder: (column) => column);

  GeneratedColumn<int> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

  $$CareersTableAnnotationComposer get careerId {
    final $$CareersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableAnnotationComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RankPointsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RankPointsTable,
          RankPointRow,
          $$RankPointsTableFilterComposer,
          $$RankPointsTableOrderingComposer,
          $$RankPointsTableAnnotationComposer,
          $$RankPointsTableCreateCompanionBuilder,
          $$RankPointsTableUpdateCompanionBuilder,
          (RankPointRow, $$RankPointsTableReferences),
          RankPointRow,
          PrefetchHooks Function({bool careerId})
        > {
  $$RankPointsTableTableManager(_$AppDatabase db, $RankPointsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RankPointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RankPointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RankPointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> careerId = const Value.absent(),
                Value<int> nationId = const Value.absent(),
                Value<int> points = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RankPointsCompanion(
                careerId: careerId,
                nationId: nationId,
                points: points,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int careerId,
                required int nationId,
                required int points,
                Value<int> rowid = const Value.absent(),
              }) => RankPointsCompanion.insert(
                careerId: careerId,
                nationId: nationId,
                points: points,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RankPointsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({careerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (careerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.careerId,
                                referencedTable: $$RankPointsTableReferences
                                    ._careerIdTable(db),
                                referencedColumn: $$RankPointsTableReferences
                                    ._careerIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RankPointsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RankPointsTable,
      RankPointRow,
      $$RankPointsTableFilterComposer,
      $$RankPointsTableOrderingComposer,
      $$RankPointsTableAnnotationComposer,
      $$RankPointsTableCreateCompanionBuilder,
      $$RankPointsTableUpdateCompanionBuilder,
      (RankPointRow, $$RankPointsTableReferences),
      RankPointRow,
      PrefetchHooks Function({bool careerId})
    >;
typedef $$SeedRankingsTableCreateCompanionBuilder =
    SeedRankingsCompanion Function({
      required int careerId,
      required int cycle,
      required int nationId,
      required int rank,
      Value<int> rowid,
    });
typedef $$SeedRankingsTableUpdateCompanionBuilder =
    SeedRankingsCompanion Function({
      Value<int> careerId,
      Value<int> cycle,
      Value<int> nationId,
      Value<int> rank,
      Value<int> rowid,
    });

final class $$SeedRankingsTableReferences
    extends BaseReferences<_$AppDatabase, $SeedRankingsTable, SeedRankingRow> {
  $$SeedRankingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CareersTable _careerIdTable(_$AppDatabase db) =>
      db.careers.createAlias('seed_rankings__career_id__careers__id');

  $$CareersTableProcessedTableManager get careerId {
    final $_column = $_itemColumn<int>('career_id')!;

    final manager = $$CareersTableTableManager(
      $_db,
      $_db.careers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_careerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SeedRankingsTableFilterComposer
    extends Composer<_$AppDatabase, $SeedRankingsTable> {
  $$SeedRankingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get cycle => $composableBuilder(
    column: $table.cycle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nationId => $composableBuilder(
    column: $table.nationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnFilters(column),
  );

  $$CareersTableFilterComposer get careerId {
    final $$CareersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableFilterComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SeedRankingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SeedRankingsTable> {
  $$SeedRankingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get cycle => $composableBuilder(
    column: $table.cycle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nationId => $composableBuilder(
    column: $table.nationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnOrderings(column),
  );

  $$CareersTableOrderingComposer get careerId {
    final $$CareersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableOrderingComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SeedRankingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SeedRankingsTable> {
  $$SeedRankingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get cycle =>
      $composableBuilder(column: $table.cycle, builder: (column) => column);

  GeneratedColumn<int> get nationId =>
      $composableBuilder(column: $table.nationId, builder: (column) => column);

  GeneratedColumn<int> get rank =>
      $composableBuilder(column: $table.rank, builder: (column) => column);

  $$CareersTableAnnotationComposer get careerId {
    final $$CareersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.careerId,
      referencedTable: $db.careers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareersTableAnnotationComposer(
            $db: $db,
            $table: $db.careers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SeedRankingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SeedRankingsTable,
          SeedRankingRow,
          $$SeedRankingsTableFilterComposer,
          $$SeedRankingsTableOrderingComposer,
          $$SeedRankingsTableAnnotationComposer,
          $$SeedRankingsTableCreateCompanionBuilder,
          $$SeedRankingsTableUpdateCompanionBuilder,
          (SeedRankingRow, $$SeedRankingsTableReferences),
          SeedRankingRow,
          PrefetchHooks Function({bool careerId})
        > {
  $$SeedRankingsTableTableManager(_$AppDatabase db, $SeedRankingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SeedRankingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SeedRankingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SeedRankingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> careerId = const Value.absent(),
                Value<int> cycle = const Value.absent(),
                Value<int> nationId = const Value.absent(),
                Value<int> rank = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SeedRankingsCompanion(
                careerId: careerId,
                cycle: cycle,
                nationId: nationId,
                rank: rank,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int careerId,
                required int cycle,
                required int nationId,
                required int rank,
                Value<int> rowid = const Value.absent(),
              }) => SeedRankingsCompanion.insert(
                careerId: careerId,
                cycle: cycle,
                nationId: nationId,
                rank: rank,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SeedRankingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({careerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (careerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.careerId,
                                referencedTable: $$SeedRankingsTableReferences
                                    ._careerIdTable(db),
                                referencedColumn: $$SeedRankingsTableReferences
                                    ._careerIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SeedRankingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SeedRankingsTable,
      SeedRankingRow,
      $$SeedRankingsTableFilterComposer,
      $$SeedRankingsTableOrderingComposer,
      $$SeedRankingsTableAnnotationComposer,
      $$SeedRankingsTableCreateCompanionBuilder,
      $$SeedRankingsTableUpdateCompanionBuilder,
      (SeedRankingRow, $$SeedRankingsTableReferences),
      SeedRankingRow,
      PrefetchHooks Function({bool careerId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NationsTableTableManager get nations =>
      $$NationsTableTableManager(_db, _db.nations);
  $$PlayersTableTableManager get players =>
      $$PlayersTableTableManager(_db, _db.players);
  $$CareersTableTableManager get careers =>
      $$CareersTableTableManager(_db, _db.careers);
  $$CompetitionsTableTableManager get competitions =>
      $$CompetitionsTableTableManager(_db, _db.competitions);
  $$QualifyingGroupsTableTableManager get qualifyingGroups =>
      $$QualifyingGroupsTableTableManager(_db, _db.qualifyingGroups);
  $$GroupMembersTableTableManager get groupMembers =>
      $$GroupMembersTableTableManager(_db, _db.groupMembers);
  $$FixturesTableTableManager get fixtures =>
      $$FixturesTableTableManager(_db, _db.fixtures);
  $$TacticsTableTableManager get tactics =>
      $$TacticsTableTableManager(_db, _db.tactics);
  $$LineupSlotsTableTableManager get lineupSlots =>
      $$LineupSlotsTableTableManager(_db, _db.lineupSlots);
  $$CallUpsTableTableManager get callUps =>
      $$CallUpsTableTableManager(_db, _db.callUps);
  $$GoalEventsTableTableManager get goalEvents =>
      $$GoalEventsTableTableManager(_db, _db.goalEvents);
  $$HonoursTableTableManager get honours =>
      $$HonoursTableTableManager(_db, _db.honours);
  $$DrawsWatchedTableTableManager get drawsWatched =>
      $$DrawsWatchedTableTableManager(_db, _db.drawsWatched);
  $$PlayerAbsencesTableTableManager get playerAbsences =>
      $$PlayerAbsencesTableTableManager(_db, _db.playerAbsences);
  $$RankPointsTableTableManager get rankPoints =>
      $$RankPointsTableTableManager(_db, _db.rankPoints);
  $$SeedRankingsTableTableManager get seedRankings =>
      $$SeedRankingsTableTableManager(_db, _db.seedRankings);
}
