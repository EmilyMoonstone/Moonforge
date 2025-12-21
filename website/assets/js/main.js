// Mobile Menu Toggle
const mobileMenuToggle = document.querySelector('.mobile-menu-toggle');
const navMenu = document.querySelector('.nav-menu');
const body = document.body;

if (mobileMenuToggle && navMenu) {
    mobileMenuToggle.addEventListener('click', () => {
        navMenu.classList.toggle('active');
        mobileMenuToggle.classList.toggle('active');
        
        // Prevent body scroll when menu is open
        if (navMenu.classList.contains('active')) {
            body.style.overflow = 'hidden';
        } else {
            body.style.overflow = '';
        }
    });

    // Close menu when clicking on a link
    const navLinks = navMenu.querySelectorAll('a');
    navLinks.forEach(link => {
        link.addEventListener('click', () => {
            navMenu.classList.remove('active');
            mobileMenuToggle.classList.remove('active');
            body.style.overflow = '';
        });
    });

    // Close menu when clicking outside
    document.addEventListener('click', (e) => {
        if (!navMenu.contains(e.target) && !mobileMenuToggle.contains(e.target)) {
            navMenu.classList.remove('active');
            mobileMenuToggle.classList.remove('active');
            body.style.overflow = '';
        }
    });
}

// Smooth Scrolling for Anchor Links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        const href = this.getAttribute('href');
        
        // Don't prevent default for empty anchors
        if (href === '#' || href === '#!') {
            e.preventDefault();
            return;
        }
        
        const target = document.querySelector(href);
        if (target) {
            e.preventDefault();
            const navbarHeight = document.querySelector('.navbar').offsetHeight;
            const targetPosition = target.getBoundingClientRect().top + window.pageYOffset - navbarHeight - 20;
            
            window.scrollTo({
                top: targetPosition,
                behavior: 'smooth'
            });
        }
    });
});

// Navbar Background on Scroll and Show/Hide
const navbar = document.querySelector('.navbar');
let lastScrollY = window.scrollY;
const scrollThreshold = 100; // Show navbar after scrolling 100px

// Show navbar immediately if page is already scrolled
if (window.scrollY > scrollThreshold) {
    navbar.classList.add('visible');
}

window.addEventListener('scroll', () => {
    const currentScrollY = window.scrollY;
    
    // Show/hide navbar based on scroll position
    if (currentScrollY > scrollThreshold) {
        navbar.classList.add('visible');
    } else {
        navbar.classList.remove('visible');
    }
    
    // Update background opacity based on scroll
    if (currentScrollY > 50) {
        navbar.style.background = 'rgba(10, 10, 15, 0.95)';
        navbar.style.boxShadow = '0 4px 6px rgba(0, 0, 0, 0.5)';
    } else {
        navbar.style.background = 'rgba(10, 10, 15, 0.8)';
        navbar.style.boxShadow = 'none';
    }
    
    lastScrollY = currentScrollY;
});

// Intersection Observer for Fade-in Animations
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.classList.add('animate-fade-in');
            observer.unobserve(entry.target);
        }
    });
}, observerOptions);

// Observe elements that should fade in
const animateElements = document.querySelectorAll('.feature-card, .screenshot-card, .download-card, .faq-item, .roadmap-item');
animateElements.forEach(el => {
    observer.observe(el);
});

// Newsletter Form Handling
const newsletterForm = document.querySelector('.newsletter-form');
if (newsletterForm) {
    newsletterForm.addEventListener('submit', (e) => {
        e.preventDefault();
        
        const emailInput = newsletterForm.querySelector('input[type="email"]');
        const email = emailInput.value;
        
        // In a real application, you would send this to your backend
        console.log('Newsletter signup:', email);
        
        // Show success message (you can customize this)
        alert('Thank you for subscribing! We\'ll keep you updated on Moonforge news and releases.');
        emailInput.value = '';
    });
}

// Feature Card Hover Effect
const featureCards = document.querySelectorAll('.feature-card');
featureCards.forEach(card => {
    card.addEventListener('mouseenter', function() {
        this.style.transform = 'translateY(-8px)';
    });
    
    card.addEventListener('mouseleave', function() {
        this.style.transform = 'translateY(0)';
    });
});

// Download Button Click Tracking
const downloadButtons = document.querySelectorAll('.btn-download:not(.disabled)');
downloadButtons.forEach(button => {
    button.addEventListener('click', (e) => {
        const platform = button.closest('.download-card').querySelector('h3').textContent;
        console.log('Download clicked for:', platform);
        
        // In a real application, you would track this analytics event
        // and redirect to the actual download URL
        
        if (button.getAttribute('href') === '#') {
            e.preventDefault();
            alert(`Downloads for ${platform} will be available soon! Follow us on GitHub for updates.`);
        }
    });
});

// Keyboard Navigation Enhancement
document.addEventListener('keydown', (e) => {
    // ESC key closes mobile menu
    if (e.key === 'Escape' && navMenu && navMenu.classList.contains('active')) {
        navMenu.classList.remove('active');
        if (mobileMenuToggle) {
            mobileMenuToggle.classList.remove('active');
        }
        body.style.overflow = '';
    }
});

// Add loading state to primary CTA buttons
const ctaButtons = document.querySelectorAll('.btn-primary');
ctaButtons.forEach(button => {
    button.addEventListener('click', function(e) {
        // Add a subtle loading effect
        const originalText = this.innerHTML;
        
        // Only add loading state if it's not navigating to an anchor
        const href = this.getAttribute('href');
        if (href && !href.startsWith('#')) {
            this.style.opacity = '0.7';
            this.style.pointerEvents = 'none';
            
            setTimeout(() => {
                this.style.opacity = '1';
                this.style.pointerEvents = 'auto';
            }, 1000);
        }
    });
});

