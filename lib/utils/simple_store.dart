class SimpleStore {
  String cookie;

  void saveCookie(String cookie) {
    this.cookie = cookie;
  }

  String getCookie(){
    return this.cookie;
  }
  @override
  String toStirng(){
    return '饼干：$cookie';
  }
}


SimpleStore store = new SimpleStore();