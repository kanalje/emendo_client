library emendo_page;

class Page {
  
  String id;
  String siteId;
  
  String name;
  String content;
 
  String parentId;
  List<String> children;
  
  void addChild(String childId) {
    children.add(childId);
  }
  
  void removeChild(String childId) {
    children.remove(childId);
  }
  
  bool hasChildren(){
    return children.length != 0;
  }
  
}