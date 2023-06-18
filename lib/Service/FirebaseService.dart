import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remessasentregas/Model/Remessa.dart';

class FirebaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> iniciarEntrega(String idRemessa, String idUsuario) async {
    await firestore
        .collection('remessas')
        .doc(idRemessa)
        .update({'status': 'Em andamento', 'usuarioEntregador': idUsuario});
  }

  Future<void> cancelarEntrega(String idRemessa, String idUsuario) async {
    await firestore
        .collection('remessas')
        .doc(idRemessa)
        .update({'status': 'Cancelada', 'usuarioEntregador': idUsuario});
  }

  Future<void> finalizarEntrega(String idRemessa, String idUsuario) async {
    await firestore
        .collection('remessas')
        .doc(idRemessa)
        .update({'status': 'Entregue', 'usuarioEntregador': idUsuario});
  }

  Stream<List<Remessa>> getRemessasPendentes() {
    return firestore
        .collection('remessas')
        .where('status', isEqualTo: 'Pendente')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => _createRemessaFromDoc(doc)).toList());
  }

  Stream<List<Remessa>> getEntregasFeitas() {
    return firestore
        .collection('remessas')
        .where('status', isEqualTo: 'Entregue')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => _createRemessaFromDoc(doc)).toList());
  }

  Remessa _createRemessaFromDoc(DocumentSnapshot doc) {
    return Remessa(
      idRemessa: doc.id,
      descricaoProduto: doc['descricaoProduto'],
      valorEntrega: doc['valorEntrega'],
      enderecoRetirada: doc['enderecoRetirada'],
      enderecoEntrega: doc['enderecoEntrega'],
      status: doc['status'],
      usuarioRequisicao: doc['usuarioRequisicao'],
      usuarioEntregador: doc['usuarioEntregador'],
      dataHoraSaida: doc['dataHoraSaida'].toDate(),
      dataHoraEntrega: doc['dataHoraEntrega'].toDate(),
    );
  }
}
