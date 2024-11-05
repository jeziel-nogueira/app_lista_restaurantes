class RestaurantModel {
  final String id; // Identificador único do restaurante no Firestore
  final String title; // Nome do restaurante
  final String description; // Descrição do restaurante
  final String type; // Tipo de restaurante (ex: fast food, casual, etc.)

  // Construtor da classe RestaurantModel, que inicializa todos os campos como obrigatórios
  RestaurantModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
  });

  // Converte a instância do modelo para um Map (JSON) para salvar no Firestore
  Map<String, dynamic> toJson() {
    return {
      'title': title,           // Mapeia o campo 'title' para o JSON
      'description': description, // Mapeia o campo 'description' para o JSON
      'type': type,               // Mapeia o campo 'type' para o JSON
    };
  }

  // Cria uma instância de RestaurantModel a partir de um documento JSON e um ID
  static RestaurantModel fromJson(Map<String, dynamic> json, String id) {
    return RestaurantModel(
      id: id,                                 // Define o ID recebido
      title: json['title'] as String,         // Converte e atribui o campo 'title' do JSON
      description: json['description'] as String, // Converte e atribui o campo 'description' do JSON
      type: json['type'] as String,           // Converte e atribui o campo 'type' do JSON
    );
  }
}
