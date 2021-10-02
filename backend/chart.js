const ChartJSImage = require('chart.js-image');

const generateChartMontly = (data) => {
  const labels = Object.keys(data.data);

  const line_chart = ChartJSImage()
    .chart({
      type: 'line',
      data: {
        labels,
        datasets: [
          {
            borderColor: 'rgb(0,0,255)',
            backgroundColor: 'rgba(0,0,255,1)',
            data: labels.map((item) => data.data[item]),
            fill: false,
            tension: 0.2,
          },
        ],
      },
      options: {
        title: {
          display: false,
        },
        legend: {
          display: false,
        },
        scales: {
          // xAxes: [
          //   {
          //     scaleLabel: {
          //       display: true,
          //       labelString: 'Time',
          //     },
          //   },
          // ],
          yAxes: [
            {
              stacked: true,
              scaleLabel: {
                display: true,
                labelString: data.units,
              },
            },
          ],
        },
      },
    })
    .backgroundColor('white')
    .width(500)
    .height(300);

  return line_chart.toURL();
};

const genChart = (data, labels, units) => {
  const line_chart = ChartJSImage()
    .chart({
      type: 'line',
      data: {
        labels,
        datasets: [
          {
            borderColor: 'rgb(0,0,255)',
            backgroundColor: 'rgba(0,0,255,1)',
            data: data,
            fill: false,
            tension: 0.2,
          },
        ],
      },
      options: {
        title: {
          display: false,
        },
        legend: {
          display: false,
        },
        scales: {
          // xAxes: [
          //   {
          //     scaleLabel: {
          //       display: true,
          //       labelString: 'Time',
          //     },
          //   },
          // ],
          yAxes: [
            {
              stacked: true,
              scaleLabel: {
                display: true,
                labelString: units,
              },
            },
          ],
        },
      },
    })
    .backgroundColor('white')
    .width(500)
    .height(300);

  return line_chart.toURL();
};

const generateChartDaily = (data) => {
  let finalData = {};

  //   console.log(data);

  for (let key of Object.keys(data.data)) {
    let tempData = [];
    for (let month of Object.keys(data.data[key])) {
      const labels = Object.keys(data.data[key][month]).sort();

      tempData.push(
        {
          month: `${key}-${month}`,
          data: genChart(
            labels.map((item) => data.data[key][month][item]),
            labels,
            data.units
          )
        }
      );
    }
    finalData[key] = tempData;
  }

  return finalData;
};

module.exports = {
  generateChartMontly,
  generateChartDaily,
};
