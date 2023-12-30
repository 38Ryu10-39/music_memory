document.addEventListener("DOMContentLoaded", (event) => {
  const currentUrl = window.location.href
  const urlSplit = currentUrl.split('/')
  const urlLast = urlSplit[urlSplit.length - 1]
  const urlSearch = urlLast.includes('search')
  const pattern = /page=\d+&/
  const modifiedString = urlLast.replace(pattern, '')
  const post_numbers = function(pre_num) { 
    const preId = document.querySelector(`#prefecture_${pre_num}`)
    const className = preId.className;
    return className
  }
  const prefecture_names = function(pre_name) {
    const prefName = document.querySelector(`#prefecture_${pre_name}`).value
    return prefName
  }
  const areas = Array.from({ length: 47 }, (_, i) => {
    const code = i + 1;
    return {
      code: code,
      name: prefecture_names(code),
      number: post_numbers(code)
    };
  });
  $(document).ready(function() {
    $('#jmap').jmap({
        width: '100%',
        height: '450px',
        lineColor: '#ea55040a',
        lineWidth: 2,
        showTextShadow: false,
        backgroundColor: 'white',
        backgroundRadius: '0.5rem',
        backgroundPadding: '0.5rem',
        dividerColor: '#EFE4A6',
        showPrefectureName: true,
        showRoundedPrefecture: true,
        prefectureNameType: 'full',
        prefectureBackgroundHoverColor: '#ea55040a',
        prefectureLineColor: '#EFE4A6',
        prefectureLineHoverColor: '#ffffff',
        prefectureLineWidth: '2px',
        prefectureLineGap: '0px',
        prefectureInnerLineWidth: '1px',
        prefectureInnerLineColor: '#EFE4A6',
        prefectureInnerLineType: 'outset',
        prefectureRadius: '15px',
        prefectureLineY: '2px',
        prefectureLineX: '2px',
        fontSize: '0.6rem',
        fontColor: '#fff',
        showHeatmap: true,
        heatmapConditions: ["0","1",">1",">2",">3",">4"],
        heatmapColors: ["#FFE", "#FEDCBD", "#FCBB76", "#FCAF17", "#F36C21", "#F15A22"],
        backgroundColor: '#ea55040a',
        onSelect: function(e, data) {
          if (urlSearch) {
            window.location.href = `/prefectures/${data.option.code}/${modifiedString}`;
          } else {
            window.location.href = `/prefectures/${data.option.code}`;
          }
        },
        areas: areas
    });
  });
});