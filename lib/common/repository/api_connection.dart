import 'dart:async';
import 'dart:convert';

import 'package:price_tracker/common/exceptions/api_exceptions.dart';
import 'package:price_tracker/common/models/tick_modal.dart';
import 'package:price_tracker/constants.dart';
import 'package:web_socket_channel/io.dart';

class ApiConnection {
  late IOWebSocketChannel _channel;

  // Added a new stream controller as the stream provided by
  // websocket isn't broadcast
  final StreamController _streamController = StreamController.broadcast();
  Stream get stream => _streamController.stream;

  String _webSocketUrl = WS_URL;

  // This stores the count of subscription per id
  // This is done so that we are not subscribing to the same symbol
  // multiple times
  // also makes unsubscribe easier as we know if
  // there is another widget subscribed to the same id
  Map<String, int> _subscriptions = {};

  // helper map to hold symbol to subscription id
  // used when unsubscribing
  Map<String, String> _symbolToIdMap = {};

  // Flag to make sure we don't try to reconnect multiple times
  bool isTryingToReconnect = false;

  ApiConnection._() {
    // Run initialize methods
    connectToSocket();
  }
  static final ApiConnection instance = ApiConnection._();

  /// Used to set custom urls for tests
  void setUrl(String url) => _webSocketUrl = url;

  void connectToSocket() {
    // Setting `isTryingToReconnect` to True so we will not run this again
    isTryingToReconnect = true;

    // Ping interval is set so that we are notified
    // when disconnected from socket
    _channel = IOWebSocketChannel.connect(
      _webSocketUrl,
      pingInterval: Duration(seconds: 2),
    );

    // Resubscribe if connection was disconnected
    if (_subscriptions.values.where((element) => element != 0).isNotEmpty) {
      _symbolToIdMap = {};
      final keysToSubscribe = _subscriptions.keys;
      _subscriptions = {};
      for (var key in keysToSubscribe) subscribeToSymbol(key);
    }

    _channel.stream.listen(onData, cancelOnError: false, onDone: onClose);
    isTryingToReconnect = false;
  }

  void onData(data) {
    _streamController.add(data);

    // If its a tick. Check if it should be added to [_symbolToIdMap]
    final parsedData = jsonDecode(data);
    if (parsedData['msg_type'] != 'tick') {
      return;
    }
    final tick = Tick.fromJson(parsedData['tick']);
    if (!_symbolToIdMap.containsValue(tick.id)) {
      _symbolToIdMap[tick.symbol] = tick.id;
    }
  }

  void onClose() {
    _streamController.addError(ApiDisconnectException(
        message:
            'Socket is disconnected. Will try again in about ${WS_RECONNECT_INTERVAL.inSeconds} seconds'));
    // Try to reconnect after a set time
    // Change this to a back-off pattern
    Future.delayed(Duration(seconds: 5), connectToSocket);
  }

  // These messages will not be resubscribed on disconnection
  // Use this for one time requests
  void addMessage(String message) {
    if (_channel.closeCode == null) {
      _channel.sink.add(message);
    }
  }

  // These messages will be resubscribed on disconnection
  // Use this only for ticks or
  // anything that responds with a stream of responses
  void subscribeToSymbol(String symbol) {
    int? subscriptionsCount = _subscriptions[symbol];

    // Increment subscriptions count
    if (subscriptionsCount != null) {
      _subscriptions[symbol] = ++subscriptionsCount;
      return;
    }
    // Already subscribed. We do not have to subscribe again
    _subscriptions[symbol] = 1;
    addMessage(jsonEncode({"ticks": symbol, "subscribe": 1}));
  }

  // Unsubscribe from socket and
  // remove from messages to resubscribe on disconnection
  void unsubscribeFromSymbol(String symbol) {
    int? subscriptionsCount = _subscriptions[symbol];

    // Decrement subscriptions count
    if (subscriptionsCount != null && subscriptionsCount > 0) {
      _subscriptions[symbol] = --subscriptionsCount;
      return;
    }

    // Last subscription, we will have to unsubscribe now
    _subscriptions.remove(symbol);
    final subscriptionId = _symbolToIdMap[symbol];
    if (subscriptionId == null) return;

    addMessage(jsonEncode({"forget": subscriptionId}));
  }
}
