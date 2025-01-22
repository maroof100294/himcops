import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class TenantOtherDetailsForm extends StatefulWidget {
  final Function(bool) onFilesUploaded;
  final Function(String?) onPhotoUploaded;
  final Function(String?) onDocumentUploaded;
  const TenantOtherDetailsForm({
    super.key, 
    required this.onFilesUploaded,
    required this.onPhotoUploaded,
    required this.onDocumentUploaded,
    });

  @override
  _TenantOtherDetailsFormState createState() => _TenantOtherDetailsFormState();
}

class _TenantOtherDetailsFormState extends State<TenantOtherDetailsForm> {
  String? _photoWarning;
  String? _documentWarning;
  File? _photoFileName;
  File? _documentFileName;

  bool _areFilesUploaded() {
    return _photoFileName != null && _documentFileName != null;
  }

    Future<void> _uploadPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileSize = await file.length();

      final fileExtension = pickedFile.path.split('.').last.toLowerCase();

      if (fileSize > 250 * 1024) {
        setState(() {
          _photoWarning = 'Photo must not exceed 250KB.';
          _photoFileName = null;
        });
      } else if (fileExtension != 'jpg' &&
          fileExtension != 'jpeg' &&
          fileExtension != 'png') {
        setState(() {
          _photoWarning = 'Only JPG and PNG files are allowed.';
          _photoFileName = null;
        });
      } else {
        setState(() {
          _photoWarning = null;
          _photoFileName = file;
          // widget.onPhotoUploaded(_photoFileName);
          widget.onPhotoUploaded(pickedFile.name);
        });
      }
    } else {
      setState(() {
        _photoWarning = 'No photo selected.';
        _photoFileName = null;
      });
    }
  }

  Future<void> _uploadDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      final file = File(result.files.first.path!);
      final fileSize = await file.length();

      if (fileSize > 21150 * 1024) { //250*1024
        setState(() {
          _documentWarning = 'Document must not exceed 250KB.';
          _documentFileName = null;
        });
      } else {
        setState(() {
          _documentWarning = null;
          _documentFileName = file;
          //widget.onDocumentUploaded(_documentFileName);
          widget.onDocumentUploaded(result.files.first.name);
        });
      }
    } else {
      setState(() {
        _documentWarning = 'No document selected.';
        _documentFileName = null;
      });
    }
  }


  @override
  void setState(fn) {
    super.setState(fn);
    widget.onFilesUploaded(_areFilesUploaded());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child:
                  Text('Upload Photograph\n(Maximum file size limit 250 kb)'),
            ),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _uploadPhoto,
                icon: const Icon(Icons.upload, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF3AC00),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                label: const Text(
                  'Choose file',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ),
          ],
        ),
        if (_photoFileName != null)
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            
            child: Image.file(
              _photoFileName!,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 8.0),
          //   child: Text(
          //     _photoFileName!,
          //     style: const TextStyle(color: Colors.blue),
          //   ),
          // ),
        if (_photoWarning != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              _photoWarning!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Expanded(
              child: Text(
                  'Upload Identification \n(Maximum file size limit 250 kb)'),
            ),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _uploadDocument,
                icon: const Icon(Icons.upload, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF3AC00),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                label: const Text(
                  'Choose file',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ),
          ],
        ),
        if (_documentFileName != null)
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '$_documentFileName',
              style: const TextStyle(color: Colors.blue),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 8.0),
          //   child: Text(
          //     _documentFileName!,
          //     style: const TextStyle(color: Colors.blue),
          //   ),
          // ),
        if (_documentWarning != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              _documentWarning!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
