import 'dart:io';
import 'dart:async';
import 'package:web_ui/component_build.dart';

// Ref: http://www.dartlang.org/articles/dart-web-components/tools.html
main() {
  
  var args = new Options().arguments;
  args.add('--full');
  args.addAll(['--', '--no-rewrite-urls']);
  
  Future dwc = build(args, ['web/emendo_client.html']);
  
  dwc
    .then((_) => Process.run('cp', ['-r', 'web/css', 'web/out/']))
    .then((_) => Process.run('cp', ['-r', 'web/img', 'web/out/']))
    .then((_) => Process.run('cp', ['-r', 'web/model', 'web/out/']));
  
}
