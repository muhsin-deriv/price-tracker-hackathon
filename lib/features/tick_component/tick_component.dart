import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:price_tracker/common/exceptions/api_exceptions.dart';
import 'package:price_tracker/common/models/symbol_model.dart';
import 'package:price_tracker/common/models/tick_modal.dart';

import 'package:price_tracker/common/utils/ticker_mixin.dart';

class TickComponent extends StatefulWidget {
  final Symbol symbol;

  const TickComponent({
    Key? key,
    required this.symbol,
  }) : super(key: key);

  @override
  _TickComponentState createState() => _TickComponentState();
}

class _TickComponentState extends State<TickComponent> with TickerMixin {
  StreamSubscription? subscription;
  Tick? lastTick;
  Tick? currentTick;
  String errorMessage = '';

  @override
  void initState() {
    subscription = tickStream(widget.symbol.symbol)?.listen((event) {
      final parsedEvent = jsonDecode(event);
      if (parsedEvent['msg_type'] != 'tick') return;

      final tick = Tick.fromJson(parsedEvent['tick']);
      setState(() {
        lastTick = currentTick;
        currentTick = tick;
        errorMessage = '';
      });
    }, onError: (error) {
      if (error is ApiDisconnectException) {
        setState(() {
          errorMessage = error.message;
        });
      }
    });
    subscribeToSymbol(widget.symbol.symbol);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 50),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Center(
            child: Text(
              currentTick?.quote.toString() ?? '--',
              style: TextStyle(
                color: getColor(),
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
        ),
        if (errorMessage.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          )
      ],
    );
  }

  Color getColor() {
    if (lastTick?.quote == currentTick?.quote) return Colors.grey;
    return (lastTick?.quote ?? 0) > (currentTick?.quote ?? 0)
        ? Colors.red
        : Colors.green;
  }

  @override
  void dispose() {
    unsubscribeToSymbol(widget.symbol.symbol);
    subscription?.cancel();
    super.dispose();
  }
}
