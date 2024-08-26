import 'package:get/get.dart';
import 'package:webui/helper/services/api_client.dart';

class ODPService extends ApiClient {
  Future<Response> getAllODPsByAdmin() async {
    try {
      var response = await get(
        "odp/odps",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getODPByAdmin(id) async {
    try {
      var response = await get(
        "odp/odps/$id",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

}
