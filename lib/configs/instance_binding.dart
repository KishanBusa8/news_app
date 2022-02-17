import 'package:get/get.dart';
import 'package:news_app/Services/api_service.dart';
import 'package:news_app/Services/google_sign_in.dart';

class InstanceBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<GoogleAuth>(() => GoogleAuth());
    Get.lazyPut<ApiService>(() => ApiService());
  }
}
