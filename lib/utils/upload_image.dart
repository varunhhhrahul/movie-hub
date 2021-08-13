import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

const CLOUDINARY_URL =
    'https://api.cloudinary.com/v1_1/muj-housing/image/upload';
const UPLOAD_PRESET = 'pxba63yt';

var cloudinary = CloudinaryPublic('muj-housing', UPLOAD_PRESET, cache: false);

Future<String> uploadImage(PickedFile img) async {
  // * To upload to cloudinary
  // final bytes = File(img.path) .readAsBytesSync();
  // final base64Image = base64Encode(bytes);
  // final base64Img = 'data:image/png;base64,$base64Image';
  // final data = json.encode({
  //   'file': base64Img,
  //   'upload_preset': UPLOAD_PRESET,
  // });

  CloudinaryResponse response = await cloudinary.uploadFile(
    CloudinaryFile.fromFile(
      File(img.path).path,
      resourceType: CloudinaryResourceType.Image,
    ),
  );
  // final res = await http.post(
  //   Uri.parse(CLOUDINARY_URL),
  //   body: data,
  //   headers: {
  //     HttpHeaders.contentTypeHeader: 'application/json',
  //   },
  // );
  // final resData = json.decode(res.body);
  print(response.secureUrl);
  return response.secureUrl;
  // resData['secure_url'];
}
