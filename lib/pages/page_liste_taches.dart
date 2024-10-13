import 'package:flutter/material.dart';

import '../models/tache.dart';
import '../repositories/db.dart';


class PageListeTaches extends StatefulWidget {
  final int idCategorie;

  PageListeTaches({required this.idCategorie});

  @override
  _PageListeTachesState createState() => _PageListeTachesState();
}

class _PageListeTachesState extends State<PageListeTaches> {
  List<Tache> _taches = [];

  @override
  void initState() {
    super.initState();
    _chargerTaches();
  }

  Future<void> _chargerTaches() async {
    final taches = await DB().getTaches(widget.idCategorie);
    setState(() {
      _taches = taches;
    });
  }

  void _ajouterTache() async {
    TextEditingController _titreController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ajouter une tâche'),
          content: TextField(
            controller: _titreController,
            decoration: InputDecoration(hintText: 'Nom de la tâche'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_titreController.text.isNotEmpty) {
                  try {
                    await DB().insertTache(
                        Tache(idCategorie: widget.idCategorie, titre: _titreController.text),
                );
                    Navigator.pop(context);
                    _chargerTaches();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tâche ajoutée avec succès !')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur lors de l\'ajout de la tâche : $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Le nom de la tâche ne peut pas être vide')),
                  );
                }
                },
              child: Text('Enregistrer'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Annuler'),
            ),
          ],
        );
      },
    );
  }


  void _basculerCompletion(Tache tache) async {
    tache.estComplete = !tache.estComplete;
    await DB().updateTache(tache);
    _chargerTaches();
  }

  void _supprimerTache(int id) async {
    await DB().deleteTache(id);
    _chargerTaches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Liste des tâches')),
      body: _taches.isEmpty
          ? Center(child: Text('Aucune tâche pour cette catégorie.'))
          : ListView.builder(
        itemCount: _taches.length,
        itemBuilder: (context, index) {
          final tache = _taches[index];
          return ListTile(
            title: Text(tache.titre),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    tache.estComplete ? Icons.check_box : Icons.check_box_outline_blank,
                  ),
                  onPressed: () => _basculerCompletion(tache),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _supprimerTache(tache.id!),
                ),
              ],
            ),
          );
          },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _ajouterTache,
        child: Icon(Icons.add),
      ),
    );
  }
}