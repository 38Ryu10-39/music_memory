document.addEventListener('DOMContentLoaded', function() {
  let myButton = document.querySelector('#myButton');
  let searchIcon = document.querySelector('#search-icon');
  let searchText = document.querySelector('#search-text');

  myButton.addEventListener('click', function() {
    searchIcon.classList.toggle('search180');
    if (searchIcon.classList.contains('search180')) {
      searchText.textContent = '閉じる';
    } else {
      searchText.textContent = '検索';
    }
  });
});