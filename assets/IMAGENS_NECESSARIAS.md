# Imagens Necessárias para o Projeto

## 🚨 Imagens Obrigatórias (referenciadas no HTML)

### Logos
- `assets/logos/logo.svg` - Logo principal da empresa (148x28px)

### Ícones
- `assets/icons/favicon.ico` - Favicon do site (16x16px, 32x32px)
- `assets/icons/google-small.svg` - Ícone pequeno do Google (18x18px)

### Avatars
- `assets/avatars/av1.jpg` - Foto do cliente Pedro Moreira (44x44px)
- `assets/avatars/av3.jpg` - Foto da cliente Denise M. (44x44px)

### Imagens Gerais
- `assets/images/og-cover.jpg` - Imagem para compartilhamento social (1200x630px)

## 📋 Imagens Recomendadas (para melhorar o design)

### Hero Section
- `assets/images/hero-certificado-digital.jpg` - Imagem principal do hero
- `assets/images/hero-background.jpg` - Background alternativo

### Ícones de Interface
- `assets/icons/whatsapp.svg` - Ícone do WhatsApp
- `assets/icons/check.svg` - Ícone de check para listas
- `assets/icons/star.svg` - Ícone de estrela para avaliações
- `assets/icons/security.svg` - Ícone de segurança
- `assets/icons/speed.svg` - Ícone de velocidade
- `assets/icons/support.svg` - Ícone de suporte

### Ilustrações
- `assets/images/processo-step1.svg` - Ilustração do passo 1
- `assets/images/processo-step2.svg` - Ilustração do passo 2
- `assets/images/processo-step3.svg` - Ilustração do passo 3
- `assets/images/certificado-exemplo.png` - Exemplo visual do certificado

### Logos de Parceiros/Certificações
- `assets/logos/icp-brasil.png` - Logo ICP-Brasil
- `assets/logos/mercado-livre.png` - Logo Mercado Livre
- `assets/logos/shopee.png` - Logo Shopee

### Avatars Adicionais
- `assets/avatars/avatar-placeholder.svg` - Avatar genérico
- `assets/avatars/equipe-1.jpg` - Foto da equipe
- `assets/avatars/equipe-2.jpg` - Foto da equipe

## 🎨 Especificações Técnicas

### Formatos Preferidos:
- **Logos e Ícones**: SVG (vetorial, escalável)
- **Fotos**: JPG (boa compressão)
- **Imagens com transparência**: PNG
- **Imagens modernas**: WebP (fallback para PNG/JPG)

### Tamanhos Recomendados:
- **Favicon**: 16x16, 32x32, 48x48px
- **Logo principal**: 148x28px (desktop), versão responsiva
- **Avatars**: 44x44px (mínimo), 80x80px (ideal)
- **Ícones pequenos**: 16x16, 24x24px
- **Ícones médios**: 32x32, 48x48px
- **Open Graph**: 1200x630px
- **Hero images**: 1200x600px (mínimo)

### Otimização:
- Comprimir todas as imagens
- Usar ferramentas como TinyPNG/TinyJPG
- Considerar lazy loading para imagens grandes
- Criar versões responsivas quando necessário

## 📝 Próximos Passos

1. **Criar/obter as imagens obrigatórias** listadas acima
2. **Adicionar as imagens às respectivas pastas**
3. **Testar se todas as referências estão funcionando**
4. **Otimizar as imagens para web**
5. **Considerar adicionar lazy loading**
6. **Implementar fallbacks para imagens que falharem**

## 🔧 Comandos Úteis

```bash
# Verificar se todas as imagens existem
find assets/ -name "*.jpg" -o -name "*.png" -o -name "*.svg" -o -name "*.ico"

# Otimizar imagens (se tiver imagemagick instalado)
mogrify -strip -interlace Plane -gaussian-blur 0.05 -quality 85% assets/images/*.jpg
```
