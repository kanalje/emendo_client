library tree_node;

import 'dart:html';
import 'package:web_ui/web_ui.dart';

import '../emendo_client.dart';
import 'tree_view.dart';
        
class TreeNode extends WebComponent {
  
  var index;
  var title;
  var icon;
  bool expanded = true;
  bool colapsible;
  List<String> nodeAreaClasses = ['tree-node-area', 
                                  'unselectable'];
  TreeView treeViewObject;
  
  
  void handleClick() {
    treeViewObject.setSelectedTreeNode(this);
  }
  
  void handleDoubleClick() {
    if (colapsible) expanded = !expanded;
    setIcon();      
  }
 
  void setIcon() {
    if (expanded) {
      icon = "icon-minus-sign";
    }
    else {
      icon = "icon-plus-sign";
    }
    
    if (!colapsible) {
      icon = "icon-stop";
    }
  }

}

