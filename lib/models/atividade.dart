class Atividade {
  final int? id;
  final String titulo;
  final DateTime dataEntrega;
  final String prioridade;
  final String status;
  final String description;
  final int idProjeto;

  Atividade({
    this.id,
    required this.titulo,
    required this.dataEntrega,
    required this.prioridade,
    required this.status,
    required this.description,
    required this.idProjeto,
  });

  // guardar no SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'dataEntrega': dataEntrega.toIso8601String(),
      'prioridade': prioridade,
      'status': status,
      'description': description,
      'idProjeto': idProjeto,
    };
  }

  // Para carregar do SQLite
  factory Atividade.fromMap(Map<String, dynamic> map) {
    return Atividade(
      id: map['id'],
      titulo: map['titulo'],
      dataEntrega: DateTime.parse(map['dataEntrega']),
      prioridade: map['prioridade'],
      status: map['status'],
      description: map['description'],
      idProjeto:  int.parse(map['idProjeto'].toString()),
    );
  }
}
