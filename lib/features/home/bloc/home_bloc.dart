import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:price_tracker/common/models/symbol_model.dart';
import 'package:price_tracker/common/repository/symbols_repo.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SymbolsRepoBase symbolsRepo;

  HomeBloc(this.symbolsRepo) : super(LoadingHomeState()) {
    on<HomeEvent>((event, emit) async {
      if (event is InitializeHome) {
        emit(LoadingHomeState());
        await _fetchAndUpdateSymbolsList(emit);
      }

      if (state is! LoadedHomeState) return;
      final castedState = state as LoadedHomeState;

      if (event is OnMarketChosen) {
        emit(LoadedHomeState.withMarket(castedState, event.market));
      }

      if (event is OnSymbolChosen) {
        emit(LoadedHomeState.withSelectedSymbol(castedState, event.symbol));
      }
    });
  }

  Future<void> _fetchAndUpdateSymbolsList(Emitter<HomeState> emit) async {
    try {
      final symbols = await symbolsRepo.getSymbols();
      emit(LoadedHomeState.initial(symbols));
    } catch (e) {
      emit(ErrorHomeState(e));
    }
  }
}
