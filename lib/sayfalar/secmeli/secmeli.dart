import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kelime_ezber/models/mysql.dart';
import 'package:kelime_ezber/constants.dart';

class secmeli extends StatefulWidget {
  var kullaniciAdi;
  var kullaniciId;
  var seviye;
  var seviye5TestUyari;

  secmeli(
      this.kullaniciAdi, this.kullaniciId, this.seviye, this.seviye5TestUyari);
  @override
  State<secmeli> createState() => _secmeliState();
}

class _secmeliState extends State<secmeli> {
  var db = Mysql();
  var kullaniciAdi;
  var kullaniciId;
  var seviye5TestUyari;
  var seviye;
  var ustseviye;
  var altseviye;

  var ceviri = "";
  var kelime = "";
  var kelime_id;
  var tur = "";
  var alan = "";
  var favori = "";
  var dogru = "";
  var yanlis = "";
  var oku = "";
  var es = "";
  var pas = "";

  var kelime_id_onceki;
  var kelime_onceki = "";
  var ceviri_onceki = "";
  var tur_onceki = "";
  var alan_onceki = "";
  var favori_onceki = "";
  var dogru_onceki = "";
  var yanlis_onceki = "";
  var oku_onceki = "";
  var es_onceki = "";

  var kullaniciDogru = "";

  var sec1 = "";
  var sec2 = "";
  var sec3 = "";
  var seceneklerList = [];
  var kelimeSayisi = "";
  var ustKelimeSayisi = "";

  var arkaplan = Colors.white;
  var arkaplanNormal = Colors.white;
  var sec1SecenekRengi = Colors.blue;
  var sec2SecenekRengi = Colors.blue;
  var sec3SecenekRengi = Colors.blue;
  var rdn = 0;
  var seviye5Durum = true;

  var trEn = 0;
  var sorusayisi = 0;
  var yanlisDogruSayi = 1000;

  void initState() {
    // TODO: implement initState
    kullaniciAdi = widget.kullaniciAdi;
    kullaniciId = widget.kullaniciId;
    seviye5TestUyari = widget.seviye5TestUyari;
    seviye = widget.seviye;
    ustseviye = seviye + 1;

    if (seviye == 1) {
      rdn = rdnSev1;
      hak = 4;
      _hak = 4;
    } else if (seviye == 2) {
      rdn = rdnSev2;
      hak = 3;
      _hak = 3;
    } else if (seviye == 3) {
      rdn = rdnSev3;
      hak = 2;
      _hak = 1;
    } else if (seviye == 4) {
      hak = 1;
      _hak = 1;
    }

    yanlisCevapSifirla();
    _getYeniSoru();
    super.initState();
    // Do something
  }

