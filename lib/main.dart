import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_tracker/features/home/bloc/home_bloc.dart';
import 'package:price_tracker/features/home/presentation/home.dart';

import 'common/repository/symbols_repo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Price Checker',
      home: BlocProvider(
        create: (_) => HomeBloc(SymbolsRepo()),
        child: HomePage(),
      ),
    );
  }
}
