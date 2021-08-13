import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

const CLOUDINARY_URL = 'https://api.cloudinary.com/v1_1/muj-housing/upload';
const UPLOAD_PRESET = 'pxba63yt';

Future<String> uploadImage(PickedFile img) async {
  // * To upload to cloudinary
  final bytes = File(img.path).readAsBytesSync();
  final base64Image = base64Encode(bytes);
  final base64Img = 'data:image/jpg;base64,$base64Image';
  final data = json.encode({
    'file': base64Img,
    'upload_preset': UPLOAD_PRESET,
  });
  final res = await http.post(
    Uri.parse(CLOUDINARY_URL),
    body: data,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    },
  );
  final resData = json.decode(res.body);
  print(resData);
  return resData['secure_url'];
}
