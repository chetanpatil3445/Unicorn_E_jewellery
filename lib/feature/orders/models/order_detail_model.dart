class OrderDetailResponse {
  bool? success;
  String? message;
  OrderDetailData? order;
  List<OrderItem>? items;
  List<StatusHistory>? statusHistory;

  OrderDetailResponse({this.success, this.message, this.order, this.items, this.statusHistory});

  OrderDetailResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    order = json['order'] != null ? OrderDetailData.fromJson(json['order']) : null;
    if (json['items'] != null) {
      items = <OrderItem>[];
      json['items'].forEach((v) => items!.add(OrderItem.fromJson(v)));
    }
    if (json['status_history'] != null) {
      statusHistory = <StatusHistory>[];
      json['status_history'].forEach((v) => statusHistory!.add(StatusHistory.fromJson(v)));
    }
  }
}

class OrderDetailData {
  int? id;
  int? addressId;
  String? orderNo;
  String? totalAmount, subtotal, taxAmount, discountAmount, couponCode;
  String? paymentMode, paymentStatus, orderStatus, createdAt;

  OrderDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressId = json['address_id'];
    orderNo = json['order_no'];
    totalAmount = json['total_amount'];
    subtotal = json['subtotal'];
    taxAmount = json['tax_amount'];
    discountAmount = json['discount_amount'];
    couponCode = json['coupon_code'];
    paymentMode = json['payment_mode'];
    paymentStatus = json['payment_status'];
    orderStatus = json['order_status'];
    createdAt = json['created_at'];
  }
}

class OrderItem {
  String? productName, qty, metalWeight, itemPrice, itemTax;
  OrderItem.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    qty = json['qty'].toString();
    metalWeight = json['metal_weight'];
    itemPrice = json['item_price'];
    itemTax = json['item_tax'];
  }
}

class StatusHistory {
  String? status, remarks, createdAt;
  StatusHistory.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    remarks = json['remarks'];
    createdAt = json['created_at'];
  }
}