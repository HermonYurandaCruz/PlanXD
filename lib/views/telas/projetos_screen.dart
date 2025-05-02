import 'package:flutter/material.dart';

class ProjetosScreen extends StatelessWidget {
  const ProjetosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text.rich(
          TextSpan(
            text: 'Projecto',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildSectionTitle('Actividades'),
            const SizedBox(height: 8),
            _buildActividadesList(),
          ],
        ),
      ),
    );
  }




  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }




  Widget _buildActividadesList() {
    return Column(
      children: List.generate(4, (index) => _buildAtividadeCard()),
    );
  }

  Widget _buildAtividadeCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Levantamento das funcionalidades do sistema',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: const [
              Icon(Icons.calendar_today, size: 16),
              SizedBox(width: 4),
              Text('12/12/2025', style: TextStyle(color: Colors.red)),
              SizedBox(width: 16),
              Text('Prioridade: Alta', style: TextStyle(color: Colors.red)),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Projecto A'),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('A Fazer'),
            ),
          ),
        ],
      ),
    );
  }
}
