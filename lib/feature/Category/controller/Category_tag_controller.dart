
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/apiUrls/api_urls.dart';
import '../../../core/utils/token_helper.dart';
import '../../products/model/product_model.dart';

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
         "tags": [selectedTag.value],
       };

       // Search Text implementation
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
         Uri.parse(ApiUrls.productListApi),
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

     // Controllers ko bhi saaf karna zaroori hai UI reset ke liye
     categoryController.clear();
     metalController.clear();
     minPriceController.clear();
     maxPriceController.clear();

     fetchStockItems();
   }

   @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    clearFilters();
  }

 }