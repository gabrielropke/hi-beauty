#!/bin/bash

# 🔹 Build script simplificado e robusto para ExFAT
# Resolve problemas com arquivos ._

echo "🧹 BUILD DEFINITIVO PARA EXFAT"
echo "=============================="

# 🔹 Configurar variáveis de ambiente
export COPYFILE_DISABLE=1
export COPY_EXTENDED_ATTRIBUTES_DISABLE=1

# 🔹 Limpeza completa
echo "🗑️ Limpeza total..."
find . -name "._*" -delete 2>/dev/null || true
find . -name ".DS_Store" -delete 2>/dev/null || true

flutter clean
rm -rf build
rm -rf .dart_tool

echo "🗑️ Segunda limpeza..."
find . -name "._*" -delete 2>/dev/null || true

echo "📦 Instalando dependências..."
flutter pub get

echo "🗑️ Limpeza pré-build..."
find . -name "._*" -delete 2>/dev/null || true

echo "🚀 Build do app bundle..."
COPYFILE_DISABLE=1 COPY_EXTENDED_ATTRIBUTES_DISABLE=1 flutter build appbundle --release

if [ $? -eq 0 ]; then
    echo "✅ BUILD CONCLUÍDO!"
    echo "📱 App bundle: build/app/outputs/bundle/release/app-release.aab"
else
    echo "❌ Falha no build. Diagnóstico:"
    find . -name "._*" | head -5
fi