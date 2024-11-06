class RestaurantModel {
  final String id; // Identificador único do restaurante no Firestore
  final String title; // Nome do restaurante
  final String description; // Descrição do restaurante
  final String type; // Tipo de restaurante (ex: fast food, casual, etc.)
  final String userId;

  // Construtor da classe RestaurantModel, que inicializa todos os campos como obrigatórios
  RestaurantModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.userId,
  });

  // Converte a instância do modelo para um Map (JSON) para salvar no Firestore
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'type': type,
      'userId': userId,
    };
  }

  // Cria uma instância de RestaurantModel a partir de um documento JSON e um ID
  static RestaurantModel fromJson(Map<String, dynamic> json, String id) {
    return RestaurantModel(
      id: id,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      userId: json['userId'] as String
    );
  }
}
