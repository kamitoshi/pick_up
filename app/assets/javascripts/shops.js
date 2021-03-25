// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var ctx = document.getElementById("canvas").getContext("2d");
  var myBar = new Chart(ctx, {
    type: 'bar',                           //◆棒グラフ
    data: {                                //◆データ
      labels: [
        "<%= @week_data[0][0][:date] %>",
        "<%= @week_data[1][0][:date] %>",
        "<%= @week_data[2][0][:date] %>",
        "<%= @week_data[3][0][:date] %>",
        "<%= @week_data[4][0][:date] %>",
        "<%= @week_data[5][0][:date] %>",
        "<%= @week_data[6][0][:date] %>"
      ],     //ラベル名
      datasets: [{                       //データ設定
        data: [
          "<%= @week_data[0][0][:count] %>",
          "<%= @week_data[1][0][:count] %>",
          "<%= @week_data[2][0][:count] %>",
          "<%= @week_data[3][0][:count] %>",
          "<%= @week_data[4][0][:count] %>",
          "<%= @week_data[5][0][:count] %>",
          "<%= @week_data[6][0][:count] %>",
        ],          //データ内容
        backgroundColor: '#4444FF'   //背景色
      }]
    },
    options: {                             //◆オプション
      responsive: true,                  //グラフ自動設定
      legend: {                          //凡例設定
        display: false                 //表示設定
      },
      title: {                           //タイトル設定
        display: true,                 //表示設定
        fontSize: 18,                  //フォントサイズ
        text: '売上件数'                //ラベル
      },
      scales: {                          //軸設定
        yAxes: [{                      //y軸設定
          display: true,             //表示設定
          scaleLabel: {              //軸ラベル設定
              display: true,          //表示設定
              labelString: '注文件数',  //ラベル
              fontSize: 18               //フォントサイズ
          },
          ticks: {                      //最大値最小値設定
              min: 0,                   //最小値
              max: 10,                  //最大値
              fontSize: 18,             //フォントサイズ
              stepSize: 2              //軸間隔
          },
        }],
        xAxes: [{                         //x軸設定
          display: true,                //表示設定
          barPercentage: 2,           //棒グラフ幅
          categoryPercentage: 0.4,      //棒グラフ幅
          scaleLabel: {                 //軸ラベル設定
            display: true,             //表示設定
            labelString: '日付',  //ラベル
            fontSize: 18               //フォントサイズ
          },
          ticks: {
            fontSize: 18             //フォントサイズ
          },
        }],
      },
      layout: {                             //レイアウト
        padding: {                          //余白設定
          left: 50,
          right: 50,
          top: 0,
          bottom: 50
        }
      }
    }
  });