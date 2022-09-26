part of 'home_bloc.dart';

@immutable
abstract class HomeState {
  final bool isLoading;
  final bool hasError;
  final Object? error;

  HomeState({
    required this.isLoading,
    required this.hasError,
    this.error,
  });
}

class LoadingHomeState extends HomeState {
  LoadingHomeState()
      : super(
          isLoading: true,
          hasError: false,
        );
}

class ErrorHomeState extends HomeState {
  final Object error;
  ErrorHomeState(this.error)
      : super(
          isLoading: false,
          hasError: true,
          error: error,
        );
}

class LoadedHomeState extends HomeState {
  final List<Symbol> symbols;
  final Market? selectedMarket;
  final List<Symbol> filteredSymbols;
  final Symbol? selectedSymbol;

  String getMarketDisplayName(Market market) {
    try {
      return symbols
          .firstWhere((element) => element.market == market)
          .marketDisplayName;
    } catch (e) {
      return '--';
    }
  }

  List<Market> get uniqueMarkets =>
      symbols.fold([], (List<Market> combinedList, Symbol symbol) {
        if (!combinedList.contains(symbol.market)) {
          combinedList.add(symbol.market);
        }

        return combinedList;
      });

  factory LoadedHomeState.initial(List<Symbol> symbols) {
    return LoadedHomeState._(
      symbols: symbols,
      filteredSymbols: [],
    );
  }

  factory LoadedHomeState.withMarket(
    LoadedHomeState currentState,
    Market market,
  ) {
    return currentState
        .copyWith(
          selectedMarket: market,
          filteredSymbols: currentState.symbols
              .where((symbol) => symbol.market == market)
              .toList(),
        )
        .withSelectedSymbolAsNull();
  }

  factory LoadedHomeState.withSelectedSymbol(
    LoadedHomeState currentState,
    Symbol symbol,
  ) {
    return currentState.copyWith(selectedSymbol: symbol);
  }

  LoadedHomeState._({
    required this.symbols,
    this.selectedMarket,
    required this.filteredSymbols,
    this.selectedSymbol,
  }) : super(isLoading: false, hasError: false);

  LoadedHomeState copyWith({
    List<Symbol>? symbols,
    Market? selectedMarket,
    List<Symbol>? filteredSymbols,
    Symbol? selectedSymbol,
  }) {
    return LoadedHomeState._(
      symbols: symbols ?? this.symbols,
      selectedMarket: selectedMarket ?? this.selectedMarket,
      filteredSymbols: filteredSymbols ?? this.filteredSymbols,
      selectedSymbol: selectedSymbol ?? this.selectedSymbol,
    );
  }

  LoadedHomeState withSelectedSymbolAsNull() {
    return LoadedHomeState._(
      symbols: this.symbols,
      selectedMarket: this.selectedMarket,
      filteredSymbols: this.filteredSymbols,
      selectedSymbol: null,
    );
  }
}
