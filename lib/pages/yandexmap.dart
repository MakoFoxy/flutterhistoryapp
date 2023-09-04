import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:mausoleum/api/yandexmap/widgets/map_page.dart';
import 'package:mausoleum/api/yandexmap/map_controls_page.dart';

const List<MapPage> _allPages = <MapPage>[
  MapControlsPage(),
  // ClusterizedPlacemarkCollectionPage(),
  // MapObjectCollectionPage(),
  // PlacemarkMapObjectPage(),
  // PolylineMapObjectPage(),
  // PolygonMapObjectPage(),
  // CircleMapObjectPage(),
  // UserLayerPage(),
  // SuggestionsPage(),
  // SearchPage(),
  // ReverseSearchPage(),
  // BicyclePage(),
  // DrivingPage(),
];

@override
void useMap() {
  AndroidYandexMap.useAndroidViewSurface = false;
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  void initState() {
    super.initState();
    useMap();
  }

  void _pushPage(BuildContext context, MapPage page) {
    Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (_) => Scaffold(
                appBar: AppBar(title: Text(page.title)),
                body:
                    Container(padding: const EdgeInsets.all(8), child: page))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('YandexMap')),
        body: Column(children: <Widget>[
          Expanded(
              child: Container(
                  padding: const EdgeInsets.all(8), child: const YandexMap())),
          Expanded(
              child: ListView.builder(
            itemCount: _allPages.length,
            itemBuilder: (_, int index) => ListTile(
              title: Text(_allPages[index].title),
              onTap: () => _pushPage(context, _allPages[index]),
            ),
          ))
        ]));
  }
}
