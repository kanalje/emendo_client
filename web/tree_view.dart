library components;

import 'package:web_ui/web_ui.dart';
import 'dart:html';
import 'emendo_client.dart';
import 'emendo/page.dart';
import 'tree_node.dart';

        
class TreeView extends WebComponent {

  
  Map<int, Page> pageMap;
  static TreeNode selectedTreeNode;
  
  void inserted() {
    this.children.add(growNode(1));      
    pageController.onChange.listen((String event) {
      
      List<String> args = event.split(' ');
      
      if (args[0] == 'Added'){
        
        Element parent = query('#node$selectedNode');
        parent.xtag.expanded = true;
        parent.xtag.icon = "icon-minus-sign";
        parent.children.add(growNode(int.parse(args[1])));
        pageController.saveData();
        elementToggle('modal_newPage');
      }
      
      if (args[0] == 'Deleted'){
        Element parent = query('#node$selectedNode').parent;
        print(parent.id);
        print(parent.xtag);
        parent.xtag.expanded = false;
        parent.children.remove(query('#node$selectedNode'));
        setSelectedNode(parent.xtag);
        elementToggle('modal_deletePage');
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
    tn.icon = pageMap[index].children.length != 0 ? "icon-plus-sign" : "icon-stop";
    if (index == 1) tn.icon = "";
    tn.colapsible = !(index == 1); 
    
    var lifeCycleCaller = new ComponentItem(tn);
    lifeCycleCaller.create();
    lifeCycleCaller.insert();  
    
    //treeNodes.add(tn);
    
    for (var childIndex in pageMap[index].children){
      tn.host.children.add(growNode(childIndex));
    }
    
    return tn.host;
  }
  
  void setSelectedNode(TreeNode tn) {
  
    if (selectedTreeNode != null) {
      selectedTreeNode.nodeAreaClasses.remove('active-node');
    }
    tn.nodeAreaClasses.add('active-node');
    selectedTreeNode = tn;
    setNodeSelected(tn.index);
    
  }
     
}


