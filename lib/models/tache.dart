class Tache {
  int? id;
  int idCategorie;
  String titre;
  bool estComplete;

  Tache({this.id, required this.idCategorie, required this.titre, this.estComplete = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idCategorie': idCategorie,
      'titre': titre,
      'estComplete': estComplete ? 1 : 0,
    };
  }

  static Tache fromMap(Map<String, dynamic> map) {
    return Tache(
      id: map['id'],
      idCategorie: map['idCategorie'],
      titre: map['titre'],
      estComplete: map['estComplete'] == 1,
    );
  }
}
