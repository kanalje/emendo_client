library tree_node;

import 'dart:html';
import 'package:web_ui/web_ui.dart';
import 'emendo_client.dart';
import 'tree_view.dart';
        
class TreeNode extends WebComponent {
  
  var index;
  var title;
  var icon;
  bool expanded = true;
  bool colapsible;
  List<String> nodeAreaClasses = ['tree-node-area', 'unselectable'];
  TreeView treeViewObject;
  
  
  void handleClick() {
    setNodeSelected(index);
    treeViewObject.setSelectedNode(this);
  }
  
  void handleDoubleClick() {
    if (colapsible){
      if (expanded){
        icon = "icon-plus-sign";
        expanded = false;
      }
      else{
        icon = "icon-minus-sign";
        expanded = true;
      }
    }
  }  
}

