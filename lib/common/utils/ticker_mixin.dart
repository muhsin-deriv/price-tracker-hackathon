import 'dart:convert';

import 'package:price_tracker/common/models/tick_modal.dart';
import 'package:price_tracker/common/repository/api_connection.dart';

mixin TickerMixin {
  void subscribeToSymbol(String symbol) {
    return ApiConnection.instance.subscribeToSymbol(symbol);
  }

  void unsubscribeToSymbol(String symbol) {
    return ApiConnection.instance.unsubscribeFromSymbol(symbol);
  }

  Stream? tickStream(String symbol) =>
      ApiConnection.instance.stream.where((event) {
        final parsedEvent = jsonDecode(event);
        if (parsedEvent['msg_type'] != 'tick') return false;

        final tick = Tick.fromJson(parsedEvent['tick']);
        return tick.symbol == symbol;
      });
}
