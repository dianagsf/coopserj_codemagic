//import 'dart:async';
import 'dart:io';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

class StorageService {
  void uploadImageAtPath(
      String imagePath, String label, String pasta, int protocolo) async {
    final imageFile = File(imagePath);
    var data = DateTime.now().toString().substring(0, 10);
    var hora = DateTime.now().toString().substring(11, 19).split(':');
    var horaFormat = "${hora[0]}h${hora[1]}m${hora[2]}s";
    var imageKey = "";

    imageKey = '$pasta/$protocolo/$label-${data}_$horaFormat.jpg';

    try {
      final options =
          S3UploadFileOptions(accessLevel: StorageAccessLevel.guest);

      await Amplify.Storage.uploadFile(
          local: imageFile, key: imageKey, options: options);
    } catch (e) {
      print('upload error - $e');
    }
  }

  void uploadComprovante(String imagePath, int matricula, String pasta,
      {int protocolo}) async {
    final imageFile = File(imagePath);
    var data = DateTime.now().toString().substring(0, 10);
    var hora = DateTime.now().toString().substring(11, 19).split(':');
    var horaFormat = "${hora[0]}h${hora[1]}m${hora[2]}s";
    var imageKey = "";

    imageKey = '$pasta/$protocolo/comprovante-${data}_$horaFormat.jpg';

    try {
      final options =
          S3UploadFileOptions(accessLevel: StorageAccessLevel.guest);

      await Amplify.Storage.uploadFile(
          local: imageFile, key: imageKey, options: options);
    } catch (e) {
      print('upload error - $e');
    }
  }
}
