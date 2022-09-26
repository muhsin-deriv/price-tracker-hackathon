import 'package:price_tracker/common/utils/enum_helpers.dart';

enum Market {
  basketIndex,
  forex,
  indices,
  cryptocurrency,
  syntheticIndex,
  commodities,
}

enum SymbolType {
  forexBasket,
  forex,
  stockindex,
  cryptocurrency,
  none,
  commodityBasket,
  commodities,
}

class Symbol {
  Symbol({
    required this.allowForwardStarting,
    required this.displayName,
    required this.exchangeIsOpen,
    required this.isTradingSuspended,
    required this.market,
    required this.marketDisplayName,
    required this.pip,
    required this.submarket,
    required this.submarketDisplayName,
    required this.symbol,
    required this.symbolType,
  });

  final bool allowForwardStarting;
  final String displayName;
  final bool exchangeIsOpen;
  final bool isTradingSuspended;
  final Market market;
  final String marketDisplayName;
  final double pip;
  final String submarket;
  final String submarketDisplayName;
  final String symbol;
  final SymbolType symbolType;

  factory Symbol.fromJson(Map<String, dynamic> json) => Symbol(
        allowForwardStarting: json["allow_forward_starting"] == 1,
        displayName: json["display_name"],
        exchangeIsOpen: json["exchange_is_open"] == 1,
        isTradingSuspended: json["is_trading_suspended"] == 1,
        market: marketValues.map[json["market"]]!,
        marketDisplayName: json["market_display_name"],
        pip: json["pip"].toDouble(),
        submarket: json["submarket"],
        submarketDisplayName: json["submarket_display_name"],
        symbol: json["symbol"],
        symbolType: symbolTypeValues.map[json["symbol_type"]]!,
      );

  Map<String, dynamic> toJson() => {
        "allow_forward_starting": allowForwardStarting,
        "display_name": displayName,
        "exchange_is_open": exchangeIsOpen,
        "is_trading_suspended": isTradingSuspended,
        "market": marketValues.reverse[market],
        "market_display_name": marketDisplayName,
        "pip": pip,
        "submarket": submarket,
        "submarket_display_name": submarketDisplayName,
        "symbol": symbol,
        "symbol_type": symbolTypeValues.reverse[symbolType],
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Symbol &&
        other.allowForwardStarting == allowForwardStarting &&
        other.displayName == displayName &&
        other.exchangeIsOpen == exchangeIsOpen &&
        other.isTradingSuspended == isTradingSuspended &&
        other.market == market &&
        other.marketDisplayName == marketDisplayName &&
        other.pip == pip &&
        other.submarket == submarket &&
        other.submarketDisplayName == submarketDisplayName &&
        other.symbol == symbol &&
        other.symbolType == symbolType;
  }

  @override
  int get hashCode {
    return allowForwardStarting.hashCode ^
        displayName.hashCode ^
        exchangeIsOpen.hashCode ^
        isTradingSuspended.hashCode ^
        market.hashCode ^
        marketDisplayName.hashCode ^
        pip.hashCode ^
        submarket.hashCode ^
        submarketDisplayName.hashCode ^
        symbol.hashCode ^
        symbolType.hashCode;
  }

  @override
  String toString() {
    return 'Symbol(displayName: $displayName, symbol: $symbol)';
  }
}

final marketValues = EnumValues({
  "basket_index": Market.basketIndex,
  "commodities": Market.commodities,
  "cryptocurrency": Market.cryptocurrency,
  "forex": Market.forex,
  "indices": Market.indices,
  "synthetic_index": Market.syntheticIndex
});

final symbolTypeValues = EnumValues({
  "commodities": SymbolType.commodities,
  "commodity_basket": SymbolType.commodityBasket,
  "cryptocurrency": SymbolType.cryptocurrency,
  "": SymbolType.none,
  "forex": SymbolType.forex,
  "forex_basket": SymbolType.forexBasket,
  "stockindex": SymbolType.stockindex
});
