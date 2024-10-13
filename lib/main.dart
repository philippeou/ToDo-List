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
    _chargerCategories(); // Charger les catégories lors de l'initialisation
  }

  Future<void> _chargerCategories() async {
    final categories = await DB().getCategories();
    setState(() {
    _categories = categories;
    });
    print('Catégories chargées : ');
  }

  // Ajouter une nouvelle catégorie
  void _ajouterCategorie() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PageAjoutCategorie(onSave: _chargerCategories), // Recharger après ajout
    ),
    );
  }

  // Modifier une catégorie existante
  void _modifierCategorie(Categorie categorie) {
  Navigator.push(
  context,
  MaterialPageRoute(
  builder: (context) => PageAjoutCategorie(categorie: categorie, onSave: _chargerCategories),
  ),
  );
  }

  // Supprimer une catégorie
  void _supprimerCategorie(int id) async {
  await DB().deleteCategorie(id);
  _chargerCategories();  // Recharger après suppression
  }

  // Ouvrir la page des tâches pour une catégorie
  void _ouvrirListeTaches(int idCategorie) {
  Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => PageListeTaches(idCategorie: idCategorie)),
  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Catégories'),
      ),
      body: _categories.isEmpty
          ? Center(child: Text('Aucune catégorie pour le moment'))
          : ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final categorie = _categories[index];
          return ListTile(
            title: Text(categorie.nom),
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
