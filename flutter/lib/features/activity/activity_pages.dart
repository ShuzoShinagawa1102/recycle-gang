import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:recycle_gang_api/recycle_gang_api.dart';

import '../../app/router.dart';
import '../../core/config.dart';
import '../../core/providers.dart';
import '../../core/widgets.dart';

class ActivityPage extends ConsumerWidget {
  const ActivityPage({super.key, this.tasksOnly = false});
  final bool tasksOnly;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final body = Load(
      value: ref.watch(reservationsProvider),
      retry: () => ref.invalidate(reservationsProvider),
      builder: (all) {
        final list = all
            .where(
              (b) =>
                  !tasksOnly || b.status == 'RESERVED' || b.status == 'ENTERED',
            )
            .toList();
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(reservationsProvider);
            await ref.read(reservationsProvider.future);
          },
          child: PageBody(
            children: [
              SectionTitle(tasksOnly ? '次にやること' : 'アクティビティ'),
              if (list.isEmpty) const Notice('予約はまだありません。'),
              ...list.map(
                (b) => ReservationTile(
                  b,
                  onTap: () => context.push('/activity/${b.id}'),
                ),
              ),
            ],
          ),
        );
      },
    );
    return tasksOnly ? SubPage(title: 'やること一覧', body: body) : body;
  }
}

class DetailPage extends ConsumerStatefulWidget {
  const DetailPage({super.key, required this.id});
  final String id;
  @override
  ConsumerState<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  Timer? timer;
  bool working = false;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (mounted && ModalRoute.of(context)?.isCurrent == true && !working) {
        ref.invalidate(reservationProvider(widget.id));
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void refresh() {
    ref.invalidate(reservationProvider(widget.id));
    ref.invalidate(reservationsProvider);
  }

  Future<void> action(Future<void> Function() run) async {
    if (working) return;
    setState(() => working = true);
    try {
      await run();
      refresh();
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => working = false);
    }
  }

  Future<void> upload(ImageSource source) => action(() async {
    final photo = await ImagePicker().pickImage(
      source: source,
      maxWidth: 2000,
      maxHeight: 2000,
      imageQuality: 85,
    );
    if (photo == null) return;
    final bytes = await photo.readAsBytes();
    if (bytes.length > 8 * 1024 * 1024) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('8MB以下の写真を選んでください。')));
      }
      return;
    }
    await ref
        .read(apiProvider)
        .getReservationsApi()
        .uploadPhoto(
          reservationId: widget.id,
          file: MultipartFile.fromBytes(bytes, filename: photo.name),
        );
  });
  Future<bool> confirm(String title, String message) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('戻る'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('確定する'),
            ),
          ],
        ),
      ) ??
      false;
  @override
  Widget build(BuildContext context) => SubPage(
    title: 'アクティビティ詳細',
    actions: [
      IconButton(
        tooltip: '状態を更新',
        onPressed: working ? null : refresh,
        icon: const Icon(Icons.refresh),
      ),
    ],
    body: Load(
      value: ref.watch(reservationProvider(widget.id)),
      retry: refresh,
      builder: (b) => PageBody(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Chip(
              label: Text(statusLabel(b.status)),
              avatar: Icon(
                b.status == 'COMPLETED'
                    ? Icons.check_circle_outline
                    : Icons.schedule,
                size: 18,
              ),
            ),
          ),
          SectionTitle(b.locationName),
          Text(b.address),
          const SizedBox(height: 12),
          Text('${dateLabel(b.slotStart)} ・ ${modeLabel(b.mode)}'),
          if (b.status == 'RESERVED' && b.mode == 'DROPOFF') ...[
            const Notice('施設の入口で管理人にQRコードを提示してください。受付後、この画面から写真を登録できます。'),
            FilledButton.icon(
              onPressed: working
                  ? null
                  : () async {
                      await context.push('/activity/${b.id}/qr');
                      refresh();
                    },
              icon: const Icon(Icons.qr_code),
              label: const Text('入場QRコードを表示'),
            ),
          ],
          if (b.status == 'ENTERED') ...[
            const Notice('入場受付が完了しました。指定場所に品物を置き、写真を登録してください。'),
            const SectionTitle('持込後の写真'),
            if (b.photos.length < 5)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: working
                        ? null
                        : () => upload(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('写真を撮る'),
                  ),
                  OutlinedButton.icon(
                    onPressed: working
                        ? null
                        : () => upload(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('写真を選ぶ'),
                  ),
                ],
              ),
            const SizedBox(height: 12),
            Text('${b.photos.length}/5枚 ・ JPEG / PNG、1枚8MBまで'),
          ],
          if (b.photos.isNotEmpty) PhotoList(reservation: b),
          if (b.status == 'ENTERED') ...[
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: working || b.photos.isEmpty
                  ? null
                  : () async {
                      if (await confirm(
                        '持込を完了しますか？',
                        '品物を指定場所に置いたことを記録します。退場時の受付は不要です。',
                      )) {
                        await action(() async {
                          await ref
                              .read(apiProvider)
                              .getReservationsApi()
                              .completeDropoff(reservationId: b.id);
                        });
                      }
                    },
              icon: const Icon(Icons.check),
              label: Text(working ? '処理中…' : '捨てました！'),
            ),
          ],
          if (b.status == 'COMPLETED')
            const Notice(
              '持込が完了しました。ご協力ありがとうございます。退場時の受付は不要です。',
              icon: Icons.check_circle_outline,
            ),
          if (b.status == 'RESERVED' && b.mode == 'PICKUP')
            const Notice('指定した住所・日時での回収予約です。このローカル版では予約の作成・確認・取消を操作できます。'),
          const SectionTitle('回収品'),
          ...b.items.map(
            (i) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('${i.name} ×${i.quantity}'),
              trailing: Text(yen(i.unitPriceYen * i.quantity)),
            ),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              b.paymentStatus == 'TEST_REFUNDED' ? 'テスト返金済み' : 'テスト決済済み',
            ),
            trailing: Text(yen(b.amountYen)),
          ),
          if (b.note.isNotEmpty) Notice(b.note),
          const SectionTitle('予約の記録'),
          Text('予約番号：${b.id}', style: Theme.of(context).textTheme.bodySmall),
          Text('予約日：${dateLabel(b.createdAt)}'),
          if (b.admittedAt != null) Text('入場受付：${dateLabel(b.admittedAt!)}'),
          if (b.completedAt != null) Text('持込完了：${dateLabel(b.completedAt!)}'),
          if (b.status == 'RESERVED')
            TextButton(
              onPressed: working
                  ? null
                  : () async {
                      if (await confirm(
                        '予約をキャンセルしますか？',
                        'テスト決済を取り消します。入場QRも利用できなくなります。',
                      )) {
                        await action(() async {
                          await ref
                              .read(apiProvider)
                              .getReservationsApi()
                              .cancelReservation(reservationId: b.id);
                        });
                      }
                    },
              child: const Text('予約をキャンセル'),
            ),
          if (working) const LinearProgressIndicator(),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => context.go('/activity'),
            child: const Text('アクティビティ一覧へ'),
          ),
        ],
      ),
    ),
  );
}

