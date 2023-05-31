import 'package:flutter/material.dart';

import 'grafico3.dart';
import 'homepage.dart';
import 'listaDatos.dart';
import 'listaDatos2.dart';

class Inicio extends StatefulWidget   {
  @override
  MyInicio createState() {
    return MyInicio();
  }
}
class MyInicio extends State<Inicio>{

  int _selectedIndex = 0;
  final List<Widget> _children=[
    HomePage(),
    ListaDatos(),
    ListaDatos2(),
    Grafico3(),
   // Chart(),
    //ControladorWidget(),
       // SinCos(),
      // Grafico4()
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme =Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      /* appBar: AppBar(
        title: const Text('IMFE INVERNADERO'),
        // backgroundColor: Color.fromRGBO(0, 0, 153, 1.0),
      ),*/
      // drawer: MenuLateral(),
      body: Center(
        child: _children[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.onSurface,
        unselectedItemColor: colorScheme.onSurface.withOpacity(.60),
        selectedLabelStyle: textTheme.caption,
        unselectedLabelStyle: textTheme.caption,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'ListaDatos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_outlined),
            label: 'ListaDatos2',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: 'Grafico',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_tree_sharp),
            label: 'Controlador',
          ),

        ],
      ),
    );
  }
}
