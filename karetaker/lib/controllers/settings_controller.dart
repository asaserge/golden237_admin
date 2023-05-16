import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';

import '../utils/apis.dart';

class SettingsController extends GetxController {

  final storage = GetStorage();
  RxBool isDarkMode = false.obs;
  RxBool isLocation = true.obs;
  RxBool isSaveAddress = true.obs;
  RxBool isDisabled = true.obs;

  final RxMap profileCache = {}.obs;

  RxString currentSelectedRegion = 'South West'.obs;
  RxString currentSelectedTown = 'Buea'.obs;

  @override
  void onInit() {

    super.onInit();
  }

}