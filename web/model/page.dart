library emendo_page;

class Page {
  
  int id;
  var title;
  var content;
  var parentId;
  List<int> children;
  
  void addChild(int childId) {
    children.add(childId);
  }
  
  void removeChild(int childId) {
    children.remove(childId);
  }
  
  bool hasChildren(){
    return children.length != 0;
  }
  
}