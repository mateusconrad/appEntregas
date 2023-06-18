class Remessa {
  String idRemessa;
  String descricaoProduto;
  double valorEntrega;
  String enderecoRetirada;
  String enderecoEntrega;
  String status;
  String usuarioRequisicao;
  String usuarioEntregador;
  DateTime dataHoraSaida;
  DateTime dataHoraEntrega;

  Remessa({
    required this.idRemessa,
    required this.descricaoProduto,
    required this.valorEntrega,
    required this.enderecoRetirada,
    required this.enderecoEntrega,
    required this.status,
    required this.usuarioRequisicao,
    required this.usuarioEntregador,
    required this.dataHoraSaida,
    required this.dataHoraEntrega,
  });
}