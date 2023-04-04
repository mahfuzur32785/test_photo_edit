import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/data_model.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key, this.meme}) : super(key: key);

  final Meme? meme;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  var image;
  var croppImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getImage();
  }

  Future _getImage() async {
    var response = await http.get(Uri.parse(widget.meme!.url));
    if (response.statusCode == 200) {
      image = File('${(await getTemporaryDirectory()).path}/image.jpg');
      setState(() {
      });
      await image.writeAsBytes(response.bodyBytes);

      print(image.writeAsBytes(response.bodyBytes));
    } else {
      print('Failed to load image.');
    }
  }

  cropImage() async {
    print("xxxxdshjfhbahjbsah");
    if (image != null) {
      var croppedFile = (await ImageCropper().cropImage(
        sourcePath: image.path,
        compressQuality: 100,
        maxWidth: 512,
        maxHeight: 512,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      ));
      if (croppedFile != null) {
        setState(() {
          File file = File(croppedFile.path);
          croppImage = file;
        });
        // saveImage();
      }
    } else {
      print('No image selected.');
    }
  }

  Future saveImage() async {
    print('File type is: ${croppImage.runtimeType}');
    final bytes = await croppImage.readAsBytes();
    if (croppImage != null) {
      final result = await ImageGallerySaver.saveImage(bytes);
      print("result is : $result");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image Saved in your device Pictures folder"),
        // action:SnackBarAction(label: "Open", onPressed: () {
        //   OpenFile.open('file:///storage/emulated/0/Pictures/1680633561712.jpg');
        // },),
        ),
      );
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meme!.name),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            croppImage==null ?
            Image(image: NetworkImage(widget.meme!.url),height: MediaQuery.of(context).size.height * 0.4,fit: BoxFit.cover,width: double.infinity,)
            :Image.file(croppImage!,height: MediaQuery.of(context).size.height * 0.3,fit: BoxFit.cover,width: double.infinity,),
            const SizedBox(height: 20,),
            const Text("Image Informatons:",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Width : ${widget.meme!.width}"),
                const SizedBox(width: 20,),
                Text("Height : ${widget.meme!.height}"),
              ],
            ),
            const SizedBox(height: 20,),

            croppImage==null ?ElevatedButton(onPressed: () {
              cropImage();
            }, child: const Text("Edit this image")):
            ElevatedButton(onPressed: () async{
              PermissionStatus storagePermission =
              await Permission.storage.request();
              print(storagePermission);
              if(storagePermission == PermissionStatus.granted){
                saveImage();
              }else if(storagePermission == PermissionStatus.denied){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Storage Permission is Required")));
              }else if(storagePermission == PermissionStatus.permanentlyDenied){
                openAppSettings();
              }

            }, child: const Text("Save this image"))
          ],
        ),
      ),
    );
  }
}
