import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_quest/quest.dart';

void main(){
  ///    name: json["name"],
  ///    type: json["type"],
  ///     coordinate: json["coordinate"],
  ///     description: json["description"],
  ///     image: json["image"],
  ///     id: json["id"]

 final mockJson = [{"name":"Aivee","type":"byggnad","coordinate":"47.2299246, 36.878124","description":"target distributed supply-chains","image":"Snapple - Iced Tea Peach","id":'1'},
   {"name":"Voolia","type":"park","coordinate":"29.1556093, 36.878124","description":"streamline mission-critical systems","image":"Napkin Colour","id":'2'},
   {"name":"Avavee","type":"byggnad","coordinate":"9.939624, 36.878124","description":"embrace cross-media infrastructures","image":"Eggplant Italian","id":'3'},
   {"name":"Kaymbo","type":"park","coordinate":"14.22528, 36.878124","description":"transform visionary interfaces","image":"Wine - Sauvignon Blanc","id":'4'},
   {"name":"Twitterwire","type":"park","coordinate":"48.581467, 36.878124","description":"innovate front-end markets","image":"Steamers White","id":'5'},
   {"name":"Buzzster","type":"kyrka","coordinate":"37.0938859, 36.878124","description":"visualize bricks-and-clicks portals","image":"","id":'6'},
   {"name":"Livepath","type":"byggnad","coordinate":"49.441512, 36.878124","description":"deliver one-to-one architectures","image":"Beer - Upper Canada Lager","id":'7'},
   {"name":"Yodoo","type":"kyrka","coordinate":"7.470498, 36.878124","description":"architect front-end applications","image":"Butter Ripple - Phillips","id":'8'},
   {"name":"Voonyx","type":"kyrka","coordinate":"47.1427431, 36.878124","description":"engineer world-class content","image":"Clam Nectar","id":'9'},
   {"name":"Flipstorm","type":"byggnad","coordinate":"9.9234974, 36.878124","description":"visualize end-to-end eyeballs","image":"Foam Tray S2","id":'10'},
   {"name":"Brightdog","type":"kyrka","coordinate":"38.4, 36.878124","description":"recontextualize sexy metrics","image":"","id":'11'},
   {"name":"Mudo","type":"park","coordinate":"14.6927846, 36.878124","description":"productize world-class networks","image":"Chef Hat 20cm","id":'12'},
   {"name":"Layo","type":"park","coordinate":"39.7028389, 36.878124","description":"facilitate innovative partnerships","image":"Beer - Upper Canada Light","id":'13'},
   {"name":"Feedspan","type":"byggnad","coordinate":"36.7715984, 36.878124","description":"strategize cross-media vortals","image":"Mahi Mahi","id":'14'},
   {"name":"Bubbletube","type":"park","coordinate":"","description":"transition integrated partnerships","image":"Veal - Chops, Split, Frenched","id":'15'}];

 List<QuestNode> nodes = [];

  group("instantiate quests", (){

    for (int i = 0; i < 15; i++) {
      QuestNode node = QuestNode.fromJson(mockJson[i]);
      nodes.add(node);
    }

    test("instantiate quest from factory has correct id", (){
      expect(nodes[0].id, '1');
    });

    test("quest with empty image returns not found", (){
      nodes.forEach((node) {if (node.image.isEmpty){
        expect((node == nodes[5] || node == nodes[10]), true);
        expect(node.getImage(), "assets/images/notfound.png");
      }});
    });

    test("quest with image that has a whitespace returns not found", (){
      nodes[1].image = " ";
      nodes.forEach((node) {if (node.image.isEmpty){
        expect(nodes[1].getImage(), "assets/images/notfound.png");
      }});
    });

    test("quest overrides equals (sort of)", (){
        expect((nodes[0] == nodes[14]), identical(nodes[5].id, nodes[11].id));
    });

    test("get coordinate gets valid coordinate", (){
      expect(nodes[0].getCoordinates(), const LatLng(47.2299246, 36.878124));
    });

    test("get invalid coordinate gets zeroed coordinate", (){
      expect(nodes[14].getCoordinates(), const LatLng(0.0, 0.0));
    });
  });


}