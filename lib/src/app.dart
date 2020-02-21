import 'package:flutter/material.dart';
import 'package:movies_viewer_flutter/src/model/seasons_model.dart';
import 'package:movies_viewer_flutter/src/resources/repository/repository.dart';
import 'package:movies_viewer_flutter/src/resources/repository/repository_impl.dart';
import 'package:movies_viewer_flutter/src/resources/web_services/web_services.dart';
import 'package:movies_viewer_flutter/src/resources/web_services/web_services_impl.dart';
import 'package:movies_viewer_flutter/src/ui/home/home.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  Database _database;
  WebServices _webServices;
  Repository _repository;

  @override
  void initState() {
    _prepare(); //TODO edit: don't rely on chance
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SeasonsModel(_repository))
        ],
        child: MaterialApp(
            title: 'Viewer',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: MyHomePage(title: 'Movies Viewer')));
  }

  Future<bool> _prepare() async {
    _database = await openDatabase('my_db.db');
    _webServices = WebServicesImpl();
    _repository = RepositoryImpl(_database, _webServices);
    return true;
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }
}
