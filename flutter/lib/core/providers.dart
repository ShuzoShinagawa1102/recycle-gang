import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recycle_gang_api/recycle_gang_api.dart';
import 'package:uuid/uuid.dart';

import 'config.dart';
import 'mock_api.dart';

final preferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('Initialize preferences in main'),
);
final mockApiProvider = Provider<MockApi>(
  (ref) => MockApi(ref.watch(preferencesProvider)),
);
final apiProvider = Provider<RecycleGangApi>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  final api = RecycleGangApi(dio: dio);
  api.setBearerAuth('bearerAuth', AppConfig.token);
  if (AppConfig.useMocks) dio.interceptors.add(ref.watch(mockApiProvider));
  ref.onDispose(() => dio.close());
  return api;
});
final catalogProvider = FutureProvider<Catalog>(
  (ref) async =>
      (await ref.watch(apiProvider).getCatalogApi().getCatalog()).data!,
);
final profileProvider = FutureProvider<Profile>(
  (ref) async =>
      (await ref.watch(apiProvider).getProfileApi().getProfile()).data!,
);
final reservationsProvider = FutureProvider<List<Reservation>>(
  (ref) async =>
      (await ref.watch(apiProvider).getReservationsApi().listReservations())
          .data!,
);
final reservationProvider = FutureProvider.autoDispose
    .family<Reservation, String>(
      (ref, id) async =>
          (await ref
                  .watch(apiProvider)
                  .getReservationsApi()
                  .getReservation(reservationId: id))
              .data!,
    );
final ticketProvider = FutureProvider.autoDispose.family<Ticket, String>(
  (ref, id) async =>
      (await ref
              .watch(apiProvider)
              .getReservationsApi()
              .getTicket(reservationId: id))
          .data!,
);

String errorMessage(Object error) {
  if (error is DioException) {
    final body = error.response?.data;
    if (body is Map && body['message'] is String) {
      return body['message'] as String;
    }
    if (error.response == null) {
      return 'サーバーに接続できません。起動状態とAPI_BASE_URLを確認してください。';
    }
  }
  return '処理を完了できませんでした。もう一度お試しください。';
}

class BookingDraft {
  final String requestId, mode, facilityId, addressId, slotId, note;
  final Map<String, int> items;
  BookingDraft({
    String? requestId,
    this.mode = 'DROPOFF',
    this.facilityId = 'tokyo-east',
    this.addressId = 'home',
    this.slotId = '',
    this.note = '',
    Map<String, int>? items,
  }) : requestId = requestId ?? const Uuid().v4(),
       items = items ?? {};
  Map<String, dynamic> toJson() => {
    'requestId': requestId,
    'mode': mode,
    'facilityId': facilityId,
    'addressId': addressId,
    'slotId': slotId,
    'note': note,
    'items': items,
  };
  factory BookingDraft.fromJson(Map<String, dynamic> j) => BookingDraft(
    requestId: j['requestId'] as String?,
    mode: j['mode'] as String? ?? 'DROPOFF',
    facilityId: j['facilityId'] as String? ?? '',
    addressId: j['addressId'] as String? ?? '',
    slotId: j['slotId'] as String? ?? '',
    note: j['note'] as String? ?? '',
    items: Map<String, int>.from(j['items'] as Map? ?? {}),
  );
  ReservationInput input() => ReservationInput(
    clientRequestId: requestId,
    mode: mode == 'DROPOFF'
        ? ReservationInputModeEnum.DROPOFF
        : ReservationInputModeEnum.PICKUP,
    facilityId: mode == 'DROPOFF' ? facilityId : null,
    addressId: mode == 'PICKUP' ? addressId : null,
    slotId: slotId,
    items: items.entries
        .where((e) => e.value > 0)
        .map((e) => ItemInput(itemTypeId: e.key, quantity: e.value))
        .toList(),
    note: note,
  );
}

final draftProvider = NotifierProvider<DraftController, BookingDraft>(
  DraftController.new,
);

class DraftController extends Notifier<BookingDraft> {
  String get _key => 'booking-draft-${AppConfig.useMocks ? 'mock' : 'api'}';
  @override
  BookingDraft build() {
    final raw = ref.watch(preferencesProvider).getString(_key);
    if (raw != null) {
      try {
        return BookingDraft.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      } catch (_) {
        /* Discard incompatible local draft. */
      }
    }
    return BookingDraft();
  }

  void update({
    String? mode,
    String? facilityId,
    String? addressId,
    String? slotId,
    String? note,
    Map<String, int>? items,
  }) {
    state = BookingDraft(
      mode: mode ?? state.mode,
      facilityId: facilityId ?? state.facilityId,
      addressId: addressId ?? state.addressId,
      slotId: slotId ?? state.slotId,
      note: note ?? state.note,
      items: items ?? state.items,
    );
    ref.read(preferencesProvider).setString(_key, jsonEncode(state.toJson()));
  }

  void clear() {
    state = BookingDraft();
    ref.read(preferencesProvider).remove(_key);
  }
}
