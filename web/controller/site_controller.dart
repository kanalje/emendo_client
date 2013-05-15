library site_controller;

import 'dart:async';
import 'dart:json';
import 'dart:html';
import 'package:uuid/uuid.dart';

import '../model/site.dart';
import '../emendo_client.dart';

class SiteController{
  
  Map<String, Site> _sites;
  Uuid _uuid;
  
  SiteController(){
    _uuid = new Uuid();
    _sites = new Map<String, Site>();
  }
  
  Site getSite(String siteId) {   
    if (_sites[siteId] == null) {
      _loadSite(siteId);
    }
    return _sites[siteId];
  }
  
  Site createSite(String name, String domainName, [String rootPageId = null]) {
    Site createdSite = new Site();
    createdSite.id = _uuid.v4();
    createdSite.name = name;
    createdSite.domainName = domainName;
    createdSite.ownerId = currentUser.id;
    if (rootPageId == null){
      createdSite.rootPageId = pageController.createPage(name, domainName, null, createdSite.id);
    }
    else {
      createdSite.rootPageId = rootPageId;
    }
    
    _saveSite(createdSite);
    _sites[createdSite.id] = createdSite;
    
    return createdSite; 
  }
  
  String getRootPageId(String siteId) {
    return _sites[siteId].rootPageId;
  }
  
  Future getOwnedSites(String userId) {
    var completer = new Completer();
    var ownedSites = new List<Site>();
    
    HttpRequest.request(location.origin + "/rest/site/ownedby/${userId}")
        .then((request) { 
          var data = parse(request.responseText);
          for (var item in data) {
            var site = new Site();
            site.id = item['id'];
            site.name = item['name'];
            site.rootPageId = item['rootPageId'];
            site.ownerId = item['ownerId'];
            site.domainName = item['domainName'];
            ownedSites.add(site);
            _sites[site.id] = site;
          }
          completer.complete(ownedSites);
        })
        .catchError((error) => print('Error in SiteController : getOwnedSites. \n\tError: ${error.toString()}'));
    
    return completer.future;
  }

  
  
  void _loadSite(String siteId) {
    HttpRequest.request(location.origin + "/rest/site/${siteId}")
        .then((request) => _sites[siteId] = _fromJson(request.responseText))
        .catchError((error) => print('Error in SiteController : _loadSite. \n\tError: ${error.toString()}'));
  }
  
  void _saveSite(Site site) {    
    String json = _toJson(site);
    var httpRequest = new HttpRequest();
    httpRequest.open('PUT', location.origin + "/rest/site");
    httpRequest.setRequestHeader('Content-type', 
    'application/json');
    httpRequest.onLoadEnd.listen((e) => loadEnd(httpRequest));
    httpRequest.send(json);
  }
  
  loadEnd(HttpRequest request) {
    if (request.status != 200) {
      print('Request returner error ${request.status}');
    } else {
      print('Data has been posted');
    }
  }
  
  Site _fromJson(String json) {
    var data = parse(json);
    Site site = new Site();
    site.id = data['id'];
    site.name = data['name'];
    site.domainName = data['domainName'];
    site.rootPageId = data['rootPageId'];
    site.ownerId = data['ownerId'];
    return site;
  }
  
  String _toJson(Site site) {
    var fields = new Map<String, String>();
    fields["id"] = site.id;
    fields["name"] = site.name;
    fields["domainName"] = site.domainName;
    fields["rootPageId"] = site.rootPageId;
    fields["ownerId"] = site.ownerId;
    return stringify(fields);
  }
  
}