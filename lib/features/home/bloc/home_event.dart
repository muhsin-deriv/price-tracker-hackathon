part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class InitializeHome extends HomeEvent {}

class OnMarketChosen extends HomeEvent {
  final Market market;
  OnMarketChosen(this.market);
}

class OnSymbolChosen extends HomeEvent {
  final Symbol symbol;
  OnSymbolChosen(this.symbol);
}
