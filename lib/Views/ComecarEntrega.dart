import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'EntregasAndamento.dart';

class DetalhesRemessaPage extends StatelessWidget {
  final String remessaId;

  DetalhesRemessaPage({required this.remessaId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Remessa'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('remessas')
            .doc(remessaId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar os detalhes da remessa'));
          }
          if (!snapshot.hasData) {
            return Center(child: Text('Nenhum dado encontrado'));
          }

          Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;
          if (data == null) {
            return Center(child: Text('Nenhum dado encontrado'));
          }

          String descricaoProduto = data['descricaoProduto'];
          String enderecoEntrega = data['enderecoEntrega'];
          String dataHoraSaida = data['dataHoraSaida'] ?? 'Não definida';
          String dataHoraEntrega = data['dataHoraEntrega'] ?? 'Não definida';

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Remessa ID: $remessaId'),
                SizedBox(height: 16.0),
                Text('Descrição do Produto: $descricaoProduto'),
                SizedBox(height: 8.0),
                Text('Endereço de Entrega: $enderecoEntrega'),
                SizedBox(height: 8.0),
                Text('Data e Hora de Saída: $dataHoraSaida'),
                SizedBox(height: 8.0),
                Text('Data e Hora de Entrega: $dataHoraEntrega'),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Atualizar a remessa para "Andamento"
                    FirebaseFirestore.instance
                        .collection('remessas')
                        .doc(remessaId)
                        .update({
                      'status': 'Andamento',
                      'dataHoraSaida': DateTime.now().toString(),
                      'dataHoraEntrega': DateTime.now(),
                    }).then((value) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Remessa Atendida'),
                            content: Text('A remessa foi atualizada para o status de "Andamento".'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EntregasEmAndamentoPage(),
                                    ),
                                  );                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }).catchError((error) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Erro ao Atender a Remessa'),
                            content: Text('Ocorreu um erro ao atualizar a remessa. Tente novamente mais tarde.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    });
                  },
                  child: Text('Atender Remessa'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
