import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/providers.dart';
import '../../core/widgets.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => RefreshIndicator(
    onRefresh: () async {
      ref.invalidate(reservationsProvider);
      await ref.read(reservationsProvider.future);
    },
    child: PageBody(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'RECYCLE GANG',
                style: TextStyle(
                  color: Colors.white70,
                  letterSpacing: 2,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '資源に、\n次の出番を。',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 12),
              Text(
                '持ち込む。来てもらう。\nあなたに合った方法で、リサイクル。',
                style: TextStyle(color: Colors.white, height: 1.6),
              ),
            ],
          ),
        ),
        const SectionTitle('今日は、どうリサイクルする？'),
        MethodCard(
          dropoff: true,
          onTap: () {
            ref.read(draftProvider.notifier).update(mode: 'DROPOFF');
            context.push('/booking');
          },
        ),
        MethodCard(
          dropoff: false,
          onTap: () {
            ref.read(draftProvider.notifier).update(mode: 'PICKUP');
            context.push('/booking');
          },
        ),
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                onPressed: () => context.push('/tasks'),
                icon: const Icon(Icons.checklist),
                label: const Text('やること'),
              ),
            ),
            Expanded(
              child: TextButton.icon(
                onPressed: () => context.push('/notifications'),
                icon: const Icon(Icons.notifications_none),
                label: const Text('お知らせ'),
              ),
            ),
          ],
        ),
        const SectionTitle('次の予定'),
        Load(
          value: ref.watch(reservationsProvider),
          retry: () => ref.invalidate(reservationsProvider),
          builder: (bookings) {
            final active = bookings
                .where((b) => b.status == 'RESERVED' || b.status == 'ENTERED')
                .take(3)
                .toList();
            return active.isEmpty
                ? const Notice(
                    'まだ予約はありません。回収品を登録して、最初の予約を作りましょう。',
                    icon: Icons.event_available,
                  )
                : Column(
                    children: active
                        .map(
                          (b) => ReservationTile(
                            b,
                            onTap: () => context.push('/activity/${b.id}'),
                          ),
                        )
                        .toList(),
                  );
          },
        ),
        ListTile(
          leading: const Icon(Icons.menu_book_outlined),
          title: const Text('回収ガイド'),
          subtitle: const Text('持込から完了までの流れ'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/guide'),
        ),
      ],
    ),
  );
}

class MethodCard extends StatelessWidget {
  const MethodCard({super.key, required this.dropoff, required this.onTap});
  final bool dropoff;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      contentPadding: const EdgeInsets.all(20),
      leading: Icon(
        dropoff ? Icons.location_on_outlined : Icons.local_shipping_outlined,
        size: 34,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        dropoff ? '指定場所に持ち込む' : '指定住所へ回収に来てもらう',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(dropoff ? '場所と日時を選んで、QRで受付' : '回収品と住所を登録して予約'),
      ),
      trailing: const Icon(Icons.arrow_forward),
      onTap: onTap,
    ),
  );
}

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => SubPage(
    title: 'お知らせ',
    body: Load(
      value: ref.watch(reservationsProvider),
      retry: () => ref.invalidate(reservationsProvider),
      builder: (list) => PageBody(
        children: [
          if (list.isEmpty) const Notice('お知らせはまだありません。'),
          ...list.map(
            (b) => Card(
              child: ListTile(
                leading: const Icon(Icons.notifications_none),
                title: Text('${statusLabel(b.status)}：${b.locationName}'),
                subtitle: Text('${dateLabel(b.createdAt)} ・ 予約の詳細を確認する'),
                onTap: () => context.push('/activity/${b.id}'),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class GuidePage extends StatelessWidget {
  const GuidePage({super.key});
  @override
  Widget build(BuildContext context) => const SubPage(
    title: '回収ガイド',
    body: PageBody(
      children: [
        SectionTitle('指定場所に持ち込む'),
        Notice('1. 回収品・施設・日時を選んで予約します。'),
        Notice('2. 施設の入口で管理人にQRコードを提示します。'),
        Notice('3. 案内された場所に品物を置き、写真を登録します。'),
        Notice('4. 「捨てました！」を押すと完了です。退場時の受付は不要です。'),
        SectionTitle('指定住所へ回収に来てもらう'),
        Notice(
          '回収品と住所・日時を登録します。予約済みの内容はアクティビティで確認できます。ユーザーが回収完了を操作することはありません。',
        ),
        SectionTitle('ローカル版の確認データ'),
        Notice(
          '施設・受付枠・料金は動作確認用です。施設の実際の営業情報ではありません。テスト決済のため、請求や返金の実取引は発生しません。',
        ),
      ],
    ),
  );
}
