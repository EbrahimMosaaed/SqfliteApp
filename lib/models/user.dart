class User {
  String _username;
  String _password;
  int _id;

// constractor
  User(this._username, this._password);

// Map all the var to return as map to can loop through then use dymanic obj to setData
  User.map(dynamic obj) {
    this._username = obj['username'];
    this._password = obj['password'];
    this._id = obj['id'];
  }

// to access private varables from outsied class use getter
  String get username => _username;
  String get password => _password;
  int get id => _id;

// this map(setData) we recive key as String /Value as gernal type dynamic
 Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = _username;
    map["password"] = _password;

    if (id != null) {
      map["id"] = _id;
    }
    return map;
  }
  

// constractr
// (getData) do opessit what we did above in tomap medthod (setData)
 User.fromMap(Map<String, dynamic> map) {
    this._username = map["username"];
    this._password = map["password"];
    this._id = map["id"];
  }
}
