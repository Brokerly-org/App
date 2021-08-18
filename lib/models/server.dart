class Server {
  String urlSchema;
  String url;
  String userToken;

  Server(this.url, this.urlSchema, this.userToken);

  Server.fromDict(Map<String, dynamic> dict) {
    this.urlSchema = dict["urlSchema"];
    this.url = dict["url"];
    this.userToken = dict["userToken"];
  }

  Map<String, dynamic> toDict() {
    Map<String, dynamic> dict = {};
    dict["urlSchema"] = this.urlSchema;
    dict["url"] = this.url;
    dict["userToken"] = this.userToken;
    return dict;
  }
}
