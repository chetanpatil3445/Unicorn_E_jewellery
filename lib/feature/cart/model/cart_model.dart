import 'dart:convert';

CartResponse cartResponseFromJson(String str) => CartResponse.fromJson(json.decode(str));

class CartResponse {
  bool success;
  String message;
  CartData data;

  CartResponse({required this.success, required this.message, required this.data});

  factory CartResponse.fromJson(Map<String, dynamic> json) => CartResponse(
    success: json["success"],
    message: json["message"],
    data: CartData.fromJson(json["data"]),
  );
}

class CartData {
  List<CartItem> items;
  int count;
  double cartTotal;

  CartData({required this.items, required this.count, required this.cartTotal});

  factory CartData.fromJson(Map<String, dynamic> json) => CartData(
    items: List<CartItem>.from(json["items"].map((x) => CartItem.fromJson(x))),
    count: json["count"] ?? 0,
    cartTotal: (json["cart_total"] as num).toDouble(),
  );
}

class CartItem {
  int cartId;
  double priceAtAdded;
  ItemDetails itemDetails;
  List<ImageUrl> imageUrls;
  double priceDiff;
  double itemTotal;

  CartItem({
    required this.cartId,
    required this.priceAtAdded,
    required this.itemDetails,
    required this.imageUrls,
    required this.priceDiff,
    required this.itemTotal,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    cartId: json["cart_id"],
    priceAtAdded: (json["price_at_added"] as num).toDouble(),
    itemDetails: ItemDetails.fromJson(json["item_details"]),
    imageUrls: List<ImageUrl>.from(json["image_urls"].map((x) => ImageUrl.fromJson(x))),
    priceDiff: (json["price_diff"] as num).toDouble(),
    itemTotal: (json["item_total"] as num).toDouble(),
  );
}

class ItemDetails {
  String id;
  String productName;
  String productCode;
  String metalType;
  String category;
  String weight;

  ItemDetails({required this.id, required this.productName,required this.productCode, required this.metalType, required this.category, required this.weight});

  factory ItemDetails.fromJson(Map<String, dynamic> json) => ItemDetails(
    id: json["id"].toString(),
    productName: json["product_name"],
    productCode: json["product_code"],
    metalType: json["metal_type"],
    category: json["category"],
    weight: json["weight_unit"] ?? "GM",
  );
}

class ImageUrl {
  String imageUrl;
  ImageUrl({required this.imageUrl});
  factory ImageUrl.fromJson(Map<String, dynamic> json) => ImageUrl(imageUrl: json["image_url"]);
}