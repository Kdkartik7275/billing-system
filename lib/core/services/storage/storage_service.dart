import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class StorageService {
  Future<String?> uploadFileData(File newImage) async {
    try {
      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/${dotenv.env['CLOUD_NAME']!}/upload',
      );

      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = dotenv.env['UPLOAD_PRESET']!
        ..files.add(await http.MultipartFile.fromPath('file', newImage.path));

      final response = await request.send();
      debugPrint("Upload Image Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final Map<String, dynamic> jsonMap = jsonDecode(responseData);

        debugPrint(jsonMap.toString());

        final String? imageUrl = jsonMap['secure_url'] as String?;
        debugPrint("Uploaded Image URL: $imageUrl");

        return imageUrl;
      }
    } catch (e, stack) {
      debugPrint("Error in the upload image: $e");
      debugPrintStack(stackTrace: stack);
    }

    return null;
  }
}
