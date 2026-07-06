import 'package:get/get.dart';

import '../models/recipe_model.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class HomeController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  final RxList<Recipe> recipes = <Recipe>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxInt currentTabIndex = 0.obs;

  String get userName => _storageService.userName;
  String get userEmail => _storageService.userEmail;

  @override
  void onInit() {
    super.onInit();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await _apiService.fetchRecipes();
      recipes.assignAll(response.recipes);
    } catch (e) {
      errorMessage.value = e is ApiException
          ? e.message
          : 'Something went wrong. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int index) => currentTabIndex.value = index;

  Future<void> logout() async {
    await _storageService.clearSession();
    Get.offAllNamed(Routes.auth);
  }
}
