document.addEventListener('DOMContentLoaded', () => {
  const burgers = Array.from(document.querySelectorAll('.navbar-burger'));

  burgers.forEach((burger) => {
    const targetId = burger.dataset.target;
    const target = targetId ? document.getElementById(targetId) : null;

    if (!target) {
      return;
    }

    burger.addEventListener('click', () => {
      const isActive = burger.classList.toggle('is-active');
      target.classList.toggle('is-active', isActive);
      burger.setAttribute('aria-expanded', String(isActive));
      burger.setAttribute('aria-label', isActive ? 'Close main menu' : 'Open main menu');
    });
  });
});
