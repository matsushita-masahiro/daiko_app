function initializeHomeJS() {
  // モバイルメニューのトグル機能
  const mobileMenuToggle = document.getElementById('mobileMenuToggle');
  const navMenu = document.getElementById('navMenu') || document.querySelector('.nav-menu');


  if (mobileMenuToggle) {
    // 既存のイベントリスナーを削除
    mobileMenuToggle.removeEventListener('click', handleMenuToggle);

    mobileMenuToggle.addEventListener('click', handleMenuToggle);
  } else {
  }

  // nav-linkクリック時にメニューを閉じる
  document.querySelectorAll('.nav-link').forEach(link => {
    link.addEventListener('click', function (e) {
      const navMenu = document.getElementById('navMenu') || document.querySelector('.nav-menu');
      if (navMenu && navMenu.classList.contains('active')) {
        navMenu.classList.remove('active');
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
          // ヘッダーの高さを考慮してスクロール位置を調整
          const headerOffset = 200;
          const elementPosition = target.getBoundingClientRect().top;
          const offsetPosition = elementPosition + window.scrollY - headerOffset;

          window.scrollTo({
            top: offsetPosition,
            behavior: 'smooth'
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
    return;
  }


  navMenu.classList.toggle('active');
  
}




// アクティブなナビゲーションリンクのハイライト（トップページのみ）
function initializeScrollHighlight() {
  if (window.location.pathname === '/' || window.location.pathname === '') {
    // スクロールイベントのハンドラー
    const handleScroll = () => {
      const sections = document.querySelectorAll('section[id]');
      const navLinks = document.querySelectorAll('.nav-link[href^="#"]');
      
      let current = '';
      const scrollPosition = window.scrollY;
      
      sections.forEach(section => {
        const sectionTop = section.offsetTop - 250;
        const sectionHeight = section.offsetHeight;
        
        if (scrollPosition >= sectionTop && scrollPosition < sectionTop + sectionHeight) {
          current = section.getAttribute('id');
        }
      });

      navLinks.forEach(link => {
        link.classList.remove('active');
        const href = link.getAttribute('href');
        if (href === '#' + current) {
          link.classList.add('active');
        }
      });
    };

    // 初回実行
    handleScroll();
    
    // スクロールイベントリスナー追加
    window.addEventListener('scroll', handleScroll, { passive: true });
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