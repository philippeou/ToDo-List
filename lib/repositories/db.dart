import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/categorie.dart';
import '../models/tache.dart';


class DB {
  static final DB _instance = DB._interne();
  static Database? _baseDeDonnees;

  factory DB() {
    return _instance;
  }

  DB._interne();

  Future<int> countTachesParCategorie(int idCategorie) async {
    final db = await baseDeDonnees;
    var result = await db.rawQuery('SELECT COUNT(*) FROM taches WHERE idCategorie = ?', [idCategorie]);
    int count = Sqflite.firstIntValue(result) ?? 0;
    print("Nombre de tâches pour la catégorie $idCategorie: $count");
    return count;
  }

  Future<Database> get baseDeDonnees async {
    if (_baseDeDonnees != null) return _baseDeDonnees!;
    _baseDeDonnees = await _initDb();
    return _baseDeDonnees!;
  }

  Future<Database> _initDb() async {
    String chemin = join(await getDatabasesPath(), 'liste_de_taches.db');
    return await openDatabase(
      chemin,
      version: 1,
      onCreate: (db, version) {
        db.execute('CREATE TABLE catégories(id INTEGER PRIMARY KEY AUTOINCREMENT,'
            ' nom TEXT)');
        db.execute('CREATE TABLE taches(id INTEGER PRIMARY KEY AUTOINCREMENT,'
            ' idCategorie INTEGER, titre TEXT, estComplete INTEGER)');
        },
    );
  }

  Future<int> insertCategorie(Categorie categorie) async {
    final db = await baseDeDonnees;
    return await db.insert('catégories', categorie.toMap());
  }

  Future<List<Categorie>> getCategories() async {
    final db = await baseDeDonnees;
    final List<Map<String, dynamic>> maps = await db.query('catégories');
    print('Données de la base : $maps');
    return List.generate(maps.length, (i) {
      return Categorie.fromMap(maps[i]);
    });
  }

  Future<int> updateCategorie(Categorie categorie) async {
    final db = await baseDeDonnees;
    return await db.update('catégories', categorie.toMap(), where: 'id = ?', whereArgs: [categorie.id]);
  }

  Future<int> deleteCategorie(int id) async {
    final db = await baseDeDonnees;
    return await db.delete('catégories', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertTache(Tache tache) async {
    final db = await baseDeDonnees;
    return await db.insert('taches', tache.toMap());
  }

  Future<List<Tache>> getTaches(int idCategorie) async {
    final db = await baseDeDonnees;
    final List<Map<String, dynamic>> maps = await db.query('taches', where: 'idCategorie = ?', whereArgs: [idCategorie]);
    return List.generate(maps.length, (i) {
      return Tache.fromMap(maps[i]);
    });
  }

  Future<int> updateTache(Tache tache) async {
    final db = await baseDeDonnees;
    return await db.update('taches', tache.toMap(), where: 'id = ?', whereArgs: [tache.id]);
  }

  Future<int> deleteTache(int id) async {
    final db = await baseDeDonnees;
    return await db.delete('taches', where: 'id = ?', whereArgs: [id]);
  }

}
