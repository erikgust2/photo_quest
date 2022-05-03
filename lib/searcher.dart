
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
   * @param type The chosen type
   * @param milieu The chosen milieu
   * @param coordinates A geo rectangle of the screen
   * @return -1 for error 0 for no data, and 1 for when the search was a success.
   */
  void search(String query, String type,
      String milieu, String coordinates) {
    bool isFirst = true;
    if ("" != query) {
      mQuery = "&query=text%3D";
      mQuery += "%22" + query.trim().replaceAll(" ", "%22+and+%22") + "%22";
      isFirst = false;
    }
    else {
      mQuery = "&query=";
    }
    if (milieu == "Byggnader") {
      if (!isFirst) {
        mQuery += "+and+";
      } else {
        isFirst = false;
      }
      mQuery += "%22bbrb%22";
    }
    if (milieu == "Fornlämningar") {
      if (!isFirst) {
        mQuery += "+and+";
      } else {
        isFirst = false;
      }
      mQuery += "%22fmi%22";
    }
    if (coordinates != null) {
      if (!isFirst) {
        mQuery += "+and+";
      } else {
        isFirst = false;
      }
      mQuery += "boundingBox=/WGS84+" + coordinates;
    }
    if (type == "Föremål") {
      if (!isFirst) {
        mQuery += "+and+";
      } else {
        isFirst = false;
      }
      mQuery += "itemType=%22objekt/f%C3%B6rem%C3%A5l%22";
    }
    if (type == "Platser") {
      if (!isFirst) {
        mQuery += "+and+";
      } else {
        isFirst = false;
      }
      mQuery += "+itemType=%22milj%C3%B6%22";
    }
    result = BASE_URL + SIZE + SELECTION_SIZE + API_KEY + mQuery;
  }

  String getSearchURL(){return result;}
}


