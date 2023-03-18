import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController{
  final storage = GetStorage();
  RxInt counter = 0.obs;

  @override
  void onReady() {
    counter = storage.read('counter') ?? 0.obs;
    super.onReady();
  }

}