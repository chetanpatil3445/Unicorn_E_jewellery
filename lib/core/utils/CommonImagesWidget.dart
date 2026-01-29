import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/Get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'dart:ui';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:flutter/material.dart';
import '../apiUrls/api_urls.dart';


Widget buildImageBox({required String label, required File? imageFile, required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: imageFile == null
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.diamond, size: 30, color: Colors.grey),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      )
          : ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(imageFile, fit: BoxFit.cover),
      ),
    ),
  );
}


Future<void> addCompressedImage(
    http.MultipartRequest request,
    File? originalFile,
    String fieldName,
    ) async {
  if (originalFile == null) return;

  File fileToUpload = originalFile;

  try {
    final XFile? compressedXFile =
    await FlutterImageCompress.compressAndGetFile(
      originalFile.absolute.path,
      '${originalFile.path}_compressed.jpg', // force jpg
      quality: 70,
      format: CompressFormat.jpeg, // 🔥 IMPORTANT
      minWidth: 800,
      minHeight: 800,
    );

    if (compressedXFile != null) {
      fileToUpload = File(compressedXFile.path);
    }
  } catch (e) {
    debugPrint('Compression skipped for $fieldName: $e');
  }

  // 🔥 Detect mime type
  final mimeType = lookupMimeType(fileToUpload.path) ?? 'image/jpeg';
  final typeSplit = mimeType.split('/');

  final multipartFile = await http.MultipartFile.fromPath(
    fieldName,
    fileToUpload.path,
    filename: path.basename(fileToUpload.path),
    contentType: MediaType(typeSplit[0], typeSplit[1]),
  );

  request.files.add(multipartFile);

  debugPrint('Attached $fieldName → $mimeType');
}

final FlutterSecureStorage storage = const FlutterSecureStorage();

Future<String?> getAccessToken() async =>
    await storage.read(key: 'access_token');