document.addEventListener('DOMContentLoaded', function(){
  const previewList = document.getElementById('previews');
  const fileField = document.querySelector('input[type="file"][name="user[avatar]"]');
  fileField.addEventListener('change', function(e){
    const alreadyPreview = document.querySelector('.preview');
    if (alreadyPreview) {
      alreadyPreview.remove();
    };

    const file = e.target.files[0];
    const blob = window.URL.createObjectURL(file);

    const previewWrapper = document.createElement('div');
    previewWrapper.setAttribute('class', 'preview');

    const previewImage = document.createElement('img');
    previewImage.setAttribute('class', 'preview rounded-circle mb-3 mx-auto d-block');
    previewImage.setAttribute('src', blob);
    previewImage.width = "160";
    previewImage.height = "160";
    
    // 生成したHTMLの要素をブラウザに表示させる
    previewWrapper.appendChild(previewImage);
    previewList.appendChild(previewWrapper);
  });
});
