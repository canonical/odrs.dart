import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:glib/glib.dart';

String getUserHash({
  required String salt,
  String? username,
  String? machineId,
}) {
  username ??= g_get_user_name();
  machineId ??= File('/etc/machine-id').readAsStringSync().trim();
  return sha1.convert(utf8.encode('$salt[$username:$machineId]')).toString();
}

String getDistroName() => g_get_os_info(G_OS_INFO_KEY_NAME) ?? 'unknown';
