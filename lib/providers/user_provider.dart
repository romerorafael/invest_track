import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final userProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception('Usuário não logado');

  final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  return doc.data() ?? {};
});
