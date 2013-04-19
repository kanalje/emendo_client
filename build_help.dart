import 'dart:io';
import 'package:web_ui/component_build.dart';

// Ref: http://www.dartlang.org/articles/dart-web-components/tools.html
main() {
  
  var args = new Options().arguments;
  args.add('--help');
  build(args, ['web/emendo_client.html']);
}
