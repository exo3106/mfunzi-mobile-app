import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../models/storageFileModel.dart';


import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


// class PDFView extends StatefulWidget {
//   const PDFView({Key? key, required this.file}) : super(key: key);
//   final FirebaseFile file;
//   @override
//   _PDFViewState createState() => _PDFViewState();
// }
//
// class _PDFViewState extends State<PDFView> {
//   final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.file.name.toString()),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(
//               Icons.bookmark,
//               color: Colors.white,
//               semanticLabel: 'Bookmark',
//             ),
//             onPressed: () {
//               _pdfViewerKey.currentState?.openBookmarkView();
//             },
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: SfPdfViewer.network(
//           widget.file.url,
//           key: _pdfViewerKey,
//           onDocumentLoaded: (PdfDocumentLoadedDetails){
//
//           },
//           onDocumentLoadFailed:(PdfDocumentLoadFailedDetails){
//             print( "Error: ${PdfDocumentLoadFailedDetails.description}");
//           },
//         ),
//       )
//     );
//   }
// }

/// Represents Homepage for Navigation
class HomePageFile extends StatefulWidget {
  const HomePageFile({Key? key,required this.path}) : super(key: key);
  final String path;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageFile> {
  Uint8List? _documentBytes;

  @override
  void initState() {
    getPdfBytes();
    super.initState();
  }

  void getPdfBytes() async {
    if (kIsWeb) {
      firebase_storage.Reference pdfRef =
      firebase_storage.FirebaseStorage.instanceFor(
          bucket: 'mfunzi-app-264be.appspot.com')
          .refFromURL(widget.path);
      //size mentioned here is max size to download from firebase.
      await pdfRef.getData(104857600).then((value) {
        _documentBytes = value;
        setState(() {});
      });
    } else {
      HttpClient client = HttpClient();
      final Uri url = Uri.base.resolve(widget.path);
      final HttpClientRequest request = await client.getUrl(url);
      final HttpClientResponse response = await request.close();
      _documentBytes = await consolidateHttpClientResponseBytes(response);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = const Center(child: CircularProgressIndicator());
    if (_documentBytes != null) {
      child = SfPdfViewer.memory(
        _documentBytes!,
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Document Viewer")),
      body: child,
    );
  }
}
