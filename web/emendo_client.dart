library emendo;

import 'dart:html';
import 'dart:json';
import 'package:web_ui/web_ui.dart';
import 'model/page.dart';
import 'page_controller.dart';
import 'components/tree_node.dart';
import 'dart:async';
import 'components/form_new_page.dart';
import 'package:widget/effects.dart';
import 'package:widget/widget.dart';

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
  return elem;
}


void elementToggle(var descriptor){
  query('#' + descriptor).xtag.toggle();
}
