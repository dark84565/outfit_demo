class Post {
  int _id;
  String _picturePath;
  String _introduction;
  String _remark;
  String _date;

  Post(this._picturePath, this._introduction, this._remark, this._date);

  Post.withId(this._id, this._picturePath, this._introduction, this._remark,
      this._date);

  int get id => _id;

  String get picturePath => _picturePath;

  String get introduction => _introduction;

  String get remark => _remark;

  String get date => _date;

  set picturePath(String newPicturePath) {
    this._picturePath = newPicturePath;
  }

  set introduction(String newIntroduction) {
    this._introduction = newIntroduction;
  }

  set remark(String newRemark) {
    this._remark = newRemark;
  }

  set date(String newData) {
    this._date = newData;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['picturePath'] = _picturePath;
    map['introduction'] = _introduction;
    map['remark'] = _remark;
    map['date'] = _date;
    return map;
  }

  Post.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._picturePath = map['picturePath'];
    this._introduction = map['introduction'];
    this._remark = map['remark'];
    this._date = map['date'];
  }
}
