library page_controller;

import 'dart:async';
import 'dart:json';
import 'dart:html';
import 'package:uuid/uuid.dart';

import '../model/site.dart';
import '../model/page.dart';

class PageController{

  Map<String, Page> _pages;
  Uuid _uuid;
  StreamController _streamController;
  Stream onChange;
  
  PageController(){
    _uuid = new Uuid();
    _pages = new Map<String, Page>();
    _streamController = new StreamController();
    onChange = _streamController.stream.asBroadcastStream();
  }    
  
  Page getPage(String id) {
    return _pages[id];
  }
  
  /**
   *  Creates a page, persists it and returns the id.
   */
  String createPage(String name, String content, String parentId, String siteId) {
    var page = new Page();
    page.id = _uuid.v4();
    page.name = name;
    page.content = content;
    page.siteId = siteId;
    page.parentId = parentId;
    page.children = new List<String>();
    
    if (parentId != null) {
      var parent = getPage(parentId);
      parent.addChild(page.id);
      _savePage(parent);
    }
    
    _pages[page.id] = page;
    _streamController.add('Created ${page.id}');
    
    _savePage(page);
    
    return page.id;
  }
  
  
  void movePage(String id, String newParentId) {
    Page page = getPage(id);

    Page newParent = getPage(newParentId);
    newParent.addChild(page.id);
    page.parentId = newParentId;
    
    _pages[newParent.id] = newParent;
    _pages[page.id] = page;
    _modifyPage(newParent);
    _modifyPage(page);
    _streamController.add('Added ${page.id}');
  }
  
  
  void deletePage(String id) {
    
    var page = getPage(id);
    var parent = getPage(page.parentId);
    parent.removeChild(page.id);

    _removePage(page);
    _pages.remove(id);
    _streamController.add('Deleted $id');
  }
  
  
  Page deletePageWithMethod(String id, String method) {
    var page = getPage(id);
    List children = new List.from(page.children);
    if (method == 'move') {
      for (var childId in children) {
        movePage(childId, page.parentId);
      }
    }
    else {
      for (var childId in children) {
        deletePageWithMethod(childId, 'wipe');
      }
    }
    deletePage(id);
  }
  
  
  void updateAllChildren() {
    for (String id in _pages.keys) {
      String parentId = _pages[id].parentId;
      if (parentId != null) {
        _pages[parentId].children.add(id);
      }
    }
  }
  
  void _savePage(Page page) {
    String json = _toJson(page);
    var httpRequest = new HttpRequest();
    httpRequest.open('POST', window.location.origin + "/rest/page");
    httpRequest.setRequestHeader('Content-type', 
    'application/json');
    httpRequest.onLoadEnd.listen((e) => loadEnd(httpRequest));
    httpRequest.send(json);
    
  }
  
  void _modifyPage(Page page) {
    String json = _toJson(page);
    var httpRequest = new HttpRequest();
    httpRequest.open('PUT', window.location.origin + "/rest/page/${page.id}");
    httpRequest.setRequestHeader('Content-type', 
    'application/json');
    httpRequest.onLoadEnd.listen((e) => loadEnd(httpRequest));
    httpRequest.send(json);
  }
  
  void _removePage(Page page) {
    var httpRequest = new HttpRequest();
    httpRequest.open('DELETE', window.location.origin + "/rest/page/${page.id}");
    httpRequest.send();
  }
  
  loadEnd(HttpRequest request) {
    if (request.status != 200) {
      print('Request failed with error: ${request.status}');
    } else {
      print('Data has been posted');
    }
  }
  
  String _toJson(Page page) {
    var fields = new Map();
    fields["id"] = page.id;
    fields["name"] = page.name;
    fields["content"] = page.content;
    fields["siteId"] = page.siteId;
    fields["parentId"] = page.parentId;
    fields["children"] = page.children;
    return stringify(fields);
  }

  Page _fromJson(var json) {    
    var data = parse(json);
    Page page = new Page();
    page.id = data['id'];
    page.name = data['name'];
    page.content = data['content'];
    page.siteId = data['siteId'];
    page.parentId = data['parentId'];
    page.children = new List<String>();
    for (var child in data['children']) {
      page.addChild(child);
    }
    return page;
  }
  
  
  Future loadData(String siteId) {
    var completer = new Completer();
    HttpRequest.request(window.location.origin + "/rest/site/${siteId}/all_pages")
      .then((req) {
        var data = parse(req.responseText);
        for (var item in data){
          var page = new Page();
          page.id = item['id'];
          page.name = item['name'];
          page.content = item['content'];
          page.siteId = item['siteId'];
          page.parentId = item['parentId'];
          page.children = new List<String>();
          _pages[page.id] = page;
        }
        updateAllChildren();
        completer.complete();
      }).catchError(print('Loading pages failed'));
    
    return completer.future;
  }

}

