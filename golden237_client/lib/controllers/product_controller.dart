import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/apis.dart';

class ProductController extends GetxController {

  var isLoading = true.obs;
  RxDouble starSum = 0.0.obs;
  RxInt rowCount = 0.obs;
  RxInt userCount = 0.obs;
  RxString userId = ''.obs;
  var productListTrending = [].obs;
  var productListAuthentic = [].obs;
  var productListRecommended = [].obs;
  var productListCheap = [].obs;
  var productListPromo = [].obs;

  var productReviewList = [].obs;

  List<String> searchSuggestions = [];

  @override
  void onInit() {
    super.onInit();
    fetchTrendingProducts();
    fetchAuthenticProducts();
    fetchCheapProducts();
    fetchPromoProducts();
    fetchRecommendedProducts();
    loadSearchSuggestions();
  }

  getProductRowCount(String prodId) async {
    try{
      isLoading(true);
      final response = await Apis
          .client
          .from('rating')
          .select('stars', const FetchOptions(count: CountOption.exact))
          .eq('product', prodId)
          .single();
      if(response != null){
        print('\n\n\n$response');
        rowCount.value = response;
      }
    } finally {
      isLoading(false);
    }
  }

  getProductUserId(String prodId) async {
    try{
      isLoading(true);
      final response = await Apis
          .client
          .from('rating')
          .select('profiles')
          .eq('product', prodId)
          .eq('product', prodId)
          .single();
      if(response != null){
        print('\n\n\n$response');
        rowCount.value = response;
      }
    } finally {
      isLoading(false);
    }
  }

  fetchTrendingProducts() async {
    try{
      isLoading(true);
      final response = await Apis
          .client
          .from('product')
          .select('*, category(*, main_category(*))')
          .order('sold', ascending: true);
      if(response != null){
        productListTrending.value = response;
      }
    } finally {
      isLoading(false);
    }
  }

  fetchAuthenticProducts() async {
    try{
      isLoading(true);
      final response = await Apis
          .client
          .from('product')
          .select('*, category(*, main_category(*))')
          .order('sold', ascending: true);
      if(response != null){
        productListAuthentic.value = response;
      }
    } finally {
      isLoading(false);
    }
  }

  fetchRecommendedProducts() async {
    try{
      isLoading(true);
      final response = await Apis
          .client
          .from('product')
          .select('*, category(*, main_category(*))')
          .order('sku', ascending: true);
      if(response != null){
        productListRecommended.value = response;
      }
    } finally {
      isLoading(false);
    }
  }

  fetchCheapProducts() async {
    try{
      isLoading(true);
      final response = await Apis
          .client
          .from('product')
          .select('*, category(*, main_category(*))')
          .order('price', ascending: true);
      if(response != null){
        productListCheap.value = response;
      }
    } finally {
      isLoading(false);
    }
  }

  fetchPromoProducts() async {
    try{
      isLoading(true);
      final response = await Apis
          .client
          .from('product')
          .select('*, category(*, main_category(*))')
          .gt('discount', 0)
          .order('discount', ascending: true);
      if(response != null){
        productListPromo.value = response;
      }
    } finally {
      isLoading(false);
    }
  }



  fetchProductReview(String productId) async {
    final response = await Apis
        .client
        .from('rating')
        .select('*, profiles(*), product(*))')
        .eq('product', productId)
        .order('created_at', ascending: true);
    return response;
  }

  fetchCategorisedProducts(String id) async {
      final response = await Apis
          .client
          .from('product')
          .select('*, category(*)')
          .eq('category:', id);
      return response;
  }

  loadSearchSuggestions(){
    for(int i = 0; i < productListRecommended.length; i++){
      searchSuggestions = productListRecommended[i]['name'];
    }
  }

}