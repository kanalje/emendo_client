library split_table;

import 'package:web_ui/web_ui.dart';

class SplitTable extends WebComponent {
  
  Map<int, String> valueMap;
  var height;
  List<Map<int,String>> get valueMapParts {
    
    var result = new List<Map<int, String>>();
    var j=0;
    var subsetOfValues = new Map<int, String>(); 
    for (var i in valueMap.keys) {      
      if(j==height){ 
        result.add(subsetOfValues);
        j=0;
        subsetOfValues.clear();
      }
      subsetOfValues[i] = valueMap[i];
      j++;
    }
    result.add(subsetOfValues);
    return result;
  }
}
