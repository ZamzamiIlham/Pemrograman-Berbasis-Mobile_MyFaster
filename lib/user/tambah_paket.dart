import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddPaket extends StatefulWidget {
  const AddPaket({Key? key}) : super(key: key);

  @override
  State<AddPaket> createState() => _AddPaketState();
}

class _AddPaketState extends State<AddPaket> {
  TextEditingController _controllerLocationUser = TextEditingController();
  TextEditingController _controllerLocationReceiver = TextEditingController();
  TextEditingController _controllerQuantity = TextEditingController();

  GlobalKey<FormState> key = GlobalKey();

  CollectionReference _reference =
      FirebaseFirestore.instance.collection('paket');

  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kirim Paket'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: key,
          child: Column(
            children: [
              IconButton(
                  onPressed: () async {
                    /*Step 1: Pick image*/
                    ImagePicker imagePicker = ImagePicker();
                    XFile? file =
                        await imagePicker.pickImage(source: ImageSource.camera);
                    print('${file?.path}');

                    if (file == null) return;

                    /*Step 2: Upload to Firebase storage*/
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
                controller: _controllerLocationUser,
                decoration: InputDecoration(hintText: 'Lokasi Anda'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Lokasi anda';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: _controllerLocationReceiver,
                decoration: InputDecoration(hintText: 'Lokasi tujuan'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Lokasi tujuan';
                  }

                  return null;
                },
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
              ElevatedButton(
                  onPressed: () async {
                    if (imageUrl.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please upload an image')));
                      return;
                    }

                    if (key.currentState!.validate()) {
                      String locationUser = _controllerLocationUser.text;
                      String locationReceiver =
                          _controllerLocationReceiver.text;
                      String itemQuantity = _controllerQuantity.text;
                      //konvert ke int
                      int parsedQuantity = int.tryParse(itemQuantity) ?? 0;

                      Map<String, dynamic> dataToSend = {
                        'user': locationUser,
                        'receiver': locationReceiver,
                        'quantity': itemQuantity,
                        'image': imageUrl,
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
