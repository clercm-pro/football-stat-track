/**
 * StatTrack - Frontend JavaScript
 * Handles animations, interactions, and scroll effects
 */

// ========================================
// DOM Elements
// ========================================

const DOM = {
    navbar: document.querySelector('.navbar'),
    mobileMenuBtn: document.querySelector('.mobile-menu-btn'),
    statNumbers: document.querySelectorAll('.stat-number'),
    featureCards: document.querySelectorAll('.feature-card'),
    designCards: document.querySelectorAll('.design-card'),
    steps: document.querySelectorAll('.step'),
    syncFeatures: document.querySelectorAll('.sync-feature'),
    scrollElements: document.querySelectorAll('.section-header, .device')
};

// ========================================
// Initialization
// ========================================

document.addEventListener('DOMContentLoaded', () => {
    initNavbar();
    initMobileMenu();
    initCounters();
    initScrollAnimations();
    initSmoothScroll();
});

// ========================================
// Navbar Scroll Effect
// ========================================

function initNavbar() {
    let lastScroll = 0;
    
    window.addEventListener('scroll', () => {
        const currentScroll = window.pageYOffset;
        
        // Add/remove scrolled class
        if (currentScroll > 50) {
            DOM.navbar.classList.add('scrolled');
        } else {
            DOM.navbar.classList.remove('scrolled');
        }
        
        lastScroll = currentScroll;
    });
}

// ========================================
// Mobile Menu Toggle
// ========================================

function initMobileMenu() {
    if (!DOM.mobileMenuBtn) return;
    
    DOM.mobileMenuBtn.addEventListener('click', () => {
        DOM.mobileMenuBtn.classList.toggle('active');
        // Add mobile menu functionality here
        console.log('Mobile menu toggled');
    });
}

// ========================================
// Animated Counters
// ========================================

function initCounters() {
    const counters = DOM.statNumbers;
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                animateCounter(entry.target);
                observer.unobserve(entry.target);
            }
        });
    }, { threshold: 0.5 });
    
    counters.forEach(counter => {
        observer.observe(counter);
    });
}

function animateCounter(element) {
    const target = parseInt(element.getAttribute('data-target'));
    const duration = 1500;
    const startTime = performance.now();
    
    function updateCounter(currentTime) {
        const elapsed = currentTime - startTime;
        const progress = Math.min(elapsed / duration, 1);
        
        // Easing function (ease-out)
        const easeOut = 1 - Math.pow(1 - progress, 3);
        const current = Math.floor(easeOut * target);
        
        element.textContent = current;
        
        if (progress < 1) {
            requestAnimationFrame(updateCounter);
        } else {
            element.textContent = target;
        }
    }
    
    requestAnimationFrame(updateCounter);
}

// ========================================
// Scroll Animations
// ========================================

function initScrollAnimations() {
    // Add animate-on-scroll class to elements
    DOM.scrollElements.forEach(el => {
        el.classList.add('animate-on-scroll');
    });
    
    // Feature cards
    DOM.featureCards.forEach(card => {
        card.classList.add('animate-on-scroll');
    });
    
    // Design cards
    DOM.designCards.forEach(card => {
        card.classList.add('animate-on-scroll');
    });
    
    // Steps
    DOM.steps.forEach(step => {
        step.classList.add('animate-on-scroll');
    });
    
    // Sync features
    DOM.syncFeatures.forEach(feature => {
        feature.classList.add('animate-on-scroll');
    });
    
    // Intersection Observer for scroll animations
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animated');
                // Optionally unobserve after animation
                // observer.unobserve(entry.target);
            }
        });
    }, {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    });
    
    document.querySelectorAll('.animate-on-scroll').forEach(el => {
        observer.observe(el);
    });
}

// ========================================
// Smooth Scroll
// ========================================

function initSmoothScroll() {
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            
            const targetId = this.getAttribute('href');
            const targetElement = document.querySelector(targetId);
            
            if (targetElement) {
                const navbarHeight = DOM.navbar.offsetHeight;
                const targetPosition = targetElement.getBoundingClientRect().top + window.pageYOffset - navbarHeight;
                
                window.scrollTo({
                    top: targetPosition,
                    behavior: 'smooth'
                });
            }
        });
    });
}

// ========================================
// Utility Functions
// ========================================

// Debounce function for performance
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Throttle function for scroll events
function throttle(func, limit) {
    let inThrottle;
    return function(...args) {
        if (!inThrottle) {
            func.apply(this, args);
            inThrottle = true;
            setTimeout(() => inThrottle = false, limit);
        }
    };
}

// ========================================
// Parallax Effects (Optional Enhancement)
// ========================================

// Uncomment to enable parallax on background elements
/*
const backgroundEffects = document.querySelector('.background-effects');

if (backgroundEffects) {
    window.addEventListener('scroll', throttle(() => {
        const scrollPosition = window.pageYOffset;
        backgroundEffects.style.transform = `translateY(${scrollPosition * 0.1}px)`;
    }, 16));
}
*/

// ========================================
// Device Sync Animation (Optional Enhancement)
// ========================================

// Add pulsing effect to sync connection
const connectionPulse = document.querySelector('.connection-pulse');

if (connectionPulse) {
    setInterval(() => {
        connectionPulse.style.transform = 'translate(-50%, -50%) scale(1)';
        setTimeout(() => {
            connectionPulse.style.transform = 'translate(-50%, -50%) scale(1.5)';
        }, 1000);
    }, 2000);
}

// ========================================
// Console Easter Egg
// ========================================

console.log(
    '%c🏆 StatTrack %cbuilt with ❤️',
    'font-size: 24px; font-weight: bold; color: #5B23FF;',
    'font-size: 16px; color: #E4FF30;'
);
console.log(
    '%cTrack. Sync. Dominate.%c\nhttps://github.com/clercm-pro/football-stat-track',
    'font-size: 14px; color: #008BFF;',
    'font-size: 12px; color: #B0B0B0;'
);