  void _getYeniSoru() {
    deneme = 0;
    sorusayisi++;
    if (seviye > 2) {
      seviye5Durum = false;
    } else {
      seviye5Durum = true;
    }

    durum = false;
    seceneklerList.clear();

    kelime_id_onceki = kelime_id;
    kelime_onceki = kelime;
    ceviri_onceki = ceviri;
    tur_onceki = tur;
    alan_onceki = alan;
    favori_onceki = favori;
    dogru_onceki = dogru;
    yanlis_onceki = yanlis;
    oku_onceki = oku;
    es_onceki = es;

    if (kelime_onceki == "") {
      geriVisible = false;
    } else {
      geriVisible = true;
    }

    var _sorgu =
        "SELECT *from $kullaniciAdi where seviye=$seviye ORDER BY seviye_tarih ASC, RAND() LIMIT 3";

    if (check_b1 == 1) {
      _sorgu =
          "SELECT *from $kullaniciAdi where seviye=$seviye and kur='b1' ORDER BY seviye_tarih ASC, RAND() LIMIT 3";
    } else if (check_c1 == 1) {
      _sorgu =
          "SELECT *from $kullaniciAdi where seviye=$seviye and kur='c1' ORDER BY seviye_tarih ASC, RAND() LIMIT 3";
    } else if (check_fiil == 1) {
      _sorgu =
          "SELECT *from $kullaniciAdi where seviye=$seviye and t??r='fiil' ORDER BY seviye_tarih ASC, RAND() LIMIT 3";
    } else if (check_isim == 1) {
      _sorgu =
          "SELECT *from $kullaniciAdi where seviye=$seviye and t??r='isim' ORDER BY seviye_tarih ASC, RAND() LIMIT 3";
    } else if (check_sifat == 1) {
      _sorgu =
          "SELECT *from $kullaniciAdi where seviye=$seviye and t??r='s??fat' ORDER BY seviye_tarih ASC, RAND() LIMIT 3";
    } else if (check_isHayati == 1) {
      _sorgu =
          "SELECT *from $kullaniciAdi where seviye=$seviye and alan='i?? hayat??' ORDER BY seviye_tarih ASC, RAND() LIMIT 3";
    } else if (check_yanlis == 1) {
      _sorgu =
          "SELECT *from $kullaniciAdi where seviye=$seviye ORDER BY yanl???? DESC, seviye_tarih ASC, RAND() LIMIT 3";
    } else if (check_a1 == 1) {
      _sorgu =
          "SELECT *from $kullaniciAdi where seviye=$seviye and kur='a1' ORDER BY seviye_tarih ASC, RAND() LIMIT 3";
    } else if (check_yanlis == 1 ||
        yanlisSayac > 2 ||
        sorusayisi == 5 ||
        sorusayisi == 7) {
      _sorgu =
          "SELECT *from $kullaniciAdi where seviye=$seviye ORDER BY yanl????do??ru ASC LIMIT 3";
      yanlisSayac = 0;
      sorusayisi = 0;
    } else {
      _sorgu =
          "SELECT *from $kullaniciAdi where seviye=$seviye ORDER BY RAND() LIMIT 3";
    }
    db.getConnection().then((conn) {
      conn.query(_sorgu).then((results) {
        for (var row in results) {
          setState(() {
            arkaplan = arkaplanNormal;
            seviye5EAL_Test = 0;
            sec1SecenekRengi = Colors.blue;
            sec2SecenekRengi = Colors.blue;
            sec3SecenekRengi = Colors.blue;

            if (trEn == 1 || trEn == 2 || seviye == 5 || dogruSayac > 3) {
              // 3 kez do??ru yap??nca, ????klar olu??mas?? i??in trEn ve seviye 5 de girecek.
              kelime = row["TR"].toString();
              ceviri = row["EN"].toString();
              oku = "TR->EN";
              trEn++; // Bunu ????klar olu??urken de buraya girmesi i??in yap??yoruz.
              yazim_secim_onceki = 1;
            } else {
              trEn = 0;
              kelime = row["EN"].toString();
              ceviri = row["TR"].toString();
              yazim_secim_onceki = 2;
              if (row["oku"].toString() == "null") {
                oku = "";
              } else {
                oku = row["oku"].toString();
              }
            }

            kelime_id = row["id"].toString();
            tur = row["t??r"].toString();
            alan = row["alan"].toString();
            favori = row["favori"].toString();
            dogru = row["do??ru"].toString();
            yanlis = row["yanl????"].toString();
            es = row["e??"].toString();
            pas = row["pas"].toString();
            seceneklerList.add(ceviri);
          });
        }
        var random = Random();
        var sayi = random.nextInt(3);
        if (sayi == 0) {
          setState(() {
            sec1 = seceneklerList[0];
            sec2 = seceneklerList[1];
            sec3 = seceneklerList[2];
          });
        } else if (sayi == 1) {
          setState(() {
            sec1 = seceneklerList[2];
            sec2 = seceneklerList[0];
            sec3 = seceneklerList[1];
          });
        } else if (sayi == 2) {
          setState(() {
            sec1 = seceneklerList[1];
            sec2 = seceneklerList[2];
            sec3 = seceneklerList[0];
          });
        }
      });
      conn
          .query("SELECT *from kullan??c??lar where id=$kullaniciId")
          .then((results) {
        for (var row in results) {
          setState(() {
            kullaniciDogru = row["do??ru"].toString();
          });
          print("Do??ru:$kullaniciDogru");
        }
      });
      conn
          .query("select COUNT(*) from $kullaniciAdi where seviye=$seviye")
          .then((results) {
        for (var row in results) {
          setState(() {
            kelimeSayisi = row[0].toString();
          });
          print("Mevcut seviye say??ld??: $kelimeSayisi");
        }
      });
      conn
          .query("select COUNT(*) from $kullaniciAdi where seviye=$ustseviye")
          .then((results) {
        for (var row in results) {
          setState(() {
            ustKelimeSayisi = row[0].toString();
          });
          print("??st seviye say??ld??: $ustKelimeSayisi");
        }
      });
    });
  }

  var trSayac = 0;

  void yanlisCevapSifirla() {
    db.getConnection().then((conn) {
      conn.query('update $kullaniciAdi set yanl????do??ru=1000');
    });
  }

  void tekDogruCevapSQl() {
    dogruSayac++;
    var _seviye = ustseviye + 1;
    var kelimeDogrusu = (int.parse(dogru) + 1);
    var bugun = DateTime.now();
    db.getConnection().then((conn) {
      conn.query('update kullan??c??lar set do??ru=? where id=$kullaniciId',
          [int.parse(kullaniciDogru) + 1]);
      conn.query(
          'update $kullaniciAdi set seviye=$_seviye, do??ru="$kelimeDogrusu", yanl????do??ru=1000, seviye_tarih="$bugun" where id=$kelime_id');
    });
  }

  void dogruCevapSQL() {
    dogruSayac++;
    var kelimeDogrusu = (int.parse(dogru) + 1);
    var bugun = DateTime.now();
    db.getConnection().then((conn) {
      conn.query('update kullan??c??lar set do??ru=? where id=$kullaniciId',
          [int.parse(kullaniciDogru) + 1]);
      conn.query(
          'update $kullaniciAdi set seviye=$ustseviye, do??ru="$kelimeDogrusu", yanl????do??ru=1000, seviye_tarih="$bugun" where id=$kelime_id');
    });
  }

  void sevive5SQL() {
    var bugun = DateTime.now();
    db.getConnection().then((conn) {
      conn.query('update kullan??c??lar set do??ru=? where id=$kullaniciId',
          [int.parse(kullaniciDogru) + 1]);
      conn.query(
          'update $kullaniciAdi set seviye=5, seviye_tarih="$bugun" where id=$kelime_id');
    });
  }

