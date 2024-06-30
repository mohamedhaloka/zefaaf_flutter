import 'package:fluttertoast/fluttertoast.dart';

Future<bool?> showToast(String msg) => Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      fontSize: 16,
    );
