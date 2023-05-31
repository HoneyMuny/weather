import 'package:flutter/material.dart';
import 'grafico3.dart';


class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IoTDurango', textAlign: TextAlign.start),
        backgroundColor:Colors.black,
        centerTitle: true,
        elevation: 25.5,
        actions: const [
          IconButton(
            onPressed: null,
            icon: Icon(Icons.info,color: Colors.white,),
            tooltip: "Información",
          )
        ],
      ),
      body: Center(
        child: Grafico3(),
      ),
      //drawer: MenuLateral(),
    );
  }
}
