import 'package:web_ui/web_ui.dart';
import 'dart:html';
import 'dart:async';

import '../emendo_client.dart';
        
class DeletePage extends WebComponent {
  
  close() { 
    query('#modal_anchor').classes.remove('open');
    Future future = new Future.delayed(new Duration(milliseconds : 500), null);
    future.then((_) => this.host.remove());
  }
  
  submit() {
    pageController.deletePageWithMethod(selectedNode, deleteMethod); 
    close();
  }
  
}