

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../DB/db_helper.dart';
import '../../models/atividade.dart';
import '../../models/projeto.dart';

class DetalhesProjecto extends StatefulWidget{
final int id;

const DetalhesProjecto({Key? key, required this.id}) : super(key: key);

  @override
  _DetalhesProjectoState createState()=> _DetalhesProjectoState();

  }
class _DetalhesProjectoState extends State<DetalhesProjecto> {
  final _formKey = GlobalKey<FormState>();
  List<Atividade> _actividades = [];
  bool _loading = true;
  DBHelper _helperProjecto = DBHelper();

  Projeto? _projeto;
  final nomeActividade= TextEditingController();
  final descricaoController = TextEditingController();
  String? statusSelecionado;

  DateTime? dataConclusao;
  List<String> prioridadeList = ['Alta', 'Media', 'Baixa'];


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

  Future<void> _salvarFormulario() async {
    print('Dados activdade:');
    print(nomeActividade.text);
    print(dataConclusao);
    print(statusSelecionado);
    print(widget.id);

    if (dataConclusao != null && nomeActividade.text.isNotEmpty && statusSelecionado != null && descricaoController != null && widget.id != null) {
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

      await DBHelper().insertAtividade(atividade);

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


  @override
  void initState() {
    super.initState();
    _buscarProjeto();

    _helperProjecto.getAtividadesByIdProjeto(widget.id).then((list) {
      setState(() {
        _actividades = list;
        _loading = false;
      });
      _actividades.forEach((actividade) {
        print('Actividade: ${actividade.titulo}, Data de fim: ${actividade.dataEntrega}, estado: ${actividade.status}');
      });
    });
  }


  Future<void> _buscarProjeto() async {
    final projeto = await DBHelper().getProjetoById(widget.id);
    setState(() {
      _projeto = projeto;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Projecto',style: const TextStyle(fontSize: 18, color: Color(0xFF706E6F) ,fontWeight: FontWeight.bold)),
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
        child: ListView(
          children: [
             Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Projecto',style: const TextStyle(fontSize: 14, color: Color(0xFF888888) ,fontWeight: FontWeight.normal)),
                const SizedBox(height: 4),
                Text(_projeto?.nome ?? 'Sem título',style: const TextStyle(fontSize: 18, color: Color(0xFF706E6F) ,fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Data de Inicio',style: const TextStyle(fontSize: 14, color: Color(0xFF888888) ,fontWeight: FontWeight.normal)),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: Color(0xFF706E6F), size: 16),
                            SizedBox(width: 4),
                            Text( '${DateFormat('dd/MM/yyyy').format(_projeto!.dateStart)}',
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
                        const Text('Data de Conclusão',style: const TextStyle(fontSize: 14, color: Color(0xFF888888) ,fontWeight: FontWeight.normal)),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: Color(0xFF706E6F), size: 16),
                            SizedBox(width: 4),
                            Text( '${DateFormat('dd/MM/yyyy').format(_projeto!.dateEnd)}',
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
                        const Text('Actividades:',style: const TextStyle(fontSize: 14, color: Color(0xFF888888) ,fontWeight: FontWeight.normal)),
                        Text('${_projeto!.numeroAtividades} Actividades',style: const TextStyle(fontSize: 14, color: Color(0xFF706E6F) ,fontWeight: FontWeight.bold)),
                      ],
                    )
                  ],

                ),
                const SizedBox(height: 12),
                const Text('Descrição do projecto:',style: const TextStyle(fontSize: 16, color: Color(0xFF888888) ,fontWeight: FontWeight.bold)),
                Text('${_projeto!.descriptionProject}',style: const TextStyle(fontSize: 14, color: Color(0xFF888888) ,fontWeight: FontWeight.normal)),

                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Actividades', style: const TextStyle(fontSize: 18, color: Color(0xFF706E6F) ,fontWeight: FontWeight.bold)),

                    IconButton(
                      onPressed:() => _mostrarBottomSheet(context),
                      icon: const Icon(Icons.add),color: Color(0xFF706E6F),
                    ),
                  ],
                ),
                _buildActividadesList()

              ],
            ),

          ],
        ),
      ),
    );
  }


  Widget _buildActividadesList() {
    if (_actividades.isEmpty) {
      return Center(
        child: _loading ? CircularProgressIndicator() : Text("Sem Actividades!"),
      );
    } else {

      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _actividades.length,
        itemBuilder: (context, index) => _buildAtividadeCard(context, index),
      );
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


  Widget _buildAtividadeCard(BuildContext context,int index) {
    final actividade = _actividades[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFEBEBEB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            actividade.titulo,
            style: TextStyle( fontSize:16,fontWeight: FontWeight.bold, color: Color(0xFF706E6F)),
          ),
          const SizedBox(height: 8),
          Row(
            children:  [
              Icon(Icons.calendar_today, size: 16),
              SizedBox(width: 4),
              Text( DateFormat('dd/MM/yyyy').format(actividade.dataEntrega), style: TextStyle(color: Color(0xFFE82B2B), fontWeight: FontWeight.bold)),
              SizedBox(width: 16),
              Text('Prioridade: '),
              Text(actividade.prioridade, style: TextStyle(color: Color(0xFFE82B2B), fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Text(
                'Projecto:${actividade.idProjeto}',
                style: TextStyle(
                  color: Color(0xFF706E6F),
                  fontWeight: FontWeight.bold,
                ),
              ),

              Checkbox(
                activeColor: Color(0xFFE82B2B),
                value: actividade.status== 1 ? true : false,
                checkColor: Colors.white,
                onChanged: (value) async {
                  if (value != null) {
                    setState(() {
                      _actividades[index].status = value  ? 1 : 0; // Atualiza o status na lista
                      print('Estado Novo: ${_actividades[index].status}, id da actividade: ${_actividades[index].id}');
                      // Atualizar na base de dados
                      DBHelper().updateStatusAtividade(value  ? 1 : 0,_actividades[index].id,);
                    });
                    _actividades = await DBHelper().getAtividades();
                    setState(() {});
                  }
                },
              ),

            ],
          ),
        ],
      ),
    );
  }

}