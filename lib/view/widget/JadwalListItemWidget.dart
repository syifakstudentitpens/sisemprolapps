import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:jadwal/data/URL.dart';
import 'package:jadwal/data/jadwal/Jadwal.dart';
import 'package:jadwal/view/Routes.dart';
import 'package:transparent_image/transparent_image.dart';

typedef JadwalItemCallback = Function(int id);

class JadwalListItemWidget extends StatelessWidget {
  final Jadwal jadwal;
  final JadwalItemCallback callback;

  const JadwalListItemWidget(
    this.jadwal, {
    this.callback,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: Card(
      child: InkWell(
        onTap: () {
          NavigateHelper.navigateToJadwalDetails(context, jadwal);
        },
        child: Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      topRight: Radius.circular(4.0),
                    ),
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: URL.imageUrl(jadwal.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0.0,
                    left: 8.0,
                    right: 8.0,
                    bottom: 4.0,
                  ),
                  child: Text(
                    jadwal.title,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 23.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0.0,
                    left: 8.0,
                    right: 8.0,
                    bottom: 4.0,
                  ),
                  child: Text(
                    _parseHtmlString(jadwal.body),
                    style: TextStyle(color: Colors.black87, fontSize: 16.0),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }

  String _parseHtmlString(String htmlString) {
    var document = parse(htmlString);

    String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }
}
