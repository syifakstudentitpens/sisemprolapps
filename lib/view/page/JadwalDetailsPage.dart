import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_text.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:jadwal/data/URL.dart';
import 'package:jadwal/data/jadwal/Jadwal.dart';
import 'package:jadwal/data/jadwal/JadwalRepository.dart';
import 'package:flutter_html_view/flutter_html_view.dart';

class JadwalDetailsPage extends StatefulWidget {
  final Jadwal jadwal;

  JadwalDetailsPage(this.jadwal);

  @override
  _JadwalDetailsPageState createState() => _JadwalDetailsPageState(jadwal);
}

class _JadwalDetailsPageState extends State<JadwalDetailsPage> {
  JadwalRepository _repository = JadwalRepository.create();
  String _title;
  String _body;
  String _imgUrl;
  final FlutterYoutube youtube = FlutterYoutube();
  Jadwal _jadwal;
  bool _isFavourite = false;

  _JadwalDetailsPageState(Jadwal jadwal) {
    _jadwal = jadwal;
    _title = jadwal.title;
    _body = jadwal.body;
    _imgUrl = URL.imageUrl(jadwal.image);
  }

  @override
  void initState() {
    _repository.isFavouriteJadwal(_jadwal.id).then((value) {
      setState(() {
        _isFavourite = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Padding(
                  padding: EdgeInsets.only(
                    top: 16.0,
                    left: 48.0,
                    right: 16.0,
                    bottom: 0.0,
                  ),
                  child: SizedBox.fromSize(
                    size: Size(
                      MediaQuery.of(context).size.width * 0.7,
                      20.0,
                    ),
                    child: Text(
                      _title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
                background: Image.network(
                  _imgUrl,
                  fit: BoxFit.cover,
                ),
                // background: Image(image: CachedNetworkImageProvider(_imgUrl)),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: HtmlView(
              data: _body,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!_isFavourite) {
            _repository.saveFavJadwal(_jadwal);
            setState(() {
              _isFavourite = true;
            });
          } else {
            _repository.removeFavJadwal(_jadwal);
            setState(() {
              _isFavourite = false;
            });
          }
        },
        elevation: 4.0,
        tooltip: 'Make Favourite',
        child: _isFavourite ? Icon(Icons.cancel) : Icon(Icons.favorite),
      ),
    );
  }
}
