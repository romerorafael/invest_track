// lib/services/firestore_service.dart

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Salva o usuário no Firestore se ainda não existir
  Future<void> saveUserIfNew(
    User user, {
    String? fullName,
    String? favoriteColor,
    String? birthDate,
    Int? age,
  }) async {
    final docRef = _db.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'uid': user.uid,
        'email': user.email,
        'displayName': fullName ?? user.displayName ?? '',
        'photoURL': user.photoURL ?? '',
        'favoriteColor': favoriteColor ?? '',
        'birthDate': birthDate ?? '',
        'age': age ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Cria subcoleções vazias para favoritos e notificações
  Future<void> initializeUserCollections(String uid) async {
    final favoritesRef = _db.collection('users').doc(uid).collection('favorites');
    final notificationsRef = _db.collection('users').doc(uid).collection('notifications');

    if ((await favoritesRef.get()).docs.isEmpty) {
      await favoritesRef.doc('_init').set({'init': true});
    }
    if ((await notificationsRef.get()).docs.isEmpty) {
      await notificationsRef.doc('_init').set({'init': true});
    }
  }
}
