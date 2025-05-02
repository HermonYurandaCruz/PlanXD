import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/ColorItem.dart';

class HomeScreen extends StatelessWidget  {

  const HomeScreen({super.key});




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
            _buildSectionTitle('Projectos'),
            const SizedBox(height: 8),
            _buildProjetosList(),
            const SizedBox(height: 16),
            _buildSectionTitle('Actividades'),
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

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, color: Color(0xFF706E6F) ,fontWeight: FontWeight.bold)),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.add),color: Color(0xFF706E6F),
        ),
      ],
    );
  }

  Widget _buildProjetosList() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 2, // exemplo
        itemBuilder: (context, index) {
          return _buildProjetoCard();
        },
      ),
    );
  }

  Widget _buildProjetoCard() {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Desenvolvimento de sistema Web para LtM',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF706E6F))),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today,color: Color(0xFF706E6F), size: 16),
              SizedBox(width: 4),
              Text('12/12/2025', style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF706E6F)),),

            ],
          ),
          Spacer(),
          Text( '12 Actividades', style: TextStyle(
              color: Color(0xFF706E6F)
          )),
        ],
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
                  color: selectedItem?.color ?? Colors.black, // cor do botão
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
