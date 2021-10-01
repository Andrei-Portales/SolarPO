List<Map<String, dynamic>> parametersList = [
  {
    "category": "Solar Fluxes and Related",
    "items": [
      {
        "name": "All Sky Surface Shortwave Downward Irradiance",
        "value": "ALLSKY_SFC_SW_DWN",
        'isSelected': false
      },
      {
        "name": "Clear Sky Surface Shortwave Downward Irradiance",
        "value": "CLRSKY_SFC_SW_DWN",
        'isSelected': false
      },
      {
        "name": "All Sky Surface Shortwave Downward Direct Normal Irradiance",
        "value": "ALLSKY_SFC_SW_DNI",
        'isSelected': false
      },
      {
        "name": "All Sky Surface Shortwave Diffuse Irradiance",
        "value": "ALLSKY_SFC_SW_DIFF",
        'isSelected': false
      },
      {
        "name": "All Sky Insolation Clearness Index",
        "value": "ALLSKY_KT",
        'isSelected': false
      },
      {
        "name": "All Sky Normalized Insolation Clearness Index",
        "value": "ALLSKY_NKT",
        'isSelected': false
      },
      {
        "name": "Clear Sky Insolation Clearness Index",
        "value": "CLRSKY_KT",
        'isSelected': false
      },
      {
        "name": "Clear Sky Normalized Insolation Clearness Index",
        "value": "CLRSKY_NKT",
        'isSelected': false
      },
      {
        "name": "All Sky Surface Albedo",
        "value": "ALLSKY_SRF_ALB",
        'isSelected': false
      },
      {
        "name": "Top-Of-Atmosphere Shortwave Downward Irradiance",
        "value": "TOA_SW_DWN",
        'isSelected': false
      },
      {"name": "Cloud Amount", "value": "CLOUD_AMT", 'isSelected': false},
      {
        "name":
            "All Sky Surface Photosynthetically Active Radiation (PAR) Total",
        "value": "ALLSKY_SFC_PAR_TOT",
        'isSelected': false
      },
      {
        "name":
            "Clear Sky Surface Photosynthetically Active Radiation (PAR) Total",
        "value": "CLRSKY_SFC_PAR_TOT",
        'isSelected': false
      },
      {
        "name": "All Sky Surface UVA Irradiance",
        "value": "ALLSKY_SFC_UVA",
        'isSelected': false
      },
      {
        "name": "All Sky Surface UVB Irradiance",
        "value": "ALLSKY_SFC_UVB",
        'isSelected': false
      },
      {
        "name": "All Sky Surface UV Index",
        "value": "ALLSKY_SFC_UV_INDEX",
        'isSelected': false
      }
    ]
  },
  {
    "category": "Parameters for Solar Cooking",
    "items": [
      {
        "name": "All Sky Surface Shortwave Downward Irradiance",
        "value": "ALLSKY_SFC_SW_DWN:89",
        'isSelected': false
      },
      {
        "name": "Clear Sky Surface Shortwave Downward Irradiance",
        "value": "CLRSKY_SFC_SW_DWN:76",
        'isSelected': false
      },
      {"name": "Wind Speed at 2 Meters", "value": "WS2M", 'isSelected': false}
    ]
  },
  {
    "category": "Temperatures",
    "items": [
      {"name": "Temperature at 2 Meters", "value": "T2M", 'isSelected': false},
      {
        "name": "Dew/Frost Point at 2 Meters",
        "value": "T2MDEW",
        'isSelected': false
      },
      {
        "name": "Wet Bulb Temperature at 2 Meters",
        "value": "T2MWET",
        'isSelected': false
      },
      {"name": "Earth Skin Temperature", "value": "TS", 'isSelected': false},
      {
        "name": "Temperature at 2 Meters Range",
        "value": "T2M_RANGE",
        'isSelected': false
      },
      {
        "name": "Temperature at 2 Meters Maximum",
        "value": "T2M_MAX",
        'isSelected': false
      },
      {
        "name": "Temperature at 2 Meters Minimum",
        "value": "T2M_MIN",
        'isSelected': false
      },
      {
        "name": "All Sky Surface Longwave Downward Irradiance",
        "value": "ALLSKY_SFC_LW_DWN",
        'isSelected': false
      }
    ]
  },
  {
    "category": "Humidity/Precipitation",
    "items": [
      {
        "name": "Specific Humidity at 2 Meters",
        "value": "QV2M",
        'isSelected': false
      },
      {
        "name": "Relative Humidity at 2 Meters",
        "value": "RH2M",
        'isSelected': false
      },
      {"name": "Precipitation ", "value": "PRECTOTCORR", 'isSelected': false}
    ]
  },
  {
    "category": "Wind/Pressure",
    "items": [
      {"name": "Surface Pressure", "value": "PS", 'isSelected': false},
      {
        "name": "Wind Speed at 10 Meters",
        "value": "WS10M",
        'isSelected': false
      },
      {
        "name": "Wind Speed at 10 Meters Maximum",
        "value": "WS10M_MAX",
        'isSelected': false
      },
      {
        "name": "Wind Speed at 10 Meters Minimum",
        "value": "WS10M_MIN",
        'isSelected': false
      },
      {
        "name": "Wind Speed at 10 Meters Range",
        "value": "WS10M_RANGE",
        'isSelected': false
      },
      {
        "name": "Wind Speed at 50 Meters",
        "value": "WS50M",
        'isSelected': false
      },
      {
        "name": "Wind Speed at 50 Meters Maximum",
        "value": "WS50M_MAX",
        'isSelected': false
      },
      {
        "name": "Wind Speed at 50 Meters Minimum",
        "value": "WS50M_MIN",
        'isSelected': false
      },
      {
        "name": "Wind Speed at 50 Meters Range",
        "value": "WS50M_RANGE",
        'isSelected': false
      }
    ]
  }
];

