library components;

import 'package:web_ui/web_ui.dart';
import 'dart:html';

import 'tree_node.dart';
import '../emendo_client.dart';
import '../model/page.dart';
        
class TreeView extends WebComponent {

  String _rootNodeId;
  static TreeNode selectedTreeNode;
  
  void inserted() {
    
    _rootNodeId = siteController.getRootPageId(currentSite.id);
    this.children.add(growNode(_rootNodeId));   
    
    pageController.onChange.listen((String event) {
      
      List<String> args = event.split(' ');
      
      if (args[0] == 'Created' && args[1] != _rootNodeId){
        String id = args[1];
        Element parent = this.query('#node${pageController.getPage(id).parentId}');
        parent.children.add(growNode(id));
        parent.xtag.colapsible = true;
        parent.xtag.expanded = true;
        parent.xtag.setIcon();
      }
      
      if (args[0] == 'Deleted'){
        Element parent = this.query('#node${args[1]}').parent;
        parent.children.remove(this.query('#node${args[1]}'));
        if (parent.queryAll('.tree-node').length == 0){
          parent.xtag.colapsible = false;
        }
        parent.xtag.setIcon();
        setSelectedTreeNode(parent.xtag);
      }
      
    });
  }
  
  Element growNode(String index){
    
    Page page = pageController.getPage(index);
    TreeNode tn = new TreeNode();
    tn.host = new Element.html('<x-tree-node></x-tree-node>');
    tn.treeViewObject = this;
    tn.index = index;
    tn.title = page.name;
    tn.host.id = 'node$index';
    tn.classes.add('tree-node');
    tn.expanded = page.id == _rootNodeId;
    tn.colapsible = !(page.id == _rootNodeId || page.children.length == 0);
    tn.setIcon();
    
    var lifeCycleCaller = new ComponentItem(tn);
    lifeCycleCaller.create();
    lifeCycleCaller.insert();  
    
    for (var childIndex in page.children){
      tn.host.children.add(growNode(childIndex));
    }
    
    return tn.host;
  }
  
  void setSelectedTreeNode(TreeNode tn) {
  
    if (selectedTreeNode != null) {
      selectedTreeNode.nodeAreaClasses.remove('active-node');
    }
    
    tn.nodeAreaClasses.add('active-node');
    selectedTreeNode = tn;
    
    setCurrentPage(tn.index);
    
  }
     
}


