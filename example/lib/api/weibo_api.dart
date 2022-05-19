import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:weibo_kit_example/api/model/weibo_api_resp.dart';

class WeiboApi {
  const WeiboApi._();

  /// 用户信息
  static Future<WeiboUserInfoResp> getUserInfo({
    required String appkey,
    required String userId,
    required String accessToken,
  }) {
    final Map<String, String> params = <String, String>{
      'uid': userId,
    };
    return HttpClient()
        .getUrl(_encodeUrl('https://api.weibo.com/2/users/show.json', appkey,
            accessToken, params))
        .then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) async {
      if (response.statusCode == HttpStatus.ok) {
        final String content = await utf8.decodeStream(response);
        return WeiboUserInfoResp.fromJson(
            json.decode(content) as Map<String, dynamic>);
      }
      throw HttpException(
          'HttpResponse statusCode: ${response.statusCode}, reasonPhrase: ${response.reasonPhrase}.');
    });
  }

  static Uri _encodeUrl(
    String baseUrl,
    String appkey,
    String accessToken,
    Map<String, String> params,
  ) {
    params['source'] = appkey;
    params['access_token'] = accessToken;
    final Uri baseUri = Uri.parse(baseUrl);
    final Map<String, List<String>> queryParametersAll =
        Map<String, List<String>>.of(baseUri.queryParametersAll);
    for (final MapEntry<String, String> entry in params.entries) {
      queryParametersAll.remove(entry.key);
      queryParametersAll.putIfAbsent(entry.key, () => <String>[entry.value]);
    }
    return baseUri.replace(queryParameters: queryParametersAll);
  }
}
