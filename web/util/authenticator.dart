library authenticator;

import 'dart:html';
import 'dart:json';
import 'dart:async';
import 'package:js/js.dart' as js;

import '../emendo_client.dart';

class Authenticator {
  
  StreamController userEventController = new StreamController();
  
  void loadEnd(HttpRequest request) {
    if (request.readyState == 4) {
      if (request.status == 200) {
        String token = request.responseText;
        
        if (token == "" || token == null) {
          window.localStorage.$dom_removeItem("auth");
          userEventController.add('SIGN_OUT ${currentUser}');
        }
        else {
          window.localStorage.$dom_setItem("auth", token);
          userEventController.add('SIGN_IN ${parse(token)["id"]}');
        }
          
      } else {
        js.context.navigator.id.logout();
        print("HttpRequest error: ${request.status}");
      }
    }
  }
  
  void verifyAssertion(String assertion) {
    // Your backend must return HTTP status code 200 to indicate successful
    // verification of user's email address and it must arrange for the binding
    // of currentUser to said address when the page is reloaded
    HttpRequest request = new HttpRequest();
    request.open("POST", window.location.origin + "/rest/user/login");
    request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    request.onLoadEnd.listen((e) => loadEnd(request));
    request.send(assertion);

  }
  
  void signoutUser() {
    // Your backend must return HTTP status code 200 to indicate successful
    // sign out (usually the resetting of one or more session variables) and
    // it must arrange for the binding of currentUser to 'null' when the page
    // is reloaded
    window.localStorage.$dom_removeItem("auth");
    window.location.reload();
    
  }
  
  void signin() {
    js.context.navigator.id.request();
  }
  
  void signout() {
    js.scoped(() {
      js.context.navigator.id.logout();
    });
  }
}