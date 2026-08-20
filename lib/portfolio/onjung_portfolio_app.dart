import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/portfolio/data/onjung_demo_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

const _brand = Color(0xFFE86F3D);
const _ink = Color(0xFF26221F);
const _cream = Color(0xFFFFF8F2);
const _soft = Color(0xFFF5E9DF);
const _green = Color(0xFF3F7D65);

final _won = NumberFormat('#,###', 'ko_KR');
final _date = DateFormat('M월 d일');

class OnjungState {
  const OnjungState({required this.records, required this.upcoming});

  final List<OnjungRecord> records;
  final List<UpcomingEvent> upcoming;

  OnjungState copyWith({List<OnjungRecord>? records}) =>
      OnjungState(records: records ?? this.records, upcoming: upcoming);
}

class OnjungController extends StateNotifier<OnjungState> {
  OnjungController(OnjungDemoRepository repository)
      : super(
          OnjungState(
            records: repository.initialRecords,
            upcoming: repository.upcomingEvents,
          ),
        );

  void addRecord(OnjungRecord record) {
    state = state.copyWith(records: [record, ...state.records]);
  }
}

final onjungProvider = StateNotifierProvider<OnjungController, OnjungState>(
  (ref) => OnjungController(const OnjungDemoRepository()),
);

class OnjungPortfolioApp extends StatelessWidget {
  const OnjungPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _brand,
      brightness: Brightness.light,
      surface: const Color(0xFFFFFBF8),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '온정',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: const Color(0xFFFFFBF8),
        fontFamily: 'Pretendard',
        textTheme: ThemeData.light().textTheme.apply(
              bodyColor: _ink,
              displayColor: _ink,
              fontFamily: 'Pretendard',
            ),
        navigationBarTheme: const NavigationBarThemeData(
          height: 68,
          backgroundColor: Colors.white,
          indicatorColor: Color(0xFFFFE6D9),
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF8F2ED),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: _brand, width: 1.4),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
      home: const OnjungShell(),
    );
  }
}

class OnjungShell extends StatefulWidget {
  const OnjungShell({super.key});

  @override
  State<OnjungShell> createState() => _OnjungShellState();
}

class _OnjungShellState extends State<OnjungShell> {
  int _index = 0;

