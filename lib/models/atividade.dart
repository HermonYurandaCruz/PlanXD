class Atividade {
  final int? id;
  final String titulo;
  final String dataEntrega;
  final String prioridade;
  final String status;
  final String idProjeto;

  Atividade({
    this.id,
    required this.titulo,
    required this.dataEntrega,
    required this.prioridade,
    required this.status,
    required this.idProjeto,
  });

  // guardar no SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'dataEntrega': dataEntrega,
      'prioridade': prioridade,
      'status': status,
      'idProjeto': idProjeto,
    };
  }

  // Para carregar do SQLite
  factory Atividade.fromMap(Map<String, dynamic> map) {
    return Atividade(
      id: map['id'],
      titulo: map['titulo'],
      dataEntrega: map['dataEntrega'],
      prioridade: map['prioridade'],
      status: map['status'],
      idProjeto: map['idProjeto'],
    );
  }
}
