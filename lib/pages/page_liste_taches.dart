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
  List<Tache> taches = [];

  @override
  void initState() {
  super.initState();
  _chargerTaches();
  }

Future<void> _chargerTaches() async {
  taches = await DB().getTaches(widget.idCategorie);
  setState(() {});
}

void _ajouterTache() async {
await DB().insertTache(Tache(idCategorie: widget.idCategorie,
    titre: 'Nouvelle tâche'));
_chargerTaches();
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
      body: ListView.builder(
        itemCount: taches.length,
        itemBuilder: (context, index) {
          final tache = taches[index];
          return ListTile(
            title: Text(tache.titre),
            trailing: IconButton(
              icon: Icon(tache.estComplete ? Icons.check_box : Icons.check_box_outline_blank),
              onPressed: () => _basculerCompletion(tache),
            ),
            onLongPress: () => _supprimerTache(tache.id!),
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