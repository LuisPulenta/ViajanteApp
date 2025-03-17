class Bill {
  int id = 0;
  String customer = '';
  String type = '';
  String number = '';
  String createDate = '';
  String billDate = '';
  double amount = 0;
  String photo = '';
  String? chargeDate = '';
  bool charge = false;
  String? deliverDate = '';
  bool deliver = false;
  String photoFullPath = '';

  Bill({
    required this.id,
    required this.customer,
    required this.type,
    required this.number,
    required this.createDate,
    required this.billDate,
    required this.amount,
    required this.photo,
    required this.chargeDate,
    required this.charge,
    required this.deliverDate,
    required this.deliver,
    required this.photoFullPath,
  });

  Bill.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customer = json['customer'];
    type = json['type'];
    number = json['number'];
    createDate = json['createDate'];
    billDate = json['billDate'];
    amount = json['amount'];
    photo = json['photo'];
    chargeDate = json['chargeDate'] ?? '';
    charge = json['charge'];
    deliverDate = json['deliverDate'] ?? '';
    deliver = json['deliver'];
    photoFullPath = json['photoFullPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer'] = customer;
    data['type'] = type;
    data['number'] = number;
    data['createDate'] = createDate;
    data['billDate'] = billDate;
    data['amount'] = amount;
    data['photo'] = photo;
    data['chargeDate'] = chargeDate ?? '';
    data['charge'] = charge;
    data['deliverDate'] = deliverDate ?? '';
    data['deliver'] = deliver;
    data['photoFullPath'] = photoFullPath;

    return data;
  }
}
