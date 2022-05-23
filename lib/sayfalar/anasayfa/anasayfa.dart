import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kelime_ezber/constants.dart';
import 'package:kelime_ezber/models/mysql.dart';
import 'package:kelime_ezber/sayfalar/Skor/skorSayfasi.dart';
import 'package:kelime_ezber/sayfalar/secmeli/secmeli.dart';

class anaSayfa extends StatefulWidget {
  var kullaniciAdi;
  var kullaniciId;
  var seviye5TestUyari;
  anaSayfa(this.kullaniciAdi, this.kullaniciId, this.seviye5TestUyari);
  @override
  State<anaSayfa> createState() => _anaSayfaState();
}

class _anaSayfaState extends State<anaSayfa> {
  var db = Mysql();
  var kullaniciAdi;

  bool seviyeDurum1 = false;
  bool seviyeDurum2 = false;
  bool seviyeDurum3 = false;
  bool seviyeDurum4 = false;
  bool seviyeDurum5 = false;

  var seviyeRenk1 = Colors.blue;
  var seviyeRenk2 = Colors.blue;
  var seviyeRenk3 = Colors.blue;
  var seviyeRenk4 = Colors.blue;
  var seviyeRenk5 = Colors.blue;

  var sinir = 5000;

  void initState() {
    // TODO: implement initState
    kullaniciAdi = widget.kullaniciAdi;
    super.initState();

    // Do something
    for (var i = 1; i < 7; i++) {
      if (i == 1) {
        sinir = 0;
      } else if (i == 2) {
        sinir = sinir2;
      } else if (i == 3) {
        sinir = sinir3;
      } else if (i == 4) {
        sinir = sinir4;
      } else if (i == 5) {
        sinir = sinir5;
      }
      seviyeKelimeKontrol(i, sinir);
    }
  }

  var seviyeKelime1 = 0;
  var seviyeKelime2 = 0;
  var seviyeKelime3 = 0;
  var seviyeKelime4 = 0;
  var seviyeKelime5 = 0;
  var kaliciHafizaKelime = 0;

