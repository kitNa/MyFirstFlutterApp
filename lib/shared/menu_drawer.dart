import 'package:flutter/material.dart';
import 'package:untitled/screens/sessions_screen.dart';
import 'package:untitled/screens/weather_screen.dart';
import '../screens/example.dart';
import '../screens/map_search_screen.dart';
import '../screens/price_screen.dart';
import '../screens/intro_screen.dart';
import '../screens/map_screen.dart';
import '../screens/map_polyline_screen.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: buildMenuItems(context),
      ),
    );
  }

  List<Widget> buildMenuItems(BuildContext context) {
    final List<String> menuTitles = [
      'Home',
      'Calculation',
      'Weather',
      'Lessons',
      'Location',
      'Map search',
      'Distance on the map',
      'Map with poliline'
    ];

    List<Widget> menuItems = [];
    menuItems.add(DrawerHeader(
      decoration: BoxDecoration(color: Colors.blueGrey),
      child: Text('Scuba diving lessons',
      style: TextStyle(color: Colors.white, fontSize: 28))));
    menuTitles.forEach((String element){
      Widget screen = Container();
      menuItems.add(ListTile(
        title: Text(element,
        style:  TextStyle (fontSize: 18)),
        onTap: () {
          switch (element) {
            case 'Home':
              screen = IntroScreen();
              break;
            case 'Calculation':
              screen = PriceScreen();
              break;
            case 'Weather':
              screen = WeatherScreen();
              break;
            case 'Lessons':
              screen = SessionsScreen();
              break;
            case 'Location':
              screen = MapScreen();
              break;
            case 'Map search':
              screen = MapSearchScreen();
              break;
            case 'Distance on the map':
              screen = MapPolylineScreen();
              break;
            case 'Map with poliline':
              screen = MyApp();
              break;
          }
          Navigator.of(context).pop();
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => screen)
          );
        }));
    });
    return menuItems;
  }
}
