
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mfunzi/res/custom_colors.dart';
import 'package:mfunzi/services/storageAPI.dart';
import 'package:mfunzi/utils/pdfView.dart';

import '../models/storageFileModel.dart';



class StorageFiles extends StatefulWidget {
  const StorageFiles ({Key? key}) : super(key: key);


  @override
  _StorageFilesState createState() => _StorageFilesState();
}
class _StorageFilesState extends State<StorageFiles> {
  Future<List<FirebaseFile>> futureFiles = StorageMethods.listAll('articles/');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 200,
      child: FutureBuilder<List<FirebaseFile>>(
        future: futureFiles,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Center(child: Text('Some error occurred!'));
              } else {
                final files = snapshot.data;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        itemCount: files?.length,
                        itemBuilder: (context, index) {
                          final file = files![index];
                          return buildFile(context, file);
                        },
                      ),
                    ),
                  ],
                );
              }
          }
        },
      ),
    );
  }

  Widget buildFile(BuildContext context, FirebaseFile file) =>
      ListTile(
        leading: SizedBox(
            height:30,
            width: 30,
            child:Image.asset("assets/icon/icons/ic_Folder.png",color: CustomColors.firebaseNavy,)
        ),
        title: Text(
          file.name, style: TextStyle(
            fontSize: 12,
            color: CustomColors.firebaseNavy,
            fontWeight: FontWeight.w700,
            fontFamily: "NotoSans"
        ),
        ),
        onTap: () =>
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomePageFile(path: file.url),
            )),
      );
}