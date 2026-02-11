import 'dart:convert';

ProductResponse productResponseFromJson(String str) => ProductResponse.fromJson(json.decode(str));

class ProductResponse {
  bool success;
  String message;
  Data data;

  ProductResponse({required this.success, required this.message, required this.data});

  factory ProductResponse.fromJson(Map<String, dynamic> json) => ProductResponse(
    success: json["success"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );
}

class Data {
  List<Product> products;
  Pagination pagination;

  Data({required this.products, required this.pagination});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    pagination: Pagination.fromJson(json["pagination"]),
  );
}

class Product {
  ProductDetails productDetails;
  CalculatedPrice calculatedPrice;
  Weights weights;
  List<ProductImage> imageUrls;
  bool isWishlisted;
  bool isInCart;

  Product({
    required this.productDetails,
    required this.calculatedPrice,
    required this.weights,
    required this.imageUrls,
    required this.isWishlisted,
    required this.isInCart,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    productDetails: ProductDetails.fromJson(json["product_details"]),
    calculatedPrice: CalculatedPrice.fromJson(json["calculated_price"]),
    weights: Weights.fromJson(json["weights"]),
    imageUrls: List<ProductImage>.from(json["image_urls"].map((x) => ProductImage.fromJson(x))),
    isWishlisted: json["is_wishlisted"] ?? false,
    isInCart: json["is_in_cart"] ?? false,
  );
}

class ProductDetails {
  String id;
  String status;
  String productName;
  String productCode;
  String metalType;
  String category;
  String? weightUnit;

  ProductDetails({required this.id,required this.status, required this.productName,required this.productCode, required this.metalType, required this.category, this.weightUnit});

  factory ProductDetails.fromJson(Map<String, dynamic> json) => ProductDetails(
    id: json["id"],
    status: json["status"],
    productName: json["product_name"],
    productCode: json["product_code"],
    category: json["category"],
    metalType: json["metal_type"],
    weightUnit: json["weight_unit"],
  );
}

class CalculatedPrice {
  num totalValuation;

  CalculatedPrice({required this.totalValuation});

  factory CalculatedPrice.fromJson(Map<String, dynamic> json) => CalculatedPrice(
    totalValuation: json["total_valuation"],
  );
}

class Weights {
  String grossWeight;

  Weights({required this.grossWeight});

  factory Weights.fromJson(Map<String, dynamic> json) => Weights(
    grossWeight: json["gross_weight"],
  );
}

class Pagination {
  int total;
  int limit;
  int offset;
  bool hasMore;

  Pagination({required this.total, required this.limit, required this.offset, required this.hasMore});

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    total: json["total"],
    limit: json["limit"],
    offset: json["offset"],
    hasMore: json["has_more"],
  );
}

class ProductImage {
  String imageUrl;

  ProductImage({required this.imageUrl});

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
    imageUrl: json["image_url"] ?? "",
  );
}