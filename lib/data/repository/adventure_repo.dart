import 'package:senior_flutter_challenge/data/models/hyll_adventures_model.dart';

import '../../api_service/api_service.dart';
import '../../api_service/apis_path.dart';

class AdventureRepository {
  static Future<HyllAdventuresModel> getAdventures(
      {required String nextUrl}) async {
    try {
    String url = ApiPaths.adventureApiInitialPath;
    if (nextUrl.isNotEmpty) url = nextUrl;

    final response = await ApiService.instance.getData(url);

    HyllAdventuresModel hyllAdventuresModel =
        HyllAdventuresModel.fromJson(response);

    return hyllAdventuresModel;
    } catch (e) {
      rethrow;
    }
  }
}
