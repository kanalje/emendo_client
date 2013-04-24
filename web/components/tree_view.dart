library components;

import 'package:web_ui/web_ui.dart';
import 'dart:html';

import 'tree_node.dart';
import '../emendo_client.dart';
import '../model/page.dart';
        
class TreeView extends WebComponent {

  
  Map<int, Page> pageMap;
  static TreeNode selectedTreeNode;
  
  void inserted() {
    this.children.add(growNode(1));      
    pageController.onChange.listen((String event) {
      
      print(event);
      List<String> args = event.split(' ');
      
      if (args[0] == 'Added'){
        int id = int.parse(args[1]);
        Element parent = query('#node${pageMap[id].parentId}');
        parent.children.add(growNode(id));
        parent.xtag.colapsible = true;
        parent.xtag.expanded = true;
        parent.xtag.setIcon();
        pageController.saveData();
        //elementToggle('modal_newPage');
      }
      
      if (args[0] == 'Deleted'){
        Element parent = query('#node${args[1]}').parent;
        parent.children.remove(query('#node${args[1]}'));
        if (parent.queryAll('.tree-node').length == 0){
          parent.xtag.colapsible = false;
        }
        parent.xtag.setIcon();
        setSelectedTreeNode(parent.xtag);
        //elementToggle('modal_deletePage');
      }
      
    });
  }
  
 
  
  Element growNode(var index){
    
    TreeNode tn = new TreeNode();
    tn.host = new Element.html('<x-tree-node></x-tree-node>');
    tn.treeViewObject = this;
    tn.index = index;
    tn.title = pageMap[index].title;
    tn.host.id = 'node$index';
    tn.classes.add('tree-node');
    tn.expanded = index == 1;
    tn.colapsible = !(index == 1 || pageMap[index].children.length == 0);
    tn.setIcon();
    
    var lifeCycleCaller = new ComponentItem(tn);
    lifeCycleCaller.create();
    lifeCycleCaller.insert();  
    
    for (var childIndex in pageMap[index].children){
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
    setSelectedNode(tn.index);
    
  }
     
}


