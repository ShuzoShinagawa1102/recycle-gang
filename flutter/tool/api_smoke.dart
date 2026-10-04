import 'dart:io';

import 'package:dio/dio.dart';
import 'package:recycle_gang_api/recycle_gang_api.dart';
import 'package:uuid/uuid.dart';

/// Starts no servers. Run with the local backend already listening on :8080.
Future<void> main() async {
  final base = Platform.environment['API_BASE_URL'] ?? 'http://localhost:8080';
  final api = RecycleGangApi(basePathOverride: base);
  api.setBearerAuth(
    'bearerAuth',
    Platform.environment['LOCAL_CONSUMER_TOKEN'] ?? 'local-user-demo',
  );
  final catalog = (await api.getCatalogApi().getCatalog()).data!;
  final profile = (await api.getProfileApi().getProfile()).data!;
  await api.getProfileApi().updateProfile(profile: profile);
  final bookings = api.getReservationsApi();
  ReservationInput input(ReservationInputModeEnum mode) => ReservationInput(
    clientRequestId: const Uuid().v4(),
    mode: mode,
    facilityId: mode == ReservationInputModeEnum.DROPOFF ? 'tokyo-east' : null,
    addressId: mode == ReservationInputModeEnum.PICKUP
        ? profile.addresses.first.id
        : null,
    slotId: catalog.slots.first.id,
    items: [ItemInput(itemTypeId: 'metal', quantity: 1)],
    note: 'SDK HTTP smoke test',
  );
  final request = input(ReservationInputModeEnum.DROPOFF);
  final b = (await bookings.createReservation(reservationInput: request)).data!;
  check(
    (await bookings.createReservation(reservationInput: request)).data!.id ==
        b.id,
    'reservation retry',
  );
  final ticket = (await bookings.getTicket(reservationId: b.id)).data!;
  final manager = Dio(
    BaseOptions(
      baseUrl: base,
      headers: {
        'Authorization':
            'Bearer ${Platform.environment['LOCAL_MANAGER_TOKEN'] ?? 'local-manager-demo'}',
      },
    ),
  );
  await manager.post<Object>(
    '/api/backyard/v1/admissions',
    data: {'token': ticket.token},
  );
  final duplicate = await manager.post<Map<String, dynamic>>(
    '/api/backyard/v1/admissions',
    data: {'token': ticket.token},
  );
  check(duplicate.data!['alreadyAdmitted'] == true, 'admission retry');
  final bytes = await File('test/fixtures/dropoff.png').readAsBytes();
  final photo = (await bookings.uploadPhoto(
    reservationId: b.id,
    file: MultipartFile.fromBytes(bytes, filename: 'dropoff.png'),
  )).data!;
  final jpeg = (await bookings.downloadPhoto(
    reservationId: b.id,
    photoId: photo.id,
  )).data!;
  check(
    jpeg.length > 2 && jpeg[0] == 255 && jpeg[1] == 216,
    'normalized JPEG download',
  );
  check(
    (await bookings.completeDropoff(reservationId: b.id)).data!.status ==
        'COMPLETED',
    'dropoff completion',
  );
  check(
    (await bookings.completeDropoff(reservationId: b.id)).data!.status ==
        'COMPLETED',
    'completion retry',
  );
  final pickup = (await bookings.createReservation(
    reservationInput: input(ReservationInputModeEnum.PICKUP),
  )).data!;
  check(
    (await bookings.cancelReservation(reservationId: pickup.id))
            .data!
            .paymentStatus ==
        'TEST_REFUNDED',
    'pickup cancellation',
  );
  check(
    (await bookings.listReservations()).data!.any(
      (x) => x.id == b.id && x.photos.length == 1,
    ),
    'persisted reservation',
  );
  stdout.writeln(
    'PASS: generated Dart SDK ↔ HTTP ↔ Spring Boot ↔ database; dropoff + photo + completion + pickup cancellation',
  );
  api.dio.close();
  manager.close();
}

void check(bool result, String step) {
  if (!result) throw StateError('Failed: $step');
}