  void _openAddRecord() async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const AddRecordScreen()),
    );
    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('온정 기록을 저장했어요. 관계 기록에 바로 반영됩니다.')),
      );
      setState(() => _index = 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onOpenRecords: () => setState(() => _index = 1)),
      const RecordsScreen(),
      const CalendarScreen(),
      const MyOnjungScreen(),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      floatingActionButton: _index < 3
          ? FloatingActionButton.extended(
              key: const Key('quick-record-fab'),
              onPressed: _openAddRecord,
              backgroundColor: _ink,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_rounded),
              label: const Text('온정 기록'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: '홈',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: '온정록',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month_rounded),
            label: '캘린더',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_rounded),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: '내 온정',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, required this.onOpenRecords});

  final VoidCallback onOpenRecords;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onjungProvider);
    final monthRecords = state.records
        .where((r) => r.date.year == 2026 && r.date.month == 8)
        .toList();
    final sent = monthRecords
        .where((r) => r.isSent)
        .fold<int>(0, (sum, r) => sum + r.amount);
    final received = monthRecords
        .where((r) => !r.isSent)
        .fold<int>(0, (sum, r) => sum + r.amount);

    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 120),
            sliver: SliverList.list(
              children: [
                const _BrandHeader(
                  eyebrow: '관계를 기억하는 가장 따뜻한 장부',
                  title: '온정',
                ),
                const SizedBox(height: 24),
                _BalanceHero(sent: sent, received: received),
                const SizedBox(height: 28),
                _SectionHeader(
                  title: '최근 온정',
                  action: '전체 보기',
                  onPressed: onOpenRecords,
                ),
                const SizedBox(height: 12),
                ...state.records.take(3).map(
                      (record) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _RecordTile(record: record),
                      ),
                    ),
                const SizedBox(height: 18),
                const _SectionHeader(title: '다가오는 경조사'),
                const SizedBox(height: 12),
                _UpcomingCard(event: state.upcoming.first),
                const SizedBox(height: 28),
                const _RelationshipInsight(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceHero extends StatelessWidget {
  const _BalanceHero({required this.sent, required this.received});

  final int sent;
  final int received;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF17B48), Color(0xFFE45B35)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(color: Color(0x22C5522C), blurRadius: 24, offset: Offset(0, 12)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  '2026년 8월',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
              const Spacer(),
              const Icon(Icons.auto_awesome_rounded, color: Colors.white),
            ],
          ),
          const SizedBox(height: 28),
          const Text(
            '이번 달 온정 흐름',
            style: TextStyle(color: Color(0xFFFFEDE5), fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            '주고받은 마음을\n한눈에 확인하세요',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  height: 1.28,
                ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _HeroMetric(label: '보낸 온정', amount: sent)),
              const SizedBox(width: 12),
              Expanded(child: _HeroMetric(label: '받은 온정', amount: received)),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.label, required this.amount});
  final String label;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFFFFE9E0), fontSize: 12)),
          const SizedBox(height: 5),
          Text(
            '${_won.format(amount)}원',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class RecordsScreen extends ConsumerStatefulWidget {
  const RecordsScreen({super.key});

  @override
  ConsumerState<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends ConsumerState<RecordsScreen> {
  String _filter = '전체';

  @override
  Widget build(BuildContext context) {
    final records = ref.watch(onjungProvider).records.where((r) {
      if (_filter == '보냄') return r.isSent;
      if (_filter == '받음') return !r.isSent;
      return true;
    }).toList();

    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 120),
            sliver: SliverList.list(
              children: [
                const _BrandHeader(
                  eyebrow: '사람과 경조사별로 다시 찾는 기록',
                  title: '온정록',
                ),
                const SizedBox(height: 22),
                TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search_rounded),
                    hintText: '이름, 관계, 경조사 검색',
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  children: ['전체', '보냄', '받음'].map((value) {
                    return ChoiceChip(
                      label: Text(value),
                      selected: _filter == value,
                      onSelected: (_) => setState(() => _filter = value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Text(
                      '${records.length}개의 기록',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const Spacer(),
                    const Text('최근순', style: TextStyle(color: Colors.black54)),
                  ],
                ),
                const SizedBox(height: 12),
                ...records.map(
                  (record) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _RecordTile(record: record, showChevron: true),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordTile extends StatelessWidget {
  const _RecordTile({required this.record, this.showChevron = false});
  final OnjungRecord record;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        key: Key('record-${record.id}'),
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => RecordDetailScreen(record: record)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: record.isSent ? const Color(0xFFFFEEE6) : const Color(0xFFE8F3EE),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  record.event.contains('장례') || record.event.contains('부친')
                      ? Icons.volunteer_activism_outlined
                      : record.event.contains('결혼')
                          ? Icons.favorite_outline_rounded
                          : Icons.redeem_outlined,
                  color: record.isSent ? _brand : _green,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            record.person,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(record.relation, style: const TextStyle(color: Colors.black45, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${record.event} · ${_date.format(record.date)}',
                      style: const TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${record.isSent ? '-' : '+'}${_won.format(record.amount)}원',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: record.isSent ? _brand : _green,
                    ),
                  ),
                  if (showChevron) ...[
                    const SizedBox(height: 4),
                    const Icon(Icons.chevron_right_rounded, size: 18, color: Colors.black38),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecordDetailScreen extends StatelessWidget {
  const RecordDetailScreen({super.key, required this.record});
  final OnjungRecord record;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('온정 상세'),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFFBF8),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
          children: [
            if (record.assetPath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: SizedBox(
                  height: 180,
                  child: Image.asset(record.assetPath!, fit: BoxFit.cover),
                ),
              ),
            if (record.assetPath != null) const SizedBox(height: 22),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(record.event, style: const TextStyle(color: _brand, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 5),
                      Text(
                        record.person,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 4),
                      Text(record.relation, style: const TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: record.isSent ? const Color(0xFFFFE9DF) : const Color(0xFFE4F1EB),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(record.isSent ? '보낸 온정' : '받은 온정', style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: _ink, borderRadius: BorderRadius.circular(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('기록 금액', style: TextStyle(color: Colors.white60)),
                  const SizedBox(height: 5),
                  Text(
                    '${_won.format(record.amount)}원',
                    style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 18),
                  const Divider(color: Colors.white12),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, color: Colors.white70, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('yyyy년 M월 d일').format(record.date),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('기억해둘 메모', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: _cream, borderRadius: BorderRadius.circular(20)),
              child: Text(record.note, style: const TextStyle(height: 1.6)),
            ),
            const SizedBox(height: 24),
            Text('관계 히스토리', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            const _TimelineRow(title: '이번 기록', detail: '관계와 상황을 함께 저장했어요', emphasized: true),
            const _TimelineRow(title: '지난 기록', detail: '이 관계의 이전 온정 기록을 이어서 확인할 수 있어요'),
          ],
        ),
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.title, required this.detail, this.emphasized = false});
  final String title;
  final String detail;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            width: 10,
            height: 10,
            decoration: BoxDecoration(shape: BoxShape.circle, color: emphasized ? _brand : Colors.black26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(detail, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddRecordScreen extends ConsumerStatefulWidget {
  const AddRecordScreen({super.key});

  @override
  ConsumerState<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends ConsumerState<AddRecordScreen> {
  final _nameController = TextEditingController(text: '한소희');
  final _relationController = TextEditingController(text: '디자인 스터디');
  final _noteController = TextEditingController(text: '결혼식 참석 예정. 식사 여부는 아직 미정.');
  bool _isSent = true;
  String _event = '결혼식';
  int _amount = 100000;

  @override
  void dispose() {
    _nameController.dispose();
    _relationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _save() {
    final person = _nameController.text.trim();
    if (person.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('상대 이름을 입력해 주세요.')));
      return;
    }
    ref.read(onjungProvider.notifier).addRecord(
          OnjungRecord(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            person: person,
            relation: _relationController.text.trim().isEmpty ? '지인' : _relationController.text.trim(),
            event: _event,
            date: DateTime(2026, 8, 20),
            amount: _amount,
            isSent: _isSent,
            note: _noteController.text.trim(),
            assetPath: _event == '결혼식'
                ? 'assets/wedding_hall.png'
                : _event == '장례식'
                    ? 'assets/funeral_hall.png'
                    : null,
          ),
        );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('빠른 온정 기록'),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFFBF8),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFFFFEADF), borderRadius: BorderRadius.circular(24)),
              child: const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.favorite_rounded, color: _brand),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      '금액만 적는 장부가 아니라\n누구와 어떤 마음을 나눴는지 남겨요.',
                      style: TextStyle(fontWeight: FontWeight.w700, height: 1.45),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const _FieldLabel('방향'),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, icon: Icon(Icons.north_east_rounded), label: Text('보냈어요')),
                ButtonSegment(value: false, icon: Icon(Icons.south_west_rounded), label: Text('받았어요')),
              ],
              selected: {_isSent},
              onSelectionChanged: (value) => setState(() => _isSent = value.first),
            ),
            const SizedBox(height: 22),
            const _FieldLabel('누구와 나눈 온정인가요?'),
            TextField(
              key: const Key('person-field'),
              controller: _nameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.person_outline_rounded), hintText: '이름'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _relationController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.group_outlined), hintText: '관계 · 소속'),
            ),
            const SizedBox(height: 22),
            const _FieldLabel('경조사'),
            DropdownButtonFormField<String>(
              value: _event,
              items: ['결혼식', '장례식', '돌잔치', '생일', '개업', '명절']
                  .map((event) => DropdownMenuItem(value: event, child: Text(event)))
                  .toList(),
              onChanged: (value) => setState(() => _event = value ?? _event),
            ),
            const SizedBox(height: 22),
            const _FieldLabel('금액'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [50000, 70000, 100000, 200000].map((amount) {
                return ChoiceChip(
                  label: Text('${_won.format(amount)}원'),
                  selected: _amount == amount,
                  onSelected: (_) => setState(() => _amount = amount),
                );
              }).toList(),
            ),
            const SizedBox(height: 22),
            const _FieldLabel('메모'),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(hintText: '참석 여부, 선물, 기억할 내용'),
            ),
            const SizedBox(height: 28),
            FilledButton(
              key: const Key('save-record-button'),
              onPressed: _save,
              style: FilledButton.styleFrom(
                backgroundColor: _ink,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              child: const Text('온정 기록 저장', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 9),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
      );
}

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onjungProvider);
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 120),
        children: [
          const _BrandHeader(eyebrow: '날짜와 함께 돌아보는 마음의 흐름', title: '온정 캘린더'),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.chevron_left_rounded),
                    Expanded(
                      child: Text(
                        '2026년 8월',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded),
                  ],
                ),
                const SizedBox(height: 18),
                const _CalendarGrid(),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const _SectionHeader(title: '이번 달 기록'),
          const SizedBox(height: 12),
          ...state.records
              .where((r) => r.date.month == 8)
              .take(3)
              .map((r) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _RecordTile(record: r))),
          const SizedBox(height: 14),
          const _SectionHeader(title: '다가오는 일정'),
          const SizedBox(height: 12),
          _UpcomingCard(event: state.upcoming.first),
        ],
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid();

  @override
  Widget build(BuildContext context) {
    const marked = {3: _green, 10: _brand, 16: _brand, 20: _green, 29: _brand};
    final days = <Widget>[];
    for (final label in ['일', '월', '화', '수', '목', '금', '토']) {
      days.add(Center(child: Text(label, style: const TextStyle(color: Colors.black45, fontSize: 12))));
    }
    for (var blank = 0; blank < 6; blank++) {
      days.add(const SizedBox.shrink());
    }
    for (var day = 1; day <= 31; day++) {
      final color = marked[day];
      days.add(
        Container(
          alignment: Alignment.center,
          decoration: day == 20
              ? BoxDecoration(color: _ink, borderRadius: BorderRadius.circular(12))
              : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$day',
                style: TextStyle(
                  fontWeight: day == 20 ? FontWeight.w800 : FontWeight.w500,
                  color: day == 20 ? Colors.white : _ink,
                ),
              ),
              const SizedBox(height: 3),
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color ?? Colors.transparent),
              ),
            ],
          ),
        ),
      );
    }
    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.05,
      children: days,
    );
  }
}

