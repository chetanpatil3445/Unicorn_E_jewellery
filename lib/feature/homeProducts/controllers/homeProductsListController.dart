
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicorn_e_jewellers/core/controller/AppDataController.dart';

import '../../../core/apiUrls/api_urls.dart';
import '../../../core/utils/token_helper.dart';
import '../../dashboard/controller/DashboardController.dart';
import '../../products/controller/stock_catalogue_controller.dart';
import '../../products/model/product_model.dart';
import '../../wishlist/controller/wishlist_controller.dart';

class homeProductsListController extends GetxController {

   var selectedTag = ''.obs;

   final ApiClient _apiClient = ApiClient();

   var stockItems = <Product>[].obs;
   var isLoading = true.obs;
   var isLoadMoreFetching = false.obs;
   var isGridView = true.obs;

   int _limit = 10;
   int _offset = 0;
   var hasMore = true.obs;

   var categoryFilter = ''.obs;
   var metalFilter = ''.obs;
   var minPriceFilter = ''.obs;
   var maxPriceFilter = ''.obs;

   late TextEditingController categoryController;
   late TextEditingController metalController;
   late TextEditingController minPriceController;
   late TextEditingController maxPriceController;

   void initFilterControllers() {
     categoryController = TextEditingController(text: categoryFilter.value);
     metalController = TextEditingController(text: metalFilter.value);
     minPriceController = TextEditingController(text: minPriceFilter.value);
     maxPriceController = TextEditingController(text: maxPriceFilter.value);
   }

   var searchText = ''.obs; // Search ke liye naya Rx variable
   late TextEditingController searchController;


   late String clickType;
   late int targetId;

   List<int> categories = [];
   List<int> tags = [];


   @override
   void onInit() {
     super.onInit();
     // Get arguments
     clickType = Get.arguments['click_type'] ?? '';
     targetId = Get.arguments['target_id'] ?? 0;

     // Populate lists based on clickType
     if (clickType.toLowerCase() == 'category') {
       categories = [targetId]; // Only categories get the value
       tags = [];               // Tags stay empty
     } else if (clickType.toLowerCase() == 'tag') {
       tags = [targetId];       // Only tags get the value
       categories = [];         // Categories stay empty
     } else {
       categories = [];
       tags = [];
     }

     searchController = TextEditingController();
     categoryController = TextEditingController();
     metalController = TextEditingController();
     minPriceController = TextEditingController();
     maxPriceController = TextEditingController();
   }



    final List<String> metalOptions = ["Gold", "Silver", "Platinum", "Rose Gold"];

   Future<void> fetchStockItems({bool isLoadMore = false}) async {
     if (isLoadMore && isLoadMoreFetching.value) return;

     if (!isLoadMore) {
       _offset = 0;
       stockItems.clear();
       isLoading.value = true;
       hasMore.value = true;
     } else {
       isLoadMoreFetching.value = true;
     }

     try {
       final Map<String, dynamic> bodyData = {
         "limit": _limit,
         "offset": _offset,
         "categories": categories,
         "tags": tags,
       };

        if (searchText.value.isNotEmpty) {
         bodyData["search_text"] = searchText.value;
       }

       if (categoryFilter.value.isNotEmpty) bodyData["categories"] = [categoryFilter.value];
       if (metalFilter.value.isNotEmpty) bodyData["metal_type"] = metalFilter.value;

       double? minP = double.tryParse(minPriceFilter.value);
       if (minP != null) bodyData["min_price"] = minP;

       double? maxP = double.tryParse(maxPriceFilter.value);
       if (maxP != null) bodyData["max_price"] = maxP;

       final response = await _apiClient.post(
         Uri.parse(ApiUrls.homeProductListApi),
         headers: {'Content-Type': 'application/json'},
         body: jsonEncode(bodyData),
       );

       if (response.statusCode == 200) {
         final productRes = productResponseFromJson(response.body);
         stockItems.addAll(productRes.data.products);
         hasMore.value = productRes.data.pagination.hasMore;
         _offset += _limit;
       }
     } catch (e) {
       print("Error fetching: $e");
     } finally {
       isLoading.value = false;
       isLoadMoreFetching.value = false;
     }
   }

   // Search trigger function
   void onSearchChanged(String value) {
     searchText.value = value;
     fetchStockItems(); // Ye automatically offset 0 kar dega isLoadMore false hone par
   }

