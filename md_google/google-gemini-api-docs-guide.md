# 📚 Google Gemini API - Documentação Completa

> **Baseado na documentação oficial do Google** - Análise de 12+ arquivos Documentos da API Gemini + guias práticos

## 📋 Índice

1. [Início Rápido e Setup](#início-rápido-e-setup)
2. [Geração de Texto Avançada](#geração-de-texto-avançada)
3. [Geração de Imagens](#geração-de-imagens)
4. [Processamento Multimodal](#processamento-multimodal)
5. [Chat e Conversação](#chat-e-conversação)
6. [Streaming e Tempo Real](#streaming-e-tempo-real)
7. [Ferramentas e Funções](#ferramentas-e-funções)
8. [Otimização e Performance](#otimização-e-performance)

## 🚀 Início Rápido e Setup

### **Configuração Inicial Completa**

#### **Instalação Multi-Plataforma**
```bash
# ✅ Node.js/TypeScript (Recomendado)
npm install @google/genai

# ✅ Python
pip install google-genai

# ✅ Go
go get google.golang.org/genai

# ✅ Apps Script (Google Workspace)
# Usar diretamente no Google Apps Script
```

#### **Configuração de API Key Segura**
```javascript
// ✅ Configuração segura para produção
import { GoogleGenAI } from "@google/genai";

class GeminiClient {
    constructor() {
        this.validateEnvironment();
        this.ai = new GoogleGenAI({
            apiKey: this.getApiKey(),
            httpOptions: {
                apiVersion: "v1beta",
                timeout: 30000,
                retries: 3
            }
        });
    }
    
    validateEnvironment() {
        if (!process.env.GEMINI_API_KEY) {
            throw new Error('GEMINI_API_KEY não configurada');
        }
        
        if (typeof window !== 'undefined') {
            console.warn('⚠️ Não use API keys no frontend em produção!');
        }
    }
    
    getApiKey() {
        // Prioridade: variável de ambiente > arquivo de config > erro
        return process.env.GEMINI_API_KEY || 
               this.loadFromConfig() || 
               (() => { throw new Error('API Key não encontrada'); })();
    }
    
    loadFromConfig() {
        try {
            const config = require('./config.json');
            return config.geminiApiKey;
        } catch {
            return null;
        }
    }
    
    async testConnection() {
        try {
            const response = await this.ai.models.generateContent({
                model: "gemini-2.0-flash",
                contents: "Test connection"
            });
            
            console.log('✅ Conexão com Gemini estabelecida');
            return true;
        } catch (error) {
            console.error('❌ Erro na conexão:', error.message);
            return false;
        }
    }
}

// Inicialização
const gemini = new GeminiClient();
await gemini.testConnection();
```

### **Configuração de Ambiente por Sistema**

#### **Linux/macOS**
```bash
# ✅ Configuração permanente
echo 'export GEMINI_API_KEY="sua-api-key-aqui"' >> ~/.bashrc
source ~/.bashrc

# ✅ Verificar configuração
curl "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${GEMINI_API_KEY}" \
  -H 'Content-Type: application/json' \
  -X POST \
  -d '{"contents": [{"parts": [{"text": "Hello Gemini!"}]}]}'
```

#### **Windows**
```powershell
# ✅ PowerShell
$env:GEMINI_API_KEY = "sua-api-key-aqui"
[Environment]::SetEnvironmentVariable("GEMINI_API_KEY", "sua-api-key-aqui", "User")

# ✅ Verificar
Invoke-RestMethod -Uri "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$env:GEMINI_API_KEY" `
  -Method POST `
  -ContentType "application/json" `
  -Body '{"contents": [{"parts": [{"text": "Hello Gemini!"}]}]}'
```

## 📝 Geração de Texto Avançada

### **Sistema de Geração Inteligente**

#### **Gerador de Texto com Configurações Dinâmicas**
```javascript
// ✅ Sistema avançado de geração de texto
class AdvancedTextGenerator {
    constructor(geminiClient) {
        this.client = geminiClient;
        this.presets = this.initializePresets();
        this.cache = new Map();
    }
    
    initializePresets() {
        return {
            creative: {
                temperature: 0.9,
                topP: 0.8,
                topK: 40,
                maxOutputTokens: 2048
            },
            balanced: {
                temperature: 0.7,
                topP: 0.8,
                topK: 40,
                maxOutputTokens: 1024
            },
            precise: {
                temperature: 0.1,
                topP: 0.9,
                topK: 20,
                maxOutputTokens: 512
            },
            analytical: {
                temperature: 0.3,
                topP: 0.9,
                topK: 30,
                maxOutputTokens: 1500
            }
        };
    }
    
    async generate(prompt, options = {}) {
        const config = this.buildConfig(prompt, options);
        const cacheKey = this.generateCacheKey(prompt, config);
        
        // Verificar cache
        if (this.cache.has(cacheKey) && options.useCache !== false) {
            return this.cache.get(cacheKey);
        }
        
        try {
            const response = await this.client.ai.models.generateContent({
                model: options.model || "gemini-2.0-flash",
                contents: this.formatPrompt(prompt, options),
                generationConfig: config.generation,
                safetySettings: config.safety,
                systemInstruction: config.systemInstruction
            });
            
            const result = this.processResponse(response, options);
            
            // Cache resultado
            if (options.useCache !== false) {
                this.cache.set(cacheKey, result);
            }
            
            return result;
        } catch (error) {
            throw this.handleError(error, prompt, options);
        }
    }
    
    buildConfig(prompt, options) {
        const preset = this.presets[options.preset] || this.presets.balanced;
        
        return {
            generation: {
                ...preset,
                ...options.generationConfig,
                // Ajustes dinâmicos baseados no prompt
                temperature: this.adjustTemperature(prompt, preset.temperature, options),
                maxOutputTokens: this.adjustMaxTokens(prompt, preset.maxOutputTokens, options)
            },
            safety: options.safetySettings || this.getDefaultSafetySettings(),
            systemInstruction: this.buildSystemInstruction(options)
        };
    }
    
    adjustTemperature(prompt, baseTemp, options) {
        // Reduzir temperatura para prompts técnicos
        if (this.isTechnicalPrompt(prompt)) {
            return Math.max(0.1, baseTemp - 0.3);
        }
        
        // Aumentar temperatura para prompts criativos
        if (this.isCreativePrompt(prompt)) {
            return Math.min(1.0, baseTemp + 0.2);
        }
        
        return baseTemp;
    }
    
    adjustMaxTokens(prompt, baseTokens, options) {
        const promptLength = prompt.length;
        
        // Mais tokens para prompts longos
        if (promptLength > 1000) {
            return Math.min(4096, baseTokens * 1.5);
        }
        
        // Menos tokens para prompts curtos
        if (promptLength < 100) {
            return Math.max(256, baseTokens * 0.7);
        }
        
        return baseTokens;
    }
    
    isTechnicalPrompt(prompt) {
        const technicalKeywords = [
            'code', 'programming', 'algorithm', 'function',
            'debug', 'error', 'syntax', 'documentation',
            'API', 'database', 'query', 'technical'
        ];
        
        const lowerPrompt = prompt.toLowerCase();
        return technicalKeywords.some(keyword => lowerPrompt.includes(keyword));
    }
    
    isCreativePrompt(prompt) {
        const creativeKeywords = [
            'story', 'creative', 'imagine', 'invent',
            'poem', 'song', 'character', 'plot',
            'artistic', 'design', 'brainstorm'
        ];
        
        const lowerPrompt = prompt.toLowerCase();
        return creativeKeywords.some(keyword => lowerPrompt.includes(keyword));
    }
    
    formatPrompt(prompt, options) {
        if (typeof prompt === 'string') {
            return [{
                role: "user",
                parts: [{ text: prompt }]
            }];
        }
        
        // Suporte para prompts multimodais
        return Array.isArray(prompt) ? prompt : [prompt];
    }
    
    buildSystemInstruction(options) {
        if (options.systemInstruction) {
            return { parts: [{ text: options.systemInstruction }] };
        }
        
        // Instruções padrão baseadas no tipo de tarefa
        const defaultInstructions = {
            technical: "You are a technical expert. Provide accurate, detailed, and well-structured responses.",
            creative: "You are a creative assistant. Be imaginative, engaging, and original in your responses.",
            analytical: "You are an analytical expert. Provide logical, evidence-based, and thorough analysis.",
            educational: "You are an educational assistant. Explain concepts clearly with examples and step-by-step guidance."
        };
        
        return options.taskType && defaultInstructions[options.taskType] 
            ? { parts: [{ text: defaultInstructions[options.taskType] }] }
            : null;
    }
    
    processResponse(response, options) {
        const result = {
            text: response.text,
            usage: response.usageMetadata,
            finishReason: response.candidates[0]?.finishReason,
            safetyRatings: response.candidates[0]?.safetyRatings,
            metadata: {
                model: options.model || "gemini-2.0-flash",
                preset: options.preset || "balanced",
                timestamp: new Date().toISOString()
            }
        };
        
        // Análise de qualidade
        result.quality = this.analyzeQuality(result.text, options);
        
        return result;
    }
    
    analyzeQuality(text, options) {
        return {
            length: text.length,
            wordCount: text.split(/\s+/).length,
            readabilityScore: this.calculateReadability(text),
            completeness: this.assessCompleteness(text, options),
            relevance: this.assessRelevance(text, options)
        };
    }
    
    calculateReadability(text) {
        // Implementação simplificada do Flesch Reading Ease
        const sentences = text.split(/[.!?]+/).length - 1;
        const words = text.split(/\s+/).length;
        const syllables = this.countSyllables(text);
        
        if (sentences === 0 || words === 0) return 0;
        
        const score = 206.835 - (1.015 * (words / sentences)) - (84.6 * (syllables / words));
        return Math.max(0, Math.min(100, score));
    }
    
    countSyllables(text) {
        // Estimativa simples de sílabas
        return text.toLowerCase()
            .replace(/[^a-z]/g, '')
            .replace(/[aeiou]{2,}/g, 'a')
            .replace(/[^aeiou]/g, '')
            .length || 1;
    }
    
    getDefaultSafetySettings() {
        return [
            {
                category: "HARM_CATEGORY_HARASSMENT",
                threshold: "BLOCK_MEDIUM_AND_ABOVE"
            },
            {
                category: "HARM_CATEGORY_HATE_SPEECH",
                threshold: "BLOCK_MEDIUM_AND_ABOVE"
            },
            {
                category: "HARM_CATEGORY_SEXUALLY_EXPLICIT",
                threshold: "BLOCK_MEDIUM_AND_ABOVE"
            },
            {
                category: "HARM_CATEGORY_DANGEROUS_CONTENT",
                threshold: "BLOCK_MEDIUM_AND_ABOVE"
            }
        ];
    }
}

// Exemplos de uso
const textGen = new AdvancedTextGenerator(gemini);

// Geração criativa
const story = await textGen.generate(
    "Write a short story about a robot learning to paint",
    {
        preset: "creative",
        taskType: "creative",
        maxOutputTokens: 800
    }
);

// Geração técnica
const documentation = await textGen.generate(
    "Explain how to implement OAuth 2.0 authentication",
    {
        preset: "precise",
        taskType: "technical",
        systemInstruction: "Provide code examples and security best practices"
    }
);

// Análise
const analysis = await textGen.generate(
    "Analyze the pros and cons of renewable energy",
    {
        preset: "analytical",
        taskType: "analytical"
    }
);
```

### **Templates e Prompts Estruturados**

#### **Sistema de Templates Reutilizáveis**
```javascript
// ✅ Sistema de templates para prompts
class PromptTemplateManager {
    constructor() {
        this.templates = new Map();
        this.initializeDefaultTemplates();
    }
    
    initializeDefaultTemplates() {
        // Template para análise de código
        this.addTemplate('code_review', {
            template: `
                Analyze the following code and provide:
                1. Code quality assessment
                2. Potential bugs or issues
                3. Performance improvements
                4. Best practices recommendations
                
                Code Language: {{language}}
                Code:
                \`\`\`{{language}}
                {{code}}
                \`\`\`
                
                Focus areas: {{focus_areas}}
            `,
            variables: ['language', 'code', 'focus_areas'],
            defaultValues: {
                focus_areas: 'security, performance, maintainability'
            }
        });
        
        // Template para criação de conteúdo
        this.addTemplate('content_creation', {
            template: `
                Create {{content_type}} about {{topic}} with the following requirements:
                
                Target Audience: {{audience}}
                Tone: {{tone}}
                Length: {{length}}
                Key Points to Cover:
                {{key_points}}
                
                Additional Requirements:
                {{requirements}}
            `,
            variables: ['content_type', 'topic', 'audience', 'tone', 'length', 'key_points', 'requirements'],
            defaultValues: {
                tone: 'professional and engaging',
                length: 'medium (500-800 words)',
                requirements: 'Include examples and actionable insights'
            }
        });
        
        // Template para resolução de problemas
        this.addTemplate('problem_solving', {
            template: `
                Help me solve this problem step by step:
                
                Problem: {{problem}}
                Context: {{context}}
                Constraints: {{constraints}}
                
                Please provide:
                1. Problem analysis
                2. Possible solutions (at least 3)
                3. Pros and cons of each solution
                4. Recommended approach with reasoning
                5. Implementation steps
            `,
            variables: ['problem', 'context', 'constraints'],
            defaultValues: {
                context: 'General business/technical context',
                constraints: 'Standard time and resource constraints'
            }
        });
    }
    
    addTemplate(name, template) {
        this.templates.set(name, {
            ...template,
            createdAt: new Date(),
            usageCount: 0
        });
    }
    
    renderTemplate(templateName, variables = {}) {
        const template = this.templates.get(templateName);
        if (!template) {
            throw new Error(`Template '${templateName}' não encontrado`);
        }
        
        // Incrementar contador de uso
        template.usageCount++;
        
        // Combinar variáveis com valores padrão
        const allVariables = {
            ...template.defaultValues,
            ...variables
        };
        
        // Verificar variáveis obrigatórias
        const missingVars = template.variables.filter(
            varName => !allVariables.hasOwnProperty(varName)
        );
        
        if (missingVars.length > 0) {
            throw new Error(`Variáveis obrigatórias faltando: ${missingVars.join(', ')}`);
        }
        
        // Renderizar template
        let rendered = template.template;
        for (const [key, value] of Object.entries(allVariables)) {
            const regex = new RegExp(`{{${key}}}`, 'g');
            rendered = rendered.replace(regex, value);
        }
        
        return rendered.trim();
    }
    
    listTemplates() {
        return Array.from(this.templates.entries()).map(([name, template]) => ({
            name,
            variables: template.variables,
            usageCount: template.usageCount,
            createdAt: template.createdAt
        }));
    }
    
    getTemplateUsage() {
        const templates = Array.from(this.templates.entries());
        return templates
            .sort((a, b) => b[1].usageCount - a[1].usageCount)
            .map(([name, template]) => ({
                name,
                usageCount: template.usageCount
            }));
    }
}

// Uso do sistema de templates
const templateManager = new PromptTemplateManager();

// Análise de código
const codeReviewPrompt = templateManager.renderTemplate('code_review', {
    language: 'JavaScript',
    code: `
        function calculateTotal(items) {
            let total = 0;
            for (let i = 0; i < items.length; i++) {
                total += items[i].price * items[i].quantity;
            }
            return total;
        }
    `,
    focus_areas: 'performance, modern JavaScript practices, error handling'
});

// Criação de conteúdo
const contentPrompt = templateManager.renderTemplate('content_creation', {
    content_type: 'blog post',
    topic: 'AI in healthcare',
    audience: 'healthcare professionals',
    key_points: `
        - Current AI applications in diagnostics
        - Benefits and challenges
        - Future trends
        - Implementation considerations
    `
});

// Usar com o gerador de texto
const codeReview = await textGen.generate(codeReviewPrompt, {
    preset: 'analytical',
    taskType: 'technical'
});
```

## 🎨 Geração de Imagens

### **Sistema Avançado de Geração de Imagens**

#### **Gerador de Imagens com Gemini e Imagen**
```javascript
// ✅ Sistema completo de geração de imagens
class ImageGenerationSystem {
    constructor(geminiClient) {
        this.client = geminiClient;
        this.imageCache = new Map();
        this.generationHistory = [];
    }
    
    async generateWithGemini(prompt, options = {}) {
        const config = {
            model: "gemini-2.0-flash-preview-image-generation",
            contents: this.formatPrompt(prompt, options),
            config: {
                responseModalities: ["TEXT", "IMAGE"],
                generationConfig: {
                    temperature: options.temperature || 0.7,
                    maxOutputTokens: options.maxOutputTokens || 1024
                }
            }
        };
        
        try {
            const response = await this.client.ai.models.generateContent(config);
            return this.processGeminiResponse(response, prompt, options);
        } catch (error) {
            throw this.handleImageError(error, 'gemini');
        }
    }
    
    async generateWithImagen(prompt, options = {}) {
        const config = {
            model: 'imagen-3.0-generate-002',
            prompt: prompt,
            config: {
                numberOfImages: options.numberOfImages || 1,
                aspectRatio: options.aspectRatio || "1:1",
                personGeneration: options.personGeneration || "ALLOW_ADULT"
            }
        };
        
        try {
            const response = await this.client.ai.models.generateImages(config);
            return this.processImagenResponse(response, prompt, options);
        } catch (error) {
            throw this.handleImageError(error, 'imagen');
        }
    }
    
    formatPrompt(prompt, options) {
        if (typeof prompt === 'string') {
            return prompt;
        }
        
        // Suporte para prompts com imagens de referência
        if (options.referenceImage) {
            return [
                { text: prompt },
                { image: options.referenceImage }
            ];
        }
        
        return prompt;
    }
    
    processGeminiResponse(response, prompt, options) {
        const result = {
            type: 'gemini',
            prompt: prompt,
            images: [],
            text: '',
            metadata: {
                model: 'gemini-2.0-flash-preview-image-generation',
                timestamp: new Date().toISOString(),
                options: options
            }
        };
        
        for (const candidate of response.candidates) {
            for (const part of candidate.content.parts) {
                if (part.text) {
                    result.text += part.text;
                } else if (part.inlineData) {
                    result.images.push({
                        data: part.inlineData.data,
                        mimeType: part.inlineData.mimeType,
                        size: this.estimateImageSize(part.inlineData.data)
                    });
                }
            }
        }
        
        this.generationHistory.push(result);
        return result;
    }
    
    processImagenResponse(response, prompt, options) {
        const result = {
            type: 'imagen',
            prompt: prompt,
            images: [],
            metadata: {
                model: 'imagen-3.0-generate-002',
                timestamp: new Date().toISOString(),
                options: options
            }
        };
        
        for (const generatedImage of response.generatedImages) {
            result.images.push({
                data: generatedImage.image.imageBytes,
                mimeType: 'image/jpeg',
                size: generatedImage.image.imageBytes.length
            });
        }
        
        this.generationHistory.push(result);
        return result;
    }
    
    async saveImages(generationResult, outputDir = './generated_images') {
        const fs = require('fs').promises;
        const path = require('path');
        
        // Criar diretório se não existir
        await fs.mkdir(outputDir, { recursive: true });
        
        const savedFiles = [];
        
        for (let i = 0; i < generationResult.images.length; i++) {
            const image = generationResult.images[i];
            const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
            const filename = `${generationResult.type}_${timestamp}_${i + 1}.${this.getFileExtension(image.mimeType)}`;
            const filepath = path.join(outputDir, filename);
            
            // Decodificar base64 se necessário
            const imageData = typeof image.data === 'string' 
                ? Buffer.from(image.data, 'base64')
                : image.data;
            
            await fs.writeFile(filepath, imageData);
            savedFiles.push({
                filename,
                filepath,
                size: image.size
            });
        }
        
        return savedFiles;
    }
    
    getFileExtension(mimeType) {
        const extensions = {
            'image/jpeg': 'jpg',
            'image/png': 'png',
            'image/webp': 'webp',
            'image/gif': 'gif'
        };
        return extensions[mimeType] || 'jpg';
    }
    
    estimateImageSize(base64Data) {
        // Estimar tamanho da imagem baseado no base64
        return Math.floor(base64Data.length * 0.75);
    }
    
    // Sistema de prompts otimizados para imagens
    optimizePrompt(prompt, style = 'photographic') {
        const styleModifiers = {
            photographic: [
                'high quality', 'professional photography', 'sharp focus',
                'good lighting', 'detailed'
            ],
            artistic: [
                'artistic', 'creative', 'stylized', 'expressive',
                'unique perspective'
            ],
            realistic: [
                'photorealistic', 'lifelike', 'natural', 'authentic',
                'true to life'
            ],
            fantasy: [
                'fantasy art', 'magical', 'ethereal', 'mystical',
                'otherworldly'
            ],
            minimalist: [
                'minimalist', 'clean', 'simple', 'elegant',
                'uncluttered'
            ]
        };
        
        const modifiers = styleModifiers[style] || styleModifiers.photographic;
        const randomModifiers = modifiers
            .sort(() => 0.5 - Math.random())
            .slice(0, 3);
        
        return `${prompt}, ${randomModifiers.join(', ')}`;
    }
    
    // Geração em lote
    async generateBatch(prompts, options = {}) {
        const results = [];
        const batchSize = options.batchSize || 3;
        const delay = options.delay || 1000; // ms entre requests
        
        for (let i = 0; i < prompts.length; i += batchSize) {
            const batch = prompts.slice(i, i + batchSize);
            const batchPromises = batch.map(prompt => 
                this.generateWithImagen(prompt, options)
            );
            
            try {
                const batchResults = await Promise.all(batchPromises);
                results.push(...batchResults);
                
                // Delay entre lotes
                if (i + batchSize < prompts.length) {
                    await new Promise(resolve => setTimeout(resolve, delay));
                }
            } catch (error) {
                console.error(`Erro no lote ${Math.floor(i / batchSize) + 1}:`, error);
                // Continuar com próximo lote
            }
        }
        
        return results;
    }
    
    // Análise de histórico
    getGenerationStats() {
        const stats = {
            totalGenerations: this.generationHistory.length,
            byModel: {},
            byDay: {},
            averageImagesPerGeneration: 0,
            totalImages: 0
        };
        
        for (const generation of this.generationHistory) {
            // Por modelo
            stats.byModel[generation.type] = (stats.byModel[generation.type] || 0) + 1;
            
            // Por dia
            const day = generation.metadata.timestamp.split('T')[0];
            stats.byDay[day] = (stats.byDay[day] || 0) + 1;
            
            // Total de imagens
            stats.totalImages += generation.images.length;
        }
        
        stats.averageImagesPerGeneration = stats.totalImages / stats.totalGenerations || 0;
        
        return stats;
    }
}

// Exemplos de uso
const imageGen = new ImageGenerationSystem(gemini);

// Geração com Gemini (conversacional)
const geminiResult = await imageGen.generateWithGemini(
    "Create a futuristic cityscape with flying cars and green buildings"
);

// Geração com Imagen (especializada)
const imagenResult = await imageGen.generateWithImagen(
    "A professional headshot of a confident business woman in modern office",
    {
        numberOfImages: 4,
        aspectRatio: "3:4",
        personGeneration: "ALLOW_ADULT"
    }
);

// Salvar imagens
const savedFiles = await imageGen.saveImages(imagenResult);
console.log('Imagens salvas:', savedFiles);

// Geração em lote
const prompts = [
    "A serene mountain landscape at sunset",
    "Modern minimalist kitchen design",
    "Abstract geometric art in blue tones"
];

const batchResults = await imageGen.generateBatch(prompts, {
    batchSize: 2,
    delay: 2000,
    aspectRatio: "16:9"
});
```

### **Editor de Imagens Conversacional**

#### **Sistema de Edição Interativa**
```javascript
// ✅ Editor de imagens conversacional
class ConversationalImageEditor {
    constructor(imageGenSystem) {
        this.imageGen = imageGenSystem;
        this.editHistory = [];
        this.currentImage = null;
    }
    
    async startEditing(initialPrompt, referenceImage = null) {
        const session = {
            id: this.generateSessionId(),
            startTime: new Date(),
            history: [],
            currentImage: null
        };
        
        // Primeira geração
        const result = await this.imageGen.generateWithGemini(initialPrompt, {
            referenceImage: referenceImage
        });
        
        session.currentImage = result.images[0];
        session.history.push({
            action: 'initial_generation',
            prompt: initialPrompt,
            result: result,
            timestamp: new Date()
        });
        
        this.editHistory.push(session);
        this.currentImage = result.images[0];
        
        return {
            sessionId: session.id,
            image: result.images[0],
            text: result.text
        };
    }
    
    async editImage(sessionId, editPrompt) {
        const session = this.findSession(sessionId);
        if (!session) {
            throw new Error('Sessão não encontrada');
        }
        
        // Usar imagem atual como referência para edição
        const editResult = await this.imageGen.generateWithGemini(
            editPrompt,
            {
                referenceImage: session.currentImage
            }
        );
        
        // Atualizar sessão
        session.currentImage = editResult.images[0];
        session.history.push({
            action: 'edit',
            prompt: editPrompt,
            result: editResult,
            timestamp: new Date()
        });
        
        return {
            image: editResult.images[0],
            text: editResult.text,
            historyLength: session.history.length
        };
    }
    
    async undoEdit(sessionId) {
        const session = this.findSession(sessionId);
        if (!session || session.history.length <= 1) {
            throw new Error('Não há edições para desfazer');
        }
        
        // Remover última edição
        session.history.pop();
        
        // Voltar para imagem anterior
        const previousEntry = session.history[session.history.length - 1];
        session.currentImage = previousEntry.result.images[0];
        
        return {
            image: session.currentImage,
            historyLength: session.history.length
        };
    }
    
    async suggestEdits(sessionId) {
        const session = this.findSession(sessionId);
        if (!session) {
            throw new Error('Sessão não encontrada');
        }
        
        // Analisar imagem atual e sugerir edições
        const analysisPrompt = `
            Analyze this image and suggest 5 creative editing ideas.
            Consider:
            - Color adjustments
            - Style changes
            - Adding/removing elements
            - Lighting modifications
            - Artistic effects
            
            Provide specific, actionable suggestions.
        `;
        
        const suggestions = await this.imageGen.client.ai.models.generateContent({
            model: "gemini-2.0-flash",
            contents: [
                { text: analysisPrompt },
                { 
                    inlineData: {
                        mimeType: session.currentImage.mimeType,
                        data: session.currentImage.data
                    }
                }
            ]
        });
        
        return {
            suggestions: suggestions.text,
            currentImage: session.currentImage
        };
    }
    
    findSession(sessionId) {
        return this.editHistory.find(session => session.id === sessionId);
    }
    
    generateSessionId() {
        return 'edit_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
    }
    
    getSessionHistory(sessionId) {
        const session = this.findSession(sessionId);
        return session ? session.history : null;
    }
    
    exportSession(sessionId, format = 'json') {
        const session = this.findSession(sessionId);
        if (!session) {
            throw new Error('Sessão não encontrada');
        }
        
        const exportData = {
            sessionId: session.id,
            startTime: session.startTime,
            duration: new Date() - session.startTime,
            totalEdits: session.history.length - 1,
            history: session.history.map(entry => ({
                action: entry.action,
                prompt: entry.prompt,
                timestamp: entry.timestamp,
                hasImage: !!entry.result.images.length
            }))
        };
        
        return format === 'json' 
            ? JSON.stringify(exportData, null, 2)
            : exportData;
    }
}

// Exemplo de uso do editor conversacional
const editor = new ConversationalImageEditor(imageGen);

// Iniciar sessão de edição
const session = await editor.startEditing(
    "A beautiful garden with colorful flowers"
);

console.log('Sessão iniciada:', session.sessionId);

// Fazer edições
const edit1 = await editor.editImage(
    session.sessionId,
    "Add a small pond with koi fish in the center"
);

const edit2 = await editor.editImage(
    session.sessionId,
    "Change the lighting to golden hour sunset"
);

const edit3 = await editor.editImage(
    session.sessionId,
    "Add a wooden bench under a cherry blossom tree"
);

// Sugerir mais edições
const suggestions = await editor.suggestEdits(session.sessionId);
console.log('Sugestões:', suggestions.suggestions);

// Desfazer última edição se necessário
const undone = await editor.undoEdit(session.sessionId);

// Exportar histórico da sessão
const history = editor.exportSession(session.sessionId);
console.log('Histórico da sessão:', history);
```

## 🎭 Processamento Multimodal

### **Sistema Unificado Multimodal**

#### **Processador de Múltiplas Modalidades**
```javascript
// ✅ Sistema completo de processamento multimodal
class MultimodalProcessor {
    constructor(geminiClient) {
        this.client = geminiClient;
        this.supportedFormats = {
            image: ['jpeg', 'jpg', 'png', 'webp', 'gif'],
            video: ['mp4', 'avi', 'mov', 'webm'],
            audio: ['mp3', 'wav', 'aac', 'ogg'],
            document: ['pdf', 'docx', 'txt', 'md']
        };
        this.processingHistory = [];
    }
    
    async processMultimodal(inputs, prompt, options = {}) {
        const processedInputs = await this.preprocessInputs(inputs);
        const formattedContents = this.formatContents(processedInputs, prompt);
        
        const config = {
            model: options.model || "gemini-2.0-flash",
            contents: formattedContents,
            generationConfig: {
                temperature: options.temperature || 0.7,
                maxOutputTokens: options.maxOutputTokens || 2048,
                ...options.generationConfig
            }
        };
        
        try {
            const response = await this.client.ai.models.generateContent(config);
            const result = this.processMultimodalResponse(response, inputs, prompt, options);
            
            this.processingHistory.push(result);
            return result;
        } catch (error) {
            throw this.handleMultimodalError(error, inputs, prompt);
        }
    }
    
    async preprocessInputs(inputs) {
        const processed = [];
        
        for (const input of inputs) {
            if (typeof input === 'string') {
                // Texto simples
                processed.push({ type: 'text', content: input });
            } else if (input.type === 'file') {
                // Arquivo local
                const fileData = await this.processFile(input.path);
                processed.push(fileData);
            } else if (input.type === 'url') {
                // URL de mídia
                const urlData = await this.processUrl(input.url);
                processed.push(urlData);
            } else if (input.type === 'base64') {
                // Dados base64
                processed.push({
                    type: input.mediaType,
                    content: input.data,
                    mimeType: input.mimeType
                });
            } else {
                // Dados já processados
                processed.push(input);
            }
        }
        
        return processed;
    }
    
    async processFile(filePath) {
        const fs = require('fs').promises;
        const path = require('path');
        const mime = require('mime-types');
        
        const fileBuffer = await fs.readFile(filePath);
        const mimeType = mime.lookup(filePath) || 'application/octet-stream';
        const extension = path.extname(filePath).toLowerCase().slice(1);
        
        return {
            type: this.getMediaType(extension),
            content: fileBuffer.toString('base64'),
            mimeType: mimeType,
            filename: path.basename(filePath),
            size: fileBuffer.length
        };
    }
    
    async processUrl(url) {
        const fetch = require('node-fetch');
        
        try {
            const response = await fetch(url);
            const buffer = await response.buffer();
            const mimeType = response.headers.get('content-type') || 'application/octet-stream';
            
            return {
                type: this.getMediaTypeFromMime(mimeType),
                content: buffer.toString('base64'),
                mimeType: mimeType,
                url: url,
                size: buffer.length
            };
        } catch (error) {
            throw new Error(`Erro ao processar URL ${url}: ${error.message}`);
        }
    }
    
    getMediaType(extension) {
        for (const [type, extensions] of Object.entries(this.supportedFormats)) {
            if (extensions.includes(extension)) {
                return type;
            }
        }
        return 'unknown';
    }
    
    getMediaTypeFromMime(mimeType) {
        if (mimeType.startsWith('image/')) return 'image';
        if (mimeType.startsWith('video/')) return 'video';
        if (mimeType.startsWith('audio/')) return 'audio';
        if (mimeType.includes('pdf') || mimeType.includes('document')) return 'document';
        return 'unknown';
    }
    
    formatContents(processedInputs, prompt) {
        const contents = [{
            role: "user",
            parts: []
        }];
        
        // Adicionar prompt de texto primeiro
        if (prompt) {
            contents[0].parts.push({ text: prompt });
        }
        
        // Adicionar inputs processados
        for (const input of processedInputs) {
            if (input.type === 'text') {
                contents[0].parts.push({ text: input.content });
            } else {
                contents[0].parts.push({
                    inlineData: {
                        mimeType: input.mimeType,
                        data: input.content
                    }
                });
            }
        }
        
        return contents;
    }
    
    processMultimodalResponse(response, inputs, prompt, options) {
        return {
            text: response.text,
            usage: response.usageMetadata,
            inputs: inputs.map(input => ({
                type: input.type || 'unknown',
                size: input.size || 0,
                filename: input.filename || null
            })),
            prompt: prompt,
            metadata: {
                model: options.model || "gemini-2.0-flash",
                timestamp: new Date().toISOString(),
                processingTime: Date.now() // Será calculado no final
            }
        };
    }
    
    // Análise específica de imagens
    async analyzeImages(imagePaths, analysisType = 'general') {
        const analysisPrompts = {
            general: "Describe what you see in these images in detail.",
            technical: "Provide a technical analysis of these images including composition, lighting, and quality.",
            comparison: "Compare and contrast these images, highlighting similarities and differences.",
            objects: "Identify and list all objects visible in these images.",
            text: "Extract and transcribe any text visible in these images.",
            accessibility: "Describe these images for accessibility purposes, focusing on important visual elements."
        };
        
        const prompt = analysisPrompts[analysisType] || analysisPrompts.general;
        const inputs = imagePaths.map(path => ({ type: 'file', path }));
        
        return await this.processMultimodal(inputs, prompt, {
            temperature: 0.3 // Mais preciso para análise
        });
    }
    
    // Análise de vídeo
    async analyzeVideo(videoPath, analysisOptions = {}) {
        const defaultPrompt = `
            Analyze this video and provide:
            1. Overall description of content
            2. Key scenes or moments
            3. Visual elements and composition
            4. Any text or graphics visible
            5. Duration and pacing assessment
        `;
        
        const prompt = analysisOptions.customPrompt || defaultPrompt;
        const inputs = [{ type: 'file', path: videoPath }];
        
        return await this.processMultimodal(inputs, prompt, {
            temperature: 0.4,
            maxOutputTokens: 3000
        });
    }
    
    // Análise de áudio
    async analyzeAudio(audioPath, analysisType = 'transcription') {
        const analysisPrompts = {
            transcription: "Transcribe the speech in this audio file accurately.",
            summary: "Provide a summary of the main points discussed in this audio.",
            sentiment: "Analyze the sentiment and emotional tone of the speech in this audio.",
            speaker: "Identify different speakers and their characteristics in this audio.",
            music: "Analyze the musical elements in this audio including genre, instruments, and mood."
        };
        
        const prompt = analysisPrompts[analysisType] || analysisPrompts.transcription;
        const inputs = [{ type: 'file', path: audioPath }];
        
        return await this.processMultimodal(inputs, prompt, {
            temperature: 0.2 // Muito preciso para transcrição
        });
    }
    
    // Análise de documentos
    async analyzeDocument(documentPath, analysisType = 'summary') {
        const analysisPrompts = {
            summary: "Provide a comprehensive summary of this document.",
            extraction: "Extract key information, dates, names, and important details from this document.",
            structure: "Analyze the structure and organization of this document.",
            translation: "Translate this document to English if it's in another language.",
            questions: "Generate relevant questions that this document answers."
        };
        
        const prompt = analysisPrompts[analysisType] || analysisPrompts.summary;
        const inputs = [{ type: 'file', path: documentPath }];
        
        return await this.processMultimodal(inputs, prompt, {
            temperature: 0.3,
            maxOutputTokens: 4000
        });
    }
    
    // Processamento em lote
    async processBatch(batchItems, options = {}) {
        const results = [];
        const batchSize = options.batchSize || 5;
        const delay = options.delay || 2000;
        
        for (let i = 0; i < batchItems.length; i += batchSize) {
            const batch = batchItems.slice(i, i + batchSize);
            const batchPromises = batch.map(item => 
                this.processMultimodal(item.inputs, item.prompt, item.options)
            );
            
            try {
                const batchResults = await Promise.all(batchPromises);
                results.push(...batchResults);
                
                if (i + batchSize < batchItems.length) {
                    await new Promise(resolve => setTimeout(resolve, delay));
                }
            } catch (error) {
                console.error(`Erro no lote ${Math.floor(i / batchSize) + 1}:`, error);
            }
        }
        
        return results;
    }
    
    getProcessingStats() {
        const stats = {
            totalProcessed: this.processingHistory.length,
            byInputType: {},
            averageProcessingTime: 0,
            totalInputSize: 0
        };
        
        for (const result of this.processingHistory) {
            for (const input of result.inputs) {
                stats.byInputType[input.type] = (stats.byInputType[input.type] || 0) + 1;
                stats.totalInputSize += input.size || 0;
            }
        }
        
        return stats;
    }
}

// Exemplos de uso
const multimodal = new MultimodalProcessor(gemini);

// Análise de múltiplas imagens
const imageAnalysis = await multimodal.analyzeImages([
    './image1.jpg',
    './image2.png'
], 'comparison');

// Análise de vídeo
const videoAnalysis = await multimodal.analyzeVideo('./presentation.mp4', {
    customPrompt: "Extract the main points from this presentation and create a summary"
});

// Análise de áudio
const audioTranscription = await multimodal.analyzeAudio('./meeting.mp3', 'transcription');

// Processamento multimodal complexo
const complexAnalysis = await multimodal.processMultimodal([
    { type: 'file', path: './report.pdf' },
    { type: 'file', path: './chart.png' },
    { type: 'text', content: 'Additional context about the project' }
], "Analyze this report and chart together, providing insights and recommendations");
```

## ✅ Checklist de Implementação

### **📋 Setup e Configuração**
- [ ] SDK instalado e configurado
- [ ] API Key configurada com segurança
- [ ] Variáveis de ambiente definidas
- [ ] Conexão testada e validada
- [ ] Tratamento de erros implementado
- [ ] Sistema de logs configurado

### **📝 Geração de Texto**
- [ ] Sistema de templates implementado
- [ ] Configurações dinâmicas ativas
- [ ] Presets de qualidade definidos
- [ ] Cache de respostas configurado
- [ ] Análise de qualidade implementada
- [ ] Histórico de gerações salvo

### **🎨 Geração de Imagens**
- [ ] Suporte a Gemini e Imagen configurado
- [ ] Sistema de edição conversacional ativo
- [ ] Otimização de prompts implementada
- [ ] Geração em lote configurada
- [ ] Salvamento automático de imagens
- [ ] Análise de estatísticas ativa

### **🎭 Processamento Multimodal**
- [ ] Suporte a múltiplos formatos ativo
- [ ] Preprocessamento de arquivos implementado
- [ ] Análise especializada por tipo configurada
- [ ] Processamento em lote ativo
- [ ] Estatísticas de uso coletadas
- [ ] Sistema de cache multimodal ativo

---

**📅 Última atualização**: 2025-01-09  
**🔧 Baseado em**: 12+ arquivos Documentos da API Gemini + guias práticos  
**📊 Fonte**: Google AI Gemini API Documentation, Imagen 3 Guide, Multimodal Processing Guide
