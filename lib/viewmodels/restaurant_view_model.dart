import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/restaurant_model.dart';
import 'package:flutter/material.dart';

class RestaurantViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Ler todos os restaurantes
  Stream<List<RestaurantModel>> getRestaurants() {
    return _firestore.collection('restaurants').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return RestaurantModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Adicionar novo restaurante
  Future<String?> addRestaurant(RestaurantModel restaurant) async {
    try {
      await _firestore.collection('restaurants').add(restaurant.toJson());
      return null; // Sem erro, então limpa a mensagem
    } on FirebaseException catch (e) {
      return 'Erro ao adicionar restaurante: ${e.message}';
    } catch (e) {
      return 'Erro inesperado ao adicionar restaurante';
    }
  }

  // Atualizar restaurante
  Future<String?> updateRestaurant(RestaurantModel restaurant) async {
    try {
      await _firestore.collection('restaurants').doc(restaurant.id).update(restaurant.toJson());
      return null;
    } on FirebaseException catch (e) {
      return 'Erro ao atualizar restaurante: ${e.message}';
    } catch (e) {
      return 'Erro inesperado ao atualizar restaurante';
    }
  }

  // Excluir restaurante
  Future<String?> deleteRestaurant(String id) async {
    try {
      await _firestore.collection('restaurants').doc(id).delete();
      print('Restaurante apagado');
      return null;
    } on FirebaseException catch (e) {
      print("Erro ao excluir restaurante");
      return 'Erro ao excluir restaurante: ${e.message}';
    } catch (e) {
      print('Erro inesperado ao excluir restaurante');
      return 'Erro inesperado ao excluir restaurante';
    }
  }
}