Map<String, String> paramKeys = {
  'ALLSKY_SFC_SW_DWN': 'All Sky Surface Shortwave Downward Irradiance',
  'CLRSKY_SFC_SW_DWN': 'Clear Sky Surface Shortwave Downward Irradiance',
  'ALLSKY_SFC_SW_DNI':
      'All Sky Surface Shortwave Downward Direct Normal Irradiance',
  'ALLSKY_SFC_SW_DIFF': 'All Sky Surface Shortwave Diffuse Irradiance',
  'ALLSKY_KT': 'All Sky Insolation Clearness Index',
  'ALLSKY_NKT': 'All Sky Normalized Insolation Clearness Index',
  'CLRSKY_KT': 'Clear Sky Insolation Clearness Index',
  'CLRSKY_NKT': 'Clear Sky Normalized Insolation Clearness Index',
  'ALLSKY_SRF_ALB': 'All Sky Surface Albedo',
  'TOA_SW_DWN': 'Top-Of-Atmosphere Shortwave Downward Irradiance',
  'CLOUD_AMT': 'Cloud Amount',
  'ALLSKY_SFC_PAR_TOT':
      'All Sky Surface Photosynthetically Active Radiation (PAR) Total',
  'CLRSKY_SFC_PAR_TOT':
      'Clear Sky Surface Photosynthetically Active Radiation (PAR) Total',
  'ALLSKY_SFC_UVA': 'All Sky Surface UVA Irradiance',
  'ALLSKY_SFC_UVB': 'All Sky Surface UVB Irradiance',
  'ALLSKY_SFC_UV_INDEX': 'All Sky Surface UV Index',
  'ALLSKY_SFC_SW_DWN:89': 'All Sky Surface Shortwave Downward Irradiance',
  'CLRSKY_SFC_SW_DWN:76': 'Clear Sky Surface Shortwave Downward Irradiance',
  'WS2M': 'Wind Speed at 2 Meters',
  'T2M': 'Temperature at 2 Meters',
  'T2MDEW': 'Dew/Frost Point at 2 Meters',
  'T2MWET': 'Wet Bulb Temperature at 2 Meters',
  'TS': 'Earth Skin Temperature',
  'T2M_RANGE': 'Temperature at 2 Meters Range',
  'T2M_MAX': 'Temperature at 2 Meters Maximum',
  'T2M_MIN': 'Temperature at 2 Meters Minimum',
  'ALLSKY_SFC_LW_DWN': 'All Sky Surface Longwave Downward Irradiance',
  'QV2M': 'Specific Humidity at 2 Meters',
  'RH2M': 'Relative Humidity at 2 Meters',
  'PRECTOTCORR': 'Precipitation ',
  'PS': 'Surface Pressure',
  'WS10M': 'Wind Speed at 10 Meters',
  'WS10M_MAX': 'Wind Speed at 10 Meters Maximum',
  'WS10M_MIN': 'Wind Speed at 10 Meters Minimum',
  'WS10M_RANGE': 'Wind Speed at 10 Meters Range',
  'WS50M': 'Wind Speed at 50 Meters',
  'WS50M_MAX': 'Wind Speed at 50 Meters Maximum',
  'WS50M_MIN': 'Wind Speed at 50 Meters Minimum',
  'WS50M_RANGE': 'Wind Speed at 50 Meters Range'
};

List<String> monthsNames = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];
