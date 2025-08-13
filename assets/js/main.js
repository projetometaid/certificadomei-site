/**
 * JavaScript Principal - Certificado Digital MEI
 * Versão segura com verificações de DOM e logs de aviso
 */

// Aguarda o DOM estar completamente carregado
document.addEventListener('DOMContentLoaded', function() {
  
  // ========== UTILITÁRIOS ==========
  
  /**
   * Verifica se um elemento existe e executa callback
   * @param {string} selector - Seletor CSS ou ID
   * @param {Function} callback - Função a executar se elemento existir
   * @param {string} warningMessage - Mensagem de aviso se não existir
   */
  function safeElementAction(selector, callback, warningMessage) {
    const element = selector.startsWith('#') ? 
      document.getElementById(selector.slice(1)) : 
      document.querySelector(selector);
    
    if (element) {
      try {
        callback(element);
      } catch (error) {
        console.warn(`Erro ao executar ação no elemento ${selector}:`, error);
      }
    } else {
      console.warn(warningMessage || `Elemento ${selector} não encontrado.`);
    }
  }

  // ========== ANO DINÂMICO NO FOOTER ==========
  
  function initDynamicYear() {
    safeElementAction('#year', function(yearElement) {
      yearElement.textContent = new Date().getFullYear();
    }, 'Elemento com ID "year" não encontrado. Ano dinâmico não será aplicado.');
  }

  // ========== MENU MOBILE COM ACESSIBILIDADE ==========
  
  function initMobileMenu() {
    const menuBtn = document.querySelector('.menu-btn');
    const nav = document.getElementById('nav');

    if (menuBtn && nav) {
      menuBtn.addEventListener('click', function() {
        try {
          const isOpen = nav.classList.toggle('open');
          menuBtn.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
          
          // Previne scroll do body quando menu está aberto
          if (document.body) {
            document.body.style.overflow = isOpen ? 'hidden' : '';
          }
        } catch (error) {
          console.warn('Erro ao manipular menu mobile:', error);
        }
      });
    } else {
      if (!menuBtn) {
        console.warn('Botão do menu (.menu-btn) não encontrado. Menu mobile não será funcional.');
      }
      if (!nav) {
        console.warn('Elemento de navegação (#nav) não encontrado. Menu mobile não será funcional.');
      }
    }
  }

  // ========== HEADER SHRINK ON SCROLL ==========
  
  function initHeaderShrink() {
    safeElementAction('.topbar', function(topbar) {
      let ticking = false;

      function updateHeader() {
        try {
          const scrollY = window.scrollY;
          if (scrollY > 24) {
            topbar.classList.add('shrink');
          } else {
            topbar.classList.remove('shrink');
          }
        } catch (error) {
          console.warn('Erro ao atualizar header:', error);
        }
        ticking = false;
      }

      function requestTick() {
        if (!ticking) {
          requestAnimationFrame(updateHeader);
          ticking = true;
        }
      }

      // Adiciona listener de scroll apenas se o topbar existir
      document.addEventListener('scroll', requestTick, { passive: true });
    }, 'Elemento topbar (.topbar) não encontrado. Efeito shrink não será aplicado.');
  }

  // ========== SUPORTE PARA PREFERS-REDUCED-MOTION ==========
  
  function initReducedMotion() {
    try {
      const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)');
      if (prefersReducedMotion.matches && document.documentElement) {
        document.documentElement.style.setProperty('--transition-duration', '0s');
      }
    } catch (error) {
      console.warn('Erro ao aplicar prefers-reduced-motion:', error);
    }
  }

  // ========== SMOOTH SCROLL PARA LINKS INTERNOS ==========
  
  function initSmoothScroll() {
    const internalLinks = document.querySelectorAll('a[href^="#"]');
    
    if (internalLinks.length > 0) {
      internalLinks.forEach(function(link) {
        link.addEventListener('click', function(e) {
          const targetId = this.getAttribute('href');
          if (targetId === '#') return;
          
          const targetElement = document.querySelector(targetId);
          if (targetElement) {
            e.preventDefault();
            try {
              targetElement.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
              });
            } catch (error) {
              // Fallback para navegadores que não suportam smooth scroll
              targetElement.scrollIntoView();
            }
          }
        });
      });
    }
  }

  // ========== LAZY LOADING PARA IMAGENS ==========
  
  function initLazyLoading() {
    if ('IntersectionObserver' in window) {
      const lazyImages = document.querySelectorAll('img[data-src]');
      
      if (lazyImages.length > 0) {
        const imageObserver = new IntersectionObserver(function(entries) {
          entries.forEach(function(entry) {
            if (entry.isIntersecting) {
              const img = entry.target;
              try {
                img.src = img.dataset.src;
                img.removeAttribute('data-src');
                imageObserver.unobserve(img);
              } catch (error) {
                console.warn('Erro ao carregar imagem lazy:', error);
              }
            }
          });
        });

        lazyImages.forEach(function(img) {
          imageObserver.observe(img);
        });
      }
    }
  }

  // ========== FORMULÁRIOS COM VALIDAÇÃO ==========
  
  function initFormValidation() {
    const forms = document.querySelectorAll('form[data-validate]');
    
    forms.forEach(function(form) {
      form.addEventListener('submit', function(e) {
        const requiredFields = form.querySelectorAll('[required]');
        let isValid = true;
        
        requiredFields.forEach(function(field) {
          if (!field.value.trim()) {
            isValid = false;
            field.classList.add('error');
          } else {
            field.classList.remove('error');
          }
        });
        
        if (!isValid) {
          e.preventDefault();
          console.warn('Formulário contém campos obrigatórios não preenchidos.');
        }
      });
    });
  }

  // ========== INICIALIZAÇÃO PRINCIPAL ==========
  
  function initializeApp() {
    try {
      initDynamicYear();
      initMobileMenu();
      initHeaderShrink();
      initReducedMotion();
      initSmoothScroll();
      initLazyLoading();
      initFormValidation();
      
      console.log('✅ JavaScript inicializado com sucesso');
    } catch (error) {
      console.error('❌ Erro durante a inicialização do JavaScript:', error);
    }
  }

  // Executa inicialização
  initializeApp();
});

// ========== FUNÇÕES GLOBAIS UTILITÁRIAS ==========

/**
 * Função global para verificar se elemento existe
 * @param {string} selector - Seletor do elemento
 * @returns {boolean} - True se elemento existir
 */
window.elementExists = function(selector) {
  return document.querySelector(selector) !== null;
};

/**
 * Função global para executar código apenas se elemento existir
 * @param {string} selector - Seletor do elemento
 * @param {Function} callback - Função a executar
 */
window.ifElementExists = function(selector, callback) {
  const element = document.querySelector(selector);
  if (element && typeof callback === 'function') {
    callback(element);
  }
};
