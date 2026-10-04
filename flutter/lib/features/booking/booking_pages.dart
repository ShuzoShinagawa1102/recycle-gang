import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recycle_gang_api/recycle_gang_api.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/router.dart';
import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../home/home_pages.dart';

class RequestPage extends ConsumerWidget {
  const RequestPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => PageBody(
    children: [
      const SectionTitle('リサイクルを依頼する'),
      const Text('回収方法を選んでください。'),
      const SizedBox(height: 16),
      ...[true, false].map(
        (dropoff) => MethodCard(
          dropoff: dropoff,
          onTap: () {
            ref
                .read(draftProvider.notifier)
                .update(mode: dropoff ? 'DROPOFF' : 'PICKUP');
            context.push('/booking');
          },
        ),
      ),
      const SizedBox(height: 16),
      OutlinedButton.icon(
        onPressed: () => context.push('/drafts'),
        icon: const Icon(Icons.edit_note),
        label: const Text('保存した下書き'),
      ),
      TextButton(
        onPressed: () => context.push('/prices'),
        child: const Text('回収品・テスト料金を確認'),
      ),
    ],
  );
}

class DraftsPage extends ConsumerWidget {
  const DraftsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(draftProvider);
    return SubPage(
      title: '下書き',
      body: PageBody(
        children: [
          const Notice('入力途中の予約を、この端末に1件保存します。'),
          Card(
            child: ListTile(
              title: Text(modeLabel(draft.mode)),
              subtitle: Text(
                '${draft.items.values.where((v) => v > 0).length}種類の回収品',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/booking'),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(draftProvider.notifier).clear();
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('下書きを削除しました。')));
            },
            child: const Text('下書きを削除'),
          ),
        ],
      ),
    );
  }
}

class BookingPage extends ConsumerStatefulWidget {
  const BookingPage({super.key});
  @override
  ConsumerState<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends ConsumerState<BookingPage> {
  late final TextEditingController note;
  @override
  void initState() {
    super.initState();
    note = TextEditingController(text: ref.read(draftProvider).note);
  }

  @override
  void dispose() {
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = ref.watch(draftProvider);
    return SubPage(
      title: d.mode == 'DROPOFF' ? '持込予約を作成' : '回収依頼を作成',
      body: Load(
        value: ref.watch(catalogProvider),
        retry: () => ref.invalidate(catalogProvider),
        builder: (catalog) => Load(
          value: ref.watch(profileProvider),
          retry: () => ref.invalidate(profileProvider),
          builder: (profile) {
            final facility = catalog.facilities
                .where((f) => f.id == d.facilityId)
                .firstOrNull;
            final address = profile.addresses
                .where((a) => a.id == d.addressId)
                .firstOrNull;
            final slot = catalog.slots
                .where((s) => s.id == d.slotId)
                .firstOrNull;
            final amount = total(catalog, d);
            return PageBody(
              children: [
                const Notice('入力内容は下書きとして自動保存されます。'),
                SelectionCard(
                  number: '1',
                  title: '回収品',
                  value: d.items.entries
                      .where((e) => e.value > 0)
                      .map(
                        (e) =>
                            '${catalog.itemTypes.where((i) => i.id == e.key).firstOrNull?.name ?? e.key} ×${e.value}',
                      )
                      .join('、'),
                  onTap: () => context.push('/booking/items'),
                ),
                SelectionCard(
                  number: '2',
                  title: d.mode == 'DROPOFF' ? '持込場所' : '回収先住所',
                  value: d.mode == 'DROPOFF'
                      ? facility?.name ?? ''
                      : address == null
                      ? ''
                      : '${address.label}：${address.prefecture}${address.addressLine}',
                  onTap: () => context.push('/booking/location'),
                ),
                SelectionCard(
                  number: '3',
                  title: d.mode == 'DROPOFF' ? '持込日時' : '回収日時',
                  value: slot?.label ?? '',
                  onTap: () => context.push('/booking/date'),
                ),
                SelectionCard(
                  number: '4',
                  title: '支払い方法',
                  value: 'テスト決済（請求は発生しません）',
                  onTap: () => context.push('/payments'),
                ),
                const SectionTitle('連絡事項'),
                TextField(
                  controller: note,
                  maxLength: 500,
                  maxLines: 3,
                  onChanged: (text) =>
                      ref.read(draftProvider.notifier).update(note: text),
                  decoration: const InputDecoration(
                    hintText: '回収品や受け渡しについて補足があれば記入',
                  ),
                ),
                const SectionTitle('テスト料金'),
                Text(
                  yen(amount),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                TextButton(
                  onPressed: () => context.push('/prices'),
                  child: const Text('料金の内訳を確認'),
                ),
              ],
            );
          },
        ),
      ),
      bottom: FilledButton(
        onPressed: () {
          final c = ref.read(catalogProvider).asData?.value;
          if (c == null ||
              !d.items.values.any((q) => q > 0) ||
              !c.slots.any((s) => s.id == d.slotId)) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('回収品と日時を選んでください。')));
            return;
          }
          if (d.mode == 'DROPOFF'
              ? !c.facilities.any((f) => f.id == d.facilityId)
              : !(ref
                        .read(profileProvider)
                        .asData
                        ?.value
                        .addresses
                        .any((a) => a.id == d.addressId) ??
                    false)) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('場所を選んでください。')));
            return;
          }
          context.push('/booking/review');
        },
        child: const Text('予約内容を確認する'),
      ),
    );
  }
}

