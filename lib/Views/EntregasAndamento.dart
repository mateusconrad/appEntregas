import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remessasentregas/Views/FinalizarEntrega.dart';

class EntregasEmAndamentoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entregas em Andamento'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('remessas')
            .where('status', isEqualTo: 'Andamento')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          List<DocumentSnapshot> remessas = snapshot.data!.docs;
          return ListView.builder(
            itemCount: remessas.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(remessas[index]['descricaoProduto']),
                  subtitle: Text(remessas[index]['enderecoEntrega']),
                  trailing: IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      _cancelarEntrega(remessas[index].id,context);
                    },
                  ),
                  onTap: () {
                    // Navegar para a página de finalizar entrega
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FinalizarEntregaPage(remessaId: remessas[index].id),
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

  void _cancelarEntrega(String remessaId,context) {
    FirebaseFirestore.instance.collection('remessas').doc(remessaId).update({
      'status': 'Cancelada',
    }).then((value) {
      // Exiba um diálogo ou uma mensagem de sucesso
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Entrega Cancelada'),
            content: Text('A entrega foi cancelada com sucesso.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }).catchError((error) {
      // Exiba um diálogo ou uma mensagem de erro
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro ao Cancelar a Entrega'),
            content: Text('Ocorreu um erro ao cancelar a entrega. Tente novamente mais tarde.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }
}
