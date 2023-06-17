import 'package:flutter/material.dart';

class ItemDetails extends StatelessWidget {
  final Map<String, dynamic> itemData;

  ItemDetails(this.itemData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Produk'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (itemData.containsKey('image'))
              Container(
                height: 200,
                width: double.infinity,
                child: Image.network(
                  itemData['image'],
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 16),
            Text(
              'Nama Barang: ${itemData['nama barang']}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Pengirim: ${itemData['nama pengirim']}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Penerima: ${itemData['nama penerima']}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Lokasi pengirim: ${itemData['user']}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Lokasi penerima: ${itemData['receiver']}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Harga: ${itemData['harga']} IDR',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Berat: ${itemData['quantity']} KG',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'metode pembayaran: ${itemData['metode pembayaran']}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
