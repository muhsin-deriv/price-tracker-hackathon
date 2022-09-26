import 'dart:convert';

import 'package:price_tracker/common/repository/api_connection.dart';

abstract class BaseRepo {
  /// Takes in String `messageKey` (To verify the response)
  /// and String `messageToBeSent`
  // This makes sure the stream is listened to only once and
  // closed immediately after we recieve the response
  Future<Map> callAndWaitForData(
    String messageKey,
    String messageToBeSent,
  ) async {
    ApiConnection.instance.addMessage(messageToBeSent);
    final dataStream = await ApiConnection.instance.stream.skipWhile((element) {
      return jsonDecode(element)[messageKey] == null;
    }).first;
    return jsonDecode(await dataStream);
  }
}
