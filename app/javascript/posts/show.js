document.getElementById('commentToggleBtn').addEventListener('click', function() {
  const btn = document.getElementById('commentToggleBtn');
  const isOpen = btn.getAttribute('aria-expanded') === 'true';
  btn.innerHTML = isOpen ? 'コメントを閉じる' : 'コメントを表示' ;
});
