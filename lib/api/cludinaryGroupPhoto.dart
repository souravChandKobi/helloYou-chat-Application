import 'dart:convert';
import 'dart:developer' show log;
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CloudinaryGroupPhoto {
  static Future<String?> upload(XFile image) async {
    try {
      final file = File(image.path);

      // Cloudinary cloudinary =
      //     Cloudinary.fromCloudName(cloudName: "dxqum2h82");

          final cloudinaryUrl =Uri.parse('http://api.cloudinary.com/v1_1/dxqum2h82/upload');

      final request = http.MultipartRequest('POST', cloudinaryUrl)
      ..fields['upload_preset']="testImagesProfile"
      ..files.add(await http.MultipartFile.fromPath('file', file.path));
      final res=await request.send();
      final responseBody = await res.stream.bytesToString();

      if (res.statusCode == 200) {
        final data = jsonDecode(responseBody);
        final secureUrl = data["secure_url"];

        log("Uploaded → $secureUrl");
        return secureUrl;
      } else {
        log("Cloudinary Error: ${res.statusCode}");
        log("Response: $responseBody");
        return null;
      }
    } catch (e) {
      log("Upload Exception: $e");
      return null;
    }
  }
}