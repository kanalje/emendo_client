import 'dart:io';
import 'dart:async';
import 'package:web_ui/component_build.dart';

// Ref: http://www.dartlang.org/articles/dart-web-components/tools.html
main() {
  
  var args = new Options().arguments;
  args.addAll(['--', '--no-rewrite-urls']);
  
  build(args, ['web/emendo_client.html']);

}
