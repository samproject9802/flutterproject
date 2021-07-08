import 'dart:async';
import 'dart:convert';

import 'package:aplikasipariwisata/show_data/komentar/komentar.dart';
import 'package:flutter/material.dart';
import 'package:aplikasipariwisata/color/color.dart' as globals;
import 'package:url_launcher/url_launcher.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:http/http.dart' as http;

class ShowdataWidget extends StatefulWidget {
  String idUser;
  String namaUser;
  String idMenu;
  String idKategori;
  String urlImage;
  String namaMenu;
  String namaKategori;
  String deskripsi;
  String namaLokasi;
  String linkLokasi;

  ShowdataWidget(
      {required this.idUser,
      required this.namaUser,
      required this.idKategori,
      required this.idMenu,
      required this.namaKategori,
      required this.namaMenu,
      required this.urlImage,
      required this.deskripsi,
      required this.namaLokasi,
      required this.linkLokasi});

  @override
  _ShowdataWidgetState createState() => _ShowdataWidgetState();
}

class _ShowdataWidgetState extends State<ShowdataWidget> {
  bool isLike = false;
  final PanelController _pc = new PanelController();
  late Timer _timer;

  Future _selectLike() async {
    var response = await http.post(
        Uri.parse(
            "https://apipariwisata.adriel-creation.tech/showlikecoment.php?page=Select Like"),
        body: {
          'id_user': widget.idUser,
          'id_menu': widget.idMenu,
          'id_kategori': widget.idKategori,
        });
    var dataLike = jsonDecode(response.body);
    var isLikeStatus = dataLike[0]['like_value'];
    if (isLikeStatus == 'true') {
      bool b = isLikeStatus.toLowerCase() == 'true';
      setState(() {
        isLike = b;
      });
    } else {
      setState(() {
        isLike = false;
      });
      print("Data Kosong");
    }
  }

  Future _sendLike(String boolean) async {
    var response = await http.post(
        Uri.parse(
            "https://apipariwisata.adriel-creation.tech/showlikecoment.php?page=Insert Like"),
        body: {
          'id_user': widget.idUser,
          'id_menu': widget.idMenu,
          'id_kategori': widget.idKategori,
          'value_like': boolean,
        });
    print(response.body);
  }

  @override
  void initState() {
    _selectLike();

    _timer = Timer.periodic(Duration(seconds: 5), (timer) => _selectLike());
    super.initState();
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: globals.lowerBackground,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 30.0),
          child: Center(
            child: Text(widget.namaKategori),
          ),
        ),
        backgroundColor: globals.upperBackground,
        elevation: 0,
      ),
      body: SlidingUpPanel(
        isDraggable: true,
        controller: _pc,
        color: Colors.transparent,
        boxShadow: [],
        backdropEnabled: true,
        panel: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
            color: Colors.white,
          ),
          child: KomentarWidget(
            idKategori: widget.idKategori,
            idMenu: widget.idMenu,
            namaUser: widget.namaUser,
          ),
        ),
        collapsed: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
            color: Colors.white,
          ),
          child: Center(
            child: Container(
              width: 30.0,
              height: 8.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
        ),
        minHeight: 23,
        body: Stack(
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: (MediaQuery.of(context).size.height) / 2.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0),
                      ),
                      color: globals.upperBackground,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                        right: 10.0,
                        top: 10.0,
                        bottom: 40.0,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Image.network(
                          'https://apipariwisata.adriel-creation.tech/upload/home/' +
                              widget.urlImage,
                          fit: BoxFit.cover,
                          height: 150.0,
                          width: 150.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: (MediaQuery.of(context).size.height) - 390.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0),
                      ),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 30.0,
                        left: 25.0,
                        right: 25.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          new Text(
                            "Overview",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 33.0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5.0,
                            ),
                            child: (widget.namaMenu != "Kuliner")
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: Icon(
                                          Icons.pin_drop,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Container(
                                        width: 179.0,
                                        padding: EdgeInsets.only(
                                          left: 8.0,
                                          right: 8.0,
                                        ),
                                        child: Text(
                                          widget.namaLokasi,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            fontSize: 13,
                                            height: 1.5,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                      MaterialButton(
                                        color: Colors.blue,
                                        onPressed: () {
                                          launch(widget.linkLokasi);
                                        },
                                        child: new Text("Lihat Maps"),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: 8.0,
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: (MediaQuery.of(context).size.height) - 560,
                            child: SingleChildScrollView(
                              child: Text(
                                widget.deskripsi,
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 273,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        if (isLike == false) {
                          setState(() {
                            _sendLike('true');
                          });
                        } else {
                          setState(() {
                            _sendLike('false');
                          });
                        }
                      },
                      child: Container(
                        width: 65.0,
                        height: 65.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.thumb_up_sharp,
                                  size: 30,
                                  color: isLike ? Colors.red : Colors.black,
                                ),
                                Text(
                                  "Suka",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        _pc.open();
                      },
                      child: Container(
                        width: 65.0,
                        height: 65.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.message,
                                  size: 30,
                                ),
                                Text(
                                  "Komentar",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
