#!/bin/bash

# Script para verificar propagação DNS
# Author: Leandro Albertini

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "🔍 Verificando propagação DNS para certificadodigitalmei.com.br..."
echo ""

# Função para verificar DNS
check_dns() {
    local domain=$1
    local expected=$2
    local type=$3
    
    echo -n "Verificando $domain ($type): "
    
    if [ "$type" = "A" ]; then
        result=$(nslookup $domain 2>/dev/null | grep "Address:" | tail -1 | awk '{print $2}')
    else
        result=$(nslookup $domain 2>/dev/null | grep -A1 "canonical name" | tail -1 | awk '{print $1}' | sed 's/\.$//')
    fi
    
    if [[ "$result" == *"$expected"* ]] && [ ! -z "$result" ]; then
        echo -e "${GREEN}✅ OK${NC} ($result)"
        return 0
    else
        echo -e "${RED}❌ Aguardando...${NC}"
        return 1
    fi
}

# Verificar registros
echo "📋 Registros configurados:"
echo "certificadodigitalmei.com.br (A) → 52.84.150.20"
echo "www.certificadodigitalmei.com.br (CNAME) → d2xkp5x4bz18ec.cloudfront.net"
echo "_4a205f58... (CNAME) → _9501a3a84... (validação SSL)"
echo "_73e088b19... (CNAME) → _bd8080aee... (validação SSL)"
echo ""

# Loop de verificação
max_attempts=20
attempt=1

while [ $attempt -le $max_attempts ]; do
    echo "🔄 Tentativa $attempt/$max_attempts:"
    
    # Verificar domínio principal
    check_dns "certificadodigitalmei.com.br" "52.84.150.20" "A"
    main_ok=$?
    
    # Verificar www
    check_dns "www.certificadodigitalmei.com.br" "d2xkp5x4bz18ec.cloudfront.net" "CNAME"
    www_ok=$?
    
    # Verificar validação SSL 1
    check_dns "_4a205f58307151aeb7f9e5457ae7dd28.certificadodigitalmei.com.br" "_9501a3a84268c330ca55addd81d19d1a.xlfgrmvvlj.acm-validations.aws" "CNAME"
    ssl1_ok=$?
    
    # Verificar validação SSL 2
    check_dns "_73e088b19625d232da43588b4fd12483.www.certificadodigitalmei.com.br" "_bd8080aee8a411613a89c99febb0fc1b.xlfgrmvvlj.acm-validations.aws" "CNAME"
    ssl2_ok=$?
    
    echo ""
    
    # Se todos estiverem OK
    if [ $main_ok -eq 0 ] && [ $www_ok -eq 0 ] && [ $ssl1_ok -eq 0 ] && [ $ssl2_ok -eq 0 ]; then
        echo -e "${GREEN}🎉 Todos os registros DNS propagaram com sucesso!${NC}"
        echo ""
        echo "✅ Próximos passos:"
        echo "1. Executar: terraform apply"
        echo "2. Aguardar validação SSL (5-10 minutos)"
        echo "3. Testar: https://certificadodigitalmei.com.br"
        exit 0
    fi
    
    if [ $attempt -lt $max_attempts ]; then
        echo -e "${YELLOW}⏳ Aguardando 30 segundos antes da próxima verificação...${NC}"
        sleep 30
    fi
    
    ((attempt++))
done

echo -e "${RED}⚠️ DNS ainda não propagou completamente após $max_attempts tentativas.${NC}"
echo "Isso é normal e pode levar até 1 hora."
echo ""
echo "💡 Você pode:"
echo "1. Aguardar mais alguns minutos"
echo "2. Verificar manualmente: nslookup certificadodigitalmei.com.br"
echo "3. Executar este script novamente: ./check-dns.sh"
