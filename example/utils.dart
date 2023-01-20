import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:stdlibc/stdlibc.dart';

String getUserHash({
  required String salt,
  String? username,
  String? machineId,
}) {
  username ??= getpwuid(geteuid())?.name;
  machineId ??= File('/etc/machine-id').readAsStringSync().trim();
  return sha1.convert(utf8.encode('$salt[$username:$machineId]')).toString();
}

Future<String?> getDistroName() async {
  final name = await _readOsRelease().then((os) => os?['NAME']);
  return name ?? await _readLsbRelease().then((lsb) => lsb?['DISTRIB_ID']);
}

Future<Map<String, String?>?> _readOsRelease() {
  return _tryReadKeyValues('/etc/os-release').then(
      (value) async => value ?? await _tryReadKeyValues('/usr/lib/os-release'));
}

Future<Map<String, String?>?> _readLsbRelease() {
  return _tryReadKeyValues('/etc/lsb-release');
}

Future<Map<String, String?>?> _tryReadKeyValues(String path) {
  return File(path)
      .readAsLines()
      .then((lines) => lines.toKeyValues(), onError: (_) => null);
}

extension _Unquote on String {
  String removePrefix(String prefix) {
    if (!startsWith(prefix)) return this;
    return substring(prefix.length);
  }

  String removeSuffix(String suffix) {
    if (!endsWith(suffix)) return this;
    return substring(0, length - suffix.length);
  }

  String unquote() {
    return removePrefix('"')
        .removePrefix("'")
        .removeSuffix('"')
        .removeSuffix("'");
  }
}

extension _KeyValues on List<String> {
  Map<String, String?> toKeyValues() {
    return Map.fromEntries(
      where((line) => !line.startsWith('#'))
          .map((line) => line.split('='))
          .where((parts) => parts.length == 2)
          .map((parts) => MapEntry(parts.first, parts.last.unquote())),
    );
  }
}
