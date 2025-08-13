# 🚀 Google PageSpeed Insights - Guia Completo de Otimização

> **Baseado na documentação oficial do Google** - Análise completa do PageSpeed Insights e API

## 📋 Índice

1. [Visão Geral do PageSpeed Insights](#visão-geral)
2. [Dados de Campo vs Laboratório](#dados-de-campo-vs-laboratório)
3. [Core Web Vitals no PSI](#core-web-vitals-no-psi)
4. [Métricas e Pontuações](#métricas-e-pontuações)
5. [API PageSpeed Insights](#api-pagespeed-insights)
6. [Interpretação de Resultados](#interpretação-de-resultados)
7. [Otimizações Recomendadas](#otimizações-recomendadas)
8. [Monitoramento Contínuo](#monitoramento-contínuo)

## 🎯 Visão Geral

### **O que é o PageSpeed Insights?**
O PageSpeed Insights (PSI) é uma ferramenta gratuita do Google que:
- **Analisa** a performance de páginas web em mobile e desktop
- **Fornece** dados reais de usuários (CrUX) e dados de laboratório (Lighthouse)
- **Sugere** melhorias específicas para otimização
- **Avalia** Core Web Vitals e outras métricas importantes

### **Duas Fontes de Dados**
```
📊 Dados de Campo (CrUX)     📧 Dados de Laboratório (Lighthouse)
├─ Usuários reais            ├─ Ambiente controlado
├─ 28 dias de histórico      ├─ Condições simuladas
├─ Variabilidade alta        ├─ Reproduzível
└─ Representativo            └─ Diagnóstico
```

### **Quando Usar Cada Tipo**
- **Dados de Campo**: Monitoramento da experiência real dos usuários
- **Dados de Laboratório**: Diagnóstico e debugging de problemas específicos

## 📊 Dados de Campo vs Laboratório

### **Dados de Campo (Chrome User Experience Report)**

#### **Métricas Disponíveis**
- **FCP** - First Contentful Paint
- **INP** - Interaction to Next Paint  
- **LCP** - Largest Contentful Paint
- **CLS** - Cumulative Layout Shift
- **TTFB** - Time to First Byte (experimental)

#### **Requisitos para Dados de Campo**
```
✅ Página deve ter tráfego suficiente
✅ URL deve ser público (rastreável e indexável)
✅ Dados coletados nos últimos 28 dias
✅ Usuários devem ter optado pelo CrUX
```

#### **Fallback de Granularidade**
```
1. 📄 Dados da página específica
   ↓ (se insuficientes)
2. 🌐 Dados da origem (todo o site)
   ↓ (se insuficientes)  
3. ❌ Sem dados de campo disponíveis
```

### **Dados de Laboratório (Lighthouse)**

#### **Condições de Teste**
- **Mobile**: Moto G4 simulado + rede móvel lenta
- **Desktop**: Computador emulado + conexão cabo
- **Localização**: Data centers do Google (América do Norte, Europa, Ásia)

#### **Categorias Analisadas**
- **Performance**: Velocidade e otimização
- **Acessibilidade**: Conformidade com padrões a11y
- **Melhores Práticas**: Padrões de desenvolvimento
- **SEO**: Otimização para mecanismos de busca

## 🎯 Core Web Vitals no PSI

### **Avaliação das Core Web Vitals**

#### **Critérios de Aprovação**
```javascript
// Para passar na avaliação CWV:
if (INP_75th_percentile <= 200ms && 
    LCP_75th_percentile <= 2500ms && 
    CLS_75th_percentile <= 0.1) {
    return "✅ APROVADO";
}

// Se INP não tiver dados suficientes:
if (LCP_75th_percentile <= 2500ms && 
    CLS_75th_percentile <= 0.1) {
    return "✅ APROVADO (sem INP)";
}

// Se LCP ou CLS não tiverem dados:
return "❌ NÃO AVALIÁVEL";
```

#### **Classificação de Qualidade**
| Métrica | Bom | Precisa Melhorar | Ruim |
|---------|-----|------------------|------|
| **LCP** | ≤ 2.5s | 2.5s - 4.0s | > 4.0s |
| **INP** | ≤ 200ms | 200ms - 500ms | > 500ms |
| **CLS** | ≤ 0.1 | 0.1 - 0.25 | > 0.25 |

### **Por que 75º Percentil?**
O Google usa o 75º percentil porque:
- Garante boa experiência para a **maioria dos usuários**
- Considera **condições mais difíceis** de dispositivo/rede
- Foca nas **experiências mais frustrantes**

## 📈 Métricas e Pontuações

### **Sistema de Pontuação Lighthouse**
```
🟢 90-100 = BOM
🟡 50-89  = PRECISA MELHORAR  
🔴 0-49   = RUIM
```

### **Métricas de Performance**
| Métrica | Descrição | Peso |
|---------|-----------|------|
| **FCP** | Primeiro conteúdo visível | 10% |
| **LCP** | Maior elemento visível | 25% |
| **TBT** | Tempo total de bloqueio | 30% |
| **CLS** | Mudanças de layout | 25% |
| **SI** | Índice de velocidade | 10% |

### **Distribuição de Métricas**
O PSI mostra distribuição em três categorias:
```
🟢 Verde (Bom)           ████████░░ 80%
🟡 Âmbar (Precisa Melhorar) ██░░░░░░░░ 15%  
🔴 Vermelho (Ruim)       █░░░░░░░░░  5%
```

## 🔧 API PageSpeed Insights

### **Endpoint da API**
```
GET https://pagespeedonline.googleapis.com/pagespeedonline/v5/runPagespeed
```

### **Parâmetros Principais**
```javascript
const params = {
    url: 'https://exemplo.com',           // URL a ser testada
    key: 'YOUR_API_KEY',                  // Chave da API
    strategy: 'mobile',                   // 'mobile' ou 'desktop'
    category: ['performance', 'seo'],     // Categorias a analisar
    locale: 'pt_BR'                       // Idioma dos resultados
};
```

### **Exemplo de Uso JavaScript**
```javascript
async function analyzePageSpeed(url) {
    const apiKey = 'YOUR_API_KEY';
    const apiUrl = `https://pagespeedonline.googleapis.com/pagespeedonline/v5/runPagespeed?url=${encodeURIComponent(url)}&key=${apiKey}&strategy=mobile`;
    
    try {
        const response = await fetch(apiUrl);
        const data = await response.json();
        
        // Dados de Campo (CrUX)
        const fieldData = data.loadingExperience;
        if (fieldData) {
            console.log('Core Web Vitals (Campo):');
            console.log('LCP:', fieldData.metrics.LARGEST_CONTENTFUL_PAINT_MS?.category);
            console.log('INP:', fieldData.metrics.INTERACTION_TO_NEXT_PAINT?.category);
            console.log('CLS:', fieldData.metrics.CUMULATIVE_LAYOUT_SHIFT_SCORE?.category);
        }
        
        // Dados de Laboratório (Lighthouse)
        const labData = data.lighthouseResult;
        console.log('Pontuação Performance:', labData.categories.performance.score * 100);
        
        // Métricas específicas
        const audits = labData.audits;
        console.log('FCP:', audits['first-contentful-paint'].displayValue);
        console.log('LCP:', audits['largest-contentful-paint'].displayValue);
        console.log('TBT:', audits['total-blocking-time'].displayValue);
        
        return data;
    } catch (error) {
        console.error('Erro ao analisar:', error);
    }
}

// Uso
analyzePageSpeed('https://web.dev');
```

### **Exemplo cURL**
```bash
curl "https://pagespeedonline.googleapis.com/pagespeedonline/v5/runPagespeed?url=https://web.dev&key=YOUR_API_KEY&strategy=mobile&category=performance&category=seo"
```

## 📖 Interpretação de Resultados

### **Estrutura da Resposta da API**
```json
{
    "captchaResult": "CAPTCHA_NOT_NEEDED",
    "kind": "pagespeedonline#result",
    "id": "https://exemplo.com/",
    
    "loadingExperience": {
        "id": "https://exemplo.com/",
        "metrics": {
            "LARGEST_CONTENTFUL_PAINT_MS": {
                "percentile": 2100,
                "distributions": [...],
                "category": "AVERAGE"
            }
        },
        "overall_category": "AVERAGE"
    },
    
    "lighthouseResult": {
        "categories": {
            "performance": {
                "id": "performance",
                "title": "Performance", 
                "score": 0.85
            }
        },
        "audits": {
            "largest-contentful-paint": {
                "id": "largest-contentful-paint",
                "title": "Largest Contentful Paint",
                "description": "...",
                "score": 0.89,
                "displayValue": "2.1 s"
            }
        }
    }
}
```

### **Interpretando Categorias**
- **FAST/BOM**: ✅ Métrica dentro dos limites ideais
- **AVERAGE/PRECISA_MELHORAR**: ⚠️ Pode ser otimizada
- **SLOW/RUIM**: ❌ Requer atenção imediata

### **Analisando Distribuições**
```javascript
// Exemplo de distribuição LCP
const lcpDistribution = {
    "distributions": [
        { "min": 0, "max": 2500, "proportion": 0.65 },      // 65% Bom
        { "min": 2500, "max": 4000, "proportion": 0.25 },   // 25% Médio  
        { "min": 4000, "proportion": 0.10 }                 // 10% Ruim
    ]
};

// 65% dos usuários têm LCP ≤ 2.5s (Bom)
// 25% dos usuários têm LCP entre 2.5s-4s (Médio)
// 10% dos usuários têm LCP > 4s (Ruim)
```

## ⚡ Otimizações Recomendadas

### **Baseadas em Auditorias Lighthouse**

#### **Oportunidades de Performance**
```javascript
// Principais auditorias para otimizar:
const optimizations = {
    'unused-css-rules': 'Remover CSS não utilizado',
    'unused-javascript': 'Remover JavaScript não utilizado', 
    'render-blocking-resources': 'Eliminar recursos que bloqueiam renderização',
    'unminified-css': 'Minificar CSS',
    'unminified-javascript': 'Minificar JavaScript',
    'next-gen-images': 'Usar formatos de imagem modernos',
    'offscreen-images': 'Lazy loading para imagens',
    'uses-text-compression': 'Ativar compressão de texto'
};
```

#### **Implementação de Correções**
```html
<!-- ✅ Eliminar recursos bloqueantes -->
<link rel="preload" href="critical.css" as="style" onload="this.onload=null;this.rel='stylesheet'">

<!-- ✅ Lazy loading de imagens -->
<img src="image.jpg" loading="lazy" alt="Descrição">

<!-- ✅ Formatos modernos de imagem -->
<picture>
    <source srcset="image.avif" type="image/avif">
    <source srcset="image.webp" type="image/webp">
    <img src="image.jpg" alt="Descrição">
</picture>

<!-- ✅ Preconnect para recursos externos -->
<link rel="preconnect" href="https://fonts.googleapis.com">
```

### **Otimizações por Métrica**

#### **Para Melhorar LCP**
1. **Otimizar servidor**: Reduzir TTFB
2. **Preload recursos críticos**: Fontes, imagens hero
3. **Otimizar imagens**: WebP/AVIF, dimensões corretas
4. **CSS crítico inline**: Above-the-fold styles

#### **Para Melhorar INP**
1. **Code splitting**: Carregar JS sob demanda
2. **Web Workers**: Mover processamento pesado
3. **Debounce/throttle**: Otimizar event handlers
4. **Reduzir JavaScript**: Menos código = menos bloqueio

#### **Para Melhorar CLS**
1. **Dimensões de imagem**: width/height sempre
2. **Reservar espaço**: Para anúncios e embeds
3. **Font loading**: font-display: swap
4. **Evitar inserções**: Conteúdo dinâmico acima do fold

## 📊 Monitoramento Contínuo

### **Estratégia de Monitoramento**
```javascript
// 1. Monitoramento automatizado
const monitoringScript = `
// Executar análise diária
const dailyCheck = async () => {
    const urls = ['/', '/produtos', '/contato'];
    
    for (const url of urls) {
        const result = await analyzePageSpeed(url);
        
        // Alertar se pontuação < 80
        if (result.lighthouseResult.categories.performance.score < 0.8) {
            sendAlert(`Performance degradada em ${url}`);
        }
        
        // Salvar histórico
        saveToDatabase(url, result);
    }
};

// Executar a cada 24h
setInterval(dailyCheck, 24 * 60 * 60 * 1000);
`;
```

### **Alertas e Thresholds**
```javascript
const thresholds = {
    performance: 80,        // Pontuação mínima
    lcp: 2500,             // LCP máximo (ms)
    inp: 200,              // INP máximo (ms)  
    cls: 0.1,              // CLS máximo
    fcp: 1800              // FCP máximo (ms)
};

function checkThresholds(data) {
    const alerts = [];
    
    // Verificar pontuação geral
    const perfScore = data.lighthouseResult.categories.performance.score * 100;
    if (perfScore < thresholds.performance) {
        alerts.push(`Performance score: ${perfScore} (< ${thresholds.performance})`);
    }
    
    // Verificar métricas específicas
    const audits = data.lighthouseResult.audits;
    const lcp = parseFloat(audits['largest-contentful-paint'].numericValue);
    if (lcp > thresholds.lcp) {
        alerts.push(`LCP: ${lcp}ms (> ${thresholds.lcp}ms)`);
    }
    
    return alerts;
}
```

### **Relatórios Regulares**
```javascript
// Gerar relatório semanal
const generateWeeklyReport = async () => {
    const pages = await getMonitoredPages();
    const report = {
        period: getLastWeek(),
        summary: {
            totalPages: pages.length,
            averageScore: 0,
            improvements: [],
            regressions: []
        },
        details: []
    };
    
    for (const page of pages) {
        const currentData = await getLatestData(page.url);
        const previousData = await getPreviousWeekData(page.url);
        
        const currentScore = currentData.performance.score * 100;
        const previousScore = previousData.performance.score * 100;
        const change = currentScore - previousScore;
        
        if (change > 5) {
            report.summary.improvements.push({
                url: page.url,
                change: `+${change.toFixed(1)}`
            });
        } else if (change < -5) {
            report.summary.regressions.push({
                url: page.url,
                change: change.toFixed(1)
            });
        }
        
        report.details.push({
            url: page.url,
            currentScore,
            change,
            coreWebVitals: extractCoreWebVitals(currentData)
        });
    }
    
    // Enviar relatório por email
    await sendEmailReport(report);
};
```

## 🔍 Troubleshooting

### **Problemas Comuns**

#### **"Dados de campo não disponíveis"**
```
Causas:
- Site novo ou com pouco tráfego
- URL não público/indexável  
- Usuários não optaram pelo CrUX

Soluções:
- Aguardar acúmulo de dados (28 dias)
- Verificar indexação no Google
- Focar em dados de laboratório
```

#### **"Diferenças entre campo e laboratório"**
```
Causas:
- Condições reais vs simuladas
- Variabilidade de dispositivos/rede
- Cache e CDN em produção

Soluções:
- Usar ambos os dados como complementares
- Focar em tendências, não valores absolutos
- Implementar RUM próprio para mais detalhes
```

#### **"Pontuação varia entre execuções"**
```
Causas:
- Variabilidade de rede
- Contenção de recursos
- Diferentes data centers

Soluções:
- Executar múltiplas análises
- Focar em tendências de longo prazo
- Usar mediana de várias execuções
```

## ✅ Checklist de Otimização

### **📊 Análise Inicial**
- [ ] Executar PSI para páginas principais
- [ ] Identificar se há dados de campo disponíveis
- [ ] Documentar pontuações atuais
- [ ] Priorizar páginas com pior performance

### **⚡ Otimizações Técnicas**
- [ ] Implementar lazy loading
- [ ] Otimizar imagens (WebP/AVIF)
- [ ] Minificar CSS/JS
- [ ] Eliminar recursos bloqueantes
- [ ] Configurar cache adequado
- [ ] Implementar CDN

### **📈 Monitoramento**
- [ ] Configurar API key
- [ ] Implementar monitoramento automatizado
- [ ] Definir thresholds de alerta
- [ ] Configurar relatórios regulares
- [ ] Integrar com ferramentas de CI/CD

---

**📅 Última atualização**: 2025-01-09  
**🔧 Baseado em**: Documentação oficial PageSpeed Insights API v5  
**📊 Fonte**: Google PageSpeed Insights, Lighthouse, Chrome UX Report