  void yanlisCevapSQL() {
    yanlisSayac++;
    trSayac = 0;
    dogruSayac = 0;
    var bugun = DateTime.now();
    var kelimeYanlisi = (int.parse(yanlis) + 1);
    if (seviye < 3) {
      db.getConnection().then((conn) {
        conn.query(
            'update $kullaniciAdi set yanl????="$kelimeYanlisi", yanl????do??ru="$yanlisDogruSayi", seviye_tarih="$bugun" where id=$kelime_id');
      });
      print("seviye 3 den k??????k oldu??u i??in seviye d??????r??lmeyecek");
    } else {
      db.getConnection().then((conn) {
        conn.query(
            'update $kullaniciAdi set seviye=2, yanl????="$kelimeYanlisi, yanl????do??ru="$yanlisDogruSayi", seviye_tarih="$bugun" where id=$kelime_id');
      });
      print("seviye 2 den b??y??k oldu??u i??in yanl???? i??lemi yap??lacak");
    }
    yanlisDogruSayi--;
  }

  var dogruSayac = 0;

  void cevapKontrolsec1() {
    DurumDegis();
    yazim_secim_onceki = 2;
    if (sec1 == ceviri) {
      //DO??RU
      print("Cevap Do??ru");
      arkaplan = Colors.green;
      sec1SecenekRengi = Colors.green;
      if (seviye5EAL_Test == 1) {
        sevive5SQL();
      } else {
        dogruCevapSQL();
      }
      yazim_secim_onceki = 2;
      setState(() {});
      Timer(const Duration(seconds: 1), () {
        _getYeniSoru();
      });
    } else {
      //YANLI??
      print("cevap yanl????");
      sec1SecenekRengi = Colors.red;
      arkaplan = Colors.orange;

      if (sec2 == ceviri) {
        sec2SecenekRengi = Colors.orange;
      } else if (sec3 == ceviri) {
        sec3SecenekRengi = Colors.orange;
      }
      yazim_secim_onceki = 2;
      setState(() {});
      yanlisCevapSQL();
      Timer(const Duration(seconds: 2), () {
        _getYeniSoru();
      });
    }
  }

  void cevapKontrolsec2() {
    DurumDegis();
    yazim_secim_onceki = 2;
    if (sec2 == ceviri) {
      //DO??RU
      print("Cevap Do??ru");
      sec2SecenekRengi = Colors.green;
      arkaplan = Colors.green;
      yazim_secim_onceki = 2;
      setState(() {});
      if (seviye5EAL_Test == 1) {
        sevive5SQL();
      } else {
        dogruCevapSQL();
      }
      Timer(const Duration(seconds: 1), () {
        _getYeniSoru();
      });
    } else {
      //YANLI??
      print("cevap yanl????");
      sec2SecenekRengi = Colors.red;
      arkaplan = Colors.orange;
      if (sec1 == ceviri) {
        sec1SecenekRengi = Colors.orange;
      } else if (sec3 == ceviri) {
        sec3SecenekRengi = Colors.orange;
      }
      yazim_secim_onceki = 2;
      setState(() {});
      yanlisCevapSQL();
      Timer(const Duration(seconds: 2), () {
        _getYeniSoru();
      });
    }
  }

  void cevapKontrolsec3() {
    yazim_secim_onceki = 2;
    DurumDegis();
    if (sec3 == ceviri) {
      //DO??RU
      print("Cevap Do??ru");
      sec3SecenekRengi = Colors.green;
      arkaplan = Colors.green;
      yazim_secim_onceki = 2;
      setState(() {});
      if (seviye5EAL_Test == 1) {
        sevive5SQL();
      } else {
        dogruCevapSQL();
      }
      Timer(const Duration(seconds: 1), () {
        _getYeniSoru();
      });
    } else {
      //YANLI??
      sec3SecenekRengi = Colors.red;
      arkaplan = Colors.orange;
      if (sec2 == ceviri) {
        sec2SecenekRengi = Colors.orange;
      } else if (sec1 == ceviri) {
        sec1SecenekRengi = Colors.orange;
      }
      yazim_secim_onceki = 2;
      setState(() {});
      yanlisCevapSQL();
      print("cevap yanl????2222");
      Timer(const Duration(seconds: 2), () {
        _getYeniSoru();
      });
    }
  }

