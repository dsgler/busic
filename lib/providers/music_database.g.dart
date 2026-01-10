// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_database.dart';

// ignore_for_file: type=lint
class $MusicItemsTable extends MusicItems
    with TableInfo<$MusicItemsTable, MusicItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MusicItemsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _storageKeyMeta = const VerificationMeta(
    'storageKey',
  );
  @override
  late final GeneratedColumn<String> storageKey = GeneratedColumn<String>(
    'storage_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bvidMeta = const VerificationMeta('bvid');
  @override
  late final GeneratedColumn<String> bvid = GeneratedColumn<String>(
    'bvid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cidMeta = const VerificationMeta('cid');
  @override
  late final GeneratedColumn<int> cid = GeneratedColumn<int>(
    'cid',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _artistMeta = const VerificationMeta('artist');
  @override
  late final GeneratedColumn<String> artist = GeneratedColumn<String>(
    'artist',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coverUrlMeta = const VerificationMeta(
    'coverUrl',
  );
  @override
  late final GeneratedColumn<String> coverUrl = GeneratedColumn<String>(
    'cover_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storageKey,
    bvid,
    cid,
    title,
    artist,
    coverUrl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'music_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<MusicItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('storage_key')) {
      context.handle(
        _storageKeyMeta,
        storageKey.isAcceptableOrUnknown(data['storage_key']!, _storageKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_storageKeyMeta);
    }
    if (data.containsKey('bvid')) {
      context.handle(
        _bvidMeta,
        bvid.isAcceptableOrUnknown(data['bvid']!, _bvidMeta),
      );
    } else if (isInserting) {
      context.missing(_bvidMeta);
    }
    if (data.containsKey('cid')) {
      context.handle(
        _cidMeta,
        cid.isAcceptableOrUnknown(data['cid']!, _cidMeta),
      );
    } else if (isInserting) {
      context.missing(_cidMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('artist')) {
      context.handle(
        _artistMeta,
        artist.isAcceptableOrUnknown(data['artist']!, _artistMeta),
      );
    } else if (isInserting) {
      context.missing(_artistMeta);
    }
    if (data.containsKey('cover_url')) {
      context.handle(
        _coverUrlMeta,
        coverUrl.isAcceptableOrUnknown(data['cover_url']!, _coverUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MusicItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MusicItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      storageKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}storage_key'],
      )!,
      bvid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bvid'],
      )!,
      cid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cid'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      artist: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artist'],
      )!,
      coverUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_url'],
      ),
    );
  }

  @override
  $MusicItemsTable createAlias(String alias) {
    return $MusicItemsTable(attachedDatabase, alias);
  }
}

