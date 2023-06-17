import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myfaster/data/provider.dart';

class AddPaket extends StatefulWidget {
  const AddPaket({Key? key}) : super(key: key);

  @override
  State<AddPaket> createState() => _AddPaketState();
}

class _AddPaketState extends State<AddPaket> {
  TextEditingController _controllerSenderName = TextEditingController();
  TextEditingController _controllerReceiverName = TextEditingController();
  TextEditingController _controllerItemName = TextEditingController();
  TextEditingController _controllerLocationUser = TextEditingController();
  TextEditingController _controllerLocationReceiver = TextEditingController();
  TextEditingController _controllerQuantity = TextEditingController();
  double _totalPrice = 0.0;

  GlobalKey<FormState> key = GlobalKey();

  CollectionReference _reference =
      FirebaseFirestore.instance.collection('paket');

  String imageUrl = '';

  String _selectedPaymentMethod = 'Cash';

  //lokasi dari provider
  LocationData? _locationData;
  @override
  void initState() {
    super.initState();
    _getLocationData();
  }

  Future<void> _getLocationData() async {
    await LocationService().restoreLocationData();
    double totalPrice = await LocationService().getTotalPrice();
    setState(() {
      _locationData = LocationService().locationData;
      _controllerLocationUser.text = _locationData?.currentAddress ?? '';
      _controllerLocationReceiver.text =
          _locationData?.destinationAddress ?? '';
      _totalPrice = double.parse(totalPrice.toStringAsFixed(2));
      _locationData?.setDistance(
          double.parse(_locationData!.distanceInMeters.toStringAsFixed(2)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kirim Paket'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: key,
          child: Column(
            children: [
              IconButton(
                  onPressed: () async {
                    /*Upload Image*/
                    ImagePicker imagePicker = ImagePicker();
                    XFile? file =
                        await imagePicker.pickImage(source: ImageSource.camera);
                    print('${file?.path}');

                    if (file == null) return;

                    /*Up Firebase*/
                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceDirImages =
                        referenceRoot.child('images');
                    String uniqueFileName =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    Reference referenceImageToUpload =
                        referenceDirImages.child(uniqueFileName);

                    try {
                      await referenceImageToUpload.putFile(File(file.path));
                      imageUrl = await referenceImageToUpload.getDownloadURL();
                    } catch (error) {
                      print(error);
                    }
                  },
                  icon: Icon(Icons.camera_alt)),
              TextFormField(
                controller: _controllerSenderName,
                decoration: InputDecoration(labelText: 'Nama pengirim'),
              ),
              TextFormField(
                controller: _controllerReceiverName,
                decoration: InputDecoration(labelText: 'Nama penerima'),
              ),
              TextFormField(
                controller: _controllerItemName,
                decoration: InputDecoration(labelText: 'Nama barang'),
              ),
              TextFormField(
                controller: _controllerQuantity,
                decoration: InputDecoration(hintText: 'Berat barang'),
                keyboardType: TextInputType.number,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Berat barang';
                  }
                  int? parsedValue = int.tryParse(value);
                  if (parsedValue == null) {
                    return 'Berat barang harus berupa angka';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller:
                    TextEditingController(text: _totalPrice.toStringAsFixed(2)),
                decoration: InputDecoration(labelText: 'Harga'),
              ),
              TextFormField(
                controller: _controllerLocationUser,
                decoration: InputDecoration(labelText: 'Alamat saat Ini'),
              ),
              TextFormField(
                controller: _controllerLocationReceiver,
                decoration: InputDecoration(labelText: 'Alamat tujuan'),
              ),
              SizedBox(height: 8),
              if (_locationData != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Distance: ${_locationData!.distanceInMeters.toStringAsFixed(2)} meters',
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              DropdownButtonFormField<String>(
                value: _selectedPaymentMethod,
                decoration: InputDecoration(
                  labelText: 'Metode Pembayaran',
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPaymentMethod = newValue!;
                  });
                },
                items: <String>[
                  'Cash',
                  'Credit Card',
                  'Bank Transfer',
                  'E-Wallet'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (imageUrl.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please upload an image')));
                      return;
                    }

                    if (key.currentState!.validate()) {
                      String senderName = _controllerSenderName.text;
                      String receiverName = _controllerReceiverName.text;
                      String itemName = _controllerItemName.text;
                      String locationUser = _controllerLocationUser.text;
                      String locationReceiver =
                          _controllerLocationReceiver.text;
                      String itemQuantity = _controllerQuantity.text;
                      double distance = _locationData!.distanceInMeters;
                      //konvert ke int
                      int parsedQuantity = int.tryParse(itemQuantity) ?? 0;
                      double totalPrice = _totalPrice;

                      Map<String, dynamic> dataToSend = {
                        'nama pengirim': senderName,
                        'nama penerima': receiverName,
                        'nama barang': itemName,
                        'quantity': itemQuantity,
                        'user': locationUser,
                        'receiver': locationReceiver,
                        'distance': distance,
                        'harga': _totalPrice,
                        'image': imageUrl,
                        'metode pembayaran': _selectedPaymentMethod,
                      };

                      _reference.add(dataToSend);
                    }

                    showDialog(
                      context: context,
                      builder: (BuildContext contextt) {
                        return AlertDialog(
                          title: Text("Success"),
                          content: Text('Data berhasil disimpan'),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Ok'))
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Submit'))
            ],
          ),
        ),
      ),
    );
  }
}