  @override // TASARIM
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(fit: StackFit.expand, children: [
          SvgPicture.asset("assets/icons/bg.svg", fit: BoxFit.fill),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 13, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [SeviyeKelimeSayisi()],
                  ),
                ),
                kelimeKarti(),
                Column(
                  children: [
                    Padding(
                      padding: butonlarRowPadding,
                      child: Row(
                        children: [
                          Padding(
                              padding: butonlarPadding,
                              child: Visibility(
                                visible: seviye5Durum,
                                child: seviye5TestButton(context),
                              )),
                          Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: sorunBildirButton(context)),
                          Visibility(
                            visible: geriVisible,
                            child: Padding(
                              // GER??
                              padding: EdgeInsets.only(left: 165),
                              child: oncekiKelimeButton(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      //KATEGOR??LER
                      visible: kategorilerVisible,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 12, bottom: 5),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: (check_a1_renk)),
                                    onPressed: () {
                                      if (check_a1 == 0) {
                                        check_a1 = 1;
                                        check_a1_renk = Colors.amber;
                                        check_b1_renk = Colors.blue;
                                        check_c1_renk = Colors.blue;
                                        check_fiil_renk = Colors.blue;
                                        check_isim_renk = Colors.blue;
                                        check_sifat_renk = Colors.blue;
                                        check_isHayati_renk = Colors.blue;
                                        check_yanlis_renk = Colors.blue;
                                        check_b1 = 0;
                                        check_c1 = 0;
                                        check_fiil = 0;
                                        check_isim = 0;
                                        check_sifat = 0;
                                        check_isHayati = 0;
                                        check_yanlis = 0;
                                        setState(() {});
                                        _getYeniSoru();
                                      } else {
                                        check_a1 = 0;
                                        check_a1_renk = Colors.blue;
                                        setState(() {});
                                        _getYeniSoru();
                                      }
                                    },
                                    child: Text("A1")),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 12, bottom: 5),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: (check_b1_renk)),
                                    onPressed: () {
                                      if (check_b1 == 0) {
                                        check_b1 = 1;
                                        check_b1_renk = Colors.amber;
                                        check_a1_renk = Colors.blue;
                                        check_c1_renk = Colors.blue;
                                        check_fiil_renk = Colors.blue;
                                        check_isim_renk = Colors.blue;
                                        check_sifat_renk = Colors.blue;
                                        check_isHayati_renk = Colors.blue;
                                        check_yanlis_renk = Colors.blue;
                                        check_a1 = 0;
                                        check_c1 = 0;
                                        check_fiil = 0;
                                        check_isim = 0;
                                        check_sifat = 0;
                                        check_isHayati = 0;
                                        check_yanlis = 0;
                                        setState(() {});
                                        _getYeniSoru();
                                      } else {
                                        check_b1 = 0;
                                        check_b1_renk = Colors.blue;
                                        setState(() {});
                                        _getYeniSoru();
                                      }
                                    },
                                    child: Text("B1")),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 12, bottom: 5),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: (check_c1_renk)),
                                    onPressed: () {
                                      if (check_c1 == 0) {
                                        check_c1 = 1;
                                        check_c1_renk = Colors.amber;
                                        check_a1_renk = Colors.blue;
                                        check_b1_renk = Colors.blue;
                                        check_fiil_renk = Colors.blue;
                                        check_isim_renk = Colors.blue;
                                        check_sifat_renk = Colors.blue;
                                        check_isHayati_renk = Colors.blue;
                                        check_yanlis_renk = Colors.blue;
                                        check_a1 = 0;
                                        check_b1 = 0;
                                        check_fiil = 0;
                                        check_isim = 0;
                                        check_sifat = 0;
                                        check_isHayati = 0;
                                        check_yanlis = 0;
                                        setState(() {});
                                        _getYeniSoru();
                                      } else {
                                        check_c1 = 0;
                                        check_c1_renk = Colors.blue;
                                        setState(() {});
                                        _getYeniSoru();
                                      }
                                    },
                                    child: Text("C1")),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 12, bottom: 5),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: (check_fiil_renk)),
                                    onPressed: () {
                                      if (check_fiil == 0) {
                                        check_fiil = 1;
                                        check_fiil_renk = Colors.amber;
                                        check_a1_renk = Colors.blue;
                                        check_b1_renk = Colors.blue;
                                        check_c1_renk = Colors.blue;
                                        check_isim_renk = Colors.blue;
                                        check_sifat_renk = Colors.blue;
                                        check_isHayati_renk = Colors.blue;
                                        check_yanlis_renk = Colors.blue;
                                        check_a1 = 0;
                                        check_b1 = 0;
                                        check_c1 = 0;
                                        check_isim = 0;
                                        check_sifat = 0;
                                        check_isHayati = 0;
                                        check_yanlis = 0;
                                        setState(() {});
                                        _getYeniSoru();
                                      } else {
                                        check_fiil = 0;
                                        check_fiil_renk = Colors.blue;
                                        setState(() {});
                                        _getYeniSoru();
                                      }
                                    },
                                    child: Text("F????L")),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 8, bottom: 20),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: (check_isim_renk)),
                                    onPressed: () {
                                      if (check_isim == 0) {
                                        check_isim = 1;
                                        check_isim_renk = Colors.amber;
                                        check_a1_renk = Colors.blue;
                                        check_b1_renk = Colors.blue;
                                        check_c1_renk = Colors.blue;
                                        check_fiil_renk = Colors.blue;
                                        check_sifat_renk = Colors.blue;
                                        check_isHayati_renk = Colors.blue;
                                        check_yanlis_renk = Colors.blue;
                                        check_a1 = 0;
                                        check_b1 = 0;
                                        check_c1 = 0;
                                        check_fiil = 0;
                                        check_sifat = 0;
                                        check_isHayati = 0;
                                        check_yanlis = 0;
                                        setState(() {});
                                        _getYeniSoru();
                                      } else {
                                        check_isim = 0;
                                        check_isim_renk = Colors.blue;
                                        setState(() {});
                                        _getYeniSoru();
                                      }
                                    },
                                    child: Text("??S??M")),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 8, bottom: 20),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: (check_sifat_renk)),
                                    onPressed: () {
                                      if (check_sifat == 0) {
                                        check_sifat = 1;
                                        check_sifat_renk = Colors.amber;
                                        check_a1_renk = Colors.blue;
                                        check_b1_renk = Colors.blue;
                                        check_c1_renk = Colors.blue;
                                        check_fiil_renk = Colors.blue;
                                        check_isim_renk = Colors.blue;
                                        check_isHayati_renk = Colors.blue;
                                        check_yanlis_renk = Colors.blue;
                                        check_a1 = 0;
                                        check_b1 = 0;
                                        check_c1 = 0;
                                        check_fiil = 0;
                                        check_isim = 0;
                                        check_isHayati = 0;
                                        check_yanlis = 0;
                                        setState(() {});
                                        _getYeniSoru();
                                      } else {
                                        check_sifat = 0;
                                        check_sifat_renk = Colors.blue;
                                        setState(() {});
                                        _getYeniSoru();
                                      }
                                    },
                                    child: Text("SIFAT")),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 8, bottom: 20),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: (check_isHayati_renk)),
                                    onPressed: () {
                                      if (check_isHayati == 0) {
                                        check_isHayati = 1;
                                        check_isHayati_renk = Colors.amber;
                                        check_a1_renk = Colors.blue;
                                        check_b1_renk = Colors.blue;
                                        check_c1_renk = Colors.blue;
                                        check_fiil_renk = Colors.blue;
                                        check_isim_renk = Colors.blue;
                                        check_sifat_renk = Colors.blue;
                                        check_yanlis_renk = Colors.blue;

                                        check_a1 = 0;
                                        check_b1 = 0;
                                        check_c1 = 0;
                                        check_fiil = 0;
                                        check_isim = 0;
                                        check_sifat = 0;
                                        check_yanlis = 0;

                                        setState(() {});
                                        _getYeniSoru();
                                      } else {
                                        check_isHayati = 0;
                                        check_isHayati_renk = Colors.blue;
                                        setState(() {});
                                        _getYeniSoru();
                                      }
                                    },
                                    child: Text("???? HAYATI")),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 8, bottom: 20),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: (check_yanlis_renk)),
                                    onPressed: () {
                                      if (check_yanlis == 0) {
                                        check_yanlis = 1;
                                        check_yanlis_renk = Colors.amber;
                                        check_a1_renk = Colors.blue;
                                        check_b1_renk = Colors.blue;
                                        check_c1_renk = Colors.blue;
                                        check_fiil_renk = Colors.blue;
                                        check_isim_renk = Colors.blue;
                                        check_sifat_renk = Colors.blue;
                                        check_isHayati_renk = Colors.blue;

                                        check_a1 = 0;
                                        check_b1 = 0;
                                        check_c1 = 0;
                                        check_fiil = 0;
                                        check_isim = 0;
                                        check_sifat = 0;
                                        check_isHayati = 0;

                                        setState(() {});
                                        _getYeniSoru();
                                      } else {
                                        check_yanlis = 0;
                                        check_yanlis_renk = Colors.blue;
                                        setState(() {});
                                        _getYeniSoru();
                                      }
                                    },
                                    child: Text("YANL??S")),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    secenekler(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(children: [
                            Column(
                              children: [ustSeviyeKelimeSayisi()],
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  IconButton oncekiKelimeButton() {
    return IconButton(
      onPressed: () {
        if (kelime_onceki != "") {
          kelime = kelime_onceki;
          kelime_id = kelime_id_onceki;
          ceviri = ceviri_onceki;
          tur = tur_onceki;
          alan = alan_onceki;
          favori = favori_onceki;
          dogru = dogru_onceki;
          yanlis = yanlis_onceki;
          oku = oku_onceki;
          es = es_onceki;
          yazim_secim_onceki = 3;
          kategorilerVisible = false;
          seviye5Durum = false;
          geriVisible = false;
          setState(() {});
        }
      },
      icon: const Icon(Icons.arrow_circle_left_outlined),
      color: Colors.amber,
    );
  }

  IconButton sorunBildirButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("SORUN B??LD??R"),
            content: TextFormField(
                decoration: InputDecoration(
                    labelText: "K??saca a????klay??n??z.",
                    icon: Icon(Icons.textsms_outlined)),
                controller: sorunBildirYazi),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    if (sorunBildirYazi.text.isNotEmpty) {
                      sorunBildir();
                      sorunBildirYazi.clear();
                      Navigator.of(ctx).pop();
                    } else {
                      sorunBildirYazi.text = "Bo?? Olamaz!";
                    }
                  },
                  child: Text("G??nder")),
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text("??ptal"),
              )
            ],
          ),
        );
      },
      icon: const Icon(Icons.announcement_outlined),
      color: Colors.amber,
    );
  }

  IconButton seviye5TestButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (seviye5TestUyari == "1") {
          seviye5EAL_Test = 1;
          seviye5TestGorsel();
          yazim_secim_onceki = 1;
          setState(() {});
        } else {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text("$kelime"),
              content: Text(
                  "??ayet do??ru cevaplarsan $kelime kelimesi 5.seviye'ye g??nderilecek.\n\nOnayl??yor musun?"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      seviye5EAL_Test = 1;
                      seviye5TestUyari = "1";
                      seviye5TestGorsel();
                      seviye5TestSql();
                      yazim_secim_onceki = 1;
                      setState(() {});
                      Navigator.of(ctx).pop();
                    },
                    child: Text("G??nder")),
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text("??ptal"),
                )
              ],
            ),
          );
        }
      },
      icon: const Icon(Icons.add_task_rounded),
      color: Colors.amber,
    );
  }

  var geriVisible = true;
  var kategorilerVisible = true;

  var yanlisSayac = 0;

  var check_a1 = 0;
  var check_a1_renk = Colors.blue;
  var check_b1 = 0;
  var check_b1_renk = Colors.blue;
  var check_c1 = 0;
  var check_c1_renk = Colors.blue;

  //T??R
  var check_fiil = 0;
  var check_fiil_renk = Colors.blue;
  var check_isim = 0;
  var check_isim_renk = Colors.blue;
  var check_sifat = 0;
  var check_sifat_renk = Colors.blue;

  //ALAN
  var check_isHayati = 0;
  var check_isHayati_renk = Colors.blue;

  var check_yanlis = 0;
  var check_yanlis_renk = Colors.blue;

  ElevatedButton kategoriler(String yazi) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(primary: (check_renk)),
        onPressed: () {
          if (yazi == "A1") {
            if (check_a1 == 0) {
              check_a1 = 1;
              check_renk = Colors.amber;
              setState(() {});
              _getYeniSoru();
            } else {
              check_a1 = 0;
              check_renk = Colors.blue;
              setState(() {});
              _getYeniSoru();
            }
          } else if (yazi == "B1") {
            if (check_b1 == 0) {
              check_b1 = 1;
              check_b1_renk = Colors.amber;
              setState(() {});
              _getYeniSoru();
            } else {
              check_b1 = 0;
              check_b1_renk = Colors.blue;
              setState(() {});
              _getYeniSoru();
            }
          } else if (yazi == "C1") {
            if (check_c1 == 0) {
              check_c1 = 1;
              check_c1_renk = Colors.amber;
              setState(() {});
              _getYeniSoru();
            } else {
              check_c1 = 0;
              check_c1_renk = Colors.blue;
              setState(() {});
              _getYeniSoru();
            }
          } else if (yazi == "F????L") {
            if (check_fiil == 0) {
              check_fiil = 1;
              check_fiil_renk = Colors.amber;
              setState(() {});
              _getYeniSoru();
            } else {
              check_fiil = 0;
              check_fiil_renk = Colors.blue;
              setState(() {});
              _getYeniSoru();
            }
          } else if (yazi == "??S??M") {
            if (check_isim == 0) {
              check_isim = 1;
              check_isim_renk = Colors.amber;
              setState(() {});
              _getYeniSoru();
            } else {
              check_isim = 0;
              check_isim_renk = Colors.blue;
              setState(() {});
              _getYeniSoru();
            }
          } else if (yazi == "SIFAT") {
            if (check_sifat == 0) {
              check_sifat = 1;
              check_sifat_renk = Colors.amber;
              setState(() {});
              _getYeniSoru();
            } else {
              check_sifat = 0;
              check_sifat_renk = Colors.blue;
              setState(() {});
              _getYeniSoru();
            }
          } else if (yazi == "???? HAYATI") {
            if (check_isHayati == 0) {
              check_isHayati = 1;
              check_isHayati_renk = Colors.amber;
              setState(() {});
              _getYeniSoru();
            } else {
              check_isHayati = 0;
              check_isHayati_renk = Colors.blue;
              setState(() {});
              _getYeniSoru();
            }
          } else if (yazi == "YANLI??") {
            if (check_yanlis == 0) {
              check_yanlis = 1;
              check_yanlis_renk = Colors.amber;
              setState(() {});
              _getYeniSoru();
            } else {
              check_yanlis = 0;
              check_yanlis_renk = Colors.blue;
              setState(() {});
              _getYeniSoru();
            }
          }
        },
        child: Text(yazi));
  }

  var check_renk = Colors.blue;

  void sorunBildir() {
    var bugun = DateTime.now();
    var metin = sorunBildirYazi.text;
    db.getConnection().then((conn) {
      conn.query(
          'Insert into sorun (sorunyaz??,kelime,kelimeid,cevap,kullan??c??,kullan??c??id,tarih) values ("$metin","$kelime","$kelime_id","$ceviri","$kullaniciAdi","$kullaniciId","$bugun")');
    });
  }

  Text SeviyeKelimeSayisi() {
    int _sinir = 0;
    if (seviye == 1) {
    } else if (seviye == 2) {
      _sinir = sinir2;
    } else if (seviye == 3) {
      _sinir = sinir3;
    } else if (seviye == 4) {
      _sinir = sinir4;
    } else if (seviye == 5) {
      _sinir = sinir5;
    }
    if (seviye == 1) {
      return Text("Seviye $seviye:   $kelimeSayisi  Kelime",
          style: const TextStyle(
              color: Colors.amber, fontSize: 25, fontWeight: FontWeight.bold));
    }
    return Text("Seviye $seviye:   $kelimeSayisi / $_sinir",
        style: const TextStyle(
            color: Colors.amber, fontSize: 25, fontWeight: FontWeight.bold));
  }

  Text ustSeviyeKelimeSayisi() {
    int _sinir = 0;
    if (seviye == 1) {
      _sinir = sinir2;
    } else if (seviye == 2) {
      _sinir = sinir3;
    } else if (seviye == 3) {
      _sinir = sinir4;
    } else if (seviye == 4) {
      _sinir = sinir5;
    } else if (seviye == 5) {
      _sinir = 0;
    }
    return Text("Seviye $ustseviye:   $ustKelimeSayisi / $_sinir",
        style: const TextStyle(color: Colors.amber, fontSize: 20));
  }

  void DurumDegis() {
    durum = true;
  }

  var durum = false;
  var dogruCeviri = "";
  var dogruCeviriDurum = false;
  var yazim_secim_onceki = 0;

  TextEditingController yaziCevap = TextEditingController();
  TextEditingController sorunBildirYazi = TextEditingController();

  Widget secenekler() {
    // int rdnSayi = Random().nextInt(rdn);
    if (yazim_secim_onceki == 1) {
      print("yazmal??");
      trEn = 0;
      return Center(
          child: Column(children: [
        Container(
          width: 320,
          child: TextField(
              controller: yaziCevap,
              autofocus: true,
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Cevab?? yaz??n??z",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ))),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 0),
          child: Text(dogruCeviri,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                  fontSize: 17)),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: ElevatedButton(
            child: Text("OK"),
            onPressed: (yazmaKontrol),
          ),
        )
      ]));
    } else if (yazim_secim_onceki == 3) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "??eviri: $ceviri_onceki",
                style: TextStyle(fontSize: 20, color: Colors.amber),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        yazim_secim_onceki = 2;
                        setState(() {
                          kategorilerVisible = true;
                          _getYeniSoru();
                        });
                      },
                      child: Text("Devam >")),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      dogruCeviri = "";
      print("se??meli");
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            Padding(
              padding: seceneklerPadding,
              child: AbsorbPointer(
                absorbing: durum,
                child: ElevatedButton(
                  onPressed: (cevapKontrolsec1),
                  child: Text(sec1, style: SecenekYazi),
                  style: ElevatedButton.styleFrom(
                    fixedSize: secenekSize,
                    primary: sec1SecenekRengi,
                  ),
                ),
              ),
            ),
            Padding(
              padding: seceneklerPadding,
              child: AbsorbPointer(
                absorbing: durum,
                child: ElevatedButton(
                    onPressed: (cevapKontrolsec2),
                    child: Text(sec2, style: SecenekYazi),
                    style: ElevatedButton.styleFrom(
                      fixedSize: secenekSize,
                      primary: sec2SecenekRengi,
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: AbsorbPointer(
                absorbing: durum,
                child: ElevatedButton(
                    onPressed: (cevapKontrolsec3),
                    child: Text(sec3, style: SecenekYazi),
                    style: ElevatedButton.styleFrom(
                      primary: sec3SecenekRengi,
                      fixedSize: secenekSize,
                    )),
              ),
            ),
          ],
        ),
      );
    }
  }

  var hak;
  var _hak;
  var seviye5EAL_Test = 0;
  var tiklama = 0;
  var deneme = 0;
  String ipucu = "";

  void yazmaKontrol() {
    if (yaziCevap.text != "") {
      var metin = ceviri.trim().toLowerCase().replaceAll(" ", "");
      int virgul = metin.indexOf(",");
      var anlam1 = "";
      var anlam2 = "";
      var anlam3 = "";
      int parantez = -1;
      print("Metin: $metin");
      print(virgul);

      //Ar??nd??rma ????lemleri
      if (virgul < 0) {
        //Tek anlam?? var, Virg??l Yok
        parantez = metin.indexOf("(");
        print("Parantez: $parantez");
        if (parantez >= 0) {
          //Parantez Var
          final arindirilmis = metin.toString().split('(');
          anlam1 = arindirilmis[0];
          print("ilk kelime: $anlam1");
        } else {
          anlam1 = metin;
        }
      } else {
        //V??RG??L VAR
        //??nce virg??lleri ay??ral??m
        final arindirilmis = metin.toString().split(',');
        anlam1 = arindirilmis[0];
        anlam2 = arindirilmis[1];
        print("??lk kelime: $anlam1");
        print("??kinci kelime: $anlam2");
        if (arindirilmis.length == 3) {
          anlam3 = arindirilmis[2];
          print("??c??nc?? kelime: $anlam3");
        }
        //??imdi Parantez var ise onlar?? temizleyelim
        //??lk kelimeden ba??l??yoruz
        parantez = anlam1.indexOf("(");
        if (parantez > 0) {
          //ilk kelimede parantez var
          final arindirilmis = anlam1.toString().split('(');
          anlam1 = arindirilmis[0];
          print(" ");
          print("Ar??nd??r??lm???? ilk kelime: $anlam1");
        }
        //??lk kelimeyi parantezden ar??nd??rd??k
        //??imdi s??ra ikinci kelimede
        parantez = -1;
        parantez = anlam2.indexOf('(');
        if (parantez > 0) {
          //ikinci kelimede parantez var.
          final arindirilmis = anlam2.toString().split('(');
          anlam2 = arindirilmis[0];
          print("Ar??nd??r??lm???? ??kinci kelime: $anlam2");
        }
        //??kinci Kelimeyi kelimeyi parantezden ar??nd??rd??k
        //??imdi s??ra ??c??nc?? kelimede
        parantez = -1;
        parantez = anlam3.indexOf('(');
        if (parantez > 0) {
          //ikinci kelimede parantez var.
          final arindirilmis = anlam3.toString().split('(');
          anlam3 = arindirilmis[0];
          print("Ar??nd??r??lm???? ??kinci kelime: $anlam3");
        }
      }

      print(" ");
      print(" ");
      print("1.Kelime: $anlam1");
      print("2.Kelime: $anlam2");
      print("3.Kelime: $anlam3");

      //Ar??nd??rma i??lemleri bitti ??imdi cevap kontrol ve ipucu i??lemlerini yap??caz.
      var cevap = yaziCevap.text.trim().toLowerCase().replaceAll(" ", "");
      if (cevap == anlam1 || cevap == anlam2 || cevap == anlam3) {
        if (hak < _hak) {
          hak++;
        }
        //DO??RU
        yazimDogruGorsel();
        if (seviye5EAL_Test == 1) {
          sevive5SQL();
        } else {
          if (seviye < 4 && deneme == 0) {
            tekDogruCevapSQl();
          } else {
            dogruCevapSQL();
          }
        }
        setState(() {
          yazim_secim_onceki = 1;
        });
        Timer(const Duration(seconds: 1), () {
          _getYeniSoru();
          yaziCevap.text = "";
          ipucu = "";
        });
      } else {
        //YANLI??

        //??pucu hakk?? var m???
        //ipucu hakk?? var ise ipucu g??stericez, yok ise yanl???? i??lemlerine devam

        if (hak > 0 &&
            (seviye != "5" || seviye != "4") &&
            seviye5EAL_Test != 1) {
          //Ceviriyi Harflerine Ay??raca????z
          hak--;
          List harfler = [];

          print("Kelime: $ceviri");
          print(ceviri.length);
          String harf;

          for (int i = 0; i < ceviri.length; i++) {
            harfler.insert(i, ceviri.substring(i, i + 1));
          }
          print(harfler);

          ipucu = harfler[0];
          var boslukSonrasi = 0;
          var virgulSonrasi = 0;

          for (int i = 0; i < ceviri.length - 1; i++) {
            if (boslukSonrasi == 0) {
              if (virgulSonrasi == 1) {
                ipucu = "" + ipucu + " " + harfler[i + 1] + "";
                virgulSonrasi = 0;
              } else if (harfler[i + 1] == ",") {
                ipucu = "" + ipucu + ",";
                virgulSonrasi = 1;
                boslukSonrasi = 1;
              } else if (i == ceviri.length - 2) {
                ipucu = "" + ipucu + "" + harfler[i + 1] + "";
              } else if (i == 2) {
                ipucu = "" + ipucu + "" + harfler[i + 1] + "";
              } else if (i == 1 && deneme > 0) {
                ipucu = "" + ipucu + "" + harfler[i + 1] + "";
              } else if (i == 3 && deneme > 1 && seviye < 3) {
                ipucu = "" + ipucu + "" + harfler[i + 1] + "";
              } else {
                ipucu = "" + ipucu + "#";
              }
            } else {
              boslukSonrasi = 0;
            }
          }
          yazim_secim_onceki = 1;
          dogruCeviriDurum = true;
          dogruCeviri = "$ipucu $hak / $_hak";
          setState(() {});
          print(ipucu);

          deneme++;
        } else {
          //??pucu Hakk?? Kalmam??i veya,
          //seviye 4 veya 5 veya,
          //Seviye 5 testi var: Yanl???? i??lemleri yap??lacak.
          yazimYanlisGorsel();
          yazim_secim_onceki = 1;
          setState(() {
            dogruCeviri = ceviri;
            dogruCeviriDurum = true;
            yazim_secim_onceki = 1;
            yanlisCevapSQL();
            Timer(const Duration(seconds: 3), () {
              _getYeniSoru();
              yaziCevap.text = "";
              dogruCeviri = "";
              ipucu = "";
            });
          });
        }
      }
    } else {
      if (tiklama == 0) {
        //??LK KEZ TIKLANIYOR ??SE
        yazim_secim_onceki = 1;
        dogruCeviri = "Cevap Bo?? Olamaz!";
        setState(() {});
        tiklama++;
      } else {
        //PAS GE????L??YOR
        pasGec();
        tiklama = 0;
        dogruCeviri = ceviri;
        yazim_secim_onceki = 1;
        dogruSayac = 0;
        setState(() {
          Timer(const Duration(seconds: 1), () {
            yazim_secim_onceki = 2;
            _getYeniSoru();
            yaziCevap.text = "";
            dogruCeviri = "";
            ipucu = "";
          });
        });
      }
    }
    setState(() {});
  }

  void pasGec() {
    var bugun = DateTime.now();
    var kelimePasi = (int.parse(pas) + 1);
    if (seviye < 3) {
      db.getConnection().then((conn) {
        conn.query(
            'update $kullaniciAdi set pas="$kelimePasi", seviye_tarih="$bugun" where id=$kelime_id');
      });
    } else {
      db.getConnection().then((conn) {
        conn.query(
            'update $kullaniciAdi set seviye=2, pas="$kelimePasi", seviye_tarih="$bugun" where id=$kelime_id');
      });
    }
  }

  void yazimDogruGorsel() {
    arkaplan = Colors.green;
  }

  void seviye5TestGorsel() {
    arkaplan = Color.fromARGB(255, 181, 214, 120);
  }

  void seviye5TestSql() {
    db.getConnection().then((conn) {
      conn.query(
          'update kullan??c??lar set seviye5uyar??=1 where id=$kullaniciId');
    });
  }

  void yazimYanlisGorsel() {
    arkaplan = Colors.red;
  }

  Container kelimeKarti() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.only(top: 8, left: 20, right: 16, bottom: 10),
      decoration: BoxDecoration(
          color: arkaplan, borderRadius: BorderRadius.circular(30)),
      child: SizedBox(
        height: 160,
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  "Yanl????: $yanlis / Do??ru: $dogru",
                  style: kelimeDogruYanlisYazi,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(tur)],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Text(
                    kelime,
                    style: kelimeYazi,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(oku)],
              ),
            )
          ],
        ),
      ),
    );
  }
}
