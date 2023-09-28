import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/gallery_image_model.dart';


final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference SliderImageCollection = firestore.collection('SliderImages');
final CollectionReference GalleryImageCollection = firestore.collection('GalleryImages');
class GalleryFireCrud {

  static Stream<List<GalleryImageModel>> fetchSliderImages() => SliderImageCollection
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) =>
          GalleryImageModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList()
  );

  static Stream<List<GalleryImageModel>> fetchGalleryImages() => GalleryImageCollection
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) =>
          GalleryImageModel.fromJson(doc.data() as Map<String,dynamic>)).toList()
  );


}