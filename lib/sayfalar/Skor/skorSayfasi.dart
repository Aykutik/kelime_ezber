import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/mysql.dart';

class skorSayfasi extends StatefulWidget {
  @override
  State<skorSayfasi> createState() => _skorSayfasiState();
}

class _skorSayfasiState extends State<skorSayfasi> {
  var db = Mysql();

  var kullanici;

  var dogru;

  var kaliciHafiza;

  List kullanicilar = [];

  List dogrular = [];

  List kaliciHafizalar = [];

  void veriGetir() {
    db.getConnection().then((conn) {
      conn
          .query(
              "SELECT *from kullanıcılar where düzey=1 or düzey=0 ORDER BY kalıcıhafıza DESC, doğru DESC")
          .then((results) {
        for (var row in results) {
          setState(() {
            kullanicilar.add(row[0].toString());
            dogrular.add(row[5].toString());
            kaliciHafizalar.add(row[6].toString());
          });
        }
      });
    });
  }

  void initState() {
    // TODO: implement initState

    // Do something
    veriGetir();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset("assets/icons/bg.svg", fit: BoxFit.fill),
          ListView.builder(
              padding: EdgeInsets.only(top: 50, left: 5, right: 5),
              itemCount: kullanicilar.length,
              itemBuilder: (BuildContext context, int index) {
                var dogru = dogrular[index];
                var kaliciHafiza = kaliciHafizalar[index];
                var kullanici = kullanicilar[index];
                int sayi = index + 1;
                return ListTile(
                  subtitle: Text(
                    textAlign: TextAlign.left,
                    "Doğru: $dogru",
                    style: TextStyle(color: Colors.amber, fontSize: 13),
                  ),
                  leading: Icon(
                    Icons.co_present_outlined,
                    color: Colors.amber,
                    size: 47,
                  ),
                  title: Text("$sayi. $kullanici",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                  trailing: Text(
                    textAlign: TextAlign.end,
                    "Kalıcı Hafıza: $kaliciHafiza",
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                );
              })
        ],
      ),
    );
  }
}
