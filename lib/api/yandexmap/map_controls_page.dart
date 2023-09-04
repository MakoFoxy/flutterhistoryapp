import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'package:mausoleum/api/yandexmap/widgets/control_button.dart';
import 'package:mausoleum/api/yandexmap/widgets/map_page.dart';

class MapControlsPage extends MapPage {
  const MapControlsPage({Key? key}) : super('Map controls', key: key);

  @override
  Widget build(BuildContext context) {
    return _MapControlsExample();
  }
}

class _MapControlsExample extends StatefulWidget {
  @override
  _MapControlsExampleState createState() => _MapControlsExampleState();
}

class _MapControlsExampleState extends State<_MapControlsExample> {
  late YandexMapController controller;
  final List<MapObject> mapObjects = [];

  final MapObjectId targetMapObjectId = const MapObjectId('target_placemark');
  static const Point _point =
      Point(latitude: 43.297884990740634, longitude: 68.27107852164164);
  static const Point _pointTauke =
      Point(latitude: 25.297884990740634, longitude: 74.27107852164164);
  static const Point _pointKazybek =
      Point(latitude: 25.297884990740634, longitude: 74.27107852164164);
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

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
              child: YandexMap(
            poiLimit: poiLimit,
            mapObjects: mapObjects,
            onMapCreated: (YandexMapController yandexMapController) async {
              controller = yandexMapController;

              final cameraPosition = await controller.getCameraPosition();
              final minZoom = await controller.getMinZoom();
              final maxZoom = await controller.getMaxZoom();

              print('Camera position: $cameraPosition');
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
                await controller.selectGeoObject(
                    geoObject.selectionMetadata!.id,
                    geoObject.selectionMetadata!.layerId);
              }
            },
          )),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Table(
                children: <TableRow>[
                  TableRow(children: <Widget>[
                    ControlButton(
                        onPressed: () async {
                          await controller.moveCamera(
                              CameraUpdate.newCameraPosition(
                                  const CameraPosition(target: _point)),
                              animation: animation);
                        },
                        title: 'Specific position'),
                    ControlButton(
                        onPressed: () async {
                          await controller.moveCamera(CameraUpdate.zoomTo(1),
                              animation: animation);
                        },
                        title: 'Specific zoom')
                  ]),
                  TableRow(children: <Widget>[
                    ControlButton(
                        onPressed: () async {
                          await controller.moveCamera(
                              CameraUpdate.newCameraPosition(
                                  const CameraPosition(target: _pointTauke)),
                              animation: animation);
                        },
                        title: 'Tauke position'),
                    ControlButton(
                        onPressed: () async {
                          await controller.moveCamera(
                              CameraUpdate.newCameraPosition(
                                  const CameraPosition(target: _pointKazybek)),
                              animation: animation);
                        },
                        title: 'Kazybek position'),
                  ]),
                  TableRow(children: <Widget>[
                    ControlButton(
                        onPressed: () async {
                          await controller.moveCamera(CameraUpdate.zoomIn(),
                              animation: animation);
                        },
                        title: 'Zoom in'),
                    ControlButton(
                        onPressed: () async {
                          await controller.moveCamera(CameraUpdate.zoomOut(),
                              animation: animation);
                        },
                        title: 'Zoom out'),
                  ]),
                  TableRow(children: <Widget>[
                    ControlButton(
                        onPressed: () async {
                          await controller.setMapStyle(style);
                        },
                        title: 'Set Style'),
                    ControlButton(
                        onPressed: () async {
                          await controller.setMapStyle('');
                        },
                        title: 'Remove style'),
                  ]),
                ],
              ),
            ),
          )
        ]);
  }
}
