class Projeto {
  final int? id;
  final String nome;
  final String dataEntrega;
  final int numeroAtividades;

  Projeto({
    this.id,
    required this.nome,
    required this.dataEntrega,
    required this.numeroAtividades,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'dataEntrega': dataEntrega,
      'numeroAtividades': numeroAtividades,
    };
  }

  factory Projeto.fromMap(Map<String, dynamic> map) {
    return Projeto(
      id: map['id'],
      nome: map['nome'],
      dataEntrega: map['dataEntrega'],
      numeroAtividades: map['numeroAtividades'],
    );
  }
}
