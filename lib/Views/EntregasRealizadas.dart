import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EntregasRealizadasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entregas Finalizadas'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('remessas')
            .where('status', whereIn: ['Entregue', 'Cancelada'])
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          List<DocumentSnapshot> entregas = snapshot.data!.docs;
          return ListView.builder(
            itemCount: entregas.length,
            itemBuilder: (context, index) {
              bool isCancelada = entregas[index]['status'] == 'Cancelada';
              return Card(
                color: isCancelada ? Colors.red : null,
                child: ListTile(
                  title: Text(entregas[index]['descricaoProduto']),
                  subtitle: Text(entregas[index]['enderecoEntrega']),
                  onTap: () {
                    // Ação ao clicar na entrega realizada
                    // Por exemplo, exibir os detalhes da entrega
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalhesEntregaPage(entrega: entregas[index]),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetalhesEntregaPage extends StatelessWidget {
  final DocumentSnapshot entrega;

  DetalhesEntregaPage({required this.entrega});

  @override
  Widget build(BuildContext context) {
    // Extrair os dados da entrega
    String descricaoProduto = entrega['descricaoProduto'];
    String enderecoEntrega = entrega['enderecoEntrega'];
    DateTime? dataHoraEntrega = entrega['dataHoraEntrega']?.toDate();

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Entrega'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Descrição do Produto: $descricaoProduto'),
            SizedBox(height: 8),
            Text('Endereço de Entrega: $enderecoEntrega'),
            SizedBox(height: 8),
            if (dataHoraEntrega != null)
              Text('Data e Hora de Entrega: $dataHoraEntrega'),
            if (dataHoraEntrega == null)
              Text('Data e Hora de Entrega: Não definida'),
          ],
        ),
      ),
    );
  }
}
