import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:glib/glib.dart';
import 'package:odrs/odrs.dart';

OdrsClient createOdrsClient({String? app, required String url}) {
  return OdrsClient(
    url: Uri.parse(url),
    userHash: _getUserHash(salt: app),
    distro: _getDistroName(),
  );
}

String _getUserHash({
  String? salt,
  String? username,
  String? machineId,
}) {
  salt ??= glib.getProgramName();
  username ??= glib.getUserName();
  machineId ??= File('/etc/machine-id').readAsStringSync().trim();
  return sha1.convert(utf8.encode('$salt[$username:$machineId]')).toString();
}

String _getDistroName() => glib.getOsInfo(GOsInfoKey.name) ?? 'unknown';