   void toggleView() => isGridView.value = !isGridView.value;

   void applyFilters() {
     categoryFilter.value = categoryController.text;
     metalFilter.value = metalController.text;
     minPriceFilter.value = minPriceController.text;
     maxPriceFilter.value = maxPriceController.text;
     fetchStockItems();
   }

   void clearFilters() {
     categoryFilter.value = '';
     metalFilter.value = '';
     minPriceFilter.value = '';
     maxPriceFilter.value = '';

     // Late controllers ko check karke hi clear karein
     try {
       categoryController.clear();
       metalController.clear();
       minPriceController.clear();
       maxPriceController.clear();
     } catch (e) {
       // Agar initialize nahi huye toh crash nahi hoga
       print("Filters not initialized yet, skipping clear.");
     }

     fetchStockItems();
   }

   @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    clearFilters();
  }




   Future<void> toggleWishlist(Product item) async {
     final int ownerId = AppDataController.to.ownerId.value ?? 0;
     final String productId = item.productDetails.id;
     final bool wasWishlisted = item.isWishlisted;

     try {
       // 1. Current Controller UI Update (Optimistic)
       item.isWishlisted = !wasWishlisted;
       stockItems.refresh();

       // 2. Dusre Controllers mein bhi turant UI update karein (Sync)
       _syncOtherControllers(productId, item.isWishlisted);

       dynamic response;
       if (!wasWishlisted) {
         response = await _apiClient.post(
           Uri.parse(ApiUrls.wishlistAddApi),
           headers: {'Content-Type': 'application/json'},
           body: jsonEncode({"product_id": int.parse(productId), "jeweller_id": ownerId}),
         );
       } else {
         response = await _apiClient.delete(
           Uri.parse("${ApiUrls.wishlistDeleteApi}/$productId"),
           headers: {'Content-Type': 'application/json'},
         );
       }

       final Map<String, dynamic> responseData = jsonDecode(response.body);

       if ((response.statusCode == 200 || response.statusCode == 201) && responseData['success'] == true) {

         // 3. Wishlist Page ki list update karein
         if (Get.isRegistered<WishlistController>()) {
           final wishCtrl = Get.find<WishlistController>();
           if (!wasWishlisted) {
             wishCtrl.fetchWishlist(); // Naya item add hua toh list refresh karein
           } else {
             wishCtrl.wishlistItems.removeWhere((w) => w.productDetails.id == productId);
           }
         }

         Get.rawSnackbar(
           message: responseData['message'] ?? "Wishlist updated",
           snackPosition: SnackPosition.BOTTOM,
           duration: const Duration(milliseconds: 900),
           backgroundColor: Colors.black87,
         );
       } else {
         throw responseData['message'] ?? "Server error";
       }
     } catch (e) {
       // 4. Rollback: Agar fail hua toh sab jagah wapas purana state
       item.isWishlisted = wasWishlisted;
       stockItems.refresh();
       _syncOtherControllers(productId, wasWishlisted);

       Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
     }
   }

   void _syncOtherControllers(String productId, bool status) {
     if (Get.isRegistered<ProductCatalogueController>()) {
      final catCtrl = Get.find<ProductCatalogueController>();
      int index = catCtrl.stockItems.indexWhere((p) => p.productDetails.id == productId);
      if (index != -1) {
        catCtrl.stockItems[index].isWishlisted = status;
        catCtrl.stockItems.refresh();
      }
    }

    // Sync Tag Controller (Agar ye function TagController ke bahar hai toh)
    if (Get.isRegistered<homeProductsListController>()) {
      final tagCtrl = Get.find<homeProductsListController>();
      int index = tagCtrl.stockItems.indexWhere((p) => p.productDetails.id == productId);
      if (index != -1) {
        tagCtrl.stockItems[index].isWishlisted = status;
        tagCtrl.stockItems.refresh();
      }
    }

     // 1. Dashboard Controller (Homepage sections) sync karein 🌟
     if (Get.isRegistered<DashboardController>()) {
       final dashCtrl = Get.find<DashboardController>();

       // Dashboard mein 'sectionProducts' ek Map hai, har list ko check karna hoga
       dashCtrl.sectionProducts.forEach((key, list) {
         for (var p in list) {
           if (p.productDetails.id == productId) {
             p.isWishlisted = status;
           }
         }
       });
       dashCtrl.sectionProducts.refresh(); // UI update trigger karein
     }
  }
 }