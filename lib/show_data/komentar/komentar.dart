import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class KomentarWidget extends StatefulWidget {
  String idMenu;
  String idKategori;
  String namaUser;

  KomentarWidget(
      {required this.idKategori, required this.idMenu, required this.namaUser});

  @override
  _KomentarWidgetState createState() => _KomentarWidgetState();
}

class _KomentarWidgetState extends State<KomentarWidget> {
  TextEditingController _komentar = new TextEditingController();
  StreamController<List> _streamController = StreamController();
  late Timer _timer;

  Future _ambilDataKomentar() async {
    var response = await http.post(
        Uri.parse(
            "https://apipariwisata.adriel-creation.tech/showlikecoment.php?page=Select Komen"),
        body: {
          'id_menu': widget.idMenu,
          'id_kategori': widget.idKategori,
        });
    var dataKomentar = jsonDecode(response.body);
    List emptydata = [];

    if (dataKomentar[0] == "Data Kosong") {
      _streamController.add(emptydata);
    } else {
      _streamController.add(dataKomentar);
    }
  }

  Future _sendDataKomentar() async {
    var response = await http.post(
        Uri.parse(
            "https://apipariwisata.adriel-creation.tech/showlikecoment.php?page=Masuk Komen"),
        body: {
          'id_menu': widget.idMenu,
          'id_kategori': widget.idKategori,
          'nama_user': widget.namaUser,
          'value_komentar': _komentar.text,
        });

    if (response.body == "New record created successfully") {
      _komentar.text = "";
    } else {
      print("Komentar Gagal");
    }
  }

  @override
  void initState() {
    _ambilDataKomentar();
    _timer =
        Timer.periodic(Duration(seconds: 1), (timer) => _ambilDataKomentar());
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.white,
        title: Text(
          'Komentar',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: StreamBuilder<List>(
            stream: _streamController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.count(
                  childAspectRatio: 8.5 / 2,
                  crossAxisCount: 1,
                  children: snapshot.data!.map((data) {
                    return Container(
                      margin: EdgeInsets.only(
                        bottom: 10.0,
                      ),
                      padding: EdgeInsets.only(
                        top: 13.0,
                        left: 10.0,
                        right: 10.0,
                      ),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25.0),
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              blurRadius: 8,
                              offset: Offset(0, 15),
                              color: Colors.black38.withOpacity(.4),
                              spreadRadius: -9),
                        ],
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(100.0),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                    'https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: 259.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['nama_user'],
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(data['komentar_value']),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              } else {
                return LinearProgressIndicator();
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 65.0,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(100.0),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: 230.0,
                  height: 50.0,
                  child: TextField(
                    controller: _komentar,
                    decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.grey)),
                        filled: true,
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 11, top: 11, right: 15),
                        hintText: "Ketik komentar anda disini..."),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _sendDataKomentar();
                  },
                  child: Container(
                    height: 50.0,
                    child: Icon(
                      Icons.send,
                      size: 35,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
