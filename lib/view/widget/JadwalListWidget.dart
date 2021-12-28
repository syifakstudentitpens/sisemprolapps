import 'package:flutter/material.dart';
import 'package:jadwal/data/jadwal/Jadwal.dart';
import 'package:jadwal/data/jadwal/JadwalRepository.dart';
import 'package:jadwal/event/Eventbus.dart';
import 'package:jadwal/event/events.dart';
import 'package:jadwal/view/widget/JadwalListItemWidget.dart';

class JadwalListWidget extends StatefulWidget {
  final String type;
  final String categoryId;

  JadwalListWidget(this.type, this.categoryId);

  @override
  _JadwalListState createState() {
    return _JadwalListState(type, categoryId);
  }
}

class _JadwalListState extends State<JadwalListWidget> {
  var repository = JadwalRepository.create();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<Jadwal> _list = [];
  bool _error = false;
  bool _empty = false;
  bool _loading = false;
  final String type;
  final String categoryId;

  _JadwalListState(this.type, this.categoryId) {
    if (type == 'fav') {
      EventBusProvider.defaultInstance()
          .on<FavJadwalUpdateEvent>()
          .listen((event) {
        fetchData();
      });
    }
  }

  Future<dynamic> fetchData() {
    setState(() {
      _error = false;
      _loading = true;
    });
    return repository.fetchAndGet(type, categoryId).then((value) {
      setState(() {
        _loading = false;
        _list = value;
        _empty = _list.length == 0;
        _error = false;
      });
    }).catchError((e, s) {
      print('error caought $e, $s');
      setState(() {
        _loading = false;
        _error = true;
        _empty = _list.length == 0;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: getView(),
    );
  }

  Widget getView() {
    print('status: $_error,$_empty,$_loading, ${_list.length}');
    if (_empty && _loading) {
      return loadingView();
    }
    if (_error && _empty) {
      return buildErrorView();
    }

    if (_empty) {
      return buildEmptyView();
    }
    if (_loading) {
      return _buildOnlyLoadingView();
    }

    return buildListView();
  }

  Container _buildOnlyLoadingView() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
      child: Container(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget buildListView() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: fetchData,
      child: ListView.builder(
        itemCount: _list.length,
        itemBuilder: (context, index) {
          var item = _list[index];
          return new JadwalListItemWidget(
            item,
          );
        },
      ),
    );
  }

  Widget buildEmptyView() {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            Text(
              'No Jadwal Found',
              style: TextStyle(
                fontSize: 23,
              ),
            ),
            SizedBox.fromSize(
              size: Size.fromHeight(120),
              child: Icon(
                Icons.inbox,
                size: 100.0,
              ),
            ),
            FlatButton(
              child: Text(
                "Retry",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                fetchData();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildErrorView() {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            SizedBox.fromSize(
              size: Size.fromHeight(120),
              child: Icon(
                Icons.error_outline,
                size: 80.0,
              ),
            ),
            Text(
              'Error fetching jadwal',
              style: TextStyle(
                fontSize: 23,
              ),
            ),
            FlatButton(
              child: Text(
                "Retry",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                fetchData();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget loadingView() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
