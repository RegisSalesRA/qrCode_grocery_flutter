class FrutaModel {
  final String nome;
  final String imagem;
  final double preco;
  final int quantidade;
  bool lida;

  FrutaModel({
    required this.nome,
    required this.imagem,
    required this.preco,
    required this.quantidade,
    required this.lida,
  });

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'imagem': imagem,
        'preco': preco,
        'quantidade': quantidade,
        'lida': lida,
      };

  factory FrutaModel.fromJson(Map<String, dynamic> json) => FrutaModel(
        nome: json['nome'],
        imagem: json['imagem'],
        preco: (json['preco'] as num).toDouble(),
        quantidade: json['quantidade'],
        lida: json['lida'],
      );

  FrutaModel copyWith({
    String? nome,
    String? imagem,
    double? preco,
    int? quantidade,
    bool? lida,
  }) {
    return FrutaModel(
      nome: nome ?? this.nome,
      imagem: imagem ?? this.imagem,
      preco: preco ?? this.preco,
      quantidade: quantidade ?? this.quantidade,
      lida: lida ?? this.lida,
    );
  }
}
