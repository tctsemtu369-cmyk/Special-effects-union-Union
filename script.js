document.addEventListener('DOMContentLoaded', () => {
    // Header Scroll Effect
    const header = document.querySelector('.main-header');

    window.addEventListener('scroll', () => {
        if (window.scrollY > 50) {
            header.style.background = 'rgba(139, 0, 0, 0.98)'; /* Deep Red */
            header.style.padding = '0.5rem 0';
            header.style.boxShadow = '0 2px 10px rgba(0,0,0,0.2)';
        } else {
            header.style.background = '#8B0000'; /* Union Red */
            header.style.padding = '1rem 0';
            header.style.boxShadow = '0 2px 10px rgba(0,0,0,0.1)';
        }
    });

    // Mobile Menu Toggle
    const mobileBtn = document.querySelector('.mobile-menu-toggle');
    const navUl = document.querySelector('.main-nav ul');

    if (mobileBtn) {
        mobileBtn.addEventListener('click', () => {
            if (navUl.style.display === 'flex') {
                navUl.style.display = 'none';
            } else {
                navUl.style.display = 'flex';
                navUl.style.flexDirection = 'column';
                navUl.style.position = 'absolute';
                navUl.style.top = '100%';
                navUl.style.right = '0';
                navUl.style.width = '200px';
                navUl.style.background = '#8B0000'; // Match Header
                navUl.style.padding = '20px';
                navUl.style.border = '1px solid #550000';
                navUl.style.zIndex = '1000';
            }
        });
    }

    // Technician Filtering
    const filterBtns = document.querySelectorAll('.filter-btn');
    const techItems = document.querySelectorAll('.tech-item');

    filterBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            // Remove active class from all buttons
            filterBtns.forEach(b => b.classList.remove('active'));
            // Add active class to clicked button
            btn.classList.add('active');

            const filterValue = btn.getAttribute('data-filter');

            techItems.forEach(item => {
                if (filterValue === 'all' || item.getAttribute('data-category') === filterValue) {
                    item.style.display = 'block';
                    // Optional: Add scale animation here
                } else {
                    item.style.display = 'none';
                }
            });
        });
    });

    // Smooth Scrolling
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            // Close mobile menu if open
            if (window.innerWidth <= 768) {
                navUl.style.display = 'none';
            }

            document.querySelector(this.getAttribute('href')).scrollIntoView({
                behavior: 'smooth'
            });
        });
    });
});

// Bio Modal Functionality removed - replaced with direct page link


// Prakash Modal section removed as it is now a direct link

