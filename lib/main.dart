import 'package:flutter/material.dart';
import 'package:movies_viewer_flutter/src/app.dart';
import 'package:movies_viewer_flutter/src/models/seasons_model.dart';
import 'package:movies_viewer_flutter/src/resources/repository.dart';
import 'package:provider/provider.dart';

void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => SeasonsModel(Repository()))
    ], child: MyApp()));