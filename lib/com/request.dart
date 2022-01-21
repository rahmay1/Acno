import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:acne_detector/pages/root_app.dart' as root_app;

//var resJson;

void main(List<String> args, File image) {
  print("IM RUNNING");

  // hello().then((i) {
  //   print(i);
  // });

  onUploadImage(image).then((i) {
    print(i);
  });

}

Future<String> onUploadImage(File image) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse("http://10.0.2.2:8000/model"),
  );
  Map<String, String> headers = {"Content-type": "multipart/form-data"};
  request.files.add(
    http.MultipartFile(
      'image',
      image.readAsBytes().asStream(),
      image.lengthSync(),
      filename: image.path.split('/').last,
    ),
  );
  request.headers.addAll(headers);
  print("request: " + request.toString());
  var res = await request.send();
  http.Response response = await http.Response.fromStream(res);
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to load');
  }
}

Future<String> hello() async {
  final response =
  await http.get(Uri.parse('http://10.0.2.2:8000/hello'));
  print("Buddygi");
  if (response.statusCode == 200) {
    print("MM");
    return response.body;
  } else {
    throw Exception('Failed to load');
  }
}

