const express = require('express');
const cors = require('cors');

const { generateChartMontly, generateChartDaily } = require('./chart');

const app = express();

app.use(cors());
app.use(express.json());

app.post('/monthly', async (req, res) => {
  try {
    const { data } = req.body;

    if (!data) {
      return res.json({ result: false });
    }

    let images = [];

    for (let item of data) {
      const chart = generateChartMontly(item);
      images.push({
        key: item.key,
        image: chart,
      });
    }

    return res.json({ result: true, images });
  } catch (e) {
    return res.json({ result: false });
  }
});


app.post('/daily', async (req, res) => {
    try {
      const { data } = req.body;
  
      if (!data) {
        return res.json({ result: false });
      }

  
      let images = [];
  
      for (let item of data) {
        const chart = generateChartDaily(item);
        images.push({
          key: item.key,
          data: chart,
        });
      }
  
      return res.json({ result: true, images });
    } catch (e) {
      return res.json({ result: false });
    }
  });
  

app.listen(2000, () => {
  console.log('Running at port: 2000');
});
