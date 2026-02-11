import 'dart:convert';

ProductDetailResponse productDetailResponseFromJson(String str) => ProductDetailResponse.fromJson(json.decode(str));

class ProductDetailResponse {
  final bool success;
  final String message;
  final StockData data;

  ProductDetailResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProductDetailResponse.fromJson(Map<String, dynamic> json) => ProductDetailResponse(
    success: json["success"] ?? false,
    message: json["message"] ?? "",
    data: StockData.fromJson(json["data"]),
  );
}

class StockData {
  final ProductDetails productDetails;
  final CalculatedPrice calculatedPrice;
  final Weights weights;
  final List<ProductImage> images;
  final List<Stone> stones;
  bool isWishlisted;
  bool isInCart;

  StockData({
    required this.productDetails,
    required this.calculatedPrice,
    required this.weights,
    required this.images,
    required this.stones,
    required this.isWishlisted,
    required this.isInCart,
  });

  factory StockData.fromJson(Map<String, dynamic> json) => StockData(
    productDetails: ProductDetails.fromJson(json["product_details"]),
    calculatedPrice: CalculatedPrice.fromJson(json["calculated_price"]),
    weights: Weights.fromJson(json["weights"]),
    images: List<ProductImage>.from(json["images"].map((x) => ProductImage.fromJson(x))),
    stones: List<Stone>.from(json["stones"].map((x) => Stone.fromJson(x))),
    isWishlisted: json["is_wishlisted"] ?? false,
    isInCart: json["is_in_cart"] ?? false,
  );
}

class ProductDetails {
  final String id;
  final String status;
  final int? refId;
  final String? sourceType;
  final String? productCode;
  final String? metalType;
  final String? barcode;
  final String? huid;
  final String? productName;
  final String? category;
  final String? modelNo;
  final String? weightUnit;
  final String? purity;
  final String? finalPurity;
  final String? wstg;
  final String? custWstg;
  final String? makingUnit;
  final String? labourUnit;
  final String? valuationOnWeight;
  final String? taxPercent;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductDetails({
    required this.id,
    required this.status,
    this.refId,
    this.sourceType,
    this.productCode,
    this.metalType,
    this.barcode,
    this.huid,
    this.productName,
    this.category,
    this.modelNo,
    this.weightUnit,
    this.purity,
    this.finalPurity,
    this.wstg,
    this.custWstg,
    this.makingUnit,
    this.labourUnit,
    this.valuationOnWeight,
    this.taxPercent,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) => ProductDetails(
    id: json["id"].toString(),
    status: json["status"].toString(),
    refId: json["ref_id"],
    sourceType: json["source_type"],
    productCode: json["product_code"],
    metalType: json["metal_type"],
    barcode: json["barcode"],
    huid: json["huid"],
    productName: json["product_name"],
    category: json["category"],
    modelNo: json["model_no"],
    weightUnit: json["weight_unit"],
    purity: json["purity"],
    finalPurity: json["final_purity"],
    wstg: json["wstg"],
    custWstg: json["cust_wstg"],
    makingUnit: json["making_unit"],
    labourUnit: json["labour_unit"],
    valuationOnWeight: json["valuation_on_weight"],
    taxPercent: json["tax_percent"],
    createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
    updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null,
  );
}

class CalculatedPrice {
  final double metalValue;
  final double totalMakingAmt;
  final double makingCharges;
  final double labourCharges;
  final double stoneValuation;
  final double totalValuation;
  final double valuationWeightUsed;
  final String? valuationBasis;

  CalculatedPrice({
    required this.metalValue,
    required this.totalMakingAmt,
    required this.makingCharges,
    required this.labourCharges,
    required this.stoneValuation,
    required this.totalValuation,
    required this.valuationWeightUsed,
    this.valuationBasis,
  });

