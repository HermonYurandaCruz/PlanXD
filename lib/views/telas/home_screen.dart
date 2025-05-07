import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:plan_xd/DB/db_helper.dart';
import 'package:plan_xd/models/projeto.dart';

import '../../models/ColorItem.dart';

class HomeScreen extends StatefulWidget   {

  const HomeScreen({super.key});

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  List<Projeto> _projetoList = [];
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
        _buildChip('Em progresso', false),
        const SizedBox(width: 8),
        _buildChip('Concluído', false),
        const SizedBox(width: 8),
        _buildChip('Em pausa', false),
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

        IconButton(
          onPressed: () => context.go('/new_project'),
          icon: const Icon(Icons.add),color: Color(0xFF706E6F),
        ),
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
          scrollDirection: Axis.horizontal, // <- IMPORTANTE!
          itemCount: _projetoList.length,
          itemBuilder: (context, index) => _buildProjetoCard(context, index),
        ),
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

  Widget _buildActividadesList() {
    return Column(
      children: List.generate(4, (index) => _buildAtividadeCard()),
    );
  }

  Widget _buildAtividadeCard() {
    ColorItem? selectedItem;

    final List<ColorItem> items = [
      ColorItem("A Fazer", Color(0xFFFFFFFF)),
      ColorItem("Em Atraso",  Color(0xFFD2A307)),
      ColorItem("Cancelada",  Color(0xFFE82B2B)),
      ColorItem("Em Progresso",  Color(0xFF0777D2)),

    ];

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
          const Text(
            'Levantamento das funcionalidades do sistema',
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF706E6F)),
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Icon(Icons.calendar_today, size: 16),
              SizedBox(width: 4),
              Text('12/12/2025', style: TextStyle(color: Color(0xFFE82B2B), fontWeight: FontWeight.bold)),
              SizedBox(width: 16),
              Text('Prioridade: '),
              Text('Alta', style: TextStyle(color: Color(0xFFE82B2B), fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Projecto A',
                style: TextStyle(
                  color: Color(0xFF706E6F),
                  fontWeight: FontWeight.bold,
                ),
              ),

              // <-- Botão adaptado aqui!
              Container(
                decoration: BoxDecoration(
                  color: selectedItem?.color ?? Colors.white, // cor do botão
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: DropdownButton<ColorItem>(
                  value: selectedItem,
                  underline: Container(),
                  icon: SizedBox.shrink(),
                  dropdownColor: Colors.white,
                  hint: const Text('Selecionar estado'),
                  items: items.map((ColorItem item) {
                    return DropdownMenuItem<ColorItem>(
                      value: item,
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: item.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(item.name),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (ColorItem? newValue) {
                      selectedItem = newValue;
                  },
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}