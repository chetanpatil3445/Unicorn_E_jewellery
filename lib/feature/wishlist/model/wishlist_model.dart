import 'dart:convert';
import '../../products/model/product_model.dart'; // Purana product model import karein

WishlistResponse wishlistResponseFromJson(String str) => WishlistResponse.fromJson(json.decode(str));

class WishlistResponse {
  bool success;
  String message;
  WishlistData data;

  WishlistResponse({required this.success, required this.message, required this.data});

  factory WishlistResponse.fromJson(Map<String, dynamic> json) => WishlistResponse(
    success: json["success"],
    message: json["message"],
    data: WishlistData.fromJson(json["data"]),
  );
}

class WishlistData {
  List<WishlistItem> items;
  int count;

  WishlistData({required this.items, required this.count});

  factory WishlistData.fromJson(Map<String, dynamic> json) => WishlistData(
    items: List<WishlistItem>.from(json["items"].map((x) => WishlistItem.fromJson(x))),
    count: json["count"],
  );
}

class WishlistItem {
  String wishlistId;
  DateTime addedAt;
  num priceAtAddition;
  ProductDetails productDetails;
  CalculatedPrice calculatedPrice;
  Weights weights;
  List<ProductImage> imageUrls;

  WishlistItem({
    required this.wishlistId,
    required this.addedAt,
    required this.priceAtAddition,
    required this.productDetails,
    required this.calculatedPrice,
    required this.weights,
    required this.imageUrls,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) => WishlistItem(
    wishlistId: json["wishlist_id"],
    addedAt: DateTime.parse(json["added_at"]),
    priceAtAddition: json["price_at_addition"],
    productDetails: ProductDetails.fromJson(json["product_details"]),
    calculatedPrice: CalculatedPrice.fromJson(json["calculated_price"]),
    weights: Weights.fromJson(json["weights"]),
    imageUrls: List<ProductImage>.from(json["image_urls"].map((x) => ProductImage.fromJson(x))),
  );
}