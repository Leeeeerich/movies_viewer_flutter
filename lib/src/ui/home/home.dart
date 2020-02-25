import 'package:flutter/material.dart';
import 'package:movies_viewer_flutter/src/model/home_model.dart';
import 'package:movies_viewer_flutter/src/ui/home/select_series/select_series.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _linkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _loadViewed(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _linkController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Link on movies from kinogo.by",
              ),
            ),
          ),
          FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.all(8.0),
            splashColor: Colors.blueAccent,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SelectSeriesWidget(_linkController.text)),
              );
            },
            child: Text(
              "Select series",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          Expanded(child: Consumer<HomeModel>(
            builder: (context, homeModel, child) {
              if (homeModel.moviePageList.isEmpty) {
                return Text('You have not viewed anything yet');
              } else {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: homeModel.moviePageList.length,
                    itemBuilder: (ctx, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelectSeriesWidget(
                                      homeModel.moviePageList[index].url)),
                            );
                          },
                          child: Row(
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: Image.network(
                                    homeModel.moviePageList[index].urlCover,
                                    width: 60,
                                    height: 80,
                                  )),
                              Text(
                                homeModel.moviePageList[index].title,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              )
                            ],
                          ));
                    });
              }
            },
          )),
        ],
      ),
    );
  }

  _loadViewed(BuildContext context) {
    Provider.of<HomeModel>(context, listen: false).loadMoviePageList();
  }

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }
}
