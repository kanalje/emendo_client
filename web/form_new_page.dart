library form_new_page;

import 'package:web_ui/web_ui.dart';
import 'dart:html';
import 'emendo/page.dart';
import 'emendo_client.dart';

class FormNewPage extends WebComponent {
  
  String title = '';
  String content = '';
  int parentId;
  
  submitForm(){
    pageController.addPage(null, title, content, parentId);
  }
}

