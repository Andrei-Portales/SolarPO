import 'package:solar_app/util/parameters.dart';

Map<String, dynamic> monthlyData(Map<String, dynamic> keys) {
  Map<String, dynamic> data = {};

  for (final key in keys.keys.toList().reversed) {
    final items = keys[key];
    Map<String, double> tempData = {};
    Map<String, int> countData = {};

    for (final itemKey in items.keys) {
      int keyDate =
          int.parse(itemKey.substring(itemKey.length - 2, itemKey.length));

      if (keyDate < 13) {
        if (!tempData.containsKey(monthsNames[keyDate - 1])) {
          tempData[monthsNames[keyDate - 1]] = 0.0;
          countData[monthsNames[keyDate - 1]] = 0;
        }
        final prevValue = tempData[monthsNames[keyDate - 1]];
        tempData[monthsNames[keyDate - 1]] = prevValue! + items[itemKey];

        countData[monthsNames[keyDate - 1]] =
            countData[monthsNames[keyDate - 1]]! + 1;
      }
    }

    for (final item in countData.keys) {
      tempData[item] = tempData[item]! / countData[item]!;
    }
    data[key] = tempData;
  }
  return data;
}

Map<String, dynamic> dailyData(Map<String, dynamic> keys) {
  Map<String, dynamic> data = {};

  for (final key in keys.keys.toList().reversed) {
    Map<String, dynamic> temp = {};

    for (final dd in keys[key].keys) {
      if (keys[key][dd] != -999.0) {
        temp[dd] = keys[key][dd];
      }
    }

    Map<String, dynamic> dataF = {};

    for (String key in temp.keys) {
      String year = key.substring(0, 4);
      String month = key.substring(4, 6);
      String day = key.substring(6, 8);

      if (!dataF.containsKey(year)) {
        dataF[year] = {};
      }

      if (!dataF[year].containsKey(month)) {
        dataF[year][month] = {};
      }

      dataF[year][month][day] = temp[key];
    }

    data[key] = dataF;
  }

  return data;
}