  factory CalculatedPrice.fromJson(Map<String, dynamic> json) => CalculatedPrice(
    metalValue: (json["metal_value"] ?? 0).toDouble(),
    totalMakingAmt: (json["total_making_amt"] ?? 0).toDouble(),
    makingCharges: (json["making_charges"] ?? 0).toDouble(),
    labourCharges: (json["labour_charges"] ?? 0).toDouble(),
    stoneValuation: (json["stone_valuation"] ?? 0).toDouble(),
    totalValuation: (json["total_valuation"] ?? 0).toDouble(),
    valuationWeightUsed: (json["valuation_weight_used"] ?? 0).toDouble(),
    valuationBasis: json["valuation_basis"],
  );
}

class Weights {
  final String grossWeight;
  final String netWeight;
  final String fineWeight;
  final String finalFineWeight;

  Weights({
    required this.grossWeight,
    required this.netWeight,
    required this.fineWeight,
    required this.finalFineWeight,
  });

  factory Weights.fromJson(Map<String, dynamic> json) => Weights(
    grossWeight: json["gross_weight"] ?? "0.00",
    netWeight: json["net_weight"] ?? "0.00",
    fineWeight: json["fine_weight"] ?? "0.00",
    finalFineWeight: json["final_fine_weight"] ?? "0.00",
  );
}

class ProductImage {
  final int id;
  final String imageKey;
  final String imageUrl;
  final int isPrimary;
  final String? imageRole;
  final String? originalFilename;
  final int? fileSize;
  final String? fileType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductImage({
    required this.id,
    required this.imageKey,
    required this.imageUrl,
    required this.isPrimary,
    this.imageRole,
    this.originalFilename,
    this.fileSize,
    this.fileType,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
    id: json["id"],
    imageKey: json["image_key"] ?? "",
    imageUrl: json["image_url"] ?? "",
    isPrimary: json["is_primary"] ?? 0,
    imageRole: json["image_role"],
    originalFilename: json["original_filename"],
    fileSize: json["file_size"],
    fileType: json["file_type"],
    createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
    updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null,
  );
}

class Stone {
  final int stoneId;
  final int stoneStockId;
  final String? stoneTransactionType;
  final String stoneItemName;
  final String? stoneItemCategory;
  final int stoneQuantity;
  final double stoneGsWeight;
  final String stoneGsWeightType;
  final double stonePurchaseRate;
  final String? stonePurchaseRateType;
  final double stoneSellRate;
  final String? stoneSellRateType;
  final String? stoneColor;
  final String? stoneClarity;
  final String? stoneShape;
  final String? stoneSize;
  final double stoneValuation;
  final double stoneFinalValuation;

  Stone({
    required this.stoneId,
    required this.stoneStockId,
    this.stoneTransactionType,
    required this.stoneItemName,
    this.stoneItemCategory,
    required this.stoneQuantity,
    required this.stoneGsWeight,
    required this.stoneGsWeightType,
    required this.stonePurchaseRate,
    this.stonePurchaseRateType,
    required this.stoneSellRate,
    this.stoneSellRateType,
    this.stoneColor,
    this.stoneClarity,
    this.stoneShape,
    this.stoneSize,
    required this.stoneValuation,
    required this.stoneFinalValuation,
  });

  factory Stone.fromJson(Map<String, dynamic> json) => Stone(
    stoneId: json["stone_id"],
    stoneStockId: json["stone_stock_id"],
    stoneTransactionType: json["stone_transaction_type"],
    stoneItemName: json["stone_item_name"] ?? "",
    stoneItemCategory: json["stone_item_category"],
    stoneQuantity: json["stone_quantity"] ?? 0,
    stoneGsWeight: (json["stone_gs_weight"] ?? 0).toDouble(),
    stoneGsWeightType: json["stone_gs_weight_type"] ?? "CT",
    stonePurchaseRate: (json["stone_purchase_rate"] ?? 0).toDouble(),
    stonePurchaseRateType: json["stone_purchase_rate_type"],
    stoneSellRate: (json["stone_sell_rate"] ?? 0).toDouble(),
    stoneSellRateType: json["stone_sell_rate_type"],
    stoneColor: json["stone_color"],
    stoneClarity: json["stone_clarity"],
    stoneShape: json["stone_shape"],
    stoneSize: json["stone_size"],
    stoneValuation: (json["stone_valuation"] ?? 0).toDouble(),
    stoneFinalValuation: (json["stone_final_valuation"] ?? 0).toDouble(),
  );
}