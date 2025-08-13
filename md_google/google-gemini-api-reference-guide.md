# 🔧 Google Gemini API - Referência Técnica Completa

> **Baseado na documentação oficial do Google** - Análise de 1 arquivo Referências da API Gemini + documentação técnica

## 📋 Índice

1. [Visão Geral da API](#visão-geral-da-api)
2. [Configuração e Autenticação](#configuração-e-autenticação)
3. [Modelos e Endpoints](#modelos-e-endpoints)
4. [Geração de Conteúdo](#geração-de-conteúdo)
5. [Streaming e WebSockets](#streaming-e-websockets)
6. [Configurações Avançadas](#configurações-avançadas)
7. [Segurança e Moderação](#segurança-e-moderação)
8. [Referência Completa de Objetos](#referência-completa-de-objetos)

## 🎯 Visão Geral da API

### **Gemini API Reference**
A **API Gemini** permite acesso aos modelos generativos mais recentes do Google, oferecendo:
- ✅ **Modelos de última geração** (Gemini 2.0 Flash, Gemini 1.5 Pro)
- ✅ **Múltiplas modalidades** (texto, imagem, áudio, vídeo)
- ✅ **Streaming em tempo real** via WebSockets
- ✅ **Ferramentas avançadas** (execução de código, chamadas de função)
- ✅ **Cache de contexto** para otimização
- ✅ **Configurações de segurança** granulares

### **Versões da API**
```
📊 Versões Disponíveis
├── v1 (Estável)
│   ├── ✅ Suporte completo durante vida útil
│   ├── ✅ Mudanças não-críticas permitidas
│   └── ✅ Recomendado para produção
│
├── v1beta (Beta)
│   ├── ⚠️ Recursos de acesso antecipado
│   ├── ⚠️ Sujeito a mudanças rápidas
│   └── ⚠️ Não recomendado para produção
│
└── v1alpha (Alpha)
    ├── 🔬 Recursos experimentais
    ├── 🔬 Instabilidade esperada
    └── 🔬 Apenas para testes
```

## 🔐 Configuração e Autenticação

### **Instalação e Setup**

#### **Node.js/TypeScript**
```javascript
// ✅ Instalação via npm
npm install @google/genai

// ✅ Configuração básica
import { GoogleGenAI } from "@google/genai";

const ai = new GoogleGenAI({
    apiKey: process.env.GEMINI_API_KEY,
    httpOptions: {
        apiVersion: "v1beta" // ou "v1" para estável
    }
});

// ✅ Primeira solicitação
async function quickStart() {
    try {
        const response = await ai.models.generateContent({
            model: "gemini-2.0-flash",
            contents: "Explain how AI works in a few words"
        });
        
        console.log(response.text);
    } catch (error) {
        console.error('Erro na API:', error);
    }
}

quickStart();
```

#### **Python**
```python
# ✅ Instalação via pip
# pip install google-generativeai

import google.generativeai as genai
import os

# ✅ Configuração
genai.configure(api_key=os.environ["GEMINI_API_KEY"])

# ✅ Cliente da API
client = genai.Client()

# ✅ Primeira solicitação
def quick_start():
    try:
        response = client.models.generate_content(
            model="gemini-2.0-flash",
            contents="Explain how AI works in a few words"
        )
        print(response.text)
    except Exception as error:
        print(f"Erro na API: {error}")

quick_start()
```

### **Configuração Avançada**
```javascript
// ✅ Configuração completa com todas as opções
const ai = new GoogleGenAI({
    apiKey: process.env.GEMINI_API_KEY,
    httpOptions: {
        apiVersion: "v1beta",
        timeout: 30000,
        retries: 3,
        baseURL: "https://generativelanguage.googleapis.com"
    },
    defaultGenerationConfig: {
        temperature: 0.7,
        topP: 0.8,
        topK: 40,
        maxOutputTokens: 2048,
        candidateCount: 1
    },
    defaultSafetySettings: [
        {
            category: "HARM_CATEGORY_HARASSMENT",
            threshold: "BLOCK_MEDIUM_AND_ABOVE"
        },
        {
            category: "HARM_CATEGORY_HATE_SPEECH",
            threshold: "BLOCK_MEDIUM_AND_ABOVE"
        }
    ]
});
```

## 🤖 Modelos e Endpoints

### **Listagem e Informações de Modelos**

#### **Listar Modelos Disponíveis**
```javascript
// ✅ Listar todos os modelos
async function listModels() {
    try {
        const models = [];
        
        for await (const model of ai.models.list()) {
            models.push({
                name: model.name,
                displayName: model.displayName,
                description: model.description,
                inputTokenLimit: model.inputTokenLimit,
                outputTokenLimit: model.outputTokenLimit,
                supportedActions: model.supportedActions
            });
        }
        
        return models;
    } catch (error) {
        console.error('Erro ao listar modelos:', error);
        throw error;
    }
}

// ✅ Filtrar modelos por capacidade
async function getModelsByCapability(capability) {
    const allModels = await listModels();
    
    return allModels.filter(model => 
        model.supportedActions.includes(capability)
    );
}

// Exemplos de uso
const textModels = await getModelsByCapability('generateContent');
const embeddingModels = await getModelsByCapability('embedContent');
```

#### **Obter Informações Específicas de um Modelo**
```javascript
// ✅ Detalhes de um modelo específico
async function getModelInfo(modelName) {
    try {
        const model = await ai.models.get({ name: `models/${modelName}` });
        
        return {
            name: model.name,
            baseModelId: model.baseModelId,
            version: model.version,
            displayName: model.displayName,
            description: model.description,
            inputTokenLimit: model.inputTokenLimit,
            outputTokenLimit: model.outputTokenLimit,
            supportedGenerationMethods: model.supportedGenerationMethods,
            temperature: model.temperature,
            maxTemperature: model.maxTemperature,
            topP: model.topP,
            topK: model.topK
        };
    } catch (error) {
        console.error(`Erro ao obter modelo ${modelName}:`, error);
        throw error;
    }
}

// Exemplo de uso
const geminiInfo = await getModelInfo('gemini-2.0-flash');
console.log('Limites do modelo:', {
    input: geminiInfo.inputTokenLimit,
    output: geminiInfo.outputTokenLimit
});
```

### **Seleção de Modelo por Caso de Uso**
```javascript
// ✅ Seletor inteligente de modelo
class ModelSelector {
    constructor(ai) {
        this.ai = ai;
        this.modelCache = new Map();
    }
    
    async selectBestModel(useCase, requirements = {}) {
        const models = await this.getAvailableModels();
        
        switch (useCase) {
            case 'text_generation':
                return this.selectForTextGeneration(models, requirements);
            case 'multimodal':
                return this.selectForMultimodal(models, requirements);
            case 'code_generation':
                return this.selectForCodeGeneration(models, requirements);
            case 'analysis':
                return this.selectForAnalysis(models, requirements);
            default:
                return 'gemini-1.5-flash'; // Padrão
        }
    }
    
    selectForTextGeneration(models, requirements) {
        const { speed, quality, contextLength } = requirements;
        
        if (speed === 'high' && quality === 'standard') {
            return 'gemini-1.5-flash';
        } else if (quality === 'high' || contextLength > 100000) {
            return 'gemini-1.5-pro';
        } else {
            return 'gemini-2.0-flash';
        }
    }
    
    selectForMultimodal(models, requirements) {
        const { mediaTypes, realTime } = requirements;
        
        if (realTime || mediaTypes.includes('audio')) {
            return 'gemini-2.0-flash';
        } else {
            return 'gemini-1.5-pro';
        }
    }
    
    selectForCodeGeneration(models, requirements) {
        const { language, complexity } = requirements;
        
        if (complexity === 'high') {
            return 'gemini-1.5-pro';
        } else {
            return 'gemini-2.0-flash';
        }
    }
    
    async getAvailableModels() {
        if (this.modelCache.has('all')) {
            return this.modelCache.get('all');
        }
        
        const models = [];
        for await (const model of this.ai.models.list()) {
            models.push(model);
        }
        
        this.modelCache.set('all', models);
        return models;
    }
}

// Uso do seletor
const selector = new ModelSelector(ai);

const textModel = await selector.selectBestModel('text_generation', {
    speed: 'high',
    quality: 'standard'
});

const multimodalModel = await selector.selectBestModel('multimodal', {
    mediaTypes: ['image', 'text'],
    realTime: false
});
```

## 📝 Geração de Conteúdo

### **Geração de Texto Básica**

#### **Solicitação Simples**
```javascript
// ✅ Geração de texto básica
async function generateText(prompt, options = {}) {
    const defaultOptions = {
        model: "gemini-2.0-flash",
        temperature: 0.7,
        maxOutputTokens: 1024,
        topP: 0.8,
        topK: 40
    };
    
    const config = { ...defaultOptions, ...options };
    
    try {
        const response = await ai.models.generateContent({
            model: config.model,
            contents: prompt,
            generationConfig: {
                temperature: config.temperature,
                maxOutputTokens: config.maxOutputTokens,
                topP: config.topP,
                topK: config.topK,
                candidateCount: 1
            }
        });
        
        return {
            text: response.text,
            usage: response.usageMetadata,
            finishReason: response.candidates[0]?.finishReason,
            safetyRatings: response.candidates[0]?.safetyRatings
        };
    } catch (error) {
        console.error('Erro na geração:', error);
        throw error;
    }
}

// Exemplos de uso
const story = await generateText(
    "Write a short story about a robot learning to paint",
    { temperature: 0.9, maxOutputTokens: 500 }
);

const summary = await generateText(
    "Summarize the key points of quantum computing",
    { temperature: 0.3, maxOutputTokens: 200 }
);
```

### **Geração Multimodal**

#### **Texto + Imagem**
```javascript
// ✅ Análise de imagem com texto
async function analyzeImage(imagePath, prompt, options = {}) {
    try {
        // Upload da imagem
        const imageFile = await ai.files.upload({
            file: imagePath,
            config: {
                mimeType: "image/jpeg" // ou detectar automaticamente
            }
        });
        
        const response = await ai.models.generateContent({
            model: options.model || "gemini-1.5-pro",
            contents: [
                {
                    role: "user",
                    parts: [
                        { text: prompt },
                        { 
                            fileData: {
                                mimeType: imageFile.mimeType,
                                fileUri: imageFile.uri
                            }
                        }
                    ]
                }
            ],
            generationConfig: options.generationConfig
        });
        
        return {
            text: response.text,
            usage: response.usageMetadata
        };
    } catch (error) {
        console.error('Erro na análise de imagem:', error);
        throw error;
    }
}

// Exemplo de uso
const imageAnalysis = await analyzeImage(
    "./product-image.jpg",
    "Describe this product and suggest marketing copy",
    {
        generationConfig: {
            temperature: 0.4,
            maxOutputTokens: 500
        }
    }
);
```

#### **Texto + Áudio**
```javascript
// ✅ Análise de áudio
async function analyzeAudio(audioPath, prompt, options = {}) {
    try {
        const audioFile = await ai.files.upload({
            file: audioPath,
            config: {
                mimeType: "audio/mp3"
            }
        });
        
        const response = await ai.models.generateContent({
            model: "gemini-2.0-flash",
            contents: [
                {
                    role: "user",
                    parts: [
                        { text: prompt },
                        {
                            fileData: {
                                mimeType: audioFile.mimeType,
                                fileUri: audioFile.uri
                            }
                        }
                    ]
                }
            ]
        });
        
        return response.text;
    } catch (error) {
        console.error('Erro na análise de áudio:', error);
        throw error;
    }
}

// Exemplo de uso
const audioSummary = await analyzeAudio(
    "./meeting-recording.mp3",
    "Provide a summary of this meeting and list action items"
);
```

### **Conversação e Chat**

#### **Sistema de Chat Avançado**
```javascript
// ✅ Sistema de chat com histórico
class GeminiChat {
    constructor(ai, options = {}) {
        this.ai = ai;
        this.model = options.model || "gemini-2.0-flash";
        this.history = [];
        this.systemInstruction = options.systemInstruction;
        this.generationConfig = options.generationConfig || {
            temperature: 0.7,
            maxOutputTokens: 1024,
            topP: 0.8
        };
    }
    
    async sendMessage(message, options = {}) {
        try {
            // Adicionar mensagem do usuário ao histórico
            this.history.push({
                role: "user",
                parts: [{ text: message }]
            });
            
            const requestConfig = {
                model: this.model,
                contents: this.history,
                generationConfig: { ...this.generationConfig, ...options.generationConfig }
            };
            
            // Adicionar instrução do sistema se fornecida
            if (this.systemInstruction) {
                requestConfig.systemInstruction = {
                    parts: [{ text: this.systemInstruction }]
                };
            }
            
            const response = await this.ai.models.generateContent(requestConfig);
            
            // Adicionar resposta do modelo ao histórico
            this.history.push({
                role: "model",
                parts: [{ text: response.text }]
            });
            
            return {
                text: response.text,
                usage: response.usageMetadata,
                historyLength: this.history.length
            };
        } catch (error) {
            console.error('Erro no chat:', error);
            throw error;
        }
    }
    
    clearHistory() {
        this.history = [];
    }
    
    getHistory() {
        return [...this.history];
    }
    
    setSystemInstruction(instruction) {
        this.systemInstruction = instruction;
    }
    
    // Gerenciar contexto longo
    async trimHistory(maxTokens = 30000) {
        if (this.history.length <= 2) return;
        
        // Estimar tokens (aproximação)
        let estimatedTokens = 0;
        const trimmedHistory = [];
        
        // Manter sempre a última interação
        for (let i = this.history.length - 1; i >= 0; i--) {
            const message = this.history[i];
            const messageTokens = this.estimateTokens(message.parts[0].text);
            
            if (estimatedTokens + messageTokens > maxTokens && trimmedHistory.length > 2) {
                break;
            }
            
            trimmedHistory.unshift(message);
            estimatedTokens += messageTokens;
        }
        
        this.history = trimmedHistory;
    }
    
    estimateTokens(text) {
        // Estimativa aproximada: 1 token ≈ 4 caracteres
        return Math.ceil(text.length / 4);
    }
}

// Exemplo de uso do chat
const chat = new GeminiChat(ai, {
    model: "gemini-2.0-flash",
    systemInstruction: "You are a helpful coding assistant. Provide clear, concise answers with code examples when appropriate.",
    generationConfig: {
        temperature: 0.3,
        maxOutputTokens: 1000
    }
});

// Conversa
const response1 = await chat.sendMessage("How do I create a REST API in Node.js?");
console.log("Assistant:", response1.text);

const response2 = await chat.sendMessage("Can you show me how to add authentication?");
console.log("Assistant:", response2.text);

// Gerenciar histórico longo
await chat.trimHistory(25000);
```

### **Geração com Ferramentas**

#### **Execução de Código**
```javascript
// ✅ Geração com execução de código
async function generateWithCodeExecution(prompt, options = {}) {
    try {
        const response = await ai.models.generateContent({
            model: "gemini-1.5-pro",
            contents: prompt,
            tools: [{ codeExecution: {} }],
            generationConfig: options.generationConfig
        });
        
        // Processar partes da resposta
        const result = {
            text: "",
            codeExecutions: [],
            finalAnswer: ""
        };
        
        for (const candidate of response.candidates) {
            for (const part of candidate.content.parts) {
                if (part.text) {
                    result.text += part.text;
                } else if (part.executableCode) {
                    result.codeExecutions.push({
                        language: part.executableCode.language,
                        code: part.executableCode.code
                    });
                } else if (part.codeExecutionResult) {
                    result.codeExecutions.push({
                        outcome: part.codeExecutionResult.outcome,
                        output: part.codeExecutionResult.output
                    });
                }
            }
        }
        
        result.finalAnswer = response.text;
        return result;
    } catch (error) {
        console.error('Erro na execução de código:', error);
        throw error;
    }
}

// Exemplo de uso
const mathResult = await generateWithCodeExecution(
    "Calculate the sum of the first 50 prime numbers and show your work"
);

console.log("Resposta completa:", mathResult.finalAnswer);
console.log("Execuções de código:", mathResult.codeExecutions);
```

#### **Chamadas de Função**
```javascript
// ✅ Definir e usar funções personalizadas
class FunctionCallingManager {
    constructor(ai) {
        this.ai = ai;
        this.functions = new Map();
    }
    
    // Registrar função
    registerFunction(name, description, parameters, handler) {
        const functionDeclaration = {
            name: name,
            description: description,
            parameters: {
                type: "object",
                properties: parameters.properties,
                required: parameters.required || []
            }
        };
        
        this.functions.set(name, {
            declaration: functionDeclaration,
            handler: handler
        });
    }
    
    // Executar com funções
    async generateWithFunctions(prompt, options = {}) {
        const tools = [{
            functionDeclarations: Array.from(this.functions.values())
                .map(f => f.declaration)
        }];
        
        try {
            const response = await this.ai.models.generateContent({
                model: options.model || "gemini-1.5-flash",
                contents: prompt,
                tools: tools,
                generationConfig: options.generationConfig
            });
            
            // Verificar se há chamadas de função
            const functionCalls = this.extractFunctionCalls(response);
            
            if (functionCalls.length > 0) {
                return await this.handleFunctionCalls(prompt, functionCalls, options);
            }
            
            return {
                text: response.text,
                functionCalls: [],
                usage: response.usageMetadata
            };
        } catch (error) {
            console.error('Erro nas chamadas de função:', error);
            throw error;
        }
    }
    
    extractFunctionCalls(response) {
        const calls = [];
        
        for (const candidate of response.candidates) {
            for (const part of candidate.content.parts) {
                if (part.functionCall) {
                    calls.push({
                        name: part.functionCall.name,
                        args: part.functionCall.args
                    });
                }
            }
        }
        
        return calls;
    }
    
    async handleFunctionCalls(originalPrompt, functionCalls, options) {
        const functionResponses = [];
        
        // Executar cada função
        for (const call of functionCalls) {
            const func = this.functions.get(call.name);
            if (func) {
                try {
                    const result = await func.handler(call.args);
                    functionResponses.push({
                        name: call.name,
                        response: result
                    });
                } catch (error) {
                    functionResponses.push({
                        name: call.name,
                        error: error.message
                    });
                }
            }
        }
        
        // Enviar resultados de volta para o modelo
        const followUpContents = [
            { role: "user", parts: [{ text: originalPrompt }] },
            { 
                role: "model", 
                parts: functionCalls.map(call => ({
                    functionCall: {
                        name: call.name,
                        args: call.args
                    }
                }))
            },
            {
                role: "user",
                parts: functionResponses.map(resp => ({
                    functionResponse: {
                        name: resp.name,
                        response: resp.response || { error: resp.error }
                    }
                }))
            }
        ];
        
        const finalResponse = await this.ai.models.generateContent({
            model: options.model || "gemini-1.5-flash",
            contents: followUpContents,
            generationConfig: options.generationConfig
        });
        
        return {
            text: finalResponse.text,
            functionCalls: functionCalls,
            functionResponses: functionResponses,
            usage: finalResponse.usageMetadata
        };
    }
}

// Exemplo de uso
const functionManager = new FunctionCallingManager(ai);

// Registrar função de busca
functionManager.registerFunction(
    "search_web",
    "Search the web for current information",
    {
        properties: {
            query: {
                type: "string",
                description: "The search query"
            },
            num_results: {
                type: "integer",
                description: "Number of results to return",
                default: 5
            }
        },
        required: ["query"]
    },
    async (args) => {
        // Implementar busca real aqui
        return {
            results: [
                {
                    title: "Example Result",
                    url: "https://example.com",
                    snippet: "This is an example search result"
                }
            ]
        };
    }
);

// Usar função
const searchResult = await functionManager.generateWithFunctions(
    "What are the latest developments in quantum computing?"
);
```

## 🌊 Streaming e WebSockets

### **Streaming de Resposta**

#### **Streaming Básico**
```javascript
// ✅ Streaming de texto
async function streamGeneration(prompt, options = {}) {
    try {
        const stream = await ai.models.streamGenerateContent({
            model: options.model || "gemini-2.0-flash",
            contents: prompt,
            generationConfig: options.generationConfig
        });
        
        let fullText = "";
        const chunks = [];
        
        for await (const chunk of stream) {
            const chunkText = chunk.text || "";
            fullText += chunkText;
            chunks.push({
                text: chunkText,
                timestamp: new Date(),
                usage: chunk.usageMetadata
            });
            
            // Callback para processar chunk em tempo real
            if (options.onChunk) {
                options.onChunk(chunkText, fullText);
            }
        }
        
        return {
            fullText,
            chunks,
            totalChunks: chunks.length
        };
    } catch (error) {
        console.error('Erro no streaming:', error);
        throw error;
    }
}

// Exemplo de uso
const streamResult = await streamGeneration(
    "Write a detailed explanation of machine learning",
    {
        generationConfig: {
            temperature: 0.7,
            maxOutputTokens: 1000
        },
        onChunk: (chunk, fullText) => {
            process.stdout.write(chunk); // Exibir em tempo real
        }
    }
);
```

### **WebSocket Live API**

#### **Conexão WebSocket**
```javascript
// ✅ Cliente WebSocket para Live API
class GeminiLiveClient {
    constructor(apiKey, options = {}) {
        this.apiKey = apiKey;
        this.options = options;
        this.ws = null;
        this.sessionConfig = null;
        this.messageHandlers = new Map();
        this.isConnected = false;
    }
    
    async connect() {
        const wsUrl = `wss://generativelanguage.googleapis.com/ws/google.ai.generativelanguage.v1beta.GenerativeService.BidiGenerateContent?key=${this.apiKey}`;
        
        return new Promise((resolve, reject) => {
            this.ws = new WebSocket(wsUrl);
            
            this.ws.onopen = () => {
                this.isConnected = true;
                this.setupSession();
                resolve();
            };
            
            this.ws.onmessage = (event) => {
                this.handleMessage(JSON.parse(event.data));
            };
            
            this.ws.onerror = (error) => {
                console.error('WebSocket error:', error);
                reject(error);
            };
            
            this.ws.onclose = () => {
                this.isConnected = false;
                console.log('WebSocket connection closed');
            };
        });
    }
    
    setupSession() {
        const config = {
            model: this.options.model || "gemini-2.0-flash",
            generationConfig: {
                candidateCount: 1,
                maxOutputTokens: 2048,
                temperature: 0.7,
                topP: 0.8,
                topK: 40,
                responseModalities: ["TEXT"],
                ...this.options.generationConfig
            },
            systemInstruction: this.options.systemInstruction,
            tools: this.options.tools || []
        };
        
        this.sessionConfig = config;
        this.send(config);
    }
    
    send(message) {
        if (this.ws && this.isConnected) {
            this.ws.send(JSON.stringify(message));
        } else {
            throw new Error('WebSocket not connected');
        }
    }
    
    sendText(text) {
        const message = {
            contents: [{
                role: "user",
                parts: [{ text: text }]
            }]
        };
        
        this.send(message);
    }
    
    sendAudio(audioData, mimeType = "audio/pcm") {
        const message = {
            contents: [{
                role: "user",
                parts: [{
                    inlineData: {
                        mimeType: mimeType,
                        data: audioData // Base64 encoded
                    }
                }]
            }]
        };
        
        this.send(message);
    }
    
    handleMessage(message) {
        // Processar diferentes tipos de mensagem
        if (message.candidates) {
            this.handleGenerationResponse(message);
        } else if (message.error) {
            this.handleError(message.error);
        }
    }
    
    handleGenerationResponse(response) {
        for (const candidate of response.candidates) {
            for (const part of candidate.content.parts) {
                if (part.text) {
                    this.emit('text', part.text);
                } else if (part.inlineData) {
                    this.emit('audio', part.inlineData);
                } else if (part.functionCall) {
                    this.emit('functionCall', part.functionCall);
                }
            }
        }
        
        if (response.usageMetadata) {
            this.emit('usage', response.usageMetadata);
        }
    }
    
    handleError(error) {
        this.emit('error', error);
    }
    
    on(event, handler) {
        if (!this.messageHandlers.has(event)) {
            this.messageHandlers.set(event, []);
        }
        this.messageHandlers.get(event).push(handler);
    }
    
    emit(event, data) {
        const handlers = this.messageHandlers.get(event) || [];
        handlers.forEach(handler => handler(data));
    }
    
    disconnect() {
        if (this.ws) {
            this.ws.close();
            this.ws = null;
            this.isConnected = false;
        }
    }
}

// Exemplo de uso
const liveClient = new GeminiLiveClient(process.env.GEMINI_API_KEY, {
    model: "gemini-2.0-flash",
    generationConfig: {
        temperature: 0.8,
        responseModalities: ["TEXT", "AUDIO"]
    },
    systemInstruction: "You are a helpful voice assistant."
});

// Configurar handlers
liveClient.on('text', (text) => {
    console.log('Received text:', text);
});

liveClient.on('audio', (audioData) => {
    console.log('Received audio:', audioData.mimeType);
    // Processar áudio recebido
});

liveClient.on('error', (error) => {
    console.error('Live API error:', error);
});

// Conectar e usar
await liveClient.connect();
liveClient.sendText("Hello, how are you today?");
```

## ⚙️ Configurações Avançadas

### **Configuração de Geração**

#### **GenerationConfig Completa**
```javascript
// ✅ Configuração completa de geração
const advancedGenerationConfig = {
    // Controle de aleatoriedade
    temperature: 0.7,           // 0.0 = determinístico, 2.0 = muito criativo
    topP: 0.8,                  // Amostragem de núcleo (0.0-1.0)
    topK: 40,                   // Top-K amostragem
    
    // Controle de saída
    maxOutputTokens: 2048,      // Máximo de tokens na resposta
    candidateCount: 1,          // Número de respostas alternativas
    
    // Modalidades de resposta
    responseModalities: ["TEXT"], // ["TEXT", "AUDIO", "IMAGE"]
    
    // Formato de resposta
    responseMimeType: "text/plain", // ou "application/json"
    responseSchema: {           // Para JSON estruturado
        type: "object",
        properties: {
            summary: { type: "string" },
            keywords: { 
                type: "array",
                items: { type: "string" }
            }
        }
    },
    
    // Controle de repetição
    presencePenalty: 0.0,       // Penalidade por presença (-2.0 a 2.0)
    frequencyPenalty: 0.0,      // Penalidade por frequência (-2.0 a 2.0)
    
    // Sequências de parada
    stopSequences: ["END", "STOP"],
    
    // Configuração de áudio (para modelos que suportam)
    speechConfig: {
        voiceConfig: {
            prebuiltVoiceConfig: {
                voiceName: "en-US-Journey-D"
            }
        },
        languageCode: "en-US"
    },
    
    // Configuração de pensamento (para modelos que suportam)
    thinkingConfig: {
        includeThoughts: true,
        thinkingBudget: 1000
    },
    
    // Resolução de mídia
    mediaResolution: "MEDIA_RESOLUTION_HIGH",
    
    // Seed para reprodutibilidade
    seed: 12345,
    
    // Logprobs
    responseLogprobs: true,
    logprobs: 5
};

// Usar configuração avançada
const response = await ai.models.generateContent({
    model: "gemini-2.0-flash",
    contents: "Analyze the current state of renewable energy",
    generationConfig: advancedGenerationConfig
});
```

### **Cache de Contexto**

#### **Implementação de Cache**
```javascript
// ✅ Sistema de cache de contexto
class ContextCacheManager {
    constructor(ai) {
        this.ai = ai;
        this.caches = new Map();
    }
    
    async createCache(name, contents, systemInstruction, options = {}) {
        try {
            const cache = await this.ai.caches.create({
                model: options.model || "gemini-1.5-flash-001",
                config: {
                    contents: contents,
                    systemInstruction: systemInstruction,
                    ttl: options.ttl || "3600s", // 1 hora
                    displayName: name
                }
            });
            
            this.caches.set(name, cache);
            return cache;
        } catch (error) {
            console.error('Erro ao criar cache:', error);
            throw error;
        }
    }
    
    async generateWithCache(cacheName, prompt, options = {}) {
        const cache = this.caches.get(cacheName);
        if (!cache) {
            throw new Error(`Cache '${cacheName}' não encontrado`);
        }
        
        try {
            const response = await this.ai.models.generateContent({
                model: options.model || "gemini-1.5-flash-001",
                contents: prompt,
                config: {
                    cachedContent: cache.name
                },
                generationConfig: options.generationConfig
            });
            
            return response;
        } catch (error) {
            console.error('Erro ao gerar com cache:', error);
            throw error;
        }
    }
    
    async listCaches() {
        try {
            const caches = [];
            for await (const cache of this.ai.caches.list()) {
                caches.push(cache);
            }
            return caches;
        } catch (error) {
            console.error('Erro ao listar caches:', error);
            throw error;
        }
    }
    
    async deleteCache(cacheName) {
        const cache = this.caches.get(cacheName);
        if (cache) {
            try {
                await this.ai.caches.delete({ name: cache.name });
                this.caches.delete(cacheName);
                return true;
            } catch (error) {
                console.error('Erro ao deletar cache:', error);
                throw error;
            }
        }
        return false;
    }
}

// Exemplo de uso
const cacheManager = new ContextCacheManager(ai);

// Criar cache com documento longo
const documentCache = await cacheManager.createCache(
    "product-manual",
    [
        {
            role: "user",
            parts: [{ text: "Este é um manual de produto muito longo..." }]
        }
    ],
    "Você é um especialista em produtos que responde perguntas baseado no manual fornecido.",
    {
        ttl: "7200s", // 2 horas
        model: "gemini-1.5-flash-001"
    }
);

// Usar cache para múltiplas perguntas
const answer1 = await cacheManager.generateWithCache(
    "product-manual",
    "Como instalar o produto?"
);

const answer2 = await cacheManager.generateWithCache(
    "product-manual",
    "Quais são os requisitos de sistema?"
);
```

## 🛡️ Segurança e Moderação

### **Configurações de Segurança**

#### **SafetySettings Completas**
```javascript
// ✅ Configurações de segurança abrangentes
const comprehensiveSafetySettings = [
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
    },
    {
        category: "HARM_CATEGORY_CIVIC_INTEGRITY",
        threshold: "BLOCK_MEDIUM_AND_ABOVE"
    }
];

// Níveis de threshold disponíveis:
// - HARM_BLOCK_THRESHOLD_UNSPECIFIED
// - BLOCK_LOW_AND_ABOVE
// - BLOCK_MEDIUM_AND_ABOVE  
// - BLOCK_ONLY_HIGH
// - BLOCK_NONE

// Usar configurações de segurança
const safeResponse = await ai.models.generateContent({
    model: "gemini-2.0-flash",
    contents: "Conte uma história sobre aventura",
    safetySettings: comprehensiveSafetySettings
});

// Verificar se foi bloqueado
if (safeResponse.promptFeedback?.blockReason) {
    console.log('Prompt bloqueado:', safeResponse.promptFeedback.blockReason);
    console.log('Ratings de segurança:', safeResponse.promptFeedback.safetyRatings);
}
```

#### **Sistema de Moderação Personalizado**
```javascript
// ✅ Sistema de moderação avançado
class ContentModerationSystem {
    constructor(ai) {
        this.ai = ai;
        this.customFilters = [];
        this.moderationHistory = [];
    }
    
    addCustomFilter(name, checkFunction) {
        this.customFilters.push({
            name: name,
            check: checkFunction
        });
    }
    
    async moderateContent(content, options = {}) {
        const moderationResult = {
            content: content,
            allowed: true,
            violations: [],
            safetyRatings: [],
            customViolations: [],
            timestamp: new Date()
        };
        
        try {
            // Verificação com Gemini
            const response = await this.ai.models.generateContent({
                model: "gemini-1.5-flash",
                contents: `Analyze this content for safety violations: "${content}"`,
                safetySettings: [
                    {
                        category: "HARM_CATEGORY_HARASSMENT",
                        threshold: "BLOCK_LOW_AND_ABOVE"
                    },
                    {
                        category: "HARM_CATEGORY_HATE_SPEECH",
                        threshold: "BLOCK_LOW_AND_ABOVE"
                    }
                ]
            });
            
            // Verificar se foi bloqueado
            if (response.promptFeedback?.blockReason) {
                moderationResult.allowed = false;
                moderationResult.violations.push({
                    type: 'GEMINI_SAFETY',
                    reason: response.promptFeedback.blockReason,
                    ratings: response.promptFeedback.safetyRatings
                });
            }
            
            // Aplicar filtros personalizados
            for (const filter of this.customFilters) {
                const violation = await filter.check(content);
                if (violation) {
                    moderationResult.allowed = false;
                    moderationResult.customViolations.push({
                        filter: filter.name,
                        violation: violation
                    });
                }
            }
            
            // Salvar no histórico
            this.moderationHistory.push(moderationResult);
            
            return moderationResult;
        } catch (error) {
            console.error('Erro na moderação:', error);
            throw error;
        }
    }
    
    getModerationStats(timeframe = '24h') {
        const cutoff = new Date();
        cutoff.setHours(cutoff.getHours() - (timeframe === '24h' ? 24 : 168));
        
        const recentModerations = this.moderationHistory.filter(
            m => m.timestamp > cutoff
        );
        
        return {
            total: recentModerations.length,
            allowed: recentModerations.filter(m => m.allowed).length,
            blocked: recentModerations.filter(m => !m.allowed).length,
            violationTypes: this.getViolationBreakdown(recentModerations)
        };
    }
    
    getViolationBreakdown(moderations) {
        const breakdown = {};
        
        for (const moderation of moderations) {
            for (const violation of moderation.violations) {
                breakdown[violation.type] = (breakdown[violation.type] || 0) + 1;
            }
            for (const violation of moderation.customViolations) {
                breakdown[violation.filter] = (breakdown[violation.filter] || 0) + 1;
            }
        }
        
        return breakdown;
    }
}

// Exemplo de uso
const moderationSystem = new ContentModerationSystem(ai);

// Adicionar filtro personalizado
moderationSystem.addCustomFilter('profanity', async (content) => {
    const profanityWords = ['palavra1', 'palavra2']; // Lista de palavras
    const lowerContent = content.toLowerCase();
    
    for (const word of profanityWords) {
        if (lowerContent.includes(word)) {
            return {
                type: 'PROFANITY',
                word: word,
                severity: 'medium'
            };
        }
    }
    
    return null;
});

// Moderar conteúdo
const moderationResult = await moderationSystem.moderateContent(
    "Este é um texto para ser moderado"
);

if (!moderationResult.allowed) {
    console.log('Conteúdo bloqueado:', moderationResult.violations);
} else {
    console.log('Conteúdo aprovado');
}

// Ver estatísticas
const stats = moderationSystem.getModerationStats('24h');
console.log('Estatísticas de moderação:', stats);
```

## ✅ Checklist de Implementação

### **📋 Configuração Básica**
- [ ] API Key configurada corretamente
- [ ] SDK instalado e importado
- [ ] Versão da API selecionada (v1/v1beta)
- [ ] Modelo apropriado escolhido
- [ ] Configurações de geração definidas
- [ ] Tratamento de erros implementado

### **🤖 Funcionalidades Avançadas**
- [ ] Sistema de chat com histórico
- [ ] Geração multimodal (texto, imagem, áudio)
- [ ] Streaming de resposta configurado
- [ ] Execução de código habilitada
- [ ] Chamadas de função implementadas
- [ ] Cache de contexto configurado

### **🛡️ Segurança e Moderação**
- [ ] Configurações de segurança aplicadas
- [ ] Sistema de moderação personalizado
- [ ] Filtros de conteúdo configurados
- [ ] Monitoramento de violações ativo
- [ ] Logs de segurança implementados
- [ ] Políticas de uso definidas

### **📊 Monitoramento e Otimização**
- [ ] Métricas de uso coletadas
- [ ] Performance monitorada
- [ ] Custos controlados
- [ ] Rate limiting implementado
- [ ] Fallbacks configurados
- [ ] Testes automatizados criados

---

**📅 Última atualização**: 2025-01-09  
**🔧 Baseado em**: 1 arquivo Referências da API Gemini + documentação técnica oficial  
**📊 Fonte**: Google AI Gemini API Reference, Live API Documentation, Safety Guidelines
