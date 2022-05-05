
class Searcher {

  static final Searcher INSTANCE = Searcher();
  static const String SELECTION_SIZE = "20";
  static const String MAP_SIZE = "20";
  static const String BASE_URL = "http://kulturarvsdata.se/ksamsok/api?method=search";
  static const String SIZE = "&hitsPerPage=";

//static final String API_KEY = "&x-api=test";
  static const String API_KEY = "&x-api=test";
  static const String FROM = "&startRecord=";
  static const String QUERY_COMMAND = "&query=text%3D";

  late String mQuery;
  late int mTotalResults;
  late String result;

  static Searcher getInstance() {
    return INSTANCE;
  }

  /**
   * Handles all primary searching in this application.
   * Combines the supplied parameters to a finished query string, which then
   * is used to do the actual search.
   * @param query The text string supplied by the user
   * @param type The chosen type: (Föremål, Byggnad, Kulturlämning, Konstverk, Kulturmiljö, Objekt)
   * @param coordinates A geo rectangle of the screen  (boundingBox=/WGS84+ ”väst syd ost nord”)
  */

  String search(String query, String type, String coordinates) {
    bool isFirst = true;
      mQuery = "&query=";
    if (query.isNotEmpty) {
        mQuery += query;
        isFirst = false;
      }
    if (type.isNotEmpty) {
      if (!isFirst) {
        mQuery += "+and+";
      }
      mQuery += "itemType=" + type;
    }
    if (coordinates.isNotEmpty) {
      if (!isFirst) {
        mQuery += "+and+";
      } else {
        isFirst = false;
      }
      mQuery += "boundingBox=" + coordinates;
    }
    mQuery+= "+and+geoDataExists='j'";
    return BASE_URL + SIZE + SELECTION_SIZE + API_KEY + mQuery;
  }

}


