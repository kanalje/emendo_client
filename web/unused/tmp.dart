


Future someServerCall() {
  var completer = new Completer();
  
  var result;
  var httpRequest = new HttpRequest();
  httpRequest.open('GET', "http://server.com/greeting");
  httpRequest.onLoadEnd.listen((request) {
    result = request.getResponseText;
  });
  httpRequest.send();
  
  completer.complete(result);
  
  return completer.future;
}

anotherMethod() {
  someServerCall().then((result) {
    print(result);
  });
}