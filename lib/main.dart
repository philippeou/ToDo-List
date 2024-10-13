import 'package:flutter/material.dart';
import 'package:todolist/pages/page_ajout_categorie.dart';
import 'package:todolist/pages/page_liste_categories.dart';
import 'package:todolist/pages/page_liste_taches.dart';
import 'package:todolist/repositories/db.dart';

import 'consts.dart';
import 'models/categorie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Liste de tâches Flutter',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: PageListeCategories(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Categorie> _categories = [];

  @override
  void initState() {
    super.initState();
    _chargerCategories();
  }

  Future<void> _chargerCategories() async {
    final categories = await DB().getCategories();
    setState(() {
      _categories = categories;
    });
  }

  Future<int> _getNombreDeTaches(int idCategorie) async {
    int nombreDeTaches = await DB().countTachesParCategorie(idCategorie);
    print("Nombre de tâches pour la catégorie $idCategorie: $nombreDeTaches");
    return nombreDeTaches;
  }

  void _ajouterCategorie() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PageAjoutCategorie(
                onSave: _chargerCategories), // Recharger après ajout
      ),
    );
  }

  void _modifierCategorie(Categorie categorie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PageAjoutCategorie(
                categorie: categorie, onSave: _chargerCategories),
      ),
    );
  }

  void _supprimerCategorie(int id) async {
    await DB().deleteCategorie(id);
    _chargerCategories();
  }

  void _ouvrirListeTaches(int idCategorie) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PageListeTaches(idCategorie: idCategorie)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO List'),
      ),
      body: _categories.isEmpty
          ? Center(child: Text('Aucune catégorie pour le moment'))
          : ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final categorie = _categories[index];
          return FutureBuilder<int>(
            future: _getNombreDeTaches(categorie.id!), // Assurez-vous que cet ID est correct
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListTile(
                  title: Text(categorie.nom),
                  subtitle: Text('Chargement...'),
                );
              } else if (snapshot.hasError) {
                return ListTile(
                  title: Text(categorie.nom),
                  subtitle: Text('Erreur lors du chargement des tâches'),
                );
              } else {
                final nombreDeTaches = snapshot.data ?? 0;
                print("Compteur pour ${categorie.nom}: $nombreDeTaches"); // Debug
                return Card(
                  elevation: 2,
                  child: ListTile(
                    title: Text(categorie.nom),
                    subtitle: Text('$nombreDeTaches tâche(s)'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _modifierCategorie(categorie),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _supprimerCategorie(categorie.id!),
                        ),
                      ],
                    ),
                    onTap: () => _ouvrirListeTaches(categorie.id!),
                  ),
                );
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _ajouterCategorie,
        child: Icon(Icons.add),
      ),
    );
  }
}
