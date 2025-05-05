class Projeto {
  final int? id;
  final String nome;
  final DateTime dateEnd;
  final DateTime dateStart;
  final String objective;
  final String typeProject;
  final String descriptionProject;
  final int numeroAtividades;

  Projeto({
    this.id,
    required this.nome,
    required this.dateEnd,
    required this.dateStart,
    required this.objective,
    required this.typeProject,
    required this.descriptionProject,
    required this.numeroAtividades,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'dateEnd': dateEnd.toIso8601String(),
      'dateStart': dateStart.toIso8601String(),
      'objective': objective,
      'typeProject': typeProject,
      'descriptionProject': descriptionProject,
      'numeroAtividades': numeroAtividades,
    };
  }

  factory Projeto.fromMap(Map<String, dynamic> map) {
    return Projeto(
      id: map['id'],
      nome: map['nome'],
      dateEnd: DateTime.parse(map['dateEnd']),
      dateStart:DateTime.parse(map['dateStart']),
      objective: map['objective'],
      typeProject: map['typeProject'],
      descriptionProject: map['descriptionProject'],
      numeroAtividades: map['numeroAtividades'],
    );
  }
}
