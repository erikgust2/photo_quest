
class Searcher {

  static final Searcher INSTANCE = Searcher();
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

  String search(String query, String type, String quantity, String coordinates) {
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

    print(BASE_URL + SIZE + quantity + API_KEY + mQuery); //double checks that URL is correct
    return BASE_URL + SIZE + quantity + API_KEY + mQuery;
  }

}


