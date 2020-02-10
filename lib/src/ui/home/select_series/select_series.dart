import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movies_viewer_flutter/src/models/season_dto.dart';
import 'package:movies_viewer_flutter/src/models/seasons_model.dart';
import 'package:movies_viewer_flutter/src/ui/video_player/video_player.dart';
import 'package:provider/provider.dart';

class SelectSeriesWidget extends StatelessWidget {
  String _linkOnMovies;

  SelectSeriesWidget(this._linkOnMovies, {Key key});

  @override
  Widget build(BuildContext context) {
    _loadMovies(context);
    return Scaffold(
      appBar: AppBar(title: Text("Title")),
      body: Consumer<SeasonsModel>(
        builder: (context, seasons, child) {
          if (seasons.seasonLists.isEmpty) {
            return Center(
                child: SpinKitCubeGrid(size: 51.0, color: Colors.blue));
          } else {
            return ListView.builder(
                itemCount: seasons.seasonLists.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return ExpansionTile(
                      title: Text(seasons.seasonLists[index].seasonName),
                      children: _buildExpandableContent(
                          seasons.seasonLists[index].getAttachments(),
                          (url) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      VideoPlayerScreen(url)))));
                });
          }
        },
      ),
    );
  }

  _loadMovies(BuildContext context) {
    Provider.of<SeasonsModel>(context, listen: false)
        .loadSeasons(_linkOnMovies);
  }

  _buildExpandableContent<T extends Attachments>(
      List<T> list, Function(String) callback) {
    List<Widget> columnContent = [];

    for (T element in list)
      columnContent.add(_getListTileOrExpandableTile(element, callback));
    return columnContent;
  }

  _getListTileOrExpandableTile<T extends Attachments>(
      T element, Function(String) callback) {
    Widget widget;
    if (element.getAttachments().isNotEmpty &&
        element.getAttachments()[0] is String) {
      widget = ListTile(
        title: Text(element.name, style: TextStyle(fontSize: 18.0)),
        onTap: () => callback(element.getAttachments()[0]),
      );
    } else {
      widget = ExpansionTile(
        title: Text(element.name, style: TextStyle(fontSize: 18.0)),
        children: _buildExpandableContent<Attachments>(
            element.getAttachments(), callback),
      );
    }
    return widget;
  }
}
