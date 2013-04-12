library emendo;

import 'dart:html';
import 'dart:json';
import 'package:web_ui/web_ui.dart';
import 'emendo/page.dart';
import 'page_controller.dart';
import 'tree_node.dart';
import 'dart:async';
import 'form_new_page.dart';

PageController pageController;

int selectedNode = 1;
String deleteMethod = 'move';


bool modal_newPage = false;

void main() {
  
  useShadowDom = true;
  
  pageController = new PageController();    
  pageController.loadData("pageData");
  
}

void setNodeSelected(int i) {
  if (selectedNode != i) {
    selectedNode=i;
    //updateNamedChildrenMap(); 
  }
}

//void change(String target) {
//  query('#form-new-page').style.setProperty('display', 'block');
//  //query('#page-properties').replaceWith(newPageForm(selectedNode));
//}


//void updateNamedChildrenMap(){
//  var map = new Map<int, String>();
//  for (var id in pages[selectedNode].children)
//    map[id] = pages[id].title;
//  namedChildrenMap = map;
//}


Element getElementById(String id) {
  Element elem = query('#$id');
  if (elem == null){
    throw new ExpectException('No element with id #$id found.');
  }
  return elem;
}


void elementToggle(var descriptor){
  query('#' + descriptor).xtag.toggle();
}
