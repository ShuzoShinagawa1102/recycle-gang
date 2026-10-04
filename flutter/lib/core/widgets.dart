import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recycle_gang_api/recycle_gang_api.dart';

import 'providers.dart';

class PageBody extends StatelessWidget {
  const PageBody({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
    children: [
      Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    ],
  );
}

class Load<T> extends StatelessWidget {
  const Load({
    super.key,
    required this.value,
    required this.builder,
    required this.retry,
  });
  final AsyncValue<T> value;
  final Widget Function(T) builder;
  final VoidCallback retry;
  @override
  Widget build(BuildContext context) => value.when(
    data: builder,
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(errorMessage(e)),
            const SizedBox(height: 16),
            FilledButton.tonal(onPressed: retry, child: const Text('再読み込み')),
          ],
        ),
      ),
    ),
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 12),
    child: Text(
      text,
      style: Theme.of(context).textTheme.titleLarge
          ?.copyWith(fontWeight: FontWeight.bold),
    ),
  );
}

class Notice extends StatelessWidget {
  const Notice(this.text, {super.key, this.icon = Icons.info_outline});
  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(text)),
      ],
    ),
  );
}

String modeLabel(String mode) =>
    mode == 'DROPOFF' ? '指定場所に持ち込む' : '指定住所へ回収に来てもらう';
String statusLabel(String status) => switch (status) {
  'RESERVED' => '予約済み',
  'ENTERED' => '入場済み・持込待ち',
  'COMPLETED' => '完了',
  'CANCELLED' => 'キャンセル済み',
  _ => status,
};
String dateLabel(DateTime date) {
  final d = date.toUtc().add(const Duration(hours: 9));
  return '${d.year}/${d.month}/${d.day}';
}

String yen(int amount) =>
    '¥${amount.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

class ReservationTile extends StatelessWidget {
  const ReservationTile(this.reservation, {super.key, required this.onTap});
  final Reservation reservation;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      contentPadding: const EdgeInsets.all(16),
      leading: CircleAvatar(
        child: Icon(
          reservation.mode == 'DROPOFF'
              ? Icons.location_on_outlined
              : Icons.local_shipping_outlined,
        ),
      ),
      title: Text(
        reservation.locationName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${dateLabel(reservation.slotStart)} ・ ${statusLabel(reservation.status)}\n${reservation.items.map((i) => '${i.name} ×${i.quantity}').join('、')}',
      ),
      isThreeLine: true,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    ),
  );
}

void showError(BuildContext context, Object e) =>
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(errorMessage(e))));
