import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';

import '../models/message_model.dart';
import '../models/profile_model.dart';
import '../utils/apis.dart';

class SettingsController extends GetxController {

  final storage = GetStorage();
  RxBool isDarkMode = false.obs;
  RxBool isLocation = true.obs;
  RxBool isSaveAddress = true.obs;
  RxBool isDisabled = true.obs;

  late final Stream<List<Message>> messagesStream;
  final RxMap profileCache = {}.obs;

  RxString currentSelectedRegion = 'South West'.obs;
  RxString currentSelectedTown = 'Buea'.obs;

  @override
  void onInit() {

    super.onInit();
  }

}