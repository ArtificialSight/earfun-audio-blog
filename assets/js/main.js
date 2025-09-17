/*
 * Global site interactions
 * ------------------------
 * Handles mobile menu toggling and standardised affiliate tracking
 * with accessibility affordances for hidden navigation content.
 */
document.addEventListener('DOMContentLoaded', () => {
  const menuToggle = document.querySelector('.mobile-menu-btn');
  const menu = document.getElementById('main-menu');
  const affiliateButtons = document.querySelectorAll('.affiliate-button');
  const mobileQuery = window.matchMedia('(max-width: 992px)');

  const syncMenuState = () => {
    if (!menu) {
      return;
    }

    const isActive = menu.classList.contains('active');
    const shouldHide = mobileQuery.matches && !isActive;

    menu.setAttribute('aria-hidden', shouldHide ? 'true' : 'false');

    if (!menuToggle) {
      return;
    }

    if (mobileQuery.matches) {
      menuToggle.setAttribute('aria-expanded', String(!shouldHide));
    } else {
      menuToggle.setAttribute('aria-expanded', 'false');
    }
  };

  if (menuToggle && menu) {
    syncMenuState();

    menuToggle.addEventListener('click', () => {
      const expanded = menuToggle.getAttribute('aria-expanded') === 'true';
      const newExpanded = !expanded;

      menuToggle.setAttribute('aria-expanded', String(newExpanded));
      menu.classList.toggle('active', newExpanded);
      syncMenuState();
    });

    if (typeof mobileQuery.addEventListener === 'function') {
      mobileQuery.addEventListener('change', syncMenuState);
    } else if (typeof mobileQuery.addListener === 'function') {
      mobileQuery.addListener(syncMenuState);
    }
  } else if (menu) {
    syncMenuState();
  }

  affiliateButtons.forEach((button) => {
    button.addEventListener('click', function () {
      if (typeof gtag !== 'undefined') {
        gtag('event', 'affiliate_click', {
          event_category: 'affiliate',
          event_label: this.getAttribute('data-product') || 'unknown',
        });
      }
    });
  });
});
