library youtube;

import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

const String YT_PLAYLIST_URL = 'http://gdata.youtube.com/feeds/api/playlists/';

Future<Map> fetchPlaylist(String playlistId) {
  var uri = Uri.parse('$YT_PLAYLIST_URL$playlistId?alt=json');
  return http.get(uri).then((resp) => jsonDecode(resp.body));
}
