import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_tracker/common/models/symbol_model.dart';
import 'package:price_tracker/features/home/bloc/home_bloc.dart';
import 'package:price_tracker/features/home/presentation/components/error_home_view.dart';
import 'package:price_tracker/features/home/presentation/components/home_loaded_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    BlocProvider.of<HomeBloc>(context).add(InitializeHome());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomeBloc>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Price Checker')),
      body: BlocBuilder<HomeBloc, HomeState>(
        bloc: bloc,
        builder: (BuildContext context, HomeState state) {
          // Loading View
          if (state is LoadingHomeState) {
            return Center(child: CircularProgressIndicator());
          }

          // Error View
          if (state is ErrorHomeState) {
            return ErrorHomeView(
              errorMessage: state.error.toString(),
              onRetry: () {
                bloc.add(InitializeHome());
              },
            );
          }

          // Loaded View
          if (state is LoadedHomeState) {
            return HomeLoadedView(
              state: state,
              onMarketChanged: (Market? market) {
                if (market == null) return;

                bloc.add(OnMarketChosen(market));
              },
              onSymbolChanged: (Symbol? symbol) {
                if (symbol == null) return;

                bloc.add(OnSymbolChosen(symbol));
              },
            );
          }

          //Default Case
          return SizedBox.shrink();
        },
      ),
    );
  }
}
