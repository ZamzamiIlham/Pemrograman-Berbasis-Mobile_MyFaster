import 'package:flutter/material.dart';

class ItemDetails extends StatelessWidget {
  final Map<String, dynamic> itemData;

  ItemDetails(this.itemData);

  String _getBulan(int month) {
    switch (month) {
      case 1:
        return 'Januari';
      case 2:
        return 'Februari';
      case 3:
        return 'Maret';
      case 4:
        return 'April';
      case 5:
        return 'Mei';
      case 6:
        return 'Juni';
      case 7:
        return 'Juli';
      case 8:
        return 'Agustus';
      case 9:
        return 'September';
      case 10:
        return 'Oktober';
      case 11:
        return 'November';
      case 12:
        return 'Desember';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime tanggalPenjemputan = DateTime.fromMillisecondsSinceEpoch(
        itemData['tanggalPenjemputan'].millisecondsSinceEpoch);

    String formattedDate = '';
    if (tanggalPenjemputan.hour == 0 &&
        tanggalPenjemputan.minute == 0 &&
        tanggalPenjemputan.second == 0) {
      formattedDate =
          '${tanggalPenjemputan.day} ${_getBulan(tanggalPenjemputan.month)} ${tanggalPenjemputan.year}';
    } else {
      formattedDate = tanggalPenjemputan.toString();
    }
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Detail Paket', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Container(
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
                'Nama Barang:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                itemData['nama barang'],
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Tanggal Penjemputan:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                formattedDate,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Pengirim:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                itemData['nama pengirim'],
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Penerima:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                itemData['nama penerima'],
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Lokasi pengirim:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                itemData['user'],
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Lokasi penerima:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                itemData['receiver'],
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Harga:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${itemData['harga']} IDR',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Berat:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${itemData['quantity']} KG',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Metode Pembayaran:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                itemData['metode pembayaran'],
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