  void seviyeKelimeKontrol(int _seviye, int sinir) {
    int kelimeSayisi = 0;
    var _sorgu = "select COUNT(*) from $kullaniciAdi where seviye=$_seviye";

    db.getConnection().then((conn) {
      conn.query(_sorgu).then((results) {
        for (var row in results) {
          //setState(() {
          kelimeSayisi = row[0];

          if (kelimeSayisi < sinir) {
            //Kelime Sayısı Sınırın Altındaysa
            if (_seviye == 1) {
              seviyeRenk1 = Colors.grey;
              seviyeDurum1 = true;
              seviyeKelime1 = kelimeSayisi;
            } else if (_seviye == 2) {
              seviyeRenk2 = Colors.grey;
              seviyeDurum2 = true;
              seviyeKelime2 = kelimeSayisi;
            } else if (_seviye == 3) {
              seviyeRenk3 = Colors.grey;
              seviyeDurum3 = true;
              seviyeKelime3 = kelimeSayisi;
            } else if (_seviye == 4) {
              seviyeRenk4 = Colors.grey;
              seviyeDurum4 = true;
              seviyeKelime4 = kelimeSayisi;
            } else if (_seviye == 5) {
              seviyeRenk5 = Colors.grey;
              seviyeDurum5 = true;
              seviyeKelime5 = kelimeSayisi;
            }

            if (_seviye == 1) {
              seviyeKelime1 = kelimeSayisi;
            } else if (_seviye == 2) {
              seviyeKelime2 = kelimeSayisi;
            } else if (_seviye == 3) {
              seviyeKelime3 = kelimeSayisi;
            } else if (_seviye == 4) {
              seviyeKelime4 = kelimeSayisi;
            } else if (_seviye == 5) {
              seviyeKelime5 = kelimeSayisi;
            } else if (_seviye == 6) {
              kaliciHafizaKelime = kelimeSayisi;
            }
            setState(() {});

            print(
                "kücük Kelime Sayısı:$kelimeSayisi, Seviye: $_seviye, sınır: $sinir");
          } else {
            //Kelime Sayısı Yeterli
            if (_seviye == 1) {
              seviyeRenk1 = Colors.blue;
              seviyeDurum1 = false;
              seviyeKelime1 = kelimeSayisi;
            } else if (_seviye == 2) {
              seviyeRenk2 = Colors.blue;
              seviyeDurum2 = false;
              seviyeKelime2 = kelimeSayisi;
            } else if (_seviye == 3) {
              if (seviyeDurum2 == false) {
                seviyeDurum3 = false;
                seviyeRenk3 = Colors.blue;
              } else {
                seviyeDurum3 = true;
                seviyeRenk3 = Colors.grey;
              }

              seviyeKelime3 = kelimeSayisi;
            } else if (_seviye == 4) {
              if (seviyeDurum3 == true) {
                seviyeDurum4 = true;
                seviyeRenk4 = Colors.grey;
              } else {
                seviyeDurum4 = false;
                seviyeRenk4 = Colors.blue;
              }

              seviyeKelime4 = kelimeSayisi;
            } else if (_seviye == 5) {
              if (seviyeDurum4 == false) {
                seviyeDurum5 = false;
                seviyeRenk5 = Colors.blue;
              } else {
                seviyeDurum5 = true;
                seviyeRenk5 = Colors.grey;
              }
              seviyeKelime5 = kelimeSayisi;
            }

            if (_seviye == 1) {
              seviyeKelime1 = kelimeSayisi;
            } else if (_seviye == 2) {
              seviyeKelime2 = kelimeSayisi;
            } else if (_seviye == 3) {
              seviyeKelime3 = kelimeSayisi;
            } else if (_seviye == 4) {
              seviyeKelime4 = kelimeSayisi;
            } else if (_seviye == 5) {
              seviyeKelime2 = kelimeSayisi;
            } else if (_seviye == 6) {
              kaliciHafizaKelime = kelimeSayisi;
            }
            setState(() {});
            print("sayıldı");
            print(
                "büyük Kelime Sayısı:$kelimeSayisi, Seviye: $_seviye, sınır: $sinir");
          }
          //});

        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(fit: StackFit.expand, children: [
          SvgPicture.asset("assets/icons/bg.svg", fit: BoxFit.fill),
          Center(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 3),
                      child: Icon(
                        Icons.person_pin,
                        color: Colors.amber,
                        size: 25,
                      ),
                    ),
                    Text(
                      "$kullaniciAdi",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Spacer(
                flex: 1,
              ),
              seviyeler(context, "Seviye 1", 1, seviyeDurum1, seviyeRenk1),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "$seviyeKelime1 Kelime",
                  style: TextStyle(color: Colors.amber),
                ),
              ),
              seviyeler(context, "Seviye 2", 2, seviyeDurum2, seviyeRenk2),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "$seviyeKelime2/$sinir2",
                  style: TextStyle(color: Colors.amber),
                ),
              ),
              seviyeler(context, "Seviye 3", 3, seviyeDurum3, seviyeRenk3),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "$seviyeKelime3/$sinir3",
                  style: TextStyle(color: Colors.amber),
                ),
              ),
              seviyeler(context, "Seviye 4", 4, seviyeDurum4, seviyeRenk4),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "$seviyeKelime4/$sinir4",
                  style: TextStyle(color: Colors.amber),
                ),
              ),
              seviyeler(context, "Seviye 5", 5, seviyeDurum5, seviyeRenk5),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "$seviyeKelime5/$sinir5",
                  style: TextStyle(color: Colors.amber),
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: seviyeRenk1, minimumSize: Size(200, 40)),
                  child: Text("Kalıcı Hafıza"),
                  onPressed: () {
                    ;
                  }),
              Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: Text(
                  "$kaliciHafizaKelime",
                  style: TextStyle(color: Colors.amber),
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: seviyeRenk1, minimumSize: Size(200, 40)),
                  child: Text("Skor Tablosu"),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => skorSayfasi()));
                  }),
              Spacer(
                flex: 1,
              ),
            ],
          ))
        ]),
      ),
    );
  }

  AbsorbPointer seviyeler(BuildContext context, String yazi, int seviye,
      bool durum, var seviyeRenk) {
    return AbsorbPointer(
      absorbing: durum,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: seviyeRenk, minimumSize: Size(200, 47)),
          child: Text(yazi),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => secmeli(widget.kullaniciAdi,
                        widget.kullaniciId, seviye, widget.seviye5TestUyari)));
          }),
    );
  }
}
