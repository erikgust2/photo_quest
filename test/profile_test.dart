import 'package:flutter/cupertino.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:photo_quest/profile.dart';
import 'profile_test.mocks.dart';

@GenerateMocks([ProfilePageState])
Future<void> main() async{

  group('galleryTests', () {

  test('galleryIsEmptyNewUser', () {
    //mock object
    var mockProfile = MockProfilePageState();

    when(mockProfile.images).thenReturn([]);
    final imageList = mockProfile.images.toList();
    expect(imageList, List.empty());
  });

  test('galleryIsFilledWithNewImage', () {
    //mock object
    var mockProfile = MockProfilePageState();

    Image img = Image.network('https://lh6.googleusercontent.com/-_37FlWvZtTc/AAAAAAAAAAI/AAAAAAAAAC4/zIH2d5LkyAU/photo.jpg?sz=256');
    when(mockProfile.images).thenReturn([img]);
    final imageList = mockProfile.images.toList();
    expect(imageList.length, 1);
  });

  });


}