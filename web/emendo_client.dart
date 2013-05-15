library emendo;

import 'dart:html';
import 'package:web_ui/web_ui.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:js/js.dart' as js;
import 'package:web_ui/watcher.dart' as watcher;

import 'model/user.dart';
import 'model/page.dart';
import 'model/site.dart';

import 'controller/page_controller.dart';
import 'controller/site_controller.dart';
import 'controller/user_controller.dart';
import 'components/delete_page.dart';
import 'components/new_page.dart';
import 'components/site_control_component.dart';
import 'package:appengine_channel/appengine_channel.dart';
import 'util/authenticator.dart';

Location location;

PageController pageController;
SiteController siteController;
UserController userController;
Authenticator authenticator;

User currentUser;
Site currentSite;
String currentPage;

String deleteMethod = 'move';
String channelToken;

Stream onUserEvent;

bool modal_newPage = false;

void main() {
  location = window.location;
  
  siteController = new SiteController();
  pageController = new PageController();
  userController = new UserController();
  
  authenticator = new Authenticator();
  onUserEvent = authenticator.userEventController.stream.asBroadcastStream();
  
  useShadowDom = true;
  
  js.scoped(() {
    js.context.currentUser = new js.Callback.many(getCurrentUser);
    js.context.verifyAssertion = new js.Callback.many(authenticator.verifyAssertion);
    js.context.signoutUser =  new js.Callback.many(authenticator.signoutUser);
    
    Element personaScript = new ScriptElement();
    personaScript.text = "navigator.id.watch( {loggedInUser: currentUser, onlogin: verifyAssertion, onlogout: signoutUser } );";
    
    document.body.nodes.add(personaScript);
  });

  onUserEvent.listen((String event) {
    List<String> args = event.split(' ');
    if (args[0] == "SIGN_IN") {

      userController.initializeUser(args[1]).then((_) {
        HttpRequest.getString(location.origin + "/rest/user/channelToken/${currentUser.id}").then((response) {
          channelToken = response;
          openChannel(channelToken);
        });
        
        currentPage = currentSite.rootPageId;
        
        var elem = new SiteControlComponent();  
        elem.host = new Element.html('<x-site-control-component></x-site-control-component>');
        var lifeCycleCaller = new ComponentItem(elem);
        lifeCycleCaller.create();
        lifeCycleCaller.insert(); 
        Element anchor = query('#content_anchor');
        anchor.children.clear();
        anchor.append(elem.host);
      });
            
    }
    if (args[0] == "SIGN_OUT") {
      
    }
    watcher.dispatch();
  });
  
}

getCurrentUser() {
  return currentUser;
}

openChannel(String token) {
  Channel channel = new Channel(token);
  Socket socket = channel.open()
    ..onOpen = (() => print("opened channel"))
    ..onClose = (() => print("closed channel"))
    ..onMessage = ((m) => print("message from channel: $m"))
    ..onError = ((code, desc) => print("error from channel: $code $desc"));
}


void setCurrentPage(String i) {
  if (currentPage != i) {
    currentPage=i; 
  }
}

void showModal(String component) {
  var elem;
  if (component == 'x-delete-page') {
    elem = new DeletePage();  
  }
  if (component == 'x-new-page') {
    elem = new NewPage();  
  }
  elem.host = new Element.html('<${component}></${component}>');
  var lifeCycleCaller = new ComponentItem(elem);
  lifeCycleCaller.create();
  lifeCycleCaller.insert(); 
  
  Element anchor = query('#modal_anchor');
  anchor.append(elem.host);
  anchor.classes.add('open');
}