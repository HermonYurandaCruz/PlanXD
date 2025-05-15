import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../DB/db_helper.dart';
import '../../models/projeto.dart';

class EditarProjectoPage extends StatefulWidget {
  final int id;
  const EditarProjectoPage({Key? key, required this.id}) : super(key: key);

  @override
  _EditarProjectoPageState createState() => _EditarProjectoPageState();
}

class _EditarProjectoPageState extends State<EditarProjectoPage> {
  final _formKey = GlobalKey<FormState>();

  // Controladores dos campos
  final nomeController = TextEditingController();
  final objetivoController = TextEditingController();
  final descricaoController = TextEditingController();
  final anexosController = TextEditingController();

  DateTime? dataInicio;
  DateTime? dataFim;

  String? tipoProjetoSelecionado;
  String? statusSelecionado;

  List<String> tiposDeProjeto = ['Interno', 'Externo'];
  List<String> statusList = ['Planejado', 'Em andamento', 'Concluído'];

  @override
  void initState() {
    super.initState();
    _carregarProjeto();
  }

  Future<void> _selecionarData(BuildContext context, bool isInicio) async {
    final dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (dataSelecionada != null) {
      setState(() {
        if (isInicio) {
          dataInicio = dataSelecionada;
        } else {
          dataFim = dataSelecionada;
        }
      });
    }
  }

  Future<void> _carregarProjeto() async {
    final projeto = await DBHelper().getProjetoById(widget.id);
    if (projeto != null) {
      setState(() {
        nomeController.text = projeto.nome;
        objetivoController.text = projeto.objective;
        descricaoController.text = projeto.descriptionProject;
        tipoProjetoSelecionado = projeto.typeProject;
        dataInicio = projeto.dateStart;
        dataFim = projeto.dateEnd;
        // statusSelecionado = projeto.status; // só se você tiver esse campo no modelo
      });
    }
  }

  Future<void> _salvarFormulario() async {
    if (_formKey.currentState!.validate() && dataInicio != null && dataFim != null && tipoProjetoSelecionado != null && statusSelecionado != null) {
      final projeto = Projeto(
        id: widget.id, // precisa garantir que `id` está incluído no modelo
        nome: nomeController.text,
        dateEnd: dataFim!,
        dateStart: dataInicio!,
        objective: objetivoController.text,
        typeProject: tipoProjetoSelecionado!,
        descriptionProject: descricaoController.text,
        numeroAtividades: 0, // opcionalmente atualizar isso também
      );

      await DBHelper().updateProjeto(projeto);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Projeto atualizado com sucesso!')),
      );
      context.go('/');
    } else {
      print('Dados em falta');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Projeto',style: const TextStyle(fontSize: 18, color: Color(0xFF706E6F) ,fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF706E6F),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('Dados básicos do projecto',style: const TextStyle(fontSize: 18, color: Color(0xFF706E6F) ,fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _inputField(nomeController, 'Nome do projecto'),
              _inputField(objetivoController, 'Objectivo Principal'),
              _dropdownField('Tipo de projecto', tiposDeProjeto, tipoProjetoSelecionado, (value) {
                setState(() => tipoProjetoSelecionado = value);
              }),
              _textArea(descricaoController, 'Descricao do projecto'),

              const SizedBox(height: 16),
              const Text('Informações de planejamento', style: const TextStyle(fontSize: 18, color: Color(0xFF706E6F) ,fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _datePickerField(context, 'Data de início prevista', dataInicio, true),
              _datePickerField(context, 'Data de término prevista', dataFim, false),
              _dropdownField('Status inicial', statusList, statusSelecionado, (value) {
                setState(() => statusSelecionado = value);
              }),

              const SizedBox(height: 16),
              const Text('Outros (opcional, mas útil)', style: const TextStyle(fontSize: 18, color: Color(0xFF706E6F) ,fontWeight: FontWeight.bold)),
              _textArea(anexosController, 'Anexos ou links de documentos relevantes'),

              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE82B2B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: _salvarFormulario,
                child: const Text('Salvar Alterações', style: TextStyle(fontWeight:  FontWeight.bold,color: Color(0xFFFFFFFF)),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
      ),
    );
  }

  Widget _dropdownField(String label, List<String> items, String? selected, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: selected,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
        validator: (value) => value == null ? 'Selecione uma opção' : null,
      ),
    );
  }

  Widget _textArea(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: 3,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _datePickerField(BuildContext context, String label, DateTime? selectedDate, bool isInicio) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _selecionarData(context, isInicio),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
          child: Text(
            selectedDate != null
                ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                : 'Selecionar data',
            style: TextStyle(color: selectedDate != null ? Colors.black : Colors.grey),
          ),
        ),
      ),
    );
  }
}
