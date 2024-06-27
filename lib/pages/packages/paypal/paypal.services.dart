import 'dart:async';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart';

class PaypalServices {
  // String domain = "https://api.sandbox.paypal.com"; // for sandbox mode

  String domain = "https://api.paypal.com"; // for production mode

  //Client ID:
  //
  // AeVWfTJqRk4cMaGwnVzWvsSOOnkxJtR7q5hlqETuRLBLBVni8UuY1XVqAk7t2OQ4pvRnLg_WCCD-QeUm
  // Secret : EJoP_8qK8_7DAj8N0v76wbq8TBoLwP76irreZBZ7hipr_3-aIvkC04ZlDOxIr4PYv3HQN0EixwO52BkE
  //
  // sandbox Accounts ;
  // sb-1ts4o6122635@personal.example.com
  // i]3N8W^8

  // change clientId and secret with your own, provided by paypal
  // Sandbox
  // String clientId =
  //     'AeVWfTJqRk4cMaGwnVzWvsSOOnkxJtR7q5hlqETuRLBLBVni8UuY1XVqAk7t2OQ4pvRnLg_WCCD-QeUm';
  // String secret =
  //     'EJoP_8qK8_7DAj8N0v76wbq8TBoLwP76irreZBZ7hipr_3-aIvkC04ZlDOxIr4PYv3HQN0EixwO52BkE';

  //Production
  String clientId =
      'AeY_P1Gvr3QDz4PaizUeV1u7imht3hyGT7uMckgQcGUMDJnDSq0gsd21XZ35KLGlouw9PpIvsTT-8scQ';
  String secret =
      'EO0BhaB-C6pbllgkZFDSzAcpq7ikXIm1eWvDcY5z_ZD4WQWTKKjb-i5qkW-qY-LH0px6PYPKUggNyAeD';

  // for getting the access token from Paypal
  Future<String?> getAccessToken() async {
    try {
      var client = BasicAuthClient(clientId, secret);
      var response = await client.post(
          Uri.parse('$domain/v1/oauth2/token?grant_type=client_credentials'));

      if (response.statusCode == 200) {
        print("Paypal access token..");
        final body = convert.jsonDecode(response.body);
        return body["access_token"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // for creating the payment request with Paypal
  Future<Map<String, String>?> createPaypalPayment(
      transactions, accessToken) async {
    try {
      print("Paypal createPaypalPayment..");
      print(transactions);
      var response = await http.post(Uri.parse("$domain/v1/payments/payment"),
          body: convert.jsonEncode(transactions),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      final body = convert.jsonDecode(response.body);
      print(body);
      if (response.statusCode == 201) {
        print("Paypal createPaypalPayment success..");

        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];

          String executeUrl = "";
          String approvalUrl = "";
          final item = links.firstWhere((o) => o["rel"] == "approval_url",
              orElse: () => null);
          if (item != null) {
            approvalUrl = item["href"];
          }
          final item1 = links.firstWhere((o) => o["rel"] == "execute",
              orElse: () => null);
          if (item1 != null) {
            executeUrl = item1["href"];
          }
          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }
        return null;
      } else {
        throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  // for executing the payment transaction
  Future<String?> executePayment(url, payerId, accessToken) async {
    try {
      var response = await http.post(
        Uri.parse(url),
        body: convert.jsonEncode({"payer_id": payerId}),
        headers: {
          "content-type": "application/json",
          'Authorization': 'Bearer $accessToken'
        },
      );

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        print("Paypal executePayment success..");

        print(body);
        return body["id"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