class PhotoList extends ConsumerWidget {
  const PhotoList({super.key, required this.reservation});
  final Reservation reservation;
  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: reservation.photos
          .map(
            (p) => ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 144,
                height: 144,
                child: FutureBuilder<Uint8List>(
                  future: ref
                      .read(apiProvider)
                      .getReservationsApi()
                      .downloadPhoto(
                        reservationId: reservation.id,
                        photoId: p.id,
                      )
                      .then((r) => r.data!),
                  builder: (context, snapshot) => snapshot.hasData
                      ? Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              const Center(child: Text('画像を表示できません')),
                        )
                      : snapshot.hasError
                      ? const Center(child: Icon(Icons.broken_image_outlined))
                      : const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          )
          .toList(),
    ),
  );
}

class QrPage extends ConsumerStatefulWidget {
  const QrPage({super.key, required this.id});
  final String id;
  @override
  ConsumerState<QrPage> createState() => _QrPageState();
}

class _QrPageState extends ConsumerState<QrPage> {
  bool working = false;
  @override
  Widget build(BuildContext context) => SubPage(
    title: '施設の入場QRコード',
    body: Load(
      value: ref.watch(ticketProvider(widget.id)),
      retry: () => ref.invalidate(ticketProvider(widget.id)),
      builder: (ticket) => PageBody(
        children: [
          const SectionTitle('入口の管理人に提示してください'),
          const Text('この予約専用のQRコードです。他の人に共有しないでください。'),
          const SizedBox(height: 24),
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: QrImageView(
                data: ticket.token,
                version: QrVersions.auto,
                size: 240,
                backgroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '有効期限：${dateLabel(ticket.expiresAt.subtract(const Duration(seconds: 1)))} 24:00（日本時間）',
            ),
          ),
          const Notice('QRを表示しただけでは入場済みになりません。管理人の受付後に、予約詳細へ戻ってください。'),
          OutlinedButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: ticket.token));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('受付テスト用のコードをコピーしました。')),
                );
              }
            },
            icon: const Icon(Icons.copy),
            label: const Text('受付テスト用にコードをコピー'),
          ),
          if (AppConfig.useMocks) ...[
            const SectionTitle('モック動作確認'),
            const Text('サーバーを使わず、管理人の入場受付を再現します。'),
            const SizedBox(height: 8),
            FilledButton.tonal(
              onPressed: working
                  ? null
                  : () async {
                      setState(() => working = true);
                      try {
                        await ref.read(mockApiProvider).admitLocal(widget.id);
                        ref.invalidate(ticketProvider(widget.id));
                        ref.invalidate(reservationProvider(widget.id));
                        ref.invalidate(reservationsProvider);
                        if (context.mounted) context.pop();
                      } catch (e) {
                        if (context.mounted) showError(context, e);
                      } finally {
                        if (mounted) setState(() => working = false);
                      }
                    },
              child: const Text('モック入場受付を実行'),
            ),
          ],
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('予約詳細に戻る'),
          ),
        ],
      ),
    ),
  );
}
