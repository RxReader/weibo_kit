import 'dart:convert';

import 'package:fake_weibo/src/domain/api/weibo_user_info_resp.dart';
import 'package:fake_weibo/src/domain/sdk/weibo_auth_resp.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

void main() {
  test('smoke test - snake case', () {
    print('${toSnakeCase('oneField')}');
    print('${toSnakeCase('oneField_street')}');
    print('${toSnakeCase('one_field')}');
  });

  test('smoke test - kebab case', () {
    print('${toKebabCase('oneField')}');
    print('${toKebabCase('oneField_street')}');
    print('${toKebabCase('one_field')}');
  });

  test('smoke test - camel case', () {
    print('${toCamelCase('oneField')}');
    print('${toCamelCase('oneField_street')}');
    print('${toCamelCase('one_field')}');
  });

  test('smoke test - jaguar_serializer', () {
    WeiboAuthResp authResp = WeiboAuthRespSerializer().fromMap(json.decode(
            '{"expiresIn":157679999,"errorCode":0,"accessToken":"2.00s67kHGj4SghD8e46233eea9O1IDB","userId":"5611295980","refreshToken":"2.00s67kHGj4SghD6ee52b48200iqHz3"}')
        as Map<dynamic, dynamic>);
    expect(authResp.errorCode, equals(0));
    expect(authResp.expiresIn, equals(157679999));
    expect(authResp.accessToken, equals('2.00s67kHGj4SghD8e46233eea9O1IDB'));

    WeiboUserInfoResp userInfoResp = WeiboUserInfoRespSerializer().fromMap(json.decode(
            '{"id":5611295980,"idstr":"5611295980","class":1,"screen_name":"v7lin","name":"v7lin","province":"35","city":"1","location":"福建 福州","description":"","url":"","profile_image_url":"http://tvax4.sinaimg.cn/crop.0.0.640.640.50/0067KqpSly8fujqh4oj39j30hs0hsjs6.jpg","cover_image_phone":"http://ww1.sinaimg.cn/crop.0.0.640.640.640/549d0121tw1egm1kjly3jj20hs0hsq4f.jpg","profile_url":"u/5611295980","domain":"","weihao":"","gender":"m","followers_count":1,"friends_count":1,"pagefriends_count":0,"statuses_count":0,"video_status_count":0,"favourites_count":0,"created_at":"Mon May 18 19:32:52 +0800 2015","following":false,"allow_all_act_msg":false,"geo_enabled":true,"verified":false,"verified_type":-1,"remark":"","insecurity":{"sexual_content":false},"ptype":0,"allow_all_comment":true,"avatar_large":"http://tvax4.sinaimg.cn/crop.0.0.640.640.180/0067KqpSly8fujqh4oj39j30hs0hsjs6.jpg","avatar_hd":"http://tvax4.sinaimg.cn/crop.0.0.640.640.1024/0067KqpSly8fujqh4oj39j30hs0hsjs6.jpg","verified_reason":"","verified_trade":"","verified_reason_url":"","verified_source":"","verified_source_url":"","follow_me":false,"like":false,"like_me":false,"online_status":0,"bi_followers_count":0,"lang":"zh-cn","star":0,"mbtype":0,"mbrank":0,"block_word":0,"block_app":0,"credit_score":80,"user_ability":0,"urank":4,"story_read_state":-1,"vclub_member":0,"is_teenager":0,"is_guardian":0,"is_teenager_list":0}')
        as Map<dynamic, dynamic>);
    expect(userInfoResp.errorCode, equals(0));
    expect(userInfoResp.id, equals(5611295980));
    expect(userInfoResp.screenName, equals('v7lin'));
    expect(userInfoResp.avatarHd, equals('http://tvax4.sinaimg.cn/crop.0.0.640.640.1024/0067KqpSly8fujqh4oj39j30hs0hsjs6.jpg'));
  });
}
