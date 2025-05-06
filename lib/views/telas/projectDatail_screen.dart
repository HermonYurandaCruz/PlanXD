

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DetalhesProjecto extends StatefulWidget{

  @override
  _DetalhesProjectoState createState()=> _DetalhesProjectoState();

  }
class _DetalhesProjectoState extends State<DetalhesProjecto> {



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
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Projecto:',style: const TextStyle(fontSize: 14, color: Color(0xFF888888) ,fontWeight: FontWeight.normal)),
              const SizedBox(height: 4),
              const Text('Desenvolvimento de sistema Web para LtM',style: const TextStyle(fontSize: 18, color: Color(0xFF706E6F) ,fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Projecto:',style: const TextStyle(fontSize: 14, color: Color(0xFF888888) ,fontWeight: FontWeight.normal)),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: Color(0xFF706E6F), size: 16),
                          SizedBox(width: 4),
                          Text(
                            '12/05/2025:',
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
                      const Text('Projecto:',style: const TextStyle(fontSize: 14, color: Color(0xFF888888) ,fontWeight: FontWeight.normal)),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: Color(0xFF706E6F), size: 16),
                          SizedBox(width: 4),
                          Text(
                            '12/05/2025:',
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
                      const Text('Projecto:',style: const TextStyle(fontSize: 14, color: Color(0xFF888888) ,fontWeight: FontWeight.normal)),
                      const Text('12 Actividades:',style: const TextStyle(fontSize: 14, color: Color(0xFF706E6F) ,fontWeight: FontWeight.bold)),
                    ],
                  )
                ],

              ),
                  const SizedBox(height: 12),
                  const Text('Descrição do projecto:',style: const TextStyle(fontSize: 16, color: Color(0xFF888888) ,fontWeight: FontWeight.bold)),
                  const Text('No código acima, fornecemos à consulta um ID como argumento usando whereArgs. Em seguida, retornamos o primeiro resultado se a lista não.',style: const TextStyle(fontSize: 14, color: Color(0xFF888888) ,fontWeight: FontWeight.normal)),

                  const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Actividades', style: const TextStyle(fontSize: 18, color: Color(0xFF706E6F) ,fontWeight: FontWeight.bold)),

                  IconButton(
                    onPressed: () => context.go('/new_project'),
                    icon: const Icon(Icons.add),color: Color(0xFF706E6F),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

}