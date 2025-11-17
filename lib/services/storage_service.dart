import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String bucket = 'produits'; // Nom du bucket Supabase

  // 🔹 Upload image produit
  Future<String?> uploadImage(File file) async {
    try {
      final String fileName = const Uuid().v4(); // nom unique

      // Upload du fichier
      final response = await _supabase.storage.from(bucket).upload(
        fileName,
        file,
      );

      if (response.isNotEmpty) {
        // Récupérer l’URL publique
        final publicUrl = _supabase.storage.from(bucket).getPublicUrl(fileName);
        return publicUrl;
      }
    } catch (e) {
      debugPrint("Erreur upload image: $e");
    }
    return null;
  }

  // 🔹 Supprimer image produit
  Future<void> deleteImage(String fileUrl) async {
    try {
      // Extraire le nom du fichier depuis l’URL
      final fileName = fileUrl.split('/').last;
      await _supabase.storage.from(bucket).remove([fileName]);
    } catch (e) {
      debugPrint("Erreur suppression image: $e");
    }
  }
}
