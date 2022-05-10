
class Searcher {

  static final Searcher INSTANCE = Searcher();
  static const String SELECTION_SIZE = "20"; //how many items searched for, but the parser limits items
                                            // to those with coordinates so less is actually returned.
  static const String MAP_SIZE = "20";      //honestly i dont know what MAP_SIZE does
  static const String BASE_URL = "http://kulturarvsdata.se/ksamsok/api?method=search";
  static const String SIZE = "&hitsPerPage=";

//static final String API_KEY = "&x-api=test";
  static const String API_KEY = "&x-api=test";
  static const String FROM = "&startRecord="; //unused
  static const String QUERY_COMMAND = "&query=text%3D";

  late String mQuery;
  late int mTotalResults;
  late String result;

  static Searcher getInstance() {
    return INSTANCE;
  }

  /*
   * Handles all primary searching in this application.
   * Combines the supplied parameters to a finished query string, which then is used to do the actual search.
  */

  String search(String query, String type, String coordinates) {
    bool isFirst = true;
      mQuery = "&query=";// @param query The text string supplied by the user
    if (query.isNotEmpty) {
        mQuery += "%22" +query.trim().replaceAll(" ", "%22+and+%22") +"%22";
        isFirst = false;
      }
    if (type.isNotEmpty && type != "type") {// @param type The chosen type: (Föremål, Byggnad, Kulturlämning, Konstverk, Kulturmiljö, Objekt)
      if (!isFirst) {
        mQuery += "+and+";
      } else {
        isFirst = false;
      }
      mQuery += "%20" + "itemType=" + type + "%20";
    }
    if (coordinates.isNotEmpty) {
      if (!isFirst) {
        mQuery += "+and+";
      } else {
        isFirst = false;
      }// @param coordinates A geo rectangle of the screen  (boundingBox=/WGS84+ ”väst syd ost nord”)
      mQuery += "boundingBox=/WGS84%20%22" + coordinates;
    }

    print(BASE_URL + SIZE + SELECTION_SIZE + API_KEY + mQuery); //double checks that URL is correct
    return BASE_URL + SIZE + SELECTION_SIZE + API_KEY + mQuery;
  }

}


