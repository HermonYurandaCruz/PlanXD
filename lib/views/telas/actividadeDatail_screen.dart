

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../DB/db_helper.dart';
import '../../models/atividade.dart';
import '../../models/projeto.dart';
import '../../services/gemini_service.dart';

class DetalhesActidade extends StatefulWidget{
final int id;

const DetalhesActidade({Key? key, required this.id}) : super(key: key);

  @override
  _DetalhesActividadesState createState()=> _DetalhesActividadesState();

  }
class _DetalhesActividadesState extends State<DetalhesActidade> {

  final GeminiService _geminiService = GeminiService();

  Atividade? _actividade;
  String _resposta = '';

  final nomeActividade= TextEditingController();
  final descricaoController = TextEditingController();
  String? statusSelecionado;

  DateTime? dataConclusao;
  List<String> prioridadeList = ['Alta', 'Media', 'Baixa'];

  void _enviarPrompt(String atividade, String descricao ) async {
    final resposta = await _geminiService.gerarResposta(atividade,descricao);
    setState(() {
      _resposta = resposta;
    });
  }

  Future<void> _selecionarData(BuildContext context) async {
    final dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (dataSelecionada != null) {
      setState(() {
        dataConclusao = dataSelecionada;
      });
    }
  }

  Widget _datePickerField(BuildContext context, String label, DateTime? selectedDate) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _selecionarData(context),
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

  Future<void> _carregarProjeto() async {
    final actividade = await DBHelper().getActividadeById(widget.id);
    if (actividade != null) {
      setState(() {
        nomeActividade.text = actividade.titulo;
        descricaoController.text = actividade.description;
        statusSelecionado = actividade.prioridade;
        dataConclusao = actividade.dataEntrega;
        // statusSelecionado = projeto.status; // só se você tiver esse campo no modelo
      });
    }
  }


  Future<void> _salvarFormulario() async {
    print('Dados activdade:');
    print(nomeActividade.text);
    print(dataConclusao);
    print(statusSelecionado);
    print(widget.id);

    if (dataConclusao != null && nomeActividade.text.isNotEmpty && statusSelecionado != null && widget.id != null) {
      print('endrou no metodo cadastreAR ACTIVIDaDE bD:');

      final atividade = Atividade(
        titulo: nomeActividade.text,
        dataEntrega: dataConclusao!,
        prioridade: statusSelecionado!,
        status:0,
        description:descricaoController.text,
        idProjeto: widget.id,
      );
      print('ADICIONOU TUDO AO OBJECTO: $atividade');

      await DBHelper().updateAtividade(atividade);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Actividade salva com sucesso!')),
      );
      nomeActividade.clear();
      descricaoController.clear();
      dataConclusao = null;
      statusSelecionado = null;
      setState(() {}); // Atualiza o UI
      initState();
    }else{
      print('Dados em falta');
    }
  }



  void _confirmarRemocao(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar remoção'),
        content: Text('Deseja realmente apagar esta atividade?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              if (widget.id != null) {
                await DBHelper().deleteAtividade(widget.id);
                context.go('/');
              }
            },
            child: Text('Apagar', style: const TextStyle(color: Color(
                0xFFFFFFFF) ,fontWeight: FontWeight.normal)),
          ),
        ],
      ),
    );
  }




  @override
  void initState() {
    super.initState();
    _buscarActividade();
    _carregarProjeto();
  }

  Future<void> _buscarActividade() async {
    final actividades = await DBHelper().getActividadeById(widget.id);
    setState(() {
      _actividade = actividades;
    });
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Actividade',style: const TextStyle(fontSize: 18, color: Color(0xFF706E6F) ,fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF706E6F),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_horiz),

            onSelected: (value) {
              if (value == 'editar') {
                if(widget.id != null){
                _mostrarBottomSheet(context);
                }
              } else if (value == 'apagar') {
                _confirmarRemocao(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'editar',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 18),
                    SizedBox(width: 8),
                    Text('Editar'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'apagar',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Apagar'),
                  ],
                ),
              ),
            ],
          ),
        ],

      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
             Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Actividade:',style: const TextStyle(fontSize: 14, color: Color(0xFF888888) ,fontWeight: FontWeight.normal)),
                const SizedBox(height: 4),
                Text(_actividade?.titulo ?? 'Sem título',style: const TextStyle(fontSize: 18, color: Color(0xFF706E6F) ,fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Data de conclusão',style: const TextStyle(fontSize: 14, color: Color(0xFF888888) ,fontWeight: FontWeight.normal)),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: Color(0xFF706E6F), size: 16),
                            SizedBox(width: 4),
                            Text( '${DateFormat('dd/MM/yyyy').format(_actividade!.dataEntrega)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF706E6F),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Prioridade:',style: const TextStyle(fontSize: 14, color: Color(0xFF888888) ,fontWeight: FontWeight.normal)),
                        Text('${_actividade!.prioridade}',style: const TextStyle(fontSize: 14, color: Color(0xFF706E6F) ,fontWeight: FontWeight.bold)),
                      ],
                    )
                  ],

                ),
                const SizedBox(height: 12),
                const Text('Descrição do projecto:',style: const TextStyle(fontSize: 16, color: Color(0xFF888888) ,fontWeight: FontWeight.bold)),
                Text('${_actividade!.description}',style: const TextStyle(fontSize: 14, color: Color(0xFF888888) ,fontWeight: FontWeight.normal)),
                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_actividade != null) {
                        _enviarPrompt(_actividade!.titulo, _actividade!.description);
                      }
                    },
                    icon: Image.asset(
                      'assets/icons/ai-technology.png', // Substitua pelo caminho do seu PNG
                      width: 24,
                      height: 24,
                    ),
                    label: Text("Gerar plano com IA"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0x2F98D1FA), // azul muito claro
                      foregroundColor: Color(0xFF706E6F), // cor do texto e ícone
                      elevation: 0,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),

                 SizedBox(height: 12),
                Text("", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(_resposta),


              ],
            ),

          ],
        ),
      ),
    );
  }
  void _mostrarBottomSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      expand: false,
      backgroundColor: Colors.transparent,
      builder: (context) => Material(   // <-- Material diretamente aqui!
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: SingleChildScrollView(
            controller: ModalScrollController.of(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 40,
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Text(
                  'Adicionar Actividade',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: nomeActividade,
                  decoration: InputDecoration(
                    labelText: 'Actividade',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 12),

                _datePickerField(context, 'Data de término prevista', dataConclusao),

                SizedBox(height: 12),
                DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Prioridade',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: prioridadeList.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
                    validator: (value) => value == null ? 'Selecione uma opção' : null,
                    onChanged:  (value) {
                      setState(() => statusSelecionado = value);
                    }),

                SizedBox(height: 12),
                TextField(
                  maxLines: 3,
                  controller: descricaoController,
                  decoration: InputDecoration(
                    labelText: 'Descrição da actividade',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _salvarFormulario,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text( 'Adicionar Actividade', style: TextStyle(fontWeight:  FontWeight.bold,color: Color(0xFFFFFFFF)),),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: Text('Cancelar', style: TextStyle(fontWeight:  FontWeight.bold,color: Color(0xFFE82B2B)),),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }




}