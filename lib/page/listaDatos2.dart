import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
//import 'package:intl/intl.dart';

class ListaDatos2 extends StatefulWidget {
  const ListaDatos2({Key? key}) : super(key: key);

  @override
  State<ListaDatos2> createState() => _searchScreenState();
}

class _searchScreenState extends State<ListaDatos2> {
  final TextEditingController searchController = TextEditingController();
  bool isShowOrder = false;
  late DateTime tsdate;
  late DateTime tsdatec;
  late Timestamp myTimeStamp;
  //late String myTimeStamp;
  var Fecha;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  /*Future<Query?> searchQuery() async {
    var query = FirebaseFirestore.instance.collection('variablesTH');
    var query2 =
    query.where('temperatura'.toString(), isEqualTo: searchController.text);//isGreaterThanOrEqualTo
    print("//////////////"+query2.toString());
    return query2;
  }*/
 fechaformat(Timestamp t) {
   // return timeago.format(t.toDate());
    tsdate = DateTime.parse(t.toDate().toString());
    String datetime = tsdate.year.toString()+ "-" +tsdate.month.toString() + "-" +tsdate.day.toString()+ " " +tsdate.hour.toString()+
        ":" +tsdate.minute.toString()+":" +tsdate.second.toString()+"."+tsdate.millisecond.toString();
    print("---------------------------"+tsdate.millisecondsSinceEpoch.toString());
    myTimeStamp = Timestamp.fromDate(tsdate);
    print("+++++++++++++++++++++++++++"+myTimeStamp .toString());
    return datetime;
  }
  fechaformat2(String t) {
    tsdate = DateTime.parse(t);
   // var fech=tsdate.millisecondsSinceEpoch;
    myTimeStamp = Timestamp.fromDate(tsdate);//Timestamp.fromMillisecondsSinceEpoch(fech);
    print("++++++++++++++"+myTimeStamp.toString());
    print("//////////////"+tsdate.toString());
    return tsdate; //myTimeStamp;
  }

  consulta(){
   FirebaseFirestore.instance
        .collection('variablesTH')
        .where('Fecha')//fechaformat2(fecha)) //fechaformat2(searchController.text))
        .get();
    print("=================");


  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title:TextButton(
            onPressed: () {
             DatePicker.showDateTimePicker(context,
                  showTitleActions: true,
                  minTime: DateTime(2022, 1, 1, 00, 00,00),// minTime: DateTime(2022, 1, 1, 00, 00,00,000),
                  maxTime: DateTime(2025, 12, 31, 00, 00,00), onChanged: (date) {
                    print('change $date in time zone ' +
                        date.timeZoneOffset.inHours.toString());
                  }, onConfirm: (date) {
                  setState(() {
                     isShowOrder = true;
                  });
                    print('confirm $date');
                    Fecha=date.toString();
                    //tsdatec=date;
                  print(date);
                  }, locale: LocaleType.es);
            },
            child: Text(
              'Seleccione Fecha',
              style: TextStyle(color: Colors.blue),
            )), /*TextFormField(
          cursorColor: Colors.white,
          controller: searchController,
          keyboardType: TextInputType.datetime,
          decoration: const InputDecoration(
            hintText: 'Valor de Temperatura',
            hintStyle: TextStyle(color: Colors.white),
          ),
          style: TextStyle(color: Colors.white),
          onFieldSubmitted: (String searchQuery) {
            setState(() {
              isShowOrder = true;
              print("++---++++++++----++++++----++++++"+searchQuery);
            });
          },
        ),*/
      ),
      body: isShowOrder
          ? FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('variablesTH')
            //.where('temperatura', isGreaterThanOrEqualTo: double.parse(searchController.text))
            .where('Fecha', isGreaterThanOrEqualTo: Fecha)//fechaformat2(fecha)) //fechaformat2(searchController.text))
            .get(),
            //.then(...);
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,//SOLO MUETRA UN REGISTRO
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                },
                child: ListTile(
                  /*leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        (snapshot.data! as dynamic).docs[index]['foto']
                      ),
                  ),*/
                  title: /*Text(
                    'Temperatura: ${(snapshot.data! as dynamic).docs[index]['temperatura'].toString()}',
                  ),*/
                  Text("Humedad: "+snapshot.data!.docs[index]['Humedad'].toString()),
                  subtitle: /*Text(
                    'Humedad: ${(snapshot.data! as dynamic).docs[index]['humedad'].toString()}',
                  ),*/
                 // Text("Temperatura: "+snapshot.data!.docs[index]['temperatura'].toString()+"\n"+"Fecha: "+fechaformat(snapshot.data!.docs[index]['fecha']).toString()),
                  Text("Temperatura: "+snapshot.data!.docs[index]['Temperatura'].toString()+"\n"+"Fecha: "+snapshot.data!.docs[index]['Fecha']),
                ),
              );
            },
          );
        },
      )
          : StreamBuilder<QuerySnapshot>(
          stream:FirebaseFirestore.instance.collection('variablesTH').snapshots(),//loadAllAspirantes(),
          builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
            if (!data.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: data.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic>  data = document.data()! as Map<String, dynamic>;
                //DateTime dt = (data['timestamp'] as Timestamp).toDate();
                return ListTile(
                  title: Text("Humedad: "+data['Humedad'].toString()),
                  subtitle: Text("Temperatura: "+data['Temperatura'].toString()+"\n"+"Fecha: "+fechaformat2(data['Fecha']).toString()),
                  );
              }).toList(),
            );
          }),

    );
  }
}