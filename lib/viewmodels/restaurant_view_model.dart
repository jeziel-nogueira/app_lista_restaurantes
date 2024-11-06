import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../models/restaurant_model.dart';
import 'package:flutter/material.dart';

class RestaurantViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Ler todos os restaurantes cadastrados pelo Ususario atual
  Stream<List<RestaurantModel>> getUserRestaurants() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return _firestore
        .collection('restaurants')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return RestaurantModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }


  // Adicionar novo restaurante
  Future<String?> addRestaurant(RestaurantModel restaurant) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    try {
      await _firestore.collection('restaurants').add({
        ...restaurant.toJson(),
        'userId': userId,
      });
      return null;
    } on FirebaseException catch (e) {
      return 'Erro ao adicionar restaurante: ${e.message}';
    } catch (e) {
      return 'Erro inesperado ao adicionar restaurante';
    }
  }


  // Atualizar restaurante
  Future<String?> updateRestaurant(RestaurantModel restaurant) async {
    try {
      // Obtendo o uid do usuário autenticado
      final userId = FirebaseAuth.instance.currentUser?.uid;

      // Verificar se o usuário atual é o dono do restaurante
      if (restaurant.userId != userId) {
        return 'Você não tem permissão para atualizar este restaurante';
      }

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
    final userId = FirebaseAuth.instance.currentUser?.uid;
    try {
      // Buscando o restaurante no Firestore para verificar o userId
      final doc = await _firestore.collection('restaurants').doc(id).get();
      if (!doc.exists) {
        return 'Restaurante não encontrado';
      }

      final restaurant = RestaurantModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);

      // Verificar se o usuário atual é o dono do restaurante
      if (restaurant.userId != userId) {
        return 'Você não tem permissão para excluir este restaurante';
      }

      await _firestore.collection('restaurants').doc(id).delete();
      return null;
    } on FirebaseException catch (e) {
      return 'Erro ao excluir restaurante: ${e.message}';
    } catch (e) {
      return 'Erro inesperado ao excluir restaurante';
    }
  }
}
