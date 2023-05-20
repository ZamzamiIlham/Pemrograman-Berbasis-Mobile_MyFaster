import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:myfaster/theme/theme.dart';
import 'package:myfaster/map/map.dart';
import 'package:myfaster/user/tambah_paket.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  Key _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //SizeConfig().init(context); //Panggil sizeconfig dari theme.dart
    return Material(
      child: SafeArea(
        child: ListView(
          children: [
            ClipPath(
              clipper: OvalBottomBorderClipper(),
              child: Container(
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: PaddingHorizonal),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset(
                            'nav_icon.svg',
                            width: 18,
                          ),
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.red,
                            backgroundImage: NetworkImage(
                              'https://cdn3d.iconscout.com/3d/premium/thumb/boy-avatar-6299533-5187865.png',
                            ),
                          ),
                        ],
                      ),
                      // ----------------- LOKASI ------------------- //
                      SizedBox(height: 30.0),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          decoration: ThemeHelper().textInputDecoration(
                            "Lokasi",
                            "Input Lokasi",
                            Container(
                              width: 18,
                              height: 18,
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                'location_icon.svg',
                                color: Color.fromARGB(255, 37, 37, 37),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
            // ----------------- DISKON ------------------- //
            const SizedBox(height: 19),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: PaddingHorizonal),
              child: SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      right: 0,
                      bottom: 0,
                      child: Image.asset(
                        'assets/images/header_image.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      //left: SizeConfig.blockSizeHorizontal! * 50,
                      top: 0,
                      bottom: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'PROMO PENGGUNA BARU',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Diskon 20%',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //------------------------- FITUR ----------------//
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: PaddingHorizonal),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/sub_logo.png',
                      ),
                      const SizedBox(width: 5.0),
                      Text(
                        'Layanan My Faster',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //--------BOX LOKASI----------------//
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyLocationScreen()),
                            );
                            /*setState(() {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ThemeHelper().alartDialog("Pakeet",
                                      "Anda mengklik tombol lokasi", context => );
                                },
                              );
                            });*/
                          },
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(13),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/lokasi.png',
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    "Lokasi",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )
                                ]),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      //--------CEK TARIF----------------//
                      Expanded(
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(13),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/cek_lokasi.png',
                              ),
                              const SizedBox(width: 5.0),
                              Text(
                                "Tarif",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      //--------KIRIM PAKET----------------//
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddPaket()),
                            );
                          },
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(13),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            padding: EdgeInsets.all(5.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/kirim.png',
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    "Kirim",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )
                                ]),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //-----------HEADER-------------------
}
