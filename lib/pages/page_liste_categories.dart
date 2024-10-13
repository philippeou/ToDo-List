import 'package:flutter/material.dart';
import 'package:todolist/pages/page_ajout_categorie.dart';
import 'package:todolist/pages/page_liste_taches.dart';

import '../models/categorie.dart';
import '../repositories/db.dart';


class PageListeCategories extends StatefulWidget {
  @override
  _PageListeCategoriesState createState() => _PageListeCategoriesState();
}

class _PageListeCategoriesState extends State<PageListeCategories> {
  List<Categorie> categories = [];

  @override
  void initState() {
    super.initState();
    _chargerCategories();
  }

  Future<void> _chargerCategories() async {
    categories = await DB().getCategories();
    setState(() {});
  }

  void _ajouterCategorie() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PageAjoutCategorie(onSave: _chargerCategories),
    ),
    );
  }


  void _modifierCategorie(Categorie categorie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PageAjoutCategorie(categorie: categorie,
          onSave: _chargerCategories)),
    );
  }

  void _supprimerCategorie(int id) async {
    await DB().deleteCategorie(id);
    _chargerCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Liste des catégories')),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final categorie = categories[index];
          return ListTile(
            title: Text(categorie.nom),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: Icon(Icons.edit), onPressed: () => _modifierCategorie(categorie)),
                IconButton(icon: Icon(Icons.delete), onPressed: () => _supprimerCategorie(categorie.id!)),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PageListeTaches(idCategorie: categorie.id!)),
              );
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