class SelectionCard extends StatelessWidget {
  const SelectionCard({
    super.key,
    required this.number,
    required this.title,
    required this.value,
    required this.onTap,
  });
  final String number, title, value;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      contentPadding: const EdgeInsets.all(18),
      leading: CircleAvatar(radius: 16, child: Text(number)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(value.isEmpty ? '選択してください' : value),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    ),
  );
}

int total(Catalog c, BookingDraft d) =>
    c.itemTypes.fold(0, (sum, i) => sum + i.priceYen * (d.items[i.id] ?? 0));

class ItemsPage extends ConsumerWidget {
  const ItemsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = ref.watch(draftProvider);
    return SubPage(
      title: '回収品を登録',
      body: Load(
        value: ref.watch(catalogProvider),
        retry: () => ref.invalidate(catalogProvider),
        builder: (c) => PageBody(
          children: [
            const Notice('品目ごとに数量を選びます。1種類につき20まで登録できます。'),
            ...c.itemTypes.map(
              (i) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        i.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text('${yen(i.priceYen)} / ${i.unit}（テスト料金）'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            tooltip: '${i.name}を減らす',
                            onPressed: (d.items[i.id] ?? 0) > 0
                                ? () => ref
                                      .read(draftProvider.notifier)
                                      .update(
                                        items: {
                                          ...d.items,
                                          i.id: d.items[i.id]! - 1,
                                        },
                                      )
                                : null,
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text(
                            '${d.items[i.id] ?? 0}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          IconButton(
                            tooltip: '${i.name}を増やす',
                            onPressed: (d.items[i.id] ?? 0) < 20
                                ? () => ref
                                      .read(draftProvider.notifier)
                                      .update(
                                        items: {
                                          ...d.items,
                                          i.id: (d.items[i.id] ?? 0) + 1,
                                        },
                                      )
                                : null,
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottom: FilledButton(
        onPressed: () => context.pop(),
        child: const Text('この内容で保存'),
      ),
    );
  }
}

class LocationPage extends ConsumerWidget {
  const LocationPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = ref.watch(draftProvider);
    if (d.mode == 'PICKUP') {
      return SubPage(
        title: '回収先住所を選択',
        body: Load(
          value: ref.watch(profileProvider),
          retry: () => ref.invalidate(profileProvider),
          builder: (p) => PageBody(
            children: [
              if (p.addresses.isEmpty) const Notice('住所を登録してください。'),
              ...p.addresses.map(
                (a) => Card(
                  child: ListTile(
                    leading: Icon(
                      d.addressId == a.id
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                    ),
                    title: Text(a.label),
                    subtitle: Text('${a.prefecture}${a.addressLine}'),
                    onTap: () {
                      ref.read(draftProvider.notifier).update(addressId: a.id);
                      context.pop();
                    },
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => context.push('/addresses'),
                icon: const Icon(Icons.add_location_alt_outlined),
                label: const Text('住所の登録・編集'),
              ),
            ],
          ),
        ),
      );
    }
    return SubPage(
      title: '持込場所を選択',
      body: Load(
        value: ref.watch(catalogProvider),
        retry: () => ref.invalidate(catalogProvider),
        builder: (c) => PageBody(
          children: [
            const Notice('東京都のデモ施設です。実在の受付場所ではありません。'),
            ...c.facilities.map(
              (f) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        f.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(f.address),
                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: () =>
                                context.push('/facilities/${f.id}'),
                            icon: const Icon(Icons.map_outlined),
                            label: const Text('施設詳細・地図'),
                          ),
                          const Spacer(),
                          FilledButton.tonal(
                            onPressed: () {
                              ref
                                  .read(draftProvider.notifier)
                                  .update(facilityId: f.id);
                              context.pop();
                            },
                            child: const Text('ここに持ち込む'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FacilityPage extends ConsumerWidget {
  const FacilityPage({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) => SubPage(
    title: '持込場所の詳細',
    body: Load(
      value: ref.watch(catalogProvider),
      retry: () => ref.invalidate(catalogProvider),
      builder: (c) {
        final f = c.facilities.where((x) => x.id == id).firstOrNull;
        if (f == null) return const Center(child: Text('施設が見つかりません。'));
        return PageBody(
          children: [
            const Icon(Icons.location_on_outlined, size: 64),
            SectionTitle(f.name),
            Text(f.address),
            const SectionTitle('受付時のご案内'),
            Text(f.instructions),
            const Notice('地図は外部の地図サービスで開きます。表示位置は動作確認用です。'),
            OutlinedButton.icon(
              onPressed: () async {
                final ok = await launchUrl(
                  Uri.parse(
                    'https://www.google.com/maps/search/?api=1&query=${f.latitude},${f.longitude}',
                  ),
                  mode: LaunchMode.externalApplication,
                );
                if (!ok && context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('地図を開けませんでした。')));
                }
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text('地図で場所を見る'),
            ),
          ],
        );
      },
    ),
  );
}

class DatePage extends ConsumerWidget {
  const DatePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = ref.watch(draftProvider);
    return SubPage(
      title: d.mode == 'DROPOFF' ? '持込日時を選択' : '回収日時を選択',
      body: Load(
        value: ref.watch(catalogProvider),
        retry: () => ref.invalidate(catalogProvider),
        builder: (c) => PageBody(
          children: [
            const Notice('今日から2週間のテスト受付枠です。QRの入場受付を今すぐ確認する場合は今日を選んでください。'),
            ...c.slots.map(
              (s) => Card(
                child: ListTile(
                  leading: Icon(
                    d.slotId == s.id
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                  ),
                  title: Text(s.label),
                  onTap: () {
                    ref.read(draftProvider.notifier).update(slotId: s.id);
                    context.pop();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PricesPage extends ConsumerWidget {
  const PricesPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => SubPage(
    title: '回収品・料金',
    body: Load(
      value: ref.watch(catalogProvider),
      retry: () => ref.invalidate(catalogProvider),
      builder: (c) => PageBody(
        children: [
          const Notice('ローカル確認用の料金表です。実際のサービス料金ではありません。'),
          ...c.itemTypes.map(
            (i) => Card(
              child: ListTile(
                title: Text(i.name),
                subtitle: Text('1${i.unit}あたり'),
                trailing: Text(yen(i.priceYen)),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class ReviewPage extends ConsumerStatefulWidget {
  const ReviewPage({super.key});
  @override
  ConsumerState<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends ConsumerState<ReviewPage> {
  bool submitting = false;
  Future<void> submit() async {
    if (submitting) return;
    setState(() => submitting = true);
    try {
      final result =
          (await ref
                  .read(apiProvider)
                  .getReservationsApi()
                  .createReservation(
                    reservationInput: ref.read(draftProvider).input(),
                  ))
              .data!;
      ref.read(draftProvider.notifier).clear();
      ref.invalidate(reservationsProvider);
      if (mounted) context.go('/complete/${result.id}');
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = ref.watch(draftProvider);
    return SubPage(
      title: '予約内容の確認',
      body: Load(
        value: ref.watch(catalogProvider),
        retry: () => ref.invalidate(catalogProvider),
        builder: (c) => Load(
          value: ref.watch(profileProvider),
          retry: () => ref.invalidate(profileProvider),
          builder: (p) {
            final f = c.facilities
                .where((f) => f.id == d.facilityId)
                .firstOrNull;
            final a = p.addresses.where((a) => a.id == d.addressId).firstOrNull;
            return PageBody(
              children: [
                SectionTitle(modeLabel(d.mode)),
                Text(
                  d.mode == 'DROPOFF'
                      ? f?.name ?? '未選択'
                      : '${a?.prefecture ?? ''}${a?.addressLine ?? ''}',
                ),
                const SizedBox(height: 12),
                Text(
                  c.slots.where((s) => s.id == d.slotId).firstOrNull?.label ??
                      '日時を選んでください',
                ),
                const SectionTitle('回収品'),
                ...c.itemTypes
                    .where((i) => (d.items[i.id] ?? 0) > 0)
                    .map(
                      (i) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('${i.name} ×${d.items[i.id]}'),
                        trailing: Text(yen(i.priceYen * d.items[i.id]!)),
                      ),
                    ),
                if (d.note.isNotEmpty) Notice(d.note),
                const SectionTitle('テスト決済の合計'),
                Text(
                  yen(total(c, d)),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Notice('この予約はローカル動作確認用です。カード情報の入力は不要で、請求は発生しません。'),
                if (d.mode == 'DROPOFF')
                  const Notice('予約後に入場QRが発行されます。施設で入場受付後、写真と「捨てました！」で完了します。'),
              ],
            );
          },
        ),
      ),
      bottom: FilledButton(
        onPressed: submitting ? null : submit,
        child: Text(submitting ? '予約を送信中…' : 'この内容で予約する'),
      ),
    );
  }
}

class CreatedPage extends StatelessWidget {
  const CreatedPage({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context) => SubPage(
    title: '予約完了',
    body: PageBody(
      children: [
        const SizedBox(height: 32),
        Icon(
          Icons.check_circle,
          size: 88,
          color: Theme.of(context).colorScheme.primary,
        ),
        const Center(child: SectionTitle('予約を受け付けました')),
        const Center(child: Text('予約内容と、次にやることを確認しましょう。')),
        const SizedBox(height: 32),
        FilledButton(
          onPressed: () => context.go('/activity/$id'),
          child: const Text('予約の詳細を見る'),
        ),
        TextButton(onPressed: () => context.go('/'), child: const Text('ホームへ')),
      ],
    ),
  );
}
