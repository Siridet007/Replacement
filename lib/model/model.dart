class SearchTicker {
  String? id;
  String? rsvn;
  String? voucher;
  String? showdate;
  String? bookdate;
  String? round;
  String? agentcode;
  String? agentname;
  String? name;
  String? customername;
  String? customertel;
  String? userid;
  String? issue;
  String? tr;
  String? rs;
  String? backZone;
  String? hotelname;
  String? status;
  String? qrcode;
  String? typeguest;
  String? seat;
  String? accode;
  String? gate;

  SearchTicker({
    this.id,
    this.rsvn,
    this.voucher,
    this.showdate,
    this.bookdate,
    this.round,
    this.agentcode,
    this.agentname,
    this.name,
    this.customername,
    this.customertel,
    this.userid,
    this.issue,
    this.tr,
    this.rs,
    this.backZone,
    this.hotelname,
    this.status,
    this.qrcode,
    this.typeguest,
    this.seat,
    this.accode,
    this.gate,
  });

  SearchTicker.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    rsvn = json['rsvn'] ?? '';
    voucher = json['voucher'] ?? '';
    showdate = json['showdate'] ?? '';
    bookdate = json['bookdate'] ?? '';
    round = json['round'] ?? '';
    agentcode = json['agentcode'] ?? '';
    agentname = json['agentname'] ?? '';
    name = json['name'] ?? '';
    customername = json['customername'] ?? '';
    customertel = json['customertel'] ?? '';
    userid = json['userid'] ?? '';
    issue = json['issue'] ?? '';
    tr = json['tr'] ?? '';
    rs = json['rs'] ?? '';
    backZone = json['back_zone'] ?? '-';
    hotelname = json['hotelname'] ?? '-';
    status = json['status'] ?? '';
    qrcode = json['qrcode'] ?? '';
    typeguest = json['typeguest'] ?? '';
    seat = json['seat'] ?? '';
    accode = json['accode'] ?? '';
    gate = json['gate'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rsvn'] = rsvn;
    data['voucher'] = voucher;
    data['showdate'] = showdate;
    data['bookdate'] = bookdate;
    data['round'] = round;
    data['agentcode'] = agentcode;
    data['agentname'] = agentname;
    data['name'] = name;
    data['customername'] = customername;
    data['customertel'] = customertel;
    data['userid'] = userid;
    data['issue'] = issue;
    data['tr'] = tr;
    data['rs'] = rs;
    data['back_zone'] = backZone;
    data['hotelname'] = hotelname;
    data['status'] = status;
    data['qrcode'] = qrcode;
    data['typeguest'] = typeguest;
    data['seat'] = seat;
    data['accode'] = accode;
    data['gate'] = gate;
    return data;
  }

  static List<SearchTicker>? fromJsonList(List list) {
    return list.map((item) => SearchTicker.fromJson(item)).toList();
  }
}

class GetReport {
  String? bookid;
  String? userid;
  String? datesave;
  String? rsvn;
  String? voucher;
  String? seat;
  String? round;
  String? agentname;

  GetReport(
      {this.bookid,
      this.userid,
      this.datesave,
      this.rsvn,
      this.voucher,
      this.seat,
      this.round,
      this.agentname});

  GetReport.fromJson(Map<String, dynamic> json) {
    bookid = json['bookid'] ?? '';
    userid = json['userid'] ?? '';
    datesave = json['datesave'] ?? '';
    rsvn = json['rsvn'] ?? '';
    voucher = json['voucher'] ?? '';
    seat = json['seat'] ?? '';
    round = json['round'] ?? '';
    agentname = json['agentname'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bookid'] = bookid;
    data['userid'] = userid;
    data['datesave'] = datesave;
    data['rsvn'] = rsvn;
    data['voucher'] = voucher;
    data['seat'] = seat;
    data['round'] = round;
    data['agentname'] = agentname;
    return data;
  }

  static List<GetReport>? fromJsonList(List list) {
    return list.map((item) => GetReport.fromJson(item)).toList();
  }
}
