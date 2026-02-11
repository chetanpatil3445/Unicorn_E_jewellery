class OrderResponse {
  bool? success;
  String? message;
  List<Order>? orders;
  Pagination? pagination;

  OrderResponse({this.success, this.message, this.orders, this.pagination});

  OrderResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['orders'] != null) {
      orders = <Order>[];
      json['orders'].forEach((v) => orders!.add(Order.fromJson(v)));
    }
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }
}

class Order {
  int? id;
  String? orderNo;
  String? totalAmount;
  String? paymentStatus;
  String? orderStatus;
  String? createdAt;
  String? itemsCount;
  String? paymentMode;

  Order({this.id, this.orderNo, this.totalAmount, this.paymentStatus, this.orderStatus, this.createdAt, this.itemsCount, this.paymentMode});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNo = json['order_no'];
    totalAmount = json['total_amount'];
    paymentStatus = json['payment_status'];
    orderStatus = json['order_status'];
    createdAt = json['created_at'];
    itemsCount = json['items_count'];
    paymentMode = json['payment_mode'];
  }
}

class Pagination {
  int? totalItems;
  Pagination.fromJson(Map<String, dynamic> json) {
    totalItems = json['total_items'];
  }
}