// Console Easter Egg
console.log('%c🌙 Welcome to Moonforge! 🎲', 'font-size: 20px; font-weight: bold; color: #a855f7;');
console.log('%cInterested in contributing? Check out our GitHub: https://github.com/EmilyMoonstone/Moonforge', 'font-size: 14px; color: #c084fc;');
console.log('%cMay your rolls be ever in your favor! 🎲✨', 'font-size: 14px; color: #7c3aed;');

// Performance Optimization: Debounce scroll events
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

// Apply debounce to scroll-heavy operations
const optimizedScroll = debounce(() => {
    // Any additional scroll-based operations can go here
}, 100);

window.addEventListener('scroll', optimizedScroll);

// Add viewport height CSS variable for mobile browsers
function setVH() {
    const vh = window.innerHeight * 0.01;
    document.documentElement.style.setProperty('--vh', `${vh}px`);
}

setVH();
window.addEventListener('resize', debounce(setVH, 250));

// Preload critical images (when they are added)
function preloadImages(urls) {
    urls.forEach(url => {
        const img = new Image();
        img.src = url;
    });
}

// Call this when you have actual images
// preloadImages(['./assets/img/hero-bg.png', './assets/img/feature-1.png']);

// Load and parse roadmap from markdown file
async function loadRoadmap() {
    const roadmapTimeline = document.querySelector('.roadmap-timeline');
    if (!roadmapTimeline) return;

    try {
        // Fetch the roadmap.md file
        const response = await fetch('./roadmap.md');
        if (!response.ok) {
            console.warn('Could not load roadmap.md, using default content');
            return;
        }
        
        const markdown = await response.text();
        const roadmapHtml = parseRoadmapMarkdown(markdown);
        
        if (roadmapHtml) {
            roadmapTimeline.innerHTML = roadmapHtml;
            
            // Re-observe new roadmap items for animations
            const newRoadmapItems = roadmapTimeline.querySelectorAll('.roadmap-item');
            newRoadmapItems.forEach(item => observer.observe(item));
        }
    } catch (error) {
        console.warn('Error loading roadmap:', error);
        // Keep the default HTML content if loading fails
    }
}

// Parse roadmap markdown into HTML
function parseRoadmapMarkdown(markdown) {
    const lines = markdown.split('\n');
    let html = '';
    let currentPhase = null;
    let inPhase = false;
    let phaseItems = [];
    
    for (let i = 0; i < lines.length; i++) {
        const line = lines[i].trim();
        
        // Match phase headers (e.g., "## Phase 1: Foundation ✅")
        const phaseMatch = line.match(/^##\s+Phase\s+(\d+):\s+(.+?)(?:\s+([✅🚧]))?$/);
        if (phaseMatch) {
            // Save previous phase if exists
            if (currentPhase) {
                html += createRoadmapItem(currentPhase, phaseItems);
            }
            
            // Start new phase
            currentPhase = {
                number: phaseMatch[1],
                title: phaseMatch[2].trim(),
                status: phaseMatch[3] || ''
            };
            phaseItems = [];
            inPhase = true;
            continue;
        }
        
        // Match list items
        if (inPhase && line.startsWith('-')) {
            const item = line.substring(1).trim();
            if (item && !item.startsWith('✅') && !item.startsWith('🚧')) {
                phaseItems.push(item);
            }
        }
        
        // Stop parsing when reaching legend or footer sections
        if (line.startsWith('---') || line.startsWith('## Legend')) {
            if (currentPhase) {
                html += createRoadmapItem(currentPhase, phaseItems);
            }
            break;
        }
    }
    
    // Add last phase if not added yet
    if (currentPhase && !html.includes(currentPhase.title)) {
        html += createRoadmapItem(currentPhase, phaseItems);
    }
    
    return html;
}

// Create HTML for a roadmap item
function createRoadmapItem(phase, items) {
    const statusClass = phase.status === '✅' ? 'completed' : 
                       phase.status === '🚧' ? 'in-progress' : '';
    
    let html = `
        <div class="roadmap-item">
            <div class="roadmap-marker ${statusClass}"></div>
            <div class="roadmap-content">
                <h3>Phase ${phase.number}: ${phase.title}</h3>
                <ul>`;
    
    items.forEach(item => {
        html += `
                    <li>${item}</li>`;
    });
    
    html += `
                </ul>
            </div>
        </div>`;
    
    return html;
}

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    console.log('Moonforge website loaded successfully!');
    
    // Add fade-in to hero section
    const heroContent = document.querySelector('.hero-content');
    if (heroContent) {
        heroContent.classList.add('animate-fade-in');
    }
    
    // Load roadmap from markdown file
    loadRoadmap();
    
    // Fetch GitHub stars
    fetchGitHubStars();
});

// Fetch GitHub stars count
async function fetchGitHubStars() {
    const starsCountElement = document.getElementById('stars-count');
    if (!starsCountElement) return;
    
    try {
        const response = await fetch('https://api.github.com/repos/EmilyMoonstone/Moonforge');
        if (response.ok) {
            const data = await response.json();
            const stars = data.stargazers_count;
            starsCountElement.textContent = stars > 0 ? stars : 'Star';
        }
    } catch (error) {
        console.warn('Could not fetch GitHub stars:', error);
        // Keep default "Star" text
    }
}
