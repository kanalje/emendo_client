import 'package:web_ui/web_ui.dart';
import 'package:js/js.dart' as js;

class LoginComponent extends WebComponent {
  String user;
  
  void signin() {
    js.context.navigator.id.request();
  }
  
  void signout() {
    js.context.navigator.id.logout();
  }
}