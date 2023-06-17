import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'tambah_paket.dart';
import 'detail_paket.dart';

class PaketList extends StatelessWidget {
  PaketList({Key? key}) : super(key: key) {
    _stream = _reference.snapshots();
  }

  CollectionReference _reference =
      FirebaseFirestore.instance.collection('paket');

  //_reference.get()  ---> returns Future<QuerySnapshot>
  //_reference.snapshots()--> Stream<QuerySnapshot> -- realtime updates
  late Stream<QuerySnapshot> _stream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Paket'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //Check error
          if (snapshot.hasError) {
            return Center(child: Text('Some error occurred ${snapshot.error}'));
          }

          //Check if data arrived
          if (snapshot.hasData) {
            //get the data
            QuerySnapshot querySnapshot = snapshot.data;
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;

            //Convert the documents to Maps
            List<Map> items = documents.map((e) => e.data() as Map).toList();

            //Display the list
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                // Get the item at this index
                Map thisItem = items[index];

                // Return the widget for the list items
                return ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${thisItem['nama barang']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(height: 8),
                      Row(children: [
                        Text('Harga: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        Text('${thisItem['harga']}'),
                        SizedBox(width: 4),
                        Text('IDR',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ))
                      ]),
                      Row(children: [
                        Text('Berat: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        Text(
                          '${thisItem['quantity']}',
                        ),
                        SizedBox(width: 4),
                        Text('KG',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ))
                      ])
                    ],
                  ),
                  leading: Container(
                    height: 100,
                    width: 80,
                    child: thisItem.containsKey('image')
                        ? Image.network(
                            '${thisItem['image']}',
                            fit: BoxFit.cover,
                          )
                        : Container(),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ItemDetails(Map<String, dynamic>.from(thisItem)),
                    ));
                  },
                );
              },
            );
          }

          //Show loader
          return Center(child: CircularProgressIndicator());
        },
      ), //Display a list // Add a FutureBuilder
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddPaket()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
