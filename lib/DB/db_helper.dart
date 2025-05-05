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
          CREATE TABLE atividades(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT,
            dataEntrega TEXT,
            prioridade TEXT,
            status TEXT,
            idProjeto TEXT
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

  Future<List<Projeto>> getProjetos() async {
    var database = await db;
    var result = await database.query('projetos');
    return result.map((e) => Projeto.fromMap(e)).toList();
  }

  // Métodos para Atividade
  Future<int> insertAtividade(Atividade atividade) async {
    var database = await db;
    return await database.insert('atividades', atividade.toMap());
  }

  Future<List<Atividade>> getAtividades() async {
    var database = await db;
    var result = await database.query('atividades');
    return result.map((e) => Atividade.fromMap(e)).toList();
  }
}
