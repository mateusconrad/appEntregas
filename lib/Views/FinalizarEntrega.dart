import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remessasentregas/Views/EntregasAndamento.dart';

class FinalizarEntregaPage extends StatelessWidget {
  final String remessaId;

  FinalizarEntregaPage({required this.remessaId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finalizar Entrega'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Confirme a finalização da entrega'),
            ElevatedButton(
              onPressed: () {
                // Ação ao finalizar a entrega
                // Por exemplo, atualizar a data e hora de entrega, setar o status como 'Entregue'
                FirebaseFirestore.instance.collection('remessas').doc(remessaId).update({
                  'dataHoraEntrega': DateTime.now(),
                  'status': 'Entregue',
                }).then((value) {
                  Navigator.pop(context);
                }).catchError((error) {
                });
              },
              child: Text('Finalizar Entrega'),
            ),
          ],
        ),
      ),
    );
  }
}