class MyOnjungScreen extends ConsumerWidget {
  const MyOnjungScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(onjungProvider).records;
    final sent = records.where((r) => r.isSent).fold<int>(0, (sum, r) => sum + r.amount);
    final received = records.where((r) => !r.isSent).fold<int>(0, (sum, r) => sum + r.amount);
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 42),
        children: [
          const _BrandHeader(eyebrow: '나의 관계와 온정 패턴', title: '내 온정'),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: _ink, borderRadius: BorderRadius.circular(26)),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xFFFFE6D9),
                  child: Text('ㅇㅈ', style: TextStyle(color: _brand, fontWeight: FontWeight.w900)),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('온정 사용자', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                      SizedBox(height: 3),
                      Text('기록으로 관계를 오래 기억하는 중', style: TextStyle(color: Colors.white60, fontSize: 13)),
                    ],
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined, color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _SummaryCard(label: '보낸 온정', value: '${_won.format(sent)}원', icon: Icons.north_east_rounded)),
              const SizedBox(width: 10),
              Expanded(child: _SummaryCard(label: '받은 온정', value: '${_won.format(received)}원', icon: Icons.south_west_rounded)),
            ],
          ),
          const SizedBox(height: 26),
          const _SectionHeader(title: '관계 인사이트'),
          const SizedBox(height: 12),
          const _RelationshipInsight(),
          const SizedBox(height: 26),
          const _SectionHeader(title: '자주 만나는 관계'),
          const SizedBox(height: 12),
          const _PersonInsight(name: '김서연', relation: '대학 친구', count: '최근 3년 4회', balance: '보낸 25만 · 받은 20만'),
          const SizedBox(height: 10),
          const _PersonInsight(name: '박준호', relation: '회사 동료', count: '최근 2년 3회', balance: '보낸 20만 · 받은 10만'),
          const SizedBox(height: 26),
          const _SectionHeader(title: '관리'),
          const SizedBox(height: 8),
          const _SettingsRow(icon: Icons.notifications_none_rounded, title: '경조사 알림', subtitle: '다가오는 일정 2건'),
          const _SettingsRow(icon: Icons.ios_share_rounded, title: '기록 내보내기', subtitle: '내 온정 데이터를 안전하게 보관'),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _brand, size: 20),
          const SizedBox(height: 14),
          Text(label, style: const TextStyle(color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 3),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        ],
      ),
    );
  }
}

