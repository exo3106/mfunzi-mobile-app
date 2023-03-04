import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


class CarouselHome extends StatefulWidget {
  CarouselHome({Key? key}) : super(key: key);
  @override
  _CarouselHomeState createState() => _CarouselHomeState();
}


class _CarouselHomeState extends State<CarouselHome> {
  final Stream<QuerySnapshot> _streamImages = FirebaseFirestore.instance.collection('images').snapshots();
  final storageRef = FirebaseStorage.instance.ref().child("images");

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getSliderImageFromDb() async {
    var _fireStore = FirebaseFirestore.instance;
    int _dataLength;

    QuerySnapshot<Map<String,dynamic>> snapshot = await _fireStore.collection('images').get();
    if (mounted) {
      setState(() {
        _dataLength = snapshot.docs.length;
      });
    }
    return snapshot.docs;
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSliderImageFromDb(),
      builder: (BuildContext context, AsyncSnapshot<List<QueryDocumentSnapshot<Map<String, dynamic>>>> snapshot) {
        return snapshot.data == null
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : SizedBox(
                    width: 310,
                    height:200,
                    child: CarouselSlider.builder(
                        itemCount: snapshot.data?.length,
                        options: CarouselOptions(
                            viewportFraction: 1,
                            initialPage: 0,
                            height:165,
                            autoPlay: true,
                            autoPlayAnimationDuration:const Duration(milliseconds: 1500)
                        ),
                        itemBuilder: (BuildContext context, index, int) {
                          DocumentSnapshot sliderImage =
                          snapshot.data![index];
                          Map? getImage = sliderImage.data() as Map?;
                          return AnimatedContainer(
                              height:400,
                              duration: const Duration(milliseconds: 3000),
                              curve: Curves.easeInOutCubic,
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          getImage!['imageUrl']
                                      )
                                  )),
                            );
                        },
                    )
                );
      },
    );
  }
}

