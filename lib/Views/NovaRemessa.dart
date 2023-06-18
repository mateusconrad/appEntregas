import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NovaRemessaPage extends StatefulWidget {
  @override
  _NovaRemessaPageState createState() => _NovaRemessaPageState();
}

class _NovaRemessaPageState extends State<NovaRemessaPage> {
  TextEditingController descricaoController = TextEditingController();
  TextEditingController valorController = TextEditingController();
  TextEditingController enderecoRetiradaController = TextEditingController();
  TextEditingController enderecoEntregaController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  NumberFormat formatadorMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  Future<void> cadastrarRemessa() async {
    String descricao = descricaoController.text;
    double valor = double.parse(valorController.text);
    String enderecoRetirada = enderecoRetiradaController.text;
    String enderecoEntrega = enderecoEntregaController.text;
    String status = 'Pendente'; // Defina o status inicial como "Pendente"

    // Aqui você pode adicionar a lógica para obter o ID do usuário requisitante,
    // talvez através de autenticação ou alguma outra forma.

    // Crie um novo documento no Firestore com os dados da remessa
    await firestore.collection('remessas').add({
      'descricaoProduto': descricao,
      'valorEntrega': valor,
      'enderecoRetirada': enderecoRetirada,
      'enderecoEntrega': enderecoEntrega,
      'status': status,
      'usuarioRequisicao': 'ID_DO_USUARIO_REQUISITANTE', // Substitua pelo ID correto
      'usuarioEntregador': '',
      'dataHoraSaida': null,
      'dataHoraEntrega': null,
    });

    // Formata o valor antes de limpar o campo
    valorController.text = formatadorMoeda.format(valor);

    // Limpe os campos após o cadastro
    descricaoController.clear();
    valorController.clear();
    enderecoRetiradaController.clear();
    enderecoEntregaController.clear();

    // Exiba um diálogo ou uma mensagem para indicar o sucesso do cadastro
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sucesso'),
          content: Text('Remessa cadastrada com sucesso!'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova Remessa'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: descricaoController,
              decoration: InputDecoration(
                labelText: 'Descrição do Produto',
              ),
            ),
            TextField(
              controller: valorController,
              decoration: InputDecoration(
                labelText: 'Valor da Entrega',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: enderecoRetiradaController,
              decoration: InputDecoration(
                labelText: 'Endereço de Retirada',
              ),
            ),
            TextField(
              controller: enderecoEntregaController,
              decoration: InputDecoration(
                labelText: 'Endereço de Entrega',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Cadastrar'),
              onPressed: cadastrarRemessa,
            ),
          ],
        ),
      ),
    );
  }
}
