import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Transport substitute: the generated client still serializes and validates every response.
class MockApi extends Interceptor {
  MockApi(this.preferences) {
    final saved = preferences.getString('mock-api-v1');
    if (saved != null) {
      try {
        final j = jsonDecode(saved) as Map<String, dynamic>;
        profile = Map<String, dynamic>.from(j['profile'] as Map);
        reservations = (j['reservations'] as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      } catch (_) {
        /* Reset incompatible fixture. */
      }
    }
  }
  final SharedPreferences preferences;
  List<Map<String, dynamic>> reservations = [];
  final Map<String, Uint8List> photoBytes = {};
  Map<String, dynamic> profile = {
    'displayName': 'リサイクル 太郎',
    'email': 'demo@example.test',
    'phone': '090-0000-0000',
    'addresses': [
      {
        'id': 'home',
        'label': '自宅',
        'postalCode': '100-0001',
        'prefecture': '東京都',
        'addressLine': '千代田区千代田1（ローカル確認用）',
      },
    ],
  };
  final facilities = [
    {
      'id': 'tokyo-east',
      'name': '東エリア リサイクルステーション',
      'address': '東京都江東区（デモ施設）',
      'latitude': 35.672,
      'longitude': 139.818,
      'instructions': '入口でQRコードを提示してください。持込後は写真を登録し「捨てました！」を押して完了です。',
    },
    {
      'id': 'tokyo-west',
      'name': '西エリア リサイクルステーション',
      'address': '東京都新宿区（デモ施設）',
      'latitude': 35.693,
      'longitude': 139.703,
      'instructions': '品目ごとに分別してお持ち込みください。',
    },
  ];
  final itemTypes = [
    {'id': 'paper', 'name': '古紙・段ボール', 'unit': '束', 'priceYen': 0},
    {'id': 'metal', 'name': '金属・小物', 'unit': '袋', 'priceYen': 300},
    {'id': 'appliance', 'name': '小型家電', 'unit': '点', 'priceYen': 800},
  ];
  List<Map<String, dynamic>> get slots {
    final now = DateTime.now().toUtc().add(const Duration(hours: 9));
    return List.generate(14, (i) {
      final day = DateTime.utc(now.year, now.month, now.day + i);
      final id = day.toIso8601String().substring(0, 10);
      return {
        'id': id,
        'label': '${day.month}月${day.day}日 00:00–24:00（テスト枠）',
        'startsAt': day.subtract(const Duration(hours: 9)).toIso8601String(),
        'endsAt': day.add(const Duration(hours: 15)).toIso8601String(),
      };
    });
  }

  Future<void> save() => preferences.setString(
    'mock-api-v1',
    jsonEncode({'profile': profile, 'reservations': reservations}),
  );
  Map<String, dynamic> booking(String id) => reservations.firstWhere(
    (b) => b['id'] == id,
    orElse: () => throw const MockFailure(404, '対象が見つかりません。'),
  );
  void need(bool condition, String message) {
    if (!condition) throw MockFailure(409, message);
  }

  Future<void> admitLocal(String id) async {
    final b = booking(id);
    if (b['status'] == 'ENTERED') return;
    need(
      b['mode'] == 'DROPOFF' && b['status'] == 'RESERVED',
      '受付できる予約ではありません。',
    );
    final now = DateTime.now();
    need(
      !now.isBefore(DateTime.parse(b['slotStart'] as String)) &&
          now.isBefore(DateTime.parse(b['slotEnd'] as String)),
      '予約日時の範囲内で受付してください。',
    );
    b['status'] = 'ENTERED';
    b['admittedAt'] = now.toUtc().toIso8601String();
    await save();
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final result = await handle(options);
      handler.resolve(
        Response(
          requestOptions: options,
          data: result,
          statusCode:
              options.method == 'POST' &&
                  (options.path.endsWith('/reservations') ||
                      options.path.endsWith('/photos'))
              ? 201
              : 200,
        ),
      );
    } on MockFailure catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: options,
            statusCode: e.status,
            data: {'code': 'MOCK_BUSINESS_ERROR', 'message': e.message},
          ),
        ),
      );
    } catch (_) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: options,
            statusCode: 400,
            data: {'code': 'INVALID_INPUT', 'message': '入力内容を確認してください。'},
          ),
        ),
      );
    }
  }

  Future<Object> handle(RequestOptions o) async {
    final data = o.data is String ? jsonDecode(o.data as String) : o.data;
    final path = o.path.replaceFirst('/api/consumer/v1/', '');
    if (path == 'catalog') {
      return {'facilities': facilities, 'itemTypes': itemTypes, 'slots': slots};
    }
    if (path == 'profile') {
      if (o.method == 'PUT') {
        profile = Map<String, dynamic>.from(data as Map);
        await save();
      }
      return profile;
    }
    if (path == 'reservations') {
      if (o.method == 'GET') return reservations.map(publicBooking).toList();
      final input = Map<String, dynamic>.from(data as Map);
      final same = reservations.where(
        (b) => b['_requestId'] == input['clientRequestId'],
      );
      if (same.isNotEmpty) {
        need(
          same.first['_input'] == jsonEncode(input),
          '送信IDが同じで予約内容が変わっています。',
        );
        return publicBooking(same.first);
      }
      final picked = (input['items'] as List).map((raw) {
        final i = raw as Map;
        final type = itemTypes.firstWhere((t) => t['id'] == i['itemTypeId']);
        return {
          'itemTypeId': type['id'],
          'name': type['name'],
          'quantity': i['quantity'],
          'unitPriceYen': type['priceYen'],
        };
      }).toList();
      need(
        picked.isNotEmpty &&
            picked.every(
              (i) =>
                  (i['quantity'] as int) >= 1 && (i['quantity'] as int) <= 20,
            ),
        '回収品を登録してください。',
      );
      final slot = slots.firstWhere((s) => s['id'] == input['slotId']);
      final dropoff = input['mode'] == 'DROPOFF';
      final location = dropoff
          ? facilities.firstWhere((f) => f['id'] == input['facilityId'])
          : (profile['addresses'] as List).cast<Map>().firstWhere(
              (a) => a['id'] == input['addressId'],
            );
      final b = <String, dynamic>{
        'id': const Uuid().v4(),
        '_requestId': input['clientRequestId'],
        '_input': jsonEncode(input),
        'mode': input['mode'],
        'status': 'RESERVED',
        'locationName': location[dropoff ? 'name' : 'label'],
        'address': dropoff
            ? location['address']
            : '${location['prefecture']}${location['addressLine']}',
        'slotStart': slot['startsAt'],
        'slotEnd': slot['endsAt'],
        'items': picked,
        'amountYen': picked.fold<int>(
          0,
          (sum, i) => sum + (i['quantity'] as int) * (i['unitPriceYen'] as int),
        ),
        'paymentStatus': 'TEST_PAID',
        'note': input['note'] ?? '',
        'photos': <Map<String, dynamic>>[],
        'createdAt': DateTime.now().toUtc().toIso8601String(),
      };
      reservations.insert(0, b);
      await save();
      return publicBooking(b);
    }
    final parts = path.split('/');
    if (parts.first != 'reservations' || parts.length < 2) {
      throw const MockFailure(404, 'APIが見つかりません。');
    }
    final b = booking(parts[1]);
    if (parts.length == 2) return publicBooking(b);
    switch (parts[2]) {
      case 'ticket':
        need(
          b['mode'] == 'DROPOFF' &&
              b['status'] == 'RESERVED' &&
              DateTime.now().isBefore(DateTime.parse(b['slotEnd'] as String)),
          'QRを表示できる予約ではありません。',
        );
        final random = Random.secure();
        final token =
            b['_ticket'] as String? ??
            'rg:entry:v1:${base64UrlEncode(List.generate(32, (_) => random.nextInt(256))).replaceAll('=', '')}';
        b['_ticket'] = token;
        await save();
        return {'token': token, 'expiresAt': b['slotEnd']};
      case 'cancel':
        if (b['status'] == 'CANCELLED') return publicBooking(b);
        need(b['status'] == 'RESERVED', '入場後・完了後の予約は取り消せません。');
        b['status'] = 'CANCELLED';
        b['paymentStatus'] = 'TEST_REFUNDED';
        await save();
        return publicBooking(b);
      case 'complete':
        if (b['status'] == 'COMPLETED') return publicBooking(b);
        need(
          b['status'] == 'ENTERED' && (b['photos'] as List).isNotEmpty,
          '入場受付と写真の登録が必要です。',
        );
        b['status'] = 'COMPLETED';
        b['completedAt'] = DateTime.now().toUtc().toIso8601String();
        await save();
        return publicBooking(b);
      case 'photos':
        if (o.method == 'GET') {
          final saved = preferences.getString('mock-photo-${parts.last}');
          return photoBytes[parts.last] ??
              (saved == null ? Uint8List(0) : base64Decode(saved));
        }
        need(
          b['status'] == 'ENTERED' && (b['photos'] as List).length < 5,
          '入場後に写真を5枚まで登録できます。',
        );
        final file = (o.data as FormData).files.first.value;
        final chunks = await file.finalize().toList();
        final bytes = Uint8List.fromList(chunks.expand((e) => e).toList());
        need(
          bytes.isNotEmpty && bytes.length <= 8 * 1024 * 1024,
          '8MB以下の画像を選んでください。',
        );
        final id = const Uuid().v4();
        photoBytes[id] = bytes;
        await preferences.setString('mock-photo-$id', base64Encode(bytes));
        final p = {
          'id': id,
          'fileName': file.filename ?? '$id.jpg',
          'contentType': 'image/jpeg',
          'size': bytes.length,
        };
        (b['photos'] as List).add(p);
        await save();
        return p;
    }
    throw const MockFailure(404, 'APIが見つかりません。');
  }

  Map<String, dynamic> publicBooking(Map<String, dynamic> b) =>
      Map.fromEntries(b.entries.where((e) => !e.key.startsWith('_')));
}

class MockFailure implements Exception {
  const MockFailure(this.status, this.message);
  final int status;
  final String message;
}
