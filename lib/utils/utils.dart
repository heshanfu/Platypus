import 'dart:io';
import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';

import 'package:platypus/providers/home.dart';

// https://github.com/pd4d10/highlight/tree/master/highlight/lib/languages
const List<String> _programmingLanguages = [
  '1c',
  'abnf',
  'accesslog',
  'actionscript',
  'ada',
  'all',
  'angelscript',
  'apache',
  'applescript',
  'arcade',
  'arduino',
  'armasm',
  'asciidoc',
  'aspectj',
  'autohotkey',
  'autoit',
  'avrasm',
  'awk',
  'axapta',
  'bash',
  'basic',
  'bnf',
  'brainfuck',
  'cal',
  'capnproto',
  'ceylon',
  'clean',
  'clojure-repl',
  'clojure',
  'cmake',
  'coffeescript',
  'coq',
  'cos',
  'cpp',
  'crmsh',
  'crystal',
  'cs',
  'csp',
  'css',
  'd',
  'dart',
  'delphi',
  'diff',
  'django',
  'dns',
  'dockerfile',
  'dos',
  'dsconfig',
  'dts',
  'dust',
  'ebnf',
  'elixir',
  'elm',
  'erb',
  'erlang-repl',
  'erlang',
  'excel',
  'fix',
  'flix',
  'fortran',
  'fsharp',
  'gams',
  'gauss',
  'gcode',
  'gherkin',
  'glsl',
  'gml',
  'gn',
  'go',
  'golo',
  'gradle',
  'graphql',
  'groovy',
  'haml',
  'handlebars',
  'haskell',
  'haxe',
  'hsp',
  'htmlbars',
  'http',
  'hy',
  'inform7',
  'ini',
  'irpf90',
  'isbl',
  'java',
  'javascript',
  'jboss-cli',
  'json',
  'julia-repl',
  'julia',
  'kotlin',
  'lasso',
  'ldif',
  'leaf',
  'less',
  'lisp',
  'livecodeserver',
  'livescript',
  'llvm',
  'lsl',
  'lua',
  'makefile',
  'markdown',
  'mathematica',
  'matlab',
  'maxima',
  'mel',
  'mercury',
  'mipsasm',
  'mizar',
  'mojolicious',
  'monkey',
  'moonscript',
  'n1ql',
  'nginx',
  'nimrod',
  'nix',
  'nsis',
  'objectivec',
  'ocaml',
  'openscad',
  'oxygene',
  'parser3',
  'perl',
  'pf',
  'pgsql',
  'php',
  'plaintext',
  'pony',
  'powershell',
  'processing',
  'profile',
  'prolog',
  'properties',
  'protobuf',
  'puppet',
  'purebasic',
  'python',
  'q',
  'qml',
  'r',
  'reasonml',
  'rib',
  'roboconf',
  'routeros',
  'rsl',
  'ruby',
  'ruleslanguage',
  'rust',
  'sas',
  'scala',
  'scheme',
  'scilab',
  'scss',
  'shell',
  'smali',
  'smalltalk',
  'sml',
  'solidity',
  'sqf',
  'sql',
  'stan',
  'stata',
  'step21',
  'stylus',
  'subunit',
  'swift',
  'taggerscript',
  'tap',
  'tcl',
  'tex',
  'thrift',
  'tp',
  'twig',
  'typescript',
  'vala',
  'vbnet',
  'vbscript-html',
  'vbscript',
  'verilog',
  'vhdl',
  'vim',
  'vue',
  'x86asm',
  'xl',
  'xml',
  'xquery',
  'yaml',
  'zephir',
];

final Map<String, String> programmingLanguages = {
  ...Map.fromEntries(_programmingLanguages.map((programmingLanguage) =>
      MapEntry(programmingLanguage, programmingLanguage))),
};

enum WindowThreeCirclesStyle {
  Filled,
  Empty,
  Hidden,
}

const Map<String, MainAxisAlignment> windowThreeCirclesPositions = {
  'Left': MainAxisAlignment.start,
  'Center': MainAxisAlignment.center,
  'Right': MainAxisAlignment.end,
};

// https://www.nbdtech.com/Blog/archive/2008/04/27/Calculating-the-Perceived-Brightness-of-a-Color.aspx
Color getCircleColor(Color c) {
  return sqrt(c.red * c.red * .241 +
              c.green * c.green * .691 +
              c.blue * c.blue * .068) <
          130
      ? Colors.white
      : Colors.black;
}

Future exportCurrentPlatypusConfig(HomeProvider homeProvider) async {
  final Directory downloadPath = await getApplicationDocumentsDirectory();
  final File configFile = File(
      '${downloadPath.path}/platypus-config-${DateTime.now().toString()}.json');
  final Map<String, dynamic> config = {
    'horizontal_padding':
        homeProvider.horizontalPaddingBetweenCodeAndBackground,
    'vertical_padding': homeProvider.verticalPaddingBetweenCodeAndBackground,
    'font_size': homeProvider.codeFontSize,
    'window_circles_style': homeProvider.windowThreeCirclesStyle,
    'window_circles_position': homeProvider.windowThreeCirclesPosition,
    'highlight_theme': homeProvider.codeHighlightTheme,
    'line_height': homeProvider.codeLineHeight,
    'show_shadow': homeProvider.showShadow,
    'programming_language': homeProvider.codeProgrammingLanguage,
    'source_code': homeProvider.codeTextEditingController.text,
    'background_color': homeProvider.codeBackgroundColor.value,
  };
  final generatedConfigFile =
      await configFile.writeAsString(jsonEncode(config));
  return generatedConfigFile;
}