class MusicItem extends DataClass implements Insertable<MusicItem> {
  final int id;
  final String storageKey;
  final String bvid;
  final int cid;
  final String title;
  final String artist;
  final String? coverUrl;
  const MusicItem({
    required this.id,
    required this.storageKey,
    required this.bvid,
    required this.cid,
    required this.title,
    required this.artist,
    this.coverUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['storage_key'] = Variable<String>(storageKey);
    map['bvid'] = Variable<String>(bvid);
    map['cid'] = Variable<int>(cid);
    map['title'] = Variable<String>(title);
    map['artist'] = Variable<String>(artist);
    if (!nullToAbsent || coverUrl != null) {
      map['cover_url'] = Variable<String>(coverUrl);
    }
    return map;
  }

  MusicItemsCompanion toCompanion(bool nullToAbsent) {
    return MusicItemsCompanion(
      id: Value(id),
      storageKey: Value(storageKey),
      bvid: Value(bvid),
      cid: Value(cid),
      title: Value(title),
      artist: Value(artist),
      coverUrl: coverUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(coverUrl),
    );
  }

  factory MusicItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MusicItem(
      id: serializer.fromJson<int>(json['id']),
      storageKey: serializer.fromJson<String>(json['storageKey']),
      bvid: serializer.fromJson<String>(json['bvid']),
      cid: serializer.fromJson<int>(json['cid']),
      title: serializer.fromJson<String>(json['title']),
      artist: serializer.fromJson<String>(json['artist']),
      coverUrl: serializer.fromJson<String?>(json['coverUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'storageKey': serializer.toJson<String>(storageKey),
      'bvid': serializer.toJson<String>(bvid),
      'cid': serializer.toJson<int>(cid),
      'title': serializer.toJson<String>(title),
      'artist': serializer.toJson<String>(artist),
      'coverUrl': serializer.toJson<String?>(coverUrl),
    };
  }

  MusicItem copyWith({
    int? id,
    String? storageKey,
    String? bvid,
    int? cid,
    String? title,
    String? artist,
    Value<String?> coverUrl = const Value.absent(),
  }) => MusicItem(
    id: id ?? this.id,
    storageKey: storageKey ?? this.storageKey,
    bvid: bvid ?? this.bvid,
    cid: cid ?? this.cid,
    title: title ?? this.title,
    artist: artist ?? this.artist,
    coverUrl: coverUrl.present ? coverUrl.value : this.coverUrl,
  );
  MusicItem copyWithCompanion(MusicItemsCompanion data) {
    return MusicItem(
      id: data.id.present ? data.id.value : this.id,
      storageKey: data.storageKey.present
          ? data.storageKey.value
          : this.storageKey,
      bvid: data.bvid.present ? data.bvid.value : this.bvid,
      cid: data.cid.present ? data.cid.value : this.cid,
      title: data.title.present ? data.title.value : this.title,
      artist: data.artist.present ? data.artist.value : this.artist,
      coverUrl: data.coverUrl.present ? data.coverUrl.value : this.coverUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MusicItem(')
          ..write('id: $id, ')
          ..write('storageKey: $storageKey, ')
          ..write('bvid: $bvid, ')
          ..write('cid: $cid, ')
          ..write('title: $title, ')
          ..write('artist: $artist, ')
          ..write('coverUrl: $coverUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, storageKey, bvid, cid, title, artist, coverUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MusicItem &&
          other.id == this.id &&
          other.storageKey == this.storageKey &&
          other.bvid == this.bvid &&
          other.cid == this.cid &&
          other.title == this.title &&
          other.artist == this.artist &&
          other.coverUrl == this.coverUrl);
}

class MusicItemsCompanion extends UpdateCompanion<MusicItem> {
  final Value<int> id;
  final Value<String> storageKey;
  final Value<String> bvid;
  final Value<int> cid;
  final Value<String> title;
  final Value<String> artist;
  final Value<String?> coverUrl;
  const MusicItemsCompanion({
    this.id = const Value.absent(),
    this.storageKey = const Value.absent(),
    this.bvid = const Value.absent(),
    this.cid = const Value.absent(),
    this.title = const Value.absent(),
    this.artist = const Value.absent(),
    this.coverUrl = const Value.absent(),
  });
  MusicItemsCompanion.insert({
    this.id = const Value.absent(),
    required String storageKey,
    required String bvid,
    required int cid,
    required String title,
    required String artist,
    this.coverUrl = const Value.absent(),
  }) : storageKey = Value(storageKey),
       bvid = Value(bvid),
       cid = Value(cid),
       title = Value(title),
       artist = Value(artist);
  static Insertable<MusicItem> custom({
    Expression<int>? id,
    Expression<String>? storageKey,
    Expression<String>? bvid,
    Expression<int>? cid,
    Expression<String>? title,
    Expression<String>? artist,
    Expression<String>? coverUrl,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storageKey != null) 'storage_key': storageKey,
      if (bvid != null) 'bvid': bvid,
      if (cid != null) 'cid': cid,
      if (title != null) 'title': title,
      if (artist != null) 'artist': artist,
      if (coverUrl != null) 'cover_url': coverUrl,
    });
  }

  MusicItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? storageKey,
    Value<String>? bvid,
    Value<int>? cid,
    Value<String>? title,
    Value<String>? artist,
    Value<String?>? coverUrl,
  }) {
    return MusicItemsCompanion(
      id: id ?? this.id,
      storageKey: storageKey ?? this.storageKey,
      bvid: bvid ?? this.bvid,
      cid: cid ?? this.cid,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      coverUrl: coverUrl ?? this.coverUrl,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (storageKey.present) {
      map['storage_key'] = Variable<String>(storageKey.value);
    }
    if (bvid.present) {
      map['bvid'] = Variable<String>(bvid.value);
    }
    if (cid.present) {
      map['cid'] = Variable<int>(cid.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (artist.present) {
      map['artist'] = Variable<String>(artist.value);
    }
    if (coverUrl.present) {
      map['cover_url'] = Variable<String>(coverUrl.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MusicItemsCompanion(')
          ..write('id: $id, ')
          ..write('storageKey: $storageKey, ')
          ..write('bvid: $bvid, ')
          ..write('cid: $cid, ')
          ..write('title: $title, ')
          ..write('artist: $artist, ')
          ..write('coverUrl: $coverUrl')
          ..write(')'))
        .toString();
  }
}

abstract class _$MusicDatabase extends GeneratedDatabase {
  _$MusicDatabase(QueryExecutor e) : super(e);
  $MusicDatabaseManager get managers => $MusicDatabaseManager(this);
  late final $MusicItemsTable musicItems = $MusicItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [musicItems];
}

typedef $$MusicItemsTableCreateCompanionBuilder =
    MusicItemsCompanion Function({
      Value<int> id,
      required String storageKey,
      required String bvid,
      required int cid,
      required String title,
      required String artist,
      Value<String?> coverUrl,
    });
typedef $$MusicItemsTableUpdateCompanionBuilder =
    MusicItemsCompanion Function({
      Value<int> id,
      Value<String> storageKey,
      Value<String> bvid,
      Value<int> cid,
      Value<String> title,
      Value<String> artist,
      Value<String?> coverUrl,
    });

class $$MusicItemsTableFilterComposer
    extends Composer<_$MusicDatabase, $MusicItemsTable> {
  $$MusicItemsTableFilterComposer({
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

  ColumnFilters<String> get storageKey => $composableBuilder(
    column: $table.storageKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bvid => $composableBuilder(
    column: $table.bvid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cid => $composableBuilder(
    column: $table.cid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artist => $composableBuilder(
    column: $table.artist,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MusicItemsTableOrderingComposer
    extends Composer<_$MusicDatabase, $MusicItemsTable> {
  $$MusicItemsTableOrderingComposer({
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

  ColumnOrderings<String> get storageKey => $composableBuilder(
    column: $table.storageKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bvid => $composableBuilder(
    column: $table.bvid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cid => $composableBuilder(
    column: $table.cid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artist => $composableBuilder(
    column: $table.artist,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MusicItemsTableAnnotationComposer
    extends Composer<_$MusicDatabase, $MusicItemsTable> {
  $$MusicItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storageKey => $composableBuilder(
    column: $table.storageKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bvid =>
      $composableBuilder(column: $table.bvid, builder: (column) => column);

  GeneratedColumn<int> get cid =>
      $composableBuilder(column: $table.cid, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get artist =>
      $composableBuilder(column: $table.artist, builder: (column) => column);

  GeneratedColumn<String> get coverUrl =>
      $composableBuilder(column: $table.coverUrl, builder: (column) => column);
}

class $$MusicItemsTableTableManager
    extends
        RootTableManager<
          _$MusicDatabase,
          $MusicItemsTable,
          MusicItem,
          $$MusicItemsTableFilterComposer,
          $$MusicItemsTableOrderingComposer,
          $$MusicItemsTableAnnotationComposer,
          $$MusicItemsTableCreateCompanionBuilder,
          $$MusicItemsTableUpdateCompanionBuilder,
          (
            MusicItem,
            BaseReferences<_$MusicDatabase, $MusicItemsTable, MusicItem>,
          ),
          MusicItem,
          PrefetchHooks Function()
        > {
  $$MusicItemsTableTableManager(_$MusicDatabase db, $MusicItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MusicItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MusicItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MusicItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> storageKey = const Value.absent(),
                Value<String> bvid = const Value.absent(),
                Value<int> cid = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> artist = const Value.absent(),
                Value<String?> coverUrl = const Value.absent(),
              }) => MusicItemsCompanion(
                id: id,
                storageKey: storageKey,
                bvid: bvid,
                cid: cid,
                title: title,
                artist: artist,
                coverUrl: coverUrl,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String storageKey,
                required String bvid,
                required int cid,
                required String title,
                required String artist,
                Value<String?> coverUrl = const Value.absent(),
              }) => MusicItemsCompanion.insert(
                id: id,
                storageKey: storageKey,
                bvid: bvid,
                cid: cid,
                title: title,
                artist: artist,
                coverUrl: coverUrl,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MusicItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$MusicDatabase,
      $MusicItemsTable,
      MusicItem,
      $$MusicItemsTableFilterComposer,
      $$MusicItemsTableOrderingComposer,
      $$MusicItemsTableAnnotationComposer,
      $$MusicItemsTableCreateCompanionBuilder,
      $$MusicItemsTableUpdateCompanionBuilder,
      (MusicItem, BaseReferences<_$MusicDatabase, $MusicItemsTable, MusicItem>),
      MusicItem,
      PrefetchHooks Function()
    >;

class $MusicDatabaseManager {
  final _$MusicDatabase _db;
  $MusicDatabaseManager(this._db);
  $$MusicItemsTableTableManager get musicItems =>
      $$MusicItemsTableTableManager(_db, _db.musicItems);
}
