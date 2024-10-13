import 'package:flutter/material.dart';

import '../models/categorie.dart';
import '../repositories/db.dart';


class PageAjoutCategorie extends StatefulWidget {
  final Categorie? categorie;
  final Function onSave;

  PageAjoutCategorie({this.categorie, required this.onSave});

  @override
  _PageAjoutCategorieState createState() => _PageAjoutCategorieState();
  }

class _PageAjoutCategorieState extends State<PageAjoutCategorie> {
  TextEditingController _nomController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.categorie != null) {
      _nomController.text = widget.categorie!.nom;
    }
  }

  void _enregistrerCategorie() async {
    if (_nomController.text.isEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Le nom de la catégorie ne peut pas être vide')),
  );
  return;
    }

    try {
      if (widget.categorie == null) {
        await DB().insertCategorie(Categorie(nom: _nomController.text));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Catégorie ajoutée avec succès !')),
        );
      } else {
        await DB().updateCategorie(
          Categorie(id: widget.categorie!.id, nom: _nomController.text),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Catégorie modifiée avec succès !')),
        );
      }

      widget.onSave();

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categorie == null ? 'Ajouter Catégorie' : 'Modifier Catégorie')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomController,
              decoration: InputDecoration(labelText: 'Nom de la catégorie'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _enregistrerCategorie,
              child: Text('Enregistrer'),
            )
          ],
        ),
      ),
    );
  }
}