import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recycle_gang_api/recycle_gang_api.dart';
import 'package:uuid/uuid.dart';

import '../../app/router.dart';
import '../../core/config.dart';
import '../../core/providers.dart';
import '../../core/widgets.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => Load(
    value: ref.watch(profileProvider),
    retry: () => ref.invalidate(profileProvider),
    builder: (p) => PageBody(
      children: [
        const SizedBox(height: 8),
        const Center(
          child: CircleAvatar(
            radius: 36,
            child: Icon(Icons.person_outline, size: 40),
          ),
        ),
        Center(child: SectionTitle(p.displayName)),
        Center(child: Text(p.email)),
        const Notice('ローカルのデモアカウントで利用しています。実際の会員登録・ログインは行いません。'),
        ...[
          (Icons.person_outline, 'プロフィール・アカウント', '/profile/edit'),
          (Icons.location_on_outlined, '住所の登録・編集', '/addresses'),
          (Icons.credit_card, '支払い方法', '/payments'),
          (Icons.receipt_long_outlined, '取引履歴', '/transactions'),
          (Icons.edit_note, '予約の下書き', '/drafts'),
        ].map(
          (item) => Card(
            child: ListTile(
              leading: Icon(item.$1),
              title: Text(item.$2),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(item.$3),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'v0.1.0 ・ ${AppConfig.useMocks ? 'モック' : 'ローカルAPI'}',
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});
  @override
  ConsumerState<EditProfilePage> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfilePage> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(),
      email = TextEditingController(),
      phone = TextEditingController();
  bool initialized = false, saving = false;
  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SubPage(
    title: 'プロフィール編集',
    body: Load(
      value: ref.watch(profileProvider),
      retry: () => ref.invalidate(profileProvider),
      builder: (p) {
        if (!initialized) {
          name.text = p.displayName;
          email.text = p.email;
          phone.text = p.phone;
          initialized = true;
        }
        return Form(
          key: form,
          child: PageBody(
            children: [
              const Notice('表示名と連絡先を保存します。ログイン用の認証情報とは別に管理します。'),
              TextFormField(
                controller: name,
                maxLength: 80,
                decoration: const InputDecoration(labelText: '表示名'),
                validator: (s) =>
                    s == null || s.trim().isEmpty ? '表示名を入力してください' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: email,
                maxLength: 200,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'メールアドレス'),
                validator: (s) =>
                    s != null &&
                        s.isNotEmpty &&
                        !RegExp(r'^[^@s]+@[^@s]+.[^@s]+$').hasMatch(s)
                    ? 'メールアドレスを確認してください'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phone,
                maxLength: 30,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: '電話番号'),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: saving
                    ? null
                    : () async {
                        if (!form.currentState!.validate()) return;
                        setState(() => saving = true);
                        try {
                          await ref
                              .read(apiProvider)
                              .getProfileApi()
                              .updateProfile(
                                profile: Profile(
                                  displayName: name.text.trim(),
                                  email: email.text.trim(),
                                  phone: phone.text.trim(),
                                  addresses: p.addresses,
                                ),
                              );
                          ref.invalidate(profileProvider);
                          if (context.mounted) context.pop();
                        } catch (e) {
                          if (context.mounted) showError(context, e);
                        } finally {
                          if (mounted) setState(() => saving = false);
                        }
                      },
                child: Text(saving ? '保存中…' : '保存する'),
              ),
            ],
          ),
        );
      },
    ),
  );
}

class AddressesPage extends ConsumerStatefulWidget {
  const AddressesPage({super.key});
  @override
  ConsumerState<AddressesPage> createState() => _AddressesState();
}

class _AddressesState extends ConsumerState<AddressesPage> {
  bool saving = false;
  Future<void> save(Profile p, List<Address> addresses) async {
    setState(() => saving = true);
    try {
      await ref
          .read(apiProvider)
          .getProfileApi()
          .updateProfile(
            profile: Profile(
              displayName: p.displayName,
              email: p.email,
              phone: p.phone,
              addresses: addresses,
            ),
          );
      ref.invalidate(profileProvider);
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  Future<void> edit(Profile p, [Address? address]) async {
    final result = await showDialog<Address>(
      context: context,
      builder: (_) => AddressDialog(address: address),
    );
    if (result != null && mounted) {
      await save(p, [...p.addresses.where((a) => a.id != result.id), result]);
    }
  }

  @override
  Widget build(BuildContext context) => SubPage(
    title: '住所の登録・編集',
    body: Load(
      value: ref.watch(profileProvider),
      retry: () => ref.invalidate(profileProvider),
      builder: (p) => PageBody(
        children: [
          if (saving) const LinearProgressIndicator(),
          ...p.addresses.map(
            (a) => Card(
              child: ListTile(
                title: Text(a.label),
                subtitle: Text(
                  '〒${a.postalCode}\n${a.prefecture}${a.addressLine}',
                ),
                isThreeLine: true,
                onTap: saving ? null : () => edit(p, a),
                trailing: IconButton(
                  tooltip: '${a.label}を削除',
                  onPressed: saving
                      ? null
                      : () async {
                          final yes = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('住所を削除しますか？'),
                              content: const Text('予約済みの回収先は変わりません。'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('戻る'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('削除'),
                                ),
                              ],
                            ),
                          );
                          if (yes == true && mounted) {
                            await save(
                              p,
                              p.addresses.where((x) => x.id != a.id).toList(),
                            );
                          }
                        },
                  icon: const Icon(Icons.delete_outline),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: saving || p.addresses.length >= 10
                ? null
                : () => edit(p),
            icon: const Icon(Icons.add),
            label: const Text('住所を追加（10件まで）'),
          ),
        ],
      ),
    ),
  );
}

class AddressDialog extends StatefulWidget {
  const AddressDialog({super.key, this.address});
  final Address? address;
  @override
  State<AddressDialog> createState() => _AddressDialogState();
}

class _AddressDialogState extends State<AddressDialog> {
  final form = GlobalKey<FormState>();
  late final TextEditingController label, postal, line;
  late String prefecture;
  static const prefectures = [
    '北海道',
    '青森県',
    '岩手県',
    '宮城県',
    '秋田県',
    '山形県',
    '福島県',
    '茨城県',
    '栃木県',
    '群馬県',
    '埼玉県',
    '千葉県',
    '東京都',
    '神奈川県',
    '新潟県',
    '富山県',
    '石川県',
    '福井県',
    '山梨県',
    '長野県',
    '岐阜県',
    '静岡県',
    '愛知県',
    '三重県',
    '滋賀県',
    '京都府',
    '大阪府',
    '兵庫県',
    '奈良県',
    '和歌山県',
    '鳥取県',
    '島根県',
    '岡山県',
    '広島県',
    '山口県',
    '徳島県',
    '香川県',
    '愛媛県',
    '高知県',
    '福岡県',
    '佐賀県',
    '長崎県',
    '熊本県',
    '大分県',
    '宮崎県',
    '鹿児島県',
    '沖縄県',
  ];
  @override
  void initState() {
    super.initState();
    label = TextEditingController(text: widget.address?.label ?? '自宅');
    postal = TextEditingController(text: widget.address?.postalCode ?? '');
    line = TextEditingController(text: widget.address?.addressLine ?? '');
    prefecture = widget.address?.prefecture ?? '東京都';
  }

  @override
  void dispose() {
    label.dispose();
    postal.dispose();
    line.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.address == null ? '住所を追加' : '住所を編集'),
    content: SizedBox(
      width: 420,
      child: Form(
        key: form,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: label,
                maxLength: 40,
                decoration: const InputDecoration(labelText: '名前（自宅など）'),
                validator: (s) =>
                    s == null || s.trim().isEmpty ? '名前を入力してください' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: postal,
                maxLength: 10,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: '郵便番号'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: prefecture,
                decoration: const InputDecoration(labelText: '都道府県'),
                items: prefectures
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (s) => prefecture = s!,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: line,
                maxLength: 200,
                maxLines: 3,
                decoration: const InputDecoration(labelText: '市区町村・番地・建物'),
                validator: (s) =>
                    s == null || s.trim().isEmpty ? '住所を入力してください' : null,
              ),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('戻る'),
      ),
      FilledButton(
        onPressed: () {
          if (form.currentState!.validate()) {
            Navigator.pop(
              context,
              Address(
                id: widget.address?.id ?? const Uuid().v4(),
                label: label.text.trim(),
                postalCode: postal.text.trim(),
                prefecture: prefecture,
                addressLine: line.text.trim(),
              ),
            );
          }
        },
        child: const Text('保存'),
      ),
    ],
  );
}

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});
  @override
  Widget build(BuildContext context) => const SubPage(
    title: '支払い方法',
    body: PageBody(
      children: [
        SectionTitle('テスト決済'),
        Card(
          child: ListTile(
            leading: Icon(Icons.science_outlined),
            title: Text('ローカル確認用の支払い方法'),
            subtitle: Text('予約時：テスト決済済み\n取消時：テスト返金済み'),
            isThreeLine: true,
            trailing: Icon(Icons.check_circle_outline),
          ),
        ),
        Notice('実際のカード番号や銀行口座を登録する必要はありません。外部の決済サービスへの送信・請求は行いません。'),
      ],
    ),
  );
}

class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => SubPage(
    title: '取引履歴',
    body: Load(
      value: ref.watch(reservationsProvider),
      retry: () => ref.invalidate(reservationsProvider),
      builder: (list) => PageBody(
        children: [
          const Notice('ローカルのテスト決済記録です。'),
          if (list.isEmpty) const Text('取引はまだありません。'),
          ...list.map(
            (b) => Card(
              child: ListTile(
                title: Text(b.locationName),
                subtitle: Text(
                  '${dateLabel(b.createdAt)} ・ ${b.paymentStatus == 'TEST_REFUNDED' ? 'テスト返金済み' : 'テスト決済済み'}',
                ),
                trailing: Text(yen(b.amountYen)),
                onTap: () => context.push('/activity/${b.id}'),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
