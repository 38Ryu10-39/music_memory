document.addEventListener("DOMContentLoaded", (event) => {
  const currentUrl = window.location.href
  const urlSplit = currentUrl.split('/')
  const urlLast = urlSplit[urlSplit.length - 1]
  const urlJudge = urlLast.includes('search')
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
          if (urlJudge) {
            window.location.href = `/prefectures/${data.option.code}/${urlSplit[urlSplit.length - 1]}`;
          } else {
            window.location.href = `/prefectures/${data.option.code}`;
          }
        },
        areas: [
          {code: 1,name: "北海道", number: document.getElementById('prefecture_1').value},
          {code: 2,name: "青森", number: document.getElementById('prefecture_2').value},
          {code: 3,name: "岩手", number: document.getElementById('prefecture_3').value},
          {code: 4,name: "宮城", number: document.getElementById('prefecture_4').value},
          {code: 5,name: "秋田", number: document.getElementById('prefecture_5').value},
          {code: 6,name: "山形", number: document.getElementById('prefecture_6').value},
          {code: 7,name: "福島", number: document.getElementById('prefecture_7').value},
          {code: 8,name: "茨城", number: document.getElementById('prefecture_8').value},
          {code: 9,name: "栃木", number: document.getElementById('prefecture_9').value},
          {code: 10,name: "群馬", number: document.getElementById('prefecture_10').value},
          {code: 11,name: "埼玉", number: document.getElementById('prefecture_11').value},
          {code: 12,name: "千葉", number: document.getElementById('prefecture_12').value},
          {code: 13,name: "東京", number: document.getElementById('prefecture_13').value},
          {code: 14,name: "神奈川", number: document.getElementById('prefecture_14').value},
          {code: 15,name: "新潟", number: document.getElementById('prefecture_15').value},
          {code: 16,name: "富山", number: document.getElementById('prefecture_16').value},
          {code: 17,name: "石川", number: document.getElementById('prefecture_17').value},
          {code: 18,name: "福井", number: document.getElementById('prefecture_18').value},
          {code: 19,name: "山梨", number: document.getElementById('prefecture_19').value},
          {code: 20,name: "長野", number: document.getElementById('prefecture_20').value},
          {code: 21,name: "岐阜", number: document.getElementById('prefecture_21').value},
          {code: 22,name: "静岡", number: document.getElementById('prefecture_22').value},
          {code: 23,name: "愛知", number: document.getElementById('prefecture_23').value},
          {code: 24,name: "三重", number: document.getElementById('prefecture_24').value},
          {code: 25,name: "滋賀", number: document.getElementById('prefecture_25').value},
          {code: 26,name: "京都", number: document.getElementById('prefecture_26').value},
          {code: 27,name: "大阪", number: document.getElementById('prefecture_27').value},
          {code: 28,name: "兵庫", number: document.getElementById('prefecture_28').value},
          {code: 29,name: "奈良", number: document.getElementById('prefecture_29').value},
          {code: 30,name: "和歌山", number: document.getElementById('prefecture_30').value},
          {code: 31,name: "鳥取", number: document.getElementById('prefecture_31').value},
          {code: 32,name: "島根", number: document.getElementById('prefecture_32').value},
          {code: 33,name: "岡山", number: document.getElementById('prefecture_33').value},
          {code: 34,name: "広島", number: document.getElementById('prefecture_34').value},
          {code: 35,name: "山口", number: document.getElementById('prefecture_35').value},
          {code: 36,name: "徳島", number: document.getElementById('prefecture_36').value},
          {code: 37,name: "香川", number: document.getElementById('prefecture_37').value},
          {code: 38,name: "愛媛", number: document.getElementById('prefecture_38').value},
          {code: 39,name: "高知", number: document.getElementById('prefecture_39').value},
          {code: 40,name: "福岡", number: document.getElementById('prefecture_40').value},
          {code: 41,name: "佐賀", number: document.getElementById('prefecture_41').value},
          {code: 42,name: "長崎", number: document.getElementById('prefecture_42').value},
          {code: 43,name: "熊本", number: document.getElementById('prefecture_43').value},
          {code: 44,name: "大分", number: document.getElementById('prefecture_44').value},
          {code: 45,name: "宮崎", number: document.getElementById('prefecture_45').value},
          {code: 46,name: "鹿児島", number: document.getElementById('prefecture_46').value},
          {code: 47,name: "沖縄", number: document.getElementById('prefecture_47').value}
          ]
    });
  });
});