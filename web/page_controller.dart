library page_controller;

import 'dart:async';
import 'dart:json';
import 'dart:html';

import 'emendo_client.dart';
import 'emendo/page.dart';

class PageController{

  Map<int, Page> pages;
  var sc;
  Stream onChange;
  
  PageController(){
    sc = new StreamController();
    pages = new Map<int, Page>();    
    onChange = sc.stream.asBroadcastStream();
  }  
  
  Stream get stream => onChange;
  
  void addPage(var pageId, var title, var content, var parentId) {
    var page = new Page();
    page.id = pageId == null ? pages.length+1 : pageId;
    page.title = title;
    page.content = content;
    page.parentId = parentId;
    page.children = new List<int>();
    
    //Add this page to the page map
    pages[page.id] = page;
    
    //notify the streamcontroller
    sc.add('Added ${page.id}'); 
  }
  
  
  void movePage(int id, int newParentId) {
    var page = getPage(id);
    
    //Remove the page from the old parents list of children
    getPage(page.parentId).children.remove(id);
    
    //Update the page's parent reference
    page.parentId = newParentId;
    
    //Add the page to the new parents list of children
    getPage(newParentId).children.add(id);
    sc.add('Added ${page.id}');
  }
  
  Page deletePage(int id) {
    print('Deleting page $id');
    var page = getPage(id);
    getPage(page.parentId).children.remove(id);
    pages.remove(id);
    print('Finished deleting page $id');
    
    print('Notifying sc');
    //notify the streamcontroller
    sc.add('Deleted  $id');
    print('Back from sc');
  }
  
  
  Page deletePageWithMethod(int id, String method) {
    var page = getPage(id);
    List children = page.children;
    if (method == 'move') {
      for (var childId in children) {
        print('Moving child $childId');
        movePage(childId, page.parentId);
        print('Finished moving child $childId');
      }
    }
    else {
      for (var childId in children) {
        deletePageWithMethod(childId, 'wipe');
      }
      
    }
    print('Calling deletePage($id)');
    deletePage(id);
  }
  
  Page getPage(int id) {
    return pages[id];
  }
  
  void updateAllChildren() {
    for (int id in pages.keys) {
      if (pages[id].parentId != 0) pages[pages[id].parentId].children.add(id);
    }
  }
  

  void parseJSON(var pagesJSON) {    
      
    var data = parse(pagesJSON);
    for (var item in data['pages']){
      var page = new Page();
      page.id = item['id'] == null ? pages.length+1 : int.parse(item['id']);
      page.title = item['name'];
      page.content = item['content'];
      page.parentId = int.parse(item['parentId']);
      page.children = new List<int>();
      
      pages[page.id] = page;
    }  
  }
  
  void saveData() {
    var data = new Map<String, List>();
    data["pages"] = new List<Map>();
    for (int id in pages.keys){
      var fields = new Map<String, String>();
      fields["id"] = id.toString();
      fields["name"] = pages[id].title;
      fields["content"] = pages[id].content;
      fields["parentId"] = pages[id].parentId.toString();
      data["pages"].add(fields);
    }
    window.localStorage.$dom_setItem("pageData", stringify(data));
  }
  
  loadData(String localStorageDescriptor) {
    String a = window.localStorage.$dom_getItem(localStorageDescriptor);
    parseJSON(a);
    updateAllChildren();
  }
  
  

}