class _PersonInsight extends StatelessWidget {
  const _PersonInsight({required this.name, required this.relation, required this.count, required this.balance});
  final String name;
  final String relation;
  final String count;
  final String balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: _soft, child: Text(name.substring(0, 1), style: const TextStyle(color: _brand, fontWeight: FontWeight.w800))),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [Text(name, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(width: 7), Text(relation, style: const TextStyle(color: Colors.black45, fontSize: 12))]),
                const SizedBox(height: 4),
                Text('$count · $balance', style: const TextStyle(color: Colors.black54, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.black26),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(color: _soft, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: _ink),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }
}

class _UpcomingCard extends StatelessWidget {
  const _UpcomingCard({required this.event});
  final UpcomingEvent event;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: [
          SizedBox(width: 112, height: 130, child: Image.asset(event.assetPath, fit: BoxFit.cover)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${DateFormat('M월 d일').format(event.date)} · ${event.relation}', style: const TextStyle(color: _brand, fontWeight: FontWeight.w700, fontSize: 12)),
                  const SizedBox(height: 6),
                  Text(event.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                  const SizedBox(height: 6),
                  Text(event.location, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                  const SizedBox(height: 9),
                  const Text('이전 기록을 참고해 금액 결정하기 →', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RelationshipInsight extends StatelessWidget {
  const _RelationshipInsight();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFFF1F5EC), borderRadius: BorderRadius.circular(24)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.insights_rounded, color: _green),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('친구 관계의 온정이 가장 활발해요', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                SizedBox(height: 6),
                Text('최근 기록의 46%가 친구 관계예요. 결혼식 기록이 가장 많고 평균 금액은 10만원이에요.', style: TextStyle(height: 1.5, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader({required this.eyebrow, required this.title});
  final String eyebrow;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(eyebrow, style: const TextStyle(color: _brand, fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 3),
              Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -0.5)),
            ],
          ),
        ),
        IconButton.filledTonal(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded)),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.action, this.onPressed});
  final String title;
  final String? action;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900))),
        if (action != null)
          TextButton(onPressed: onPressed, child: Text(action!, style: const TextStyle(color: _brand, fontWeight: FontWeight.w700))),
      ],
    );
  }
}
