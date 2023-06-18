import 'package:flutter/material.dart';

class PaymentInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title:
            Text('Informasi Pembayaran', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tarif',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/kirim.png', // Gambar untuk rekening
                    width: 40,
                    height: 40,
                  ),
                  SizedBox(width: 16.0),
                  Text(
                    '2500 setiap jarak 1km',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Nomor Rekening',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/bca.png', // Gambar untuk rekening
                    width: 40,
                    height: 40,
                  ),
                  SizedBox(width: 16.0),
                  Text(
                    '1234-5678-9012', // Nomor rekening
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Nomor E-Wallet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/ShopeePay.png', // Gambar untuk e-wallet
                    width: 40,
                    height: 40,
                  ),
                  SizedBox(width: 16.0),
                  Text(
                    '+62 1234 5678', // Nomor e-wallet
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
