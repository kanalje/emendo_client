library user_controller;

import 'dart:html';
import 'dart:async';
import 'dart:json';
import 'package:js/js.dart' as js;
import '../emendo_client.dart';
import '../model/user.dart';


class UserController{
  
  UserController() {
    currentUser = new User();
  }
  
  Future initializeUser(String userId) {
    
    var completer = new Completer();
    
    _loadUser(userId).then((user) {
      currentUser = user;
      siteController.getOwnedSites(currentUser.id).then((ownedSites) {

        currentUser.ownedSites = ownedSites;
       
        //Temporary solution, until site creation is implemented
        if (currentUser.ownedSites == null || currentUser.ownedSites.length == 0) {
          currentSite = siteController.createSite("emendo", "www.emendo.no");
          completer.complete();
        }
        else {
          currentSite = currentUser.ownedSites[0];
          pageController.loadData(currentSite.id).then((_) {
            completer.complete();
          });
        }
        
      });
      
      
    });
    
    return completer.future;
  }
  
  
  Future _loadUser(String id) {
    var completer = new Completer();
    User user;    
    
    HttpRequest.request(location.origin + '/rest/user/${id}')
      .then((req) { 
        user = _fromJson(req.responseText);
        completer.complete(user);
      });
    
    return completer.future;

  }  
  
  User _fromJson(var json) {    
    var data = parse(json);
    User user = new User();
    user.id = data['id'];
    user.email = data['email'];
    user.firstName = data['firstName'];
    user.lastName = data['lastName'];
    
    return user;
  }  
    
}