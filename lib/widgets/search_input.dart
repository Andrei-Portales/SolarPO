import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../screens/result_screen.dart';
import '../util/parameters.dart';
import './date_select.dart';
import 'dart:convert';
import './map_button.dart';
import './parameters_select.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({Key? key}) : super(key: key);

  @override
  _SearchInputState createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final List<String> temporalValues = ['daily', 'monthly'];
  String currentTemporal = 'monthly';
  LatLng? _currentLocation;
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  List<Map<String, dynamic>> parameters = [...parametersList];
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  int _selectedCount = 0;

  Future<void> _search() async {
    if (_formKey.currentState == null) {
      return;
    }

    final isFormValid = _formKey.currentState!.validate();

    if (!isFormValid) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Have invalid fields!')));
      return;
    }

    List<String> params = [];

    for (var cat in parameters) {
      for (var item in cat['items']) {
        if (item['isSelected']) {
          params.add(item['value']);
        }
      }
    }

    if (params.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String startDate = '';
    String endDate = '';

    if (currentTemporal == 'monthly') {
      startDate = startTime.year.toString();

      if (endTime.year == DateTime.now().year) {
        endDate = (endTime.year - 1).toString();
      } else {
        endDate = endTime.year.toString();
      }
    } else {
      startDate =
          '${startTime.year}${startTime.month.toString().padLeft(2, '0')}${startTime.day.toString().padLeft(2, '0')}';
      endDate =
          '${endTime.year}${endTime.month.toString().padLeft(2, '0')}${endTime.day.toString().padLeft(2, '0')}';
    }

    try {
      final response = await http.get(Uri.parse(
          'https://power.larc.nasa.gov/api/temporal/$currentTemporal/point?' +
              'parameters=${params.join(',')}&community=RE' +
              '&longitude=${_longitudeController.text.trim()}' +
              '&latitude=${_latitudeController.text.trim()}' +
              '&format=JSON&start=$startDate&end=$endDate&user=DAV'));

      final data = json.decode(response.body);

      if (data['messages'].length > 0) {
        throw data['messages'][0];
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              ResultScreen(temporalType: currentTemporal, data: data),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() {
      _isLoading = false;
    });
  }

  void setTime(DateTime time, int cTime) {
    setState(() {
      if (cTime == 0) {
        startTime = time;
      } else {
        endTime = time;
      }
    });
  }

  void setLocation(LatLng? location) {
    if (location != null) {
      _latitudeController.text = location.latitude.toString();
      _longitudeController.text = location.longitude.toString();
    }
    setState(() => _currentLocation = location);
  }

  void setSelected(int main, int sub) {
    bool c = !parameters[main]['items'][sub]['isSelected'];

    if (c) {
      if (_selectedCount == 16) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('The limit is 16')));
        return;
      }
      _selectedCount++;
    } else {
      _selectedCount--;
    }

    setState(() {
      parameters[main]['items'][sub]['isSelected'] = c;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: double.infinity,
      child: ListView(
        children: [
          Card(
            elevation: 3,
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Text(
                    'Choose a Temporal Average',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(0, 0, 0, 0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      iconSize: 42,
                      underline: const SizedBox(),
                      value: currentTemporal,
                      onChanged: (value) {
                        setState(() {
                          currentTemporal = value!;
                        });
                      },
                      items: [
                        for (String item in temporalValues)
                          DropdownMenuItem<String>(
                            child: Center(
                              child: Text(
                                item.toUpperCase(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            value: item,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          Card(
            elevation: 3,
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      'Enter Lat/Lon or Add a Point to Map',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Latitude: '),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Empty field!';
                              }

                              try {
                                double.parse(value.trim());
                              } catch (e) {
                                return 'Value is not a number!';
                              }

                              return null;
                            },
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            controller: _latitudeController,
                            decoration:
                                const InputDecoration(hintText: '00.00000'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Longitude: '),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Empty field!';
                              }

                              try {
                                double.parse(value.trim());
                              } catch (e) {
                                return 'Value is not a number!';
                              }

                              return null;
                            },
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            controller: _longitudeController,
                            decoration:
                                const InputDecoration(hintText: '00.00000'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    MapButton(
                      setLocation: setLocation,
                      currentLocation: _currentLocation,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Card(
            elevation: 3,
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Text(
                    'Select Time Extent',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 10),
                  DateSelect(
                    startTime: startTime,
                    endTime: endTime,
                    setTime: setTime,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          Card(
            elevation: 3,
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Text(
                    'Select Parameters',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  ParametersSelect(
                    parameters: parameters,
                    setSelected: setSelected,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                  ),
                  onPressed: _search,
                  child: const Text('Search'),
                ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
