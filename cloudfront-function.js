function handler(event) {
    var request = event.request;
    var uri = request.uri;
    
    // Redirecionamento 301: /compra.html -> /compra
    if (uri === '/compra.html') {
        var response = {
            statusCode: 301,
            statusDescription: 'Moved Permanently',
            headers: {
                'location': { value: '/compra' }
            }
        };
        return response;
    }
    
    // Redirecionamento 301: /www/compra.html -> /compra
    if (uri === '/www/compra.html' || uri === '/www/compra') {
        var response = {
            statusCode: 301,
            statusDescription: 'Moved Permanently',
            headers: {
                'location': { value: '/compra' }
            }
        };
        return response;
    }
    
    // Rewrite: /compra -> /compra.html (interno, sem redirecionamento)
    if (uri === '/compra') {
        request.uri = '/compra.html';
    }
    
    return request;
}
