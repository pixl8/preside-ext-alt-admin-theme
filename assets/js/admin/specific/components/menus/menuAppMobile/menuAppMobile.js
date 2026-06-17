(function($) {
  'use strict';

  const SETTINGS = {
    container:   '.c-menu-app-mobile',
    trigger:     '.c-menu-app-mobile__item-link',
    submenu:     '.c-menu-app-mobile__submenu',
    item:        '.c-menu-app-mobile__item',
    activeClass: 'is-open',
  };

  const toggleSubmenu = function(e) {
    const $link    = $(this);
    const $parent  = $link.closest(SETTINGS.item);
    const $submenu = $link.next(SETTINGS.submenu);

    // No submenu - let the link navigate normally
    if (!$submenu.length) {
      return;
    }

    e.preventDefault();

    const isExpanding = !$parent.hasClass(SETTINGS.activeClass);

    $link.attr('aria-expanded', isExpanding);
    $parent.toggleClass(SETTINGS.activeClass, isExpanding);
    $submenu.stop(true, true).slideToggle();
  };

  $(SETTINGS.container).on('click', SETTINGS.trigger, toggleSubmenu);
})(presideJQuery);