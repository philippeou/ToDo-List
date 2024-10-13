class Categorie {
  int? id;
  String nom;

  Categorie({this.id, required this.nom});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
    };
  }

  static Categorie fromMap(Map<String, dynamic> map) {
    return Categorie(
      id: map['id'],
      nom: map['nom'],
    );
  }
}
