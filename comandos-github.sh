#!/bin/bash

# Comandos para conectar ao GitHub após criar o repositório certificadomei-site

echo "🔧 Conectando ao repositório certificadomei-site..."

# Adicionar remote origin
git remote add origin https://github.com/projetometaid/certificadomei-site.git

# Verificar se foi adicionado
git remote -v

# Fazer push do commit
git push -u origin main

echo "✅ Push concluído para certificadomei-site!"
echo "🔗 Acesse: https://github.com/projetometaid/certificadomei-site"
