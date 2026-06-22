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
          ..write('strength: $strength')
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
          other.strength == this.strength);
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
          ..write('strength: $strength')
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NationsTable nations = $NationsTable(this);
  late final $PlayersTable players = $PlayersTable(this);
  late final $CareersTable careers = $CareersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    nations,
    players,
    careers,
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
          PrefetchHooks Function({bool nationId})
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
                return [];
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
      PrefetchHooks Function({bool nationId})
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
}
