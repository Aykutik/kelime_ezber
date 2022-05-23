import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kelime_ezber/constants.dart';
import 'package:kelime_ezber/sayfalar/anasayfa/anasayfa.dart';

import '../../models/mysql.dart';
import '../secmeli/secmeli.dart';

class baslangicekrani extends StatefulWidget {
  @override
  State<baslangicekrani> createState() => _baslangicekraniState();
}

class _baslangicekraniState extends State<baslangicekrani> {
  TextEditingController kullaniciAdi = TextEditingController();

  TextEditingController parola = TextEditingController();

  var db = Mysql();

  var sonuckontrol = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset("assets/icons/bg.svg", fit: BoxFit.fill),
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Spacer(
                  flex: 3,
                ),
                Text("KELİME EZBER",
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                Spacer(flex: 1),
                TextField(
                  controller: kullaniciAdi,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Kullanıcı Adı",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
                const Spacer(flex: 1),
                TextField(
                  controller: parola,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Parola",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
                Spacer(flex: 1),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.amber)),
                    child: Text("Giriş",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    onPressed: () {
                      var kul = kullaniciAdi.text;
                      var par = parola.text;
                      var sonuc = 0;

                      db.getConnection().then((conn) {
                        conn.query(
                            "SELECT *from kullanıcılar where kullanıcıadı=? and parola=$par",
                            [kul]).then((results) {
                          for (var row in results) {
                            var kullaniciAdi = row["kullanıcıadı"].toString();
                            var kullaniciId = row["id"].toString();
                            var seviye5TestUyari =
                                row["seviye5uyarı"].toString();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => anaSayfa(kullaniciAdi,
                                        kullaniciId, seviye5TestUyari)));
                          }
                        });
                      });
                    }),
                Spacer(
                  flex: 6,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 23),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        footer,
                        style: TextStyle(color: Colors.amber, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 2),
                  child: Row(
                    children: [
                      Text(
                        surum,
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
