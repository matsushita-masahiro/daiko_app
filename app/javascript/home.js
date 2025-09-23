function initializeHomeJS() {
  // モバイルメニューのトグル機能
  const mobileMenuToggle = document.getElementById('mobileMenuToggle');
  const navMenu = document.getElementById('navMenu') || document.querySelector('.nav-menu');

  console.log('mobileMenuToggle:', mobileMenuToggle);
  console.log('navMenu:', navMenu);

  if (mobileMenuToggle) {
    // 既存のイベントリスナーを削除
    mobileMenuToggle.removeEventListener('click', handleMenuToggle);

    console.log('Adding click listener to hamburger menu');
    mobileMenuToggle.addEventListener('click', handleMenuToggle);
  } else {
    console.log('mobileMenuToggle not found');
  }

  // nav-linkクリック時にメニューを閉じる
  document.querySelectorAll('.nav-link').forEach(link => {
    link.addEventListener('click', function (e) {
      const navMenu = document.getElementById('navMenu') || document.querySelector('.nav-menu');
      if (navMenu && navMenu.classList.contains('active')) {
        navMenu.classList.remove('active');
        console.log('Menu closed by nav-link click');
      }
    });
  });

  // スムーススクロール（ハッシュリンクのみ）
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      const href = this.getAttribute('href');
      if (href && href !== '#') {
        e.preventDefault();
        const target = document.querySelector(href);
        if (target) {
          target.scrollIntoView({
            behavior: 'smooth',
            block: 'start'
          });
        }
      }
    });
  });
}

function handleMenuToggle(e) {
  e.preventDefault();
  const navMenu = document.getElementById('navMenu') || document.querySelector('.nav-menu');

  if (!navMenu) {
    console.log('navMenu not found for toggle');
    return;
  }

  console.log('Toggle clicked, current classes:', navMenu.className);

  navMenu.classList.toggle('active');
  
  console.log('After toggle, classes:', navMenu.className);
  console.log('Has active class?', navMenu.classList.contains('active'));
}




// アクティブなナビゲーションリンクのハイライト（トップページのみ）
function initializeScrollHighlight() {
  if (window.location.pathname === '/' || window.location.pathname === '') {
    window.addEventListener('scroll', function() {
      const sections = document.querySelectorAll('section[id]');
      const navLinks = document.querySelectorAll('.nav-link[href^="#"]');
      
      let current = '';
      sections.forEach(section => {
        const sectionTop = section.offsetTop - 200;
        if (pageYOffset >= sectionTop) {
          current = section.getAttribute('id');
        }
      });

      navLinks.forEach(link => {
        link.classList.remove('active');
        if (link.getAttribute('href') === '#' + current) {
          link.classList.add('active');
        }
      });
    });
  }
}

// 初期化時にスクロールハイライトも実行
document.addEventListener('DOMContentLoaded', function() {
  initializeHomeJS();
  initializeScrollHighlight();
});

document.addEventListener('turbo:load', function() {
  initializeHomeJS();
  initializeScrollHighlight();
});

document.addEventListener('turbo:render', function() {
  initializeHomeJS();
  initializeScrollHighlight();
});