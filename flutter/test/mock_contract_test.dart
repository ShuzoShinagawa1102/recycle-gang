import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recycle_gang/core/mock_api.dart';
import 'package:recycle_gang_api/recycle_gang_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

void main() {
  test('generated SDK completes dropoff through mock transport and survives reload', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final mock = MockApi(preferences);
    final api = RecycleGangApi(
      dio: Dio(BaseOptions(baseUrl: 'http://mock.invalid')),
      interceptors: [mock],
    );
    final catalog = (await api.getCatalogApi().getCatalog()).data!;
    final reservations = api.getReservationsApi();
    final input = ReservationInput(
      clientRequestId: const Uuid().v4(),
      mode: ReservationInputModeEnum.DROPOFF,
      facilityId: 'tokyo-east',
      slotId: catalog.slots.first.id,
      items: [ItemInput(itemTypeId: 'metal', quantity: 2)],
    );
    final booking = (await reservations.createReservation(
      reservationInput: input,
    )).data!;
    expect(booking.amountYen, 600);
    expect(
      (await reservations.createReservation(reservationInput: input)).data!.id,
      booking.id,
    );
    await expectLater(
      reservations.completeDropoff(reservationId: booking.id),
      throwsA(isA<DioException>()),
    );
    final ticket = (await reservations.getTicket(reservationId: booking.id))
        .data!
        .token;
    expect(ticket, startsWith('rg:entry:v1:'));
    final reloaded = RecycleGangApi(
      dio: Dio(BaseOptions(baseUrl: 'http://mock.invalid')),
      interceptors: [MockApi(preferences)],
    );
    expect(
      (await reloaded.getReservationsApi().getTicket(reservationId: booking.id))
          .data!
          .token,
      ticket,
    );
    await mock.admitLocal(booking.id);
    await expectLater(
      reservations.cancelReservation(reservationId: booking.id),
      throwsA(isA<DioException>()),
    );
    final bytes = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+/lZkAAAAASUVORK5CYII=',
    );
    final photo = (await reservations.uploadPhoto(
      reservationId: booking.id,
      file: MultipartFile.fromBytes(bytes, filename: 'photo.png'),
    )).data!;
    expect(
      (await reservations.downloadPhoto(
        reservationId: booking.id,
        photoId: photo.id,
      )).data,
      bytes,
    );
    expect(
      (await reservations.completeDropoff(reservationId: booking.id))
          .data!
          .status,
      'COMPLETED',
    );
    expect(
      (await reservations.completeDropoff(reservationId: booking.id))
          .data!
          .status,
      'COMPLETED',
    );
    final restored = RecycleGangApi(
      dio: Dio(BaseOptions(baseUrl: 'http://mock.invalid')),
      interceptors: [MockApi(preferences)],
    );
    expect(
      (await restored.getReservationsApi().getReservation(
        reservationId: booking.id,
      )).data!.status,
      'COMPLETED',
    );
  });
}
