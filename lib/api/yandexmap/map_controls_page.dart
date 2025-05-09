import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'package:mausoleum/api/yandexmap/widgets/control_button.dart';
import 'package:mausoleum/api/yandexmap/widgets/map_page.dart';

class MapControlsPage extends MapPage {
  late double selectedX;
  late double selectedY;
  MapControlsPage({
    required String id,
    required this.selectedX,
    required this.selectedY,
    Key? key,
  }) : super(id, key: key);

  @override
  Widget build(BuildContext context) {
    return MapControlsExample(selectedX: selectedX, selectedY: selectedY);
  }
}

class MapControlsExample extends StatefulWidget {
  late double selectedX;
  late double selectedY;

  MapControlsExample({
    required this.selectedX,
    required this.selectedY,
    Key? key,
  });

  @override
  MapControlsExampleState createState() => MapControlsExampleState();
}

class MapControlsExampleState extends State<MapControlsExample> {
  late YandexMapController controller;

  final List<MapObject> mapObjects = [];

  final MapObjectId targetMapObjectId = const MapObjectId('target_placemark');

  late Point _point;
  bool nightModeEnabled = false;

  @override
  void initState() {
    super.initState();

    // Доступ к свойству widget в initState
    _point = Point(latitude: widget.selectedX, longitude: widget.selectedY);
  }

  final animation =
      const MapAnimation(type: MapAnimationType.smooth, duration: 2.0);

  int? poiLimit;

  final String style = '''
    [
      {
        "tags": {
          "all": ["landscape"]
        },
        "stylers": {
          "color": "f00",
          "saturation": 0.5,
          "lightness": 0.5
        }
      }
    ]
  ''';
  String _enabledText(bool enabled) {
    return enabled ? 'on' : 'off';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
            child: YandexMap(
          nightModeEnabled: nightModeEnabled,
          poiLimit: poiLimit,
          mapObjects: mapObjects,
          onMapCreated: (YandexMapController yandexMapController) async {
            controller = yandexMapController;

            //final cameraPosition = await controller.getCameraPosition();
            double initialZoom = 15.0;
            await controller.moveCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(target: _point, zoom: initialZoom),
              ),
            );
            final minZoom = await controller.getMinZoom();
            final maxZoom = await controller.getMaxZoom();

            // print('Camera position: $cameraPosition');
            print('Min zoom: $minZoom, Max zoom: $maxZoom');
          },
          onMapTap: (Point point) async {
            print('Tapped map at $point');

            await controller.deselectGeoObject();
          },
          onMapLongTap: (Point point) => print('Long tapped map at $point'),
          onCameraPositionChanged: (CameraPosition cameraPosition,
              CameraUpdateReason reason, bool finished) {
            print('Camera position: $cameraPosition, Reason: $reason');

            if (finished) {
              print('Camera position movement has been finished');
            }
          },
          onObjectTap: (GeoObject geoObject) async {
            print('Tapped object: ${geoObject.name}');

            if (geoObject.selectionMetadata != null) {
              await controller.selectGeoObject(geoObject.selectionMetadata!.id,
                  geoObject.selectionMetadata!.layerId);
            }
          },
        )),
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Table(
              children: <TableRow>[
                TableRow(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                await controller.moveCamera(
                                  CameraUpdate.newCameraPosition(
                                    CameraPosition(target: _point),
                                  ),
                                  animation: animation,
                                );
                              },
                              child: Icon(
                                Icons.place,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                setState(() {
                                  nightModeEnabled = !nightModeEnabled;
                                });
                              },
                              icon: Icon(
                                Icons
                                    .mode_night, // Здесь выберите нужную иконку
                                // Другие параметры для настройки иконки, такие как размер и цвет
                              ),
                              label: SizedBox.shrink(), // Текст кнопки
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
