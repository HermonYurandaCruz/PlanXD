import 'dart:ffi';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/projeto.dart';
import '../models/atividade.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    final path = join(await getDatabasesPath(), 'planxd.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('PRAGMA foreign_keys = ON');

        await db.execute('''
        CREATE TABLE projetos(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT,
          dateEnd TEXT,
          dateStart TEXT,
          objective TEXT,
          typeProject TEXT,
          descriptionProject TEXT,
          numeroAtividades INTEGER
        )
      ''');

        await db.execute('''
        CREATE TABLE actividades(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          titulo TEXT,
          dataEntrega TEXT,
          prioridade TEXT,
          status INTEGER,
          description TEXT,
          idProjeto INTEGER,
          FOREIGN KEY (idProjeto) REFERENCES projetos(id) ON DELETE CASCADE
        )
      ''');
      },
    );
  }

  // Métodos para Projeto
  Future<int> insertProjeto(Projeto projeto) async {
    var database = await db;
    return await database.insert('projetos', projeto.toMap());
  }

  Future<int> deleteProject(int id) async {
    final database = await db;
    return await database.delete(
      'projetos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateProjeto(Projeto projeto) async {
    final database = await db;
    return await database.update(
      'projetos',
      projeto.toMap(),
      where: 'id = ?',
      whereArgs: [projeto.id],
    );
  }


  Future<List<Projeto>> getProjetos() async {
    var database = await db;
    var result = await database.query('projetos');
    return result.map((e) => Projeto.fromMap(e)).toList();
  }

  Future<Projeto?> getProjetoById(int id) async {
    var database = await db;
    var result = await database.query(
      'projetos',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Projeto.fromMap(result.first);
    } else {
      return null;
    }
  }


  // Métodos para Atividade
  Future<int> insertAtividade(Atividade atividade) async {
    var database = await db;
    return await database.insert('actividades', atividade.toMap());
  }

  Future<int> deleteAtividade(int id) async {
    final database = await db;
    return await database.delete(
      'actividades',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  Future<List<Atividade>> getAtividades() async {
    var database = await db;
    var result = await database.query('actividades');
    return result.map((e) => Atividade.fromMap(e)).toList();
  }

  Future<List<Atividade>> getAtividadesByIdProjeto(int idProjeto) async {
    final database = await db;
    DBHelper _helperProjecto = DBHelper();

    // Faz a query filtrando pelo idProjeto
    final result = await database.query(
      'actividades',
      where: 'idProjeto = ?',
      whereArgs: [idProjeto],
    );

    // Converte os resultados para uma lista de Atividade
    return result.map((e) => Atividade.fromMap(e)).toList();
  }


  Future<int> updateStatusAtividade(int status, int? id) async {
    if (id == null) {
      print('ID da actividade não pode ser nulo!');
      throw Exception('ID da actividade não pode ser nulo!');
    }

    final database = await db;
    print('Actualizando actividade ID: $id com status: $status'); // <= Adiciona isto para ver se chegou aqui

    final result = await database.update(
      'actividades',
      {
        'status': status,
      },
      where: 'id = ?',
      whereArgs: [id],
    );

    print('Resultado do update: $result'); // <= Adiciona isto também
    return result;
  }

  Future<Atividade?> getActividadeById(int id) async {
    var database = await db;
    var result = await database.query(
      'actividades',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Atividade.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<int> updateAtividade(Atividade atividade) async {
    final database = await db;
    return await database.update(
      'actividades',
      atividade.toMap(),
      where: 'id = ?',
      whereArgs: [atividade.id],
    );
  }



}
