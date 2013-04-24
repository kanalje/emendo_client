library emendo;

import 'dart:html';
import 'package:web_ui/web_ui.dart';

import 'model/page.dart';
import 'page_controller.dart';
import 'components/delete_page.dart';
import 'components/new_page.dart';

PageController pageController;

int selectedNode = 1;
String deleteMethod = 'move';


bool modal_newPage = false;

void main() {
  
  useShadowDom = true;
  
  pageController = new PageController();    
  pageController.loadData("pageData");
  
}

void setSelectedNode(int i) {
  if (selectedNode != i) {
    selectedNode=i; 
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

void showNewPage() {
  NewPage np = new NewPage();
  np.host = new Element.html('<x-new-page></x-new-page>');
  var lifeCycleCaller = new ComponentItem(np);
  lifeCycleCaller.create();
  lifeCycleCaller.insert(); 
  
  Element anchor = query('#modal_anchor');
  anchor.append(np.host);
  anchor.classes.add('open');
}

void showDeletePage() {
  DeletePage dp = new DeletePage();
  dp.host = new Element.html('<x-delete-page></x-delete-page>');
  var lifeCycleCaller = new ComponentItem(dp);
  lifeCycleCaller.create();
  lifeCycleCaller.insert(); 
  
  Element anchor = query('#modal_anchor');
  anchor.append(dp.host);
  anchor.classes.add('open');
  

}

void elementToggle(var descriptor){
  query('#' + descriptor).xtag.toggle();
}
