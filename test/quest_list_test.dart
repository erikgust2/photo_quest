import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:photo_quest/quest.dart';
import 'package:photo_quest/quest_list.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'quest_list_test.mocks.dart';

@GenerateMocks([QuestNodeList])
Future<void> main() async {
  // Create mock object.
  var questList1 = MockQuestNodeList();

  group("location", () {

    test('Finding redundant invocations', () {
      when(questList1.getLocation()).thenAnswer((_) =>Future.value(const LatLng(0.0, 0.0)));
      questList1.getLocation();
      verify(questList1.getLocation()).called(1);
      verifyNoMoreInteractions(questList1);
    });

    test(
        "getLocation() should return an instance of LatLng on fetch success", () {
      final result = questList1.getLocation();
      expect(result, isInstanceOf<Future<LatLng>>());
    });



    test('GetDistance gets proper distance', () {
      const coord1 =LatLng(0.0, 0.0);
      const coord2 =LatLng(1.0, 1.0);
      when(questList1.getDistance(coord1, coord2))
          .thenReturn(Geolocator.distanceBetween(coord1.latitude, coord1.longitude, coord2.latitude, coord2.longitude).toString());
      expect(questList1.getDistance(coord1, coord2),
          Geolocator.distanceBetween(coord1.latitude, coord1.longitude, coord2.latitude, coord2.longitude).toString());
    });

    test('Seeing if location works somewhat', () async {
      when(questList1.getLocation()).thenAnswer((_) => Future.value(
          const LatLng(59.34596907543916, 18.052631969665576)
      ));
      expect(const LatLng(59.34596907543916, 18.052631969665576), await questList1.getLocation());
    });

  });

  var questList2 = MockQuestNodeList();

  group('testing quest completion', (){

    test('Verify list', () async {
      var node1 = QuestNode(description: '1', type: '1', name: '1', coordinate: '1', id: '1', image: '1');
      var node2 = QuestNode(description: '2', type: '2', name: '2', coordinate: '2', id: '2', image: '2');
      var node3 = QuestNode(description: '3', type: '3', name: '3', coordinate: '3', id: '3', image: '3');
      final list = [node1, node2, node3];
      when(questList2.getQuestNodes())
          .thenAnswer((value) {return list;});
      expect(questList2.getQuestNodes(), isA());
    });


    test('Verify completed list shows up properly', () async {
      when(questList1.clearCompletedList())
          .thenAnswer((value) async {return [];});
      expect(await questList1.clearCompletedList(), isA());
    });

  });

  final completed = QuestNodeList.completedQuests.toList();
  final available = QuestNodeList.availableQuests.toList();
  final selected = QuestNodeList.availableQuests.toList();

  test("testing complete nodes initializes empty", (){
    expect(completed, List.empty());
  }
  );

  test("testing available empty init", (){
    expect(available, List.empty());
  }
  );

  test("testing selected empty init", (){
    expect(selected, List.empty());
  }
  );

}