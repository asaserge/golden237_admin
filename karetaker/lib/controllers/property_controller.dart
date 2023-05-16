import 'package:get/get.dart';

import '../utils/apis.dart';

class PropertyController extends GetxController{

  RxBool isLoading = false.obs;
  var propertyRentApartment = [].obs;
  var propertyRentStudio = [].obs;

  @override
  void onInit() {
    getPropertyForRentApartment();
    super.onInit();
  }

  getPropertyForRentApartment() async {
    try{
      isLoading(true);
      final res = await Apis
          .client
          .from('properties')
          .select('*, reviews(*)')
          .eq('type', 'Apartment');
      if(res != null){
        propertyRentApartment.value = res;
      }
    } finally {
      isLoading(false);
    }
  }

  getPropertyForRentStudio() async {
    try{
      isLoading(true);
      final res = await Apis
          .client
          .from('properties')
          .select('*, reviews(*)')
          .eq('type', 'Studio');
      if(res != null){
        propertyRentStudio.value = res;
      }
    } finally {
      isLoading(false);
    }
  }
}