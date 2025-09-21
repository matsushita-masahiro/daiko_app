function initializeHomeJS() {
  // モバイルメニューのトグル機能
  const mobileMenuToggle = document.getElementById('mobileMenuToggle');
  const navMenu = document.getElementById('navMenu');

  console.log('mobileMenuToggle:', mobileMenuToggle);
  console.log('navMenu:', navMenu);

  if (mobileMenuToggle && navMenu) {
    // 既存のイベントリスナーを削除
    mobileMenuToggle.removeEventListener('click', handleMenuToggle);

    console.log('Adding click listener to hamburger menu');
    mobileMenuToggle.addEventListener('click', handleMenuToggle);
  } else {
    console.log('Elements not found - mobileMenuToggle:', !!mobileMenuToggle, 'navMenu:', !!navMenu);
  }

  // nav-linkクリック時にメニューを閉じる
  document.querySelectorAll('.nav-link').forEach(link => {
    link.addEventListener('click', function (e) {
      const navMenu = document.getElementById('navMenu');
      if (navMenu && navMenu.classList.contains('active')) {
        navMenu.classList.remove('active');
        console.log('Menu closed by nav-link click');
      }
    });
  });

  // スムーススクロール
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      e.preventDefault();
      const target = document.querySelector(this.getAttribute('href'));
      if (target) {
        target.scrollIntoView({
          behavior: 'smooth',
          block: 'start'
        });
      }
    });
  });
}

function handleMenuToggle(e) {
  e.preventDefault();
  const navMenu = document.getElementById('navMenu');

  console.log('Toggle clicked, current classes:', navMenu.className);

  navMenu.classList.toggle('active');
  
  console.log('After toggle, classes:', navMenu.className);
  console.log('Has active class?', navMenu.classList.contains('active'));
}

// 複数のイベントに対応
document.addEventListener('DOMContentLoaded', initializeHomeJS);
document.addEventListener('turbo:load', initializeHomeJS);
document.addEventListener('turbo:render', initializeHomeJS);


