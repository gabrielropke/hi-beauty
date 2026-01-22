import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class BrandLoader {
  /// Retorna o map do brand baseado no bundleId
  static Future<Map<String, dynamic>> load() async {
    print('🚀 [BrandLoader] Iniciando BrandLoader.load()...');
    
    // 1. Pega o bundleId do app
    print('📱 [BrandLoader] Obtendo PackageInfo...');
    final info = await PackageInfo.fromPlatform();
    final bundleId = info.packageName; // ex: com.hibarber, org.hibeauty
    print('📦 [BrandLoader] BundleId obtido: $bundleId');

    // 2. Extrai o nome do brand: a última parte do bundleId
    final brandId = bundleId.split('.').last.toLowerCase();
    print('🏷️ [BrandLoader] BrandId extraído: $brandId');

    // 3. Carrega o JSON de brands
    print('📄 [BrandLoader] Carregando brands.json...');
    try {
      final jsonString = await rootBundle.loadString(
        'assets/config/brands/brands.json',
      );
      print('✅ [BrandLoader] brands.json carregado com sucesso!');
      print('📝 [BrandLoader] JSON length: ${jsonString.length} caracteres');
      
      final Map<String, dynamic> brands = jsonDecode(jsonString);
      print('🗂️ [BrandLoader] JSON decodificado. Brands disponíveis: ${brands.keys.toList()}');

      // 4. Retorna o brand correspondente
      if (!brands.containsKey(brandId)) {
        print('❌ [BrandLoader] Brand "$brandId" não encontrado no brands.json');
        throw Exception("Brand '$brandId' não encontrado no brands.json");
      }

      print('✨ [BrandLoader] Brand encontrado! Retornando dados do brand "$brandId"');
      final brandData = brands[brandId];
      print('📋 [BrandLoader] Brand data: $brandData');
      return brandData;
      
    } catch (e, stackTrace) {
      print('💥 [BrandLoader] Erro ao carregar/processar brands.json: $e');
      print('📊 [BrandLoader] Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Apenas retorna o ID do brand
  static Future<String> getBrandId() async {
    final info = await PackageInfo.fromPlatform();
    return info.packageName.split('.').last.toLowerCase();
  }

  /// Retorna o brandHeader (ex.: "hi_barber")
  static Future<String> getBrandHeader() async {
    final brand = await load();
    final api = brand['api'];
    if (api == null || !api.containsKey('brandHeader')) {
      throw Exception("Campo 'brandHeader' não encontrado dentro de 'api'.");
    }

    return api['brandHeader'] as String;
  }
}
