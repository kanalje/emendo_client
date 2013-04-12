
import 'package:web_ui/web_ui.dart';
import 'emendo_client.dart';


class Modal extends WebComponent {
  
  bool show = false;
  
  void close(){
    show=false;
  }
  
  void toggle(){
    show = !show;
  }
  
}