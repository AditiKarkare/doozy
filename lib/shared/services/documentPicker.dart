import 'package:doozy/shared/core/others/dataFormates.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ModalImage {
  BuildContext context;

  final picker = ImagePicker();
  Function()? removeImg;
  final Function(String path, String fileType) onImageSelect;
  bool isImageCroppable;
  bool? isRemoveVisible;

  ModalImage(
      {required this.context,
      required this.onImageSelect,
      required this.isImageCroppable,
      this.removeImg,
      this.isRemoveVisible = false});
//====
  callGallery() async {
    await picker
        .pickImage(source: ImageSource.gallery, imageQuality: 20)
        .then((image) async {
      if (image != null) {
        onImageSelect(image.path, CoreDataFormates.eventType.elementAt(2));
      }
      Navigator.pop(context);
    });
  }

  callCamera() async {
    await picker
        .pickImage(source: ImageSource.camera, imageQuality: 50)
        .then((image) async {
      if (image != null) {
        onImageSelect(image.path, CoreDataFormates.eventType.elementAt(2));
      }
      Navigator.pop(context);
    });
  }

  callpdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      onImageSelect(
          result.files.single.path!, CoreDataFormates.eventType.elementAt(3));
      Navigator.pop(context);
    } else {}
  }

  mainBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: isRemoveVisible ?? false ? 235.0 : 250,
            color: const Color(0x00000000),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text("Gallery"),
                  onTap: callGallery,
                ),
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text("Camera"),
                  onTap: callCamera,
                ),
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf),
                  title: const Text("Pdf Document"),
                  onTap: callpdf,
                ),
                ListTile(
                  leading: const Icon(Icons.cancel),
                  title: const Text("Cancel"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                isRemoveVisible ?? false
                    ? ListTile(
                        leading: const Icon(Icons.close, color: Colors.red),
                        title: const Text("Remove",
                            style: TextStyle(color: Colors.red)),
                        onTap: removeImg,
                      )
                    : const SizedBox(),
              ],
            ),
          );
        });
  }
}
