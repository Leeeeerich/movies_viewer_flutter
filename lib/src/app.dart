import 'package:flutter/material.dart';
import 'package:movies_viewer_flutter/src/model/home_model.dart';
import 'package:movies_viewer_flutter/src/model/seasons_model.dart';
import 'package:movies_viewer_flutter/src/resources/database/app_database.dart';
import 'package:movies_viewer_flutter/src/resources/database/app_database_impl.dart';
import 'package:movies_viewer_flutter/src/resources/repository/repository.dart';
import 'package:movies_viewer_flutter/src/resources/repository/repository_impl.dart';
import 'package:movies_viewer_flutter/src/resources/web_services/web_services.dart';
import 'package:movies_viewer_flutter/src/resources/web_services/web_services_impl.dart';
import 'package:movies_viewer_flutter/src/ui/home/home.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  AppDatabase _database;
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
          ChangeNotifierProvider(
              create: (context) => SeasonsModel(_repository)),
          ChangeNotifierProvider(create: (context) => HomeModel(_repository))
        ],
        child: MaterialApp(
            title: 'Viewer',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: MyHomePage(title: 'Movies Viewer')));
  }

  Future<bool> _prepare() async {
    _database = AppDatabaseImpl.db;
    _webServices = WebServicesImpl();
    _repository = RepositoryImpl(_database, _webServices);
    return true;
  }

  @override
  void dispose() {
    _database.closeDatabase();
    super.dispose();
  }
}
