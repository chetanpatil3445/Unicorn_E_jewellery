
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicorn_e_jewellers/core/controller/AppDataController.dart';

import '../../../Routes/app_routes.dart';
import '../../../core/apiUrls/api_urls.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/utils/token_helper.dart';
import '../../dashboard/controller/DashboardController.dart';
import '../../products/controller/stock_catalogue_controller.dart';
import '../../products/model/product_model.dart';
import '../../wishlist/controller/wishlist_controller.dart';

class TagController extends GetxController {
   var categorizedTags = <String, List<String>>{
    'Highlights': [
      'Trending', 'Best Seller', 'Recommended', 'New Arrival', 'Hot Deal',
      'Limited Stock', 'Fast Selling', 'Top Rated', 'Most Viewed',
      'Customer Favorite', 'Staff Pick'
    ],
    'Offers': [
      'On Sale', 'Discounted', 'Budget Friendly', 'Premium Collection',
      'Luxury Range', 'Clearance Sale', 'Festive Offer'
    ],
    'Occasions': [
      'Wedding Special', 'Bridal Collection', 'Engagement Special',
      'Party Wear', 'Daily Wear', 'Festival Special', 'Anniversary Gift',
      'Gift Ready', 'Festive Collection'
    ],
    'Material': [
      'Hallmarked Gold', 'Pure Silver', 'Diamond Jewellery',
      'Lightweight Jewellery', 'Heavy Bridal Set', 'Handmade',
      'Designer Collection', 'Antique Finish'
    ],
    'Style': [
      'Minimal Design', 'Traditional Look', 'Modern Style',
      'Vintage Collection', 'Celebrity Inspired', 'Ethnic Wear',
      'Statement Jewellery'
    ],
    'Festivals': [
      'Diwali Collection', 'Dussehra Special', 'Navratri Special',
      'Raksha Bandhan Gifts', 'Ganesh Chaturthi Special', 'Karva Chauth Collection',
      'Eid Special', 'Holi Collection', 'Christmas Collection', 'Pongal Special',
      'Baisakhi Special', 'Onam Collection', 'New Year Special', 'Republic Day Collection',
      'Independence Day Collection', 'Makar Sankranti Collection', 'Gudi Padwa Collection',
      'Vishu Collection', 'Easter Special', 'Mahashivratri Special', 'Janmashtami Collection',
      'Good Friday Special', 'Wedding Season Collection'
    ],
    'Stock Status': [
      'Pre Order', 'Coming Soon', 'Low Stock', 'In Stock'
    ],
  }.obs;

  var selectedCategory = 'Highlights'.obs;
  var selectedTag = ''.obs;
  var gender = ''.obs;

  void selectCategory(String category) {
    selectedCategory.value = category;
    categorizedTags.refresh(); // Force refresh for UI safety
  }






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

   @override
   void onInit() {
     super.onInit();
     searchController = TextEditingController();
     categoryController = TextEditingController();
     metalController = TextEditingController();
     minPriceController = TextEditingController();
     maxPriceController = TextEditingController();
   }





   var selectedMetal = "Gold".obs; // Default value
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
         // "tags": [selectedTag.value],
       };

       // Search Text implementation
       if (searchText.value.isNotEmpty) {
         bodyData["search_text"] = searchText.value;
       }

       if (categoryFilter.value.isNotEmpty) bodyData["categories"] = [categoryFilter.value];
       if (metalFilter.value.isNotEmpty) bodyData["metal_type"] = metalFilter.value;
       if (gender.value.isNotEmpty) bodyData["gender"] = gender.value;
       if (selectedTag.value.isNotEmpty) bodyData["tags"] = [selectedTag.value];

       double? minP = double.tryParse(minPriceFilter.value);
       if (minP != null) bodyData["min_price"] = minP;

       double? maxP = double.tryParse(maxPriceFilter.value);
       if (maxP != null) bodyData["max_price"] = maxP;

       print(bodyData);

       final response = await _apiClient.post(
         Uri.parse(ApiUrls.productListApi),
         headers: {'Content-Type': 'application/json'},
         body: jsonEncode(bodyData),
       );

       // if (response.statusCode == 200) {
       //   final productRes = productResponseFromJson(response.body);
       //   stockItems.addAll(productRes.data.products);
       //   hasMore.value = productRes.data.pagination.hasMore;
       //   _offset += _limit;
       // }
       if (response.statusCode == 200) {
         final productRes = productResponseFromJson(response.body);

         final newProducts = productRes.data.products.where((newItem) {
           return !stockItems.any((oldItem) => oldItem.productDetails.id == newItem.productDetails.id);
         }).toList();

         stockItems.addAll(newProducts);

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
    if (Get.isRegistered<TagController>()) {
      final tagCtrl = Get.find<TagController>();
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




// Theme color constant
  static const Color goldAccent = Color(0xFFD4AF37);

  Future<void> addToCart(Product item) async {
    final String productId = item.productDetails.id;
    if (item.isInCart) {
      Get.toNamed(AppRoutes.cartPage);
      return;
    }

    try {
      // 1. Optimistic UI Update
      item.isInCart = true;
      stockItems.refresh();

      // 2. Sync with other controllers (Dashboard/Catalogue)
      _syncCartStatus(productId, true);

      final response = await _apiClient.post(
        Uri.parse(ApiUrls.cartAddApi),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"item_id": int.parse(productId)}),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw "Failed to add";
      }

      Get.rawSnackbar(
        message: "Added to Bag",
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.black87,
        mainButton: TextButton(
          onPressed: () => Get.toNamed(AppRoutes.cartPage),
          child: const Text("VIEW", style: TextStyle(color: goldAccent, fontWeight: FontWeight.bold)),
        ),
      );
    } catch (e) {
      // Rollback
      item.isInCart = false;
      stockItems.refresh();
      _syncCartStatus(productId, false);
      Get.snackbar("Error", "Could not add to cart");
    }
  }

  void _syncCartStatus(String productId, bool status) {
    // Sync with Catalogue
    if (Get.isRegistered<ProductCatalogueController>()) {
      final catCtrl = Get.find<ProductCatalogueController>();
      int idx = catCtrl.stockItems.indexWhere((p) => p.productDetails.id == productId);
      if (idx != -1) {
        catCtrl.stockItems[idx].isInCart = status;
        catCtrl.stockItems.refresh();
      }
    }
    // Sync with Dashboard
    if (Get.isRegistered<DashboardController>()) {
      final dashCtrl = Get.find<DashboardController>();
      dashCtrl.sectionProducts.forEach((key, list) {
        for (var p in list) {
          if (p.productDetails.id == productId) p.isInCart = status;
        }
      });
      dashCtrl.sectionProducts.refresh();
    }
  }
}