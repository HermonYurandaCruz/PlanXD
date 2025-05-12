import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:plan_xd/DB/db_helper.dart';
import 'package:plan_xd/models/atividade.dart';
import 'package:plan_xd/models/projeto.dart';

import '../../models/ColorItem.dart';

class HomeScreen extends StatefulWidget   {

  const HomeScreen({super.key});

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  List<Projeto> _projetoList = [];
  List<Atividade> _actividades = [];

  DBHelper _helperProjecto = DBHelper();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _helperProjecto.getProjetos().then((list) {
      setState(() {
        _projetoList = list;
        _loading = false;
      });
      _projetoList.forEach((projeto) {
        print('Projeto: ${projeto.nome}, Data de fim: ${projeto.dateEnd}');
      });
    });

    _helperProjecto.getAtividades().then((list) {
      setState(() {
        _actividades = list;
        _loading = false;
      });
      _actividades.forEach((actividade) {
        print('Actividade: ${actividade.titulo}, Data de fim: ${actividade.dataEntrega}, estado: ${actividade.status}');
      });
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/icons/logo.svg',
          height: 40,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/search.svg',
                width: 24,
                height: 24,
              ),
              onPressed: () {},
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildFilterChips(),
            const SizedBox(height: 16),
            _buildSectionTitle(context,'Projectos'),
            const SizedBox(height: 8),
            _buildProjetosList(),
            const SizedBox(height: 16),
            _buildSectionTitle(context,'Actividades'),
            const SizedBox(height: 8),
            _buildActividadesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildChip('All', true),
        const SizedBox(width: 8),
        const SizedBox(width: 8),
        _buildChip('Concluído', false),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildChip(String label, bool selected) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (bool value) {

      },
      disabledColor:Color(0xFFF4F4F4),
      selectedColor:Color(0xFFE82B2B),
      showCheckmark: false,
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.black,
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context,String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, color: Color(0xFF706E6F) ,fontWeight: FontWeight.bold)),

      ],
    );
  }

  Widget _buildProjetosList() {
    if (_projetoList.isEmpty) {
      return Center(
        child: _loading ? CircularProgressIndicator() : Text("Sem Projectos!"),
      );
    } else {
      return SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _projetoList.length,
          itemBuilder: (context, index) => _buildProjetoCard(context, index),
        ),
      );
    }
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


  Widget _buildProjetoCard(BuildContext context, int index) {
    final project = _projetoList[index];
    return InkWell(
      onTap: () {
        context.go('/detail_project/${project.id}');
        // Aqui defines o que acontece ao clicar no projeto
        print('Projeto clicado: ${project.nome}');
        // Exemplo: navegar para outra tela
        // context.push('/detalhes_projeto', extra: project);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFEBEBEB),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.nome,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF706E6F),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Color(0xFF706E6F), size: 16),
                SizedBox(width: 4),
                Text(
                  DateFormat('dd/MM/yyyy').format(project.dateEnd),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF706E6F),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              '${project.numeroAtividades} Actividades',
              style: TextStyle(
                color: Color(0xFF706E6F),
              ),
            ),
          ],
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