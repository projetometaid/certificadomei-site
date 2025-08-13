# 🌐 Google Web Development - Guia Completo de Desenvolvimento Moderno

> **Baseado na documentação oficial do Google** - Análise de 6 cursos Web.dev + melhores práticas

## 📋 Índice

1. [Visão Geral Web.dev](#visão-geral-webdev)
2. [Design Responsivo Avançado](#design-responsivo-avançado)
3. [Acessibilidade Completa](#acessibilidade-completa)
4. [Formulários Modernos](#formulários-modernos)
5. [Imagens e Mídia](#imagens-e-mídia)
6. [Privacidade e Segurança](#privacidade-e-segurança)
7. [Performance e Otimização](#performance-e-otimização)
8. [Ferramentas e Workflow](#ferramentas-e-workflow)

## 🎯 Visão Geral Web.dev

### **O que é Web.dev?**
Web.dev é a plataforma oficial do Google para ensinar desenvolvimento web moderno, oferecendo:
- ✅ **Cursos estruturados** com 17+ módulos cada
- ✅ **Melhores práticas** validadas pelo Google
- ✅ **Autoavaliações** para testar conhecimento
- ✅ **Exemplos práticos** e demonstrações
- ✅ **Atualizações constantes** com tecnologias emergentes

### **Filosofia de Desenvolvimento**
```
🎯 Mobile-first sempre
♿ Acessibilidade por design
⚡ Performance como prioridade
🔒 Privacidade e segurança
🌍 Internacionalização nativa
```

### **Cursos Principais Analisados**
1. **Learn Responsive Design** (17 atividades)
2. **Learn Accessibility** (21 atividades)
3. **Learn Forms** (módulos de formulários)
4. **Learn Images** (otimização de mídia)
5. **Learn Privacy** (privacidade e segurança)
6. **Learn HTML** (fundamentos semânticos)

## 📱 Design Responsivo Avançado

### **Evolução do Design Responsivo**

#### **Histórico das Abordagens**
```css
/* ❌ Design de largura fixa (anos 90-2000) */
.container {
    width: 640px; /* Depois 800px, 1024px... */
}

/* ⚠️ Layout líquido (anos 2000) */
.container {
    width: 100%;
    min-width: 320px;
    max-width: 1200px;
}

/* ✅ Design responsivo moderno (2010+) */
.container {
    width: 100%;
    padding: clamp(16px, 4vw, 40px);
}
```

### **Consultas de Mídia Avançadas**

#### **Tipos de Mídia e Condições**
```css
/* ✅ Segmentar diferentes saídas */
@media screen {
    body { background: #ffffff; }
}

@media print {
    body { 
        background: transparent;
        color: black;
    }
}

/* ✅ Orientação e proporção */
@media (orientation: landscape) and (min-aspect-ratio: 16/9) {
    .video-container {
        aspect-ratio: 16/9;
    }
}

/* ✅ Preferências do usuário */
@media (prefers-reduced-motion: reduce) {
    * {
        animation-duration: 0.01ms !important;
        animation-iteration-count: 1 !important;
        transition-duration: 0.01ms !important;
    }
}

@media (prefers-color-scheme: dark) {
    :root {
        --bg-color: #121212;
        --text-color: #ffffff;
    }
}
```

#### **Consultas de Contêiner**
```css
/* ✅ Responsividade baseada no contêiner */
.sidebar, .main-content {
    container-type: inline-size;
}

.card {
    padding: 16px;
}

@container (min-width: 300px) {
    .card {
        display: grid;
        grid-template-columns: auto 1fr;
        gap: 16px;
    }
}

@container (min-width: 500px) {
    .card {
        grid-template-columns: 200px 1fr;
        padding: 24px;
    }
}
```

### **Layouts Modernos sem Media Queries**

#### **Grid Intrínseco**
```css
/* ✅ Layout que se adapta automaticamente */
.auto-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 1rem;
}

/* ✅ Layout de pancake (header/main/footer) */
.page-layout {
    display: grid;
    grid-template-rows: auto 1fr auto;
    min-height: 100vh;
}

/* ✅ Layout de sidebar flexível */
.sidebar-layout {
    display: grid;
    grid-template-columns: minmax(200px, 25%) 1fr;
    gap: 2rem;
}

@media (max-width: 768px) {
    .sidebar-layout {
        grid-template-columns: 1fr;
    }
}
```

#### **Flexbox Responsivo**
```css
/* ✅ Cards que se ajustam automaticamente */
.flex-cards {
    display: flex;
    flex-wrap: wrap;
    gap: 1rem;
}

.flex-cards .card {
    flex: 1 1 300px; /* grow shrink basis */
    min-width: 0; /* Permite shrinking */
}

/* ✅ Navegação adaptável */
.nav-flex {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
    align-items: center;
    gap: 1rem;
}
```

### **Tipografia Fluida**

#### **Escalas Responsivas**
```css
/* ✅ Tipografia que escala com viewport */
:root {
    --font-size-sm: clamp(0.875rem, 0.8rem + 0.375vw, 1rem);
    --font-size-base: clamp(1rem, 0.9rem + 0.5vw, 1.25rem);
    --font-size-lg: clamp(1.25rem, 1.1rem + 0.75vw, 1.75rem);
    --font-size-xl: clamp(1.75rem, 1.5rem + 1.25vw, 2.5rem);
    --font-size-2xl: clamp(2.5rem, 2rem + 2.5vw, 4rem);
}

/* ✅ Line-height responsivo */
.text-content {
    font-size: var(--font-size-base);
    line-height: calc(1.4 + 0.2 * ((100vw - 320px) / (1200 - 320)));
}

/* ✅ Medida (largura de linha) otimizada */
.readable-text {
    max-inline-size: 66ch; /* ~66 caracteres */
    line-height: 1.6;
}
```

## ♿ Acessibilidade Completa

### **Princípios POUR**

#### **1. Perceptível**
```html
<!-- ✅ Imagens com alt text descritivo -->
<img src="chart.png" 
     alt="Gráfico de vendas mostrando crescimento de 25% em 2024"
     width="600" 
     height="400">

<!-- ✅ Vídeos com legendas e transcrições -->
<video controls>
    <source src="tutorial.mp4" type="video/mp4">
    <track kind="captions" src="captions.vtt" srclang="pt" label="Português">
    <track kind="descriptions" src="descriptions.vtt" srclang="pt" label="Descrições">
</video>

<!-- ✅ Contraste adequado -->
<style>
.high-contrast {
    color: #212121; /* Contraste 4.5:1 mínimo */
    background: #ffffff;
}

.error-text {
    color: #d32f2f; /* Contraste 4.5:1 com fundo branco */
}
</style>
```

#### **2. Operável**
```html
<!-- ✅ Navegação por teclado -->
<nav aria-label="Navegação principal">
    <ul>
        <li><a href="/" tabindex="0">Início</a></li>
        <li><a href="/produtos" tabindex="0">Produtos</a></li>
        <li><a href="/contato" tabindex="0">Contato</a></li>
    </ul>
</nav>

<!-- ✅ Controles de mídia acessíveis -->
<div class="video-controls">
    <button aria-label="Reproduzir vídeo" id="play-btn">
        <span aria-hidden="true">▶️</span>
    </button>
    <button aria-label="Pausar vídeo" id="pause-btn">
        <span aria-hidden="true">⏸️</span>
    </button>
    <input type="range" 
           aria-label="Controle de volume" 
           min="0" 
           max="100" 
           value="50">
</div>

<!-- ✅ Tempo suficiente para interações -->
<div class="timeout-warning" role="alert">
    <p>Sua sessão expirará em <span id="countdown">5:00</span> minutos.</p>
    <button onclick="extendSession()">Estender sessão</button>
</div>
```

#### **3. Compreensível**
```html
<!-- ✅ Linguagem clara e simples -->
<main>
    <h1>Como criar uma conta</h1>
    <p>Siga estes 3 passos simples:</p>
    <ol>
        <li>Preencha o formulário abaixo</li>
        <li>Verifique seu email</li>
        <li>Faça login com suas credenciais</li>
    </ol>
</main>

<!-- ✅ Mensagens de erro claras -->
<div class="error-message" role="alert" aria-live="polite">
    <h2>Erro no formulário</h2>
    <p>Por favor, corrija os seguintes problemas:</p>
    <ul>
        <li><a href="#email">Email: formato inválido</a></li>
        <li><a href="#password">Senha: deve ter pelo menos 8 caracteres</a></li>
    </ul>
</div>

<!-- ✅ Navegação previsível -->
<header>
    <nav aria-label="Navegação principal">
        <!-- Mesma estrutura em todas as páginas -->
    </nav>
</header>
```

#### **4. Robusto**
```html
<!-- ✅ HTML semântico válido -->
<article>
    <header>
        <h1>Título do Artigo</h1>
        <time datetime="2025-01-09">9 de Janeiro, 2025</time>
    </header>
    
    <section>
        <h2>Seção Principal</h2>
        <p>Conteúdo do artigo...</p>
    </section>
    
    <footer>
        <p>Autor: João Silva</p>
    </footer>
</article>

<!-- ✅ ARIA quando necessário -->
<div role="tablist" aria-label="Configurações da conta">
    <button role="tab" 
            aria-selected="true" 
            aria-controls="panel-1" 
            id="tab-1">
        Perfil
    </button>
    <button role="tab" 
            aria-selected="false" 
            aria-controls="panel-2" 
            id="tab-2">
        Privacidade
    </button>
</div>

<div role="tabpanel" 
     id="panel-1" 
     aria-labelledby="tab-1">
    <!-- Conteúdo do painel -->
</div>
```

### **Testes de Acessibilidade**

#### **Ferramentas Automatizadas**
```javascript
// ✅ Integração com axe-core
import { axe, toHaveNoViolations } from 'jest-axe';

expect.extend(toHaveNoViolations);

test('página deve ser acessível', async () => {
    const { container } = render(<App />);
    const results = await axe(container);
    expect(results).toHaveNoViolations();
});

// ✅ Lighthouse CI para acessibilidade
// lighthouse-ci.json
{
    "ci": {
        "assert": {
            "assertions": {
                "categories:accessibility": ["error", {"minScore": 0.9}]
            }
        }
    }
}
```

#### **Testes Manuais**
```javascript
// ✅ Teste de navegação por teclado
const testKeyboardNavigation = () => {
    // Tab através de todos os elementos focáveis
    const focusableElements = document.querySelectorAll(
        'a, button, input, textarea, select, [tabindex]:not([tabindex="-1"])'
    );
    
    focusableElements.forEach((element, index) => {
        element.addEventListener('focus', () => {
            console.log(`Elemento ${index + 1} focado:`, element);
        });
    });
};

// ✅ Teste de leitores de tela
const announceToScreenReader = (message) => {
    const announcement = document.createElement('div');
    announcement.setAttribute('aria-live', 'polite');
    announcement.setAttribute('aria-atomic', 'true');
    announcement.className = 'sr-only';
    announcement.textContent = message;
    
    document.body.appendChild(announcement);
    
    setTimeout(() => {
        document.body.removeChild(announcement);
    }, 1000);
};
```

## 📝 Formulários Modernos

### **Estrutura Semântica**
```html
<!-- ✅ Formulário bem estruturado -->
<form novalidate>
    <fieldset>
        <legend>Informações Pessoais</legend>
        
        <div class="form-group">
            <label for="name">Nome completo *</label>
            <input type="text" 
                   id="name" 
                   name="name" 
                   required 
                   aria-describedby="name-help name-error"
                   autocomplete="name">
            <div id="name-help" class="help-text">
                Digite seu nome completo como aparece no documento
            </div>
            <div id="name-error" class="error-text" aria-live="polite"></div>
        </div>
        
        <div class="form-group">
            <label for="email">Email *</label>
            <input type="email" 
                   id="email" 
                   name="email" 
                   required 
                   aria-describedby="email-help email-error"
                   autocomplete="email">
            <div id="email-help" class="help-text">
                Usaremos este email para contato
            </div>
            <div id="email-error" class="error-text" aria-live="polite"></div>
        </div>
    </fieldset>
    
    <fieldset>
        <legend>Preferências de Contato</legend>
        
        <div class="radio-group" role="radiogroup" aria-labelledby="contact-legend">
            <div class="radio-item">
                <input type="radio" id="contact-email" name="contact" value="email">
                <label for="contact-email">Email</label>
            </div>
            <div class="radio-item">
                <input type="radio" id="contact-phone" name="contact" value="phone">
                <label for="contact-phone">Telefone</label>
            </div>
        </div>
    </fieldset>
    
    <div class="form-actions">
        <button type="submit" class="btn-primary">Enviar</button>
        <button type="reset" class="btn-secondary">Limpar</button>
    </div>
</form>
```

### **Validação Acessível**
```javascript
// ✅ Validação em tempo real acessível
class AccessibleFormValidator {
    constructor(form) {
        this.form = form;
        this.setupValidation();
    }
    
    setupValidation() {
        this.form.addEventListener('submit', this.handleSubmit.bind(this));
        
        // Validação em tempo real
        this.form.querySelectorAll('input, textarea, select').forEach(field => {
            field.addEventListener('blur', () => this.validateField(field));
            field.addEventListener('input', () => this.clearErrors(field));
        });
    }
    
    validateField(field) {
        const errors = [];
        
        // Validação required
        if (field.hasAttribute('required') && !field.value.trim()) {
            errors.push(`${this.getFieldLabel(field)} é obrigatório`);
        }
        
        // Validação de email
        if (field.type === 'email' && field.value) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(field.value)) {
                errors.push('Digite um email válido');
            }
        }
        
        // Validação de senha
        if (field.type === 'password' && field.value) {
            if (field.value.length < 8) {
                errors.push('A senha deve ter pelo menos 8 caracteres');
            }
        }
        
        this.displayErrors(field, errors);
        return errors.length === 0;
    }
    
    displayErrors(field, errors) {
        const errorContainer = document.getElementById(`${field.id}-error`);
        
        if (errors.length > 0) {
            field.setAttribute('aria-invalid', 'true');
            field.classList.add('error');
            errorContainer.textContent = errors[0];
            errorContainer.style.display = 'block';
        } else {
            field.removeAttribute('aria-invalid');
            field.classList.remove('error');
            errorContainer.textContent = '';
            errorContainer.style.display = 'none';
        }
    }
    
    clearErrors(field) {
        if (field.classList.contains('error')) {
            this.validateField(field);
        }
    }
    
    getFieldLabel(field) {
        const label = document.querySelector(`label[for="${field.id}"]`);
        return label ? label.textContent.replace('*', '').trim() : field.name;
    }
    
    handleSubmit(event) {
        event.preventDefault();
        
        let isValid = true;
        const fields = this.form.querySelectorAll('input, textarea, select');
        
        fields.forEach(field => {
            if (!this.validateField(field)) {
                isValid = false;
            }
        });
        
        if (isValid) {
            this.submitForm();
        } else {
            // Focar no primeiro campo com erro
            const firstError = this.form.querySelector('.error');
            if (firstError) {
                firstError.focus();
                this.announceErrors();
            }
        }
    }
    
    announceErrors() {
        const errorCount = this.form.querySelectorAll('.error').length;
        const message = `Formulário contém ${errorCount} erro${errorCount > 1 ? 's' : ''}. Por favor, corrija os campos destacados.`;
        
        // Anunciar para leitores de tela
        const announcement = document.createElement('div');
        announcement.setAttribute('aria-live', 'assertive');
        announcement.setAttribute('aria-atomic', 'true');
        announcement.className = 'sr-only';
        announcement.textContent = message;
        
        document.body.appendChild(announcement);
        
        setTimeout(() => {
            document.body.removeChild(announcement);
        }, 1000);
    }
    
    submitForm() {
        // Lógica de envio do formulário
        console.log('Formulário válido, enviando...');
    }
}

// Inicializar validação
document.addEventListener('DOMContentLoaded', () => {
    const forms = document.querySelectorAll('form');
    forms.forEach(form => new AccessibleFormValidator(form));
});
```

## 🖼️ Imagens e Mídia

### **Imagens Responsivas Avançadas**
```html
<!-- ✅ Picture element com art direction -->
<picture>
    <!-- Mobile: imagem quadrada -->
    <source media="(max-width: 767px)" 
            srcset="hero-mobile.avif 480w, hero-mobile@2x.avif 960w"
            type="image/avif">
    <source media="(max-width: 767px)" 
            srcset="hero-mobile.webp 480w, hero-mobile@2x.webp 960w"
            type="image/webp">
    <source media="(max-width: 767px)" 
            srcset="hero-mobile.jpg 480w, hero-mobile@2x.jpg 960w">
    
    <!-- Desktop: imagem widescreen -->
    <source srcset="hero-desktop.avif 1200w, hero-desktop@2x.avif 2400w"
            type="image/avif">
    <source srcset="hero-desktop.webp 1200w, hero-desktop@2x.webp 2400w"
            type="image/webp">
    
    <img src="hero-desktop.jpg"
         srcset="hero-desktop.jpg 1200w, hero-desktop@2x.jpg 2400w"
         sizes="(max-width: 767px) 100vw, 1200px"
         alt="Equipe trabalhando em projeto colaborativo"
         width="1200"
         height="600"
         loading="lazy">
</picture>

<!-- ✅ Lazy loading com intersection observer -->
<img class="lazy-image" 
     src="placeholder.jpg"
     data-src="actual-image.jpg"
     data-srcset="image-480.jpg 480w, image-800.jpg 800w, image-1200.jpg 1200w"
     alt="Descrição da imagem"
     width="800"
     height="600"
     loading="lazy">
```

### **Otimização de Performance**
```javascript
// ✅ Lazy loading com Intersection Observer
class LazyImageLoader {
    constructor() {
        this.imageObserver = new IntersectionObserver(
            this.handleIntersection.bind(this),
            {
                rootMargin: '50px 0px',
                threshold: 0.01
            }
        );
        
        this.init();
    }
    
    init() {
        const lazyImages = document.querySelectorAll('.lazy-image');
        lazyImages.forEach(img => this.imageObserver.observe(img));
    }
    
    handleIntersection(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                this.loadImage(entry.target);
                this.imageObserver.unobserve(entry.target);
            }
        });
    }
    
    loadImage(img) {
        // Preload da imagem
        const imageLoader = new Image();
        
        imageLoader.onload = () => {
            // Aplicar srcset se disponível
            if (img.dataset.srcset) {
                img.srcset = img.dataset.srcset;
            }
            
            // Aplicar src
            img.src = img.dataset.src;
            
            // Remover classe lazy
            img.classList.remove('lazy-image');
            img.classList.add('loaded');
            
            // Fade in effect
            img.style.opacity = '1';
        };
        
        imageLoader.onerror = () => {
            img.classList.add('error');
            console.error('Erro ao carregar imagem:', img.dataset.src);
        };
        
        // Iniciar carregamento
        imageLoader.src = img.dataset.src;
    }
}

// Inicializar lazy loading
document.addEventListener('DOMContentLoaded', () => {
    new LazyImageLoader();
});
```

### **Vídeos Acessíveis**
```html
<!-- ✅ Vídeo com controles completos -->
<div class="video-container">
    <video id="main-video" 
           controls 
           preload="metadata"
           poster="video-poster.jpg"
           aria-describedby="video-description">
        
        <source src="video.mp4" type="video/mp4">
        <source src="video.webm" type="video/webm">
        
        <!-- Legendas em múltiplos idiomas -->
        <track kind="captions" 
               src="captions-pt.vtt" 
               srclang="pt" 
               label="Português" 
               default>
        <track kind="captions" 
               src="captions-en.vtt" 
               srclang="en" 
               label="English">
        
        <!-- Descrições de áudio -->
        <track kind="descriptions" 
               src="descriptions-pt.vtt" 
               srclang="pt" 
               label="Descrições em Português">
        
        <!-- Fallback para navegadores sem suporte -->
        <p>Seu navegador não suporta vídeo HTML5. 
           <a href="video.mp4">Baixe o vídeo</a>.</p>
    </video>
    
    <div id="video-description" class="video-description">
        <h3>Descrição do Vídeo</h3>
        <p>Tutorial sobre desenvolvimento web responsivo, mostrando técnicas de CSS Grid e Flexbox.</p>
    </div>
    
    <!-- Transcrição completa -->
    <details class="video-transcript">
        <summary>Ver transcrição completa</summary>
        <div class="transcript-content">
            <p><strong>[00:00]</strong> Olá, bem-vindos ao tutorial de CSS Grid...</p>
            <p><strong>[00:15]</strong> Primeiro, vamos entender os conceitos básicos...</p>
        </div>
    </details>
</div>
```

## 🔒 Privacidade e Segurança

### **Implementação de Privacidade**
```html
<!-- ✅ Consentimento de cookies -->
<div id="cookie-banner" class="cookie-banner" role="dialog" aria-labelledby="cookie-title">
    <div class="cookie-content">
        <h2 id="cookie-title">Configurações de Privacidade</h2>
        <p>Usamos cookies para melhorar sua experiência. Você pode escolher quais tipos aceitar:</p>
        
        <div class="cookie-categories">
            <div class="cookie-category">
                <input type="checkbox" id="essential" checked disabled>
                <label for="essential">
                    <strong>Essenciais</strong> - Necessários para o funcionamento do site
                </label>
            </div>
            
            <div class="cookie-category">
                <input type="checkbox" id="analytics">
                <label for="analytics">
                    <strong>Analytics</strong> - Nos ajudam a entender como você usa o site
                </label>
            </div>
            
            <div class="cookie-category">
                <input type="checkbox" id="marketing">
                <label for="marketing">
                    <strong>Marketing</strong> - Personalizam anúncios e conteúdo
                </label>
            </div>
        </div>
        
        <div class="cookie-actions">
            <button onclick="acceptSelected()" class="btn-primary">Aceitar Selecionados</button>
            <button onclick="acceptAll()" class="btn-secondary">Aceitar Todos</button>
            <button onclick="rejectAll()" class="btn-text">Rejeitar Opcionais</button>
        </div>
    </div>
</div>
```

### **Segurança de Formulários**
```javascript
// ✅ Validação e sanitização segura
class SecureFormHandler {
    constructor(form) {
        this.form = form;
        this.setupSecurity();
    }
    
    setupSecurity() {
        // CSRF Protection
        this.addCSRFToken();
        
        // Rate limiting
        this.setupRateLimit();
        
        // Input sanitization
        this.setupSanitization();
    }
    
    addCSRFToken() {
        const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
        const hiddenInput = document.createElement('input');
        hiddenInput.type = 'hidden';
        hiddenInput.name = '_token';
        hiddenInput.value = csrfToken;
        this.form.appendChild(hiddenInput);
    }
    
    setupRateLimit() {
        const submitButton = this.form.querySelector('button[type="submit"]');
        let submitCount = 0;
        const maxSubmits = 3;
        const timeWindow = 60000; // 1 minuto
        
        this.form.addEventListener('submit', (e) => {
            submitCount++;
            
            if (submitCount > maxSubmits) {
                e.preventDefault();
                this.showError('Muitas tentativas. Tente novamente em 1 minuto.');
                return;
            }
            
            // Reset counter após time window
            setTimeout(() => {
                submitCount = 0;
            }, timeWindow);
        });
    }
    
    setupSanitization() {
        this.form.querySelectorAll('input, textarea').forEach(field => {
            field.addEventListener('input', (e) => {
                // Sanitizar entrada básica
                e.target.value = this.sanitizeInput(e.target.value, e.target.type);
            });
        });
    }
    
    sanitizeInput(value, type) {
        // Remover scripts maliciosos
        value = value.replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '');
        
        // Sanitização específica por tipo
        switch (type) {
            case 'email':
                return value.toLowerCase().trim();
            case 'tel':
                return value.replace(/[^\d\s\-\+\(\)]/g, '');
            case 'url':
                return value.trim();
            default:
                return value.trim();
        }
    }
    
    showError(message) {
        const errorDiv = document.createElement('div');
        errorDiv.className = 'security-error';
        errorDiv.setAttribute('role', 'alert');
        errorDiv.textContent = message;
        
        this.form.insertBefore(errorDiv, this.form.firstChild);
        
        setTimeout(() => {
            errorDiv.remove();
        }, 5000);
    }
}
```

## ✅ Checklist de Implementação

### **📱 Design Responsivo**
- [ ] Mobile-first CSS implementado
- [ ] Consultas de mídia baseadas em conteúdo
- [ ] Consultas de contêiner para componentes
- [ ] Tipografia fluida com clamp()
- [ ] Layouts intrínsecos sem media queries
- [ ] Testes em múltiplos dispositivos

### **♿ Acessibilidade**
- [ ] Princípios POUR aplicados
- [ ] HTML semântico correto
- [ ] ARIA usado adequadamente
- [ ] Navegação por teclado funcional
- [ ] Contraste adequado (4.5:1 mínimo)
- [ ] Testes automatizados e manuais

### **📝 Formulários**
- [ ] Labels associados corretamente
- [ ] Validação em tempo real acessível
- [ ] Mensagens de erro claras
- [ ] Autocomplete implementado
- [ ] Fieldsets para agrupamento
- [ ] Estados de loading e sucesso

### **🖼️ Mídia**
- [ ] Imagens responsivas com srcset
- [ ] Lazy loading implementado
- [ ] Alt text descritivo
- [ ] Formatos modernos (AVIF, WebP)
- [ ] Vídeos com legendas e transcrições
- [ ] Controles de mídia acessíveis

### **🔒 Privacidade e Segurança**
- [ ] Consentimento de cookies implementado
- [ ] CSRF protection ativo
- [ ] Rate limiting configurado
- [ ] Sanitização de inputs
- [ ] HTTPS obrigatório
- [ ] Headers de segurança configurados

---

**📅 Última atualização**: 2025-01-09  
**🔧 Baseado em**: 6 cursos Web.dev + documentação Google  
**📊 Fonte**: Learn Responsive Design, Learn Accessibility, Learn Forms, Learn Images, Learn Privacy, Learn HTML
