import 'package:flutter/material.dart';

import 'login_screen.dart';

class Doctor {
  const Doctor(
    this.name,
    this.specialty,
    this.phone, {
    required this.openHour,
    required this.closeHour,
    required this.acceptsReps,
    this.repsTime,
  });
  final String name;
  final String specialty;
  final String phone;
  final int openHour;
  final int closeHour;
  final bool acceptsReps;
  final String? repsTime;
}

class Pharmacy {
  const Pharmacy(
    this.name,
    this.address,
    this.phone, {
    this.open24h = false,
    this.openHour = 9,
    this.closeHour = 22,
    required this.acceptsReps,
    this.repsTime,
  });
  final String name;
  final String address;
  final String phone;
  final bool open24h;
  final int openHour;
  final int closeHour;
  final bool acceptsReps;
  final String? repsTime;
}

// بيانات تجريبية - استبدلها لاحقاً بالبيانات الحقيقية
// أوقات الدوام بنظام 24 ساعة (مثلاً 16 = الرابعة عصراً)
const _doctors = [
  Doctor('د. أحمد محمود', 'طب عام', '0770 111 2233',
      openHour: 16, closeHour: 21, acceptsReps: true, repsTime: 'من 4 إلى 5 عصراً'),
  Doctor('د. سارة علي', 'طب أطفال', '0770 222 3344',
      openHour: 9, closeHour: 14, acceptsReps: false),
  Doctor('د. محمد حسن', 'أمراض القلب', '0770 333 4455',
      openHour: 17, closeHour: 22, acceptsReps: true, repsTime: 'يوم الخميس فقط'),
  Doctor('د. زينب كريم', 'نسائية وتوليد', '0770 444 5566',
      openHour: 10, closeHour: 15, acceptsReps: true, repsTime: 'بعد الساعة 2 ظهراً'),
  Doctor('د. علي جاسم', 'جراحة عظام', '0770 555 6677',
      openHour: 15, closeHour: 20, acceptsReps: false),
  Doctor('د. نور الهدى', 'جلدية', '0770 666 7788',
      openHour: 11, closeHour: 18, acceptsReps: true),
];

const _pharmacies = [
  Pharmacy('صيدلية الشفاء', 'شارع الجمهورية', '0780 111 2233',
      open24h: true, acceptsReps: true, repsTime: 'صباحاً من 9 إلى 12'),
  Pharmacy('صيدلية الرحمة', 'حي الأطباء', '0780 222 3344', acceptsReps: false),
  Pharmacy('صيدلية النور', 'شارع المستشفى', '0780 333 4455',
      open24h: true, acceptsReps: true),
  Pharmacy('صيدلية الحياة', 'السوق الكبير', '0780 444 5566',
      openHour: 8, closeHour: 20, acceptsReps: true, repsTime: 'كل يوم أحد'),
  Pharmacy('صيدلية ابن سينا', 'حي الجامعة', '0780 555 6677',
      openHour: 10, closeHour: 23, acceptsReps: false),
];

class DirectoryScreen extends StatelessWidget {
  const DirectoryScreen({super.key, required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('مرحباً $username'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'تسجيل الخروج',
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: _CategoryTile(
                icon: Icons.medical_services_outlined,
                title: 'الأطباء',
                count: _doctors.length,
                color: Colors.teal,
                onTap: () => _open(
                  context,
                  _EntryListScreen(
                    title: 'الأطباء',
                    searchHint: 'بحث بالاسم أو التخصص',
                    entries: [
                      for (final d in _doctors)
                        _Entry(
                          Icons.person,
                          d.name,
                          d.specialty,
                          d.phone,
                          openHour: d.openHour,
                          closeHour: d.closeHour,
                          acceptsReps: d.acceptsReps,
                          repsTime: d.repsTime,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _CategoryTile(
                icon: Icons.local_pharmacy_outlined,
                title: 'الصيدليات',
                count: _pharmacies.length,
                color: Colors.indigo,
                onTap: () => _open(
                  context,
                  _EntryListScreen(
                    title: 'الصيدليات',
                    searchHint: 'بحث بالاسم أو العنوان',
                    entries: [
                      for (final p in _pharmacies)
                        _Entry(
                          Icons.local_pharmacy,
                          p.name,
                          p.address,
                          p.phone,
                          openHour: p.open24h ? 0 : p.openHour,
                          closeHour: p.open24h ? 24 : p.closeHour,
                          acceptsReps: p.acceptsReps,
                          repsTime: p.repsTime,
                          badge: p.open24h ? '24 ساعة' : null,
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

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.icon,
    required this.title,
    required this.count,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final int count;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 72, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: color, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text('العدد: $count', style: TextStyle(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Entry {
  const _Entry(
    this.icon,
    this.title,
    this.subtitle,
    this.phone, {
    required this.openHour,
    required this.closeHour,
    required this.acceptsReps,
    this.repsTime,
    this.badge,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final String phone;
  final int openHour;
  final int closeHour;
  final bool acceptsReps;
  final String? repsTime;
  final String? badge;

  bool get isAvailableNow {
    final hour = DateTime.now().hour;
    return hour >= openHour && hour < closeHour;
  }

  String get hoursText => (openHour == 0 && closeHour == 24)
      ? 'على مدار 24 ساعة'
      : 'من ${_formatHour(openHour)} إلى ${_formatHour(closeHour)}';
}

String _formatHour(int hour) {
  final h = hour % 12 == 0 ? 12 : hour % 12;
  final period = hour < 12 ? 'صباحاً' : 'مساءً';
  return '$h $period';
}

class _EntryListScreen extends StatefulWidget {
  const _EntryListScreen({
    required this.title,
    required this.searchHint,
    required this.entries,
  });

  final String title;
  final String searchHint;
  final List<_Entry> entries;

  @override
  State<_EntryListScreen> createState() => _EntryListScreenState();
}

class _EntryListScreenState extends State<_EntryListScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.trim();
    final entries = widget.entries
        .where((e) => e.title.contains(q) || e.subtitle.contains(q))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: widget.searchHint,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          Expanded(
            child: entries.isEmpty
                ? const Center(child: Text('لا توجد نتائج'))
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    itemCount: entries.length,
                    itemBuilder: (context, i) => _EntryCard(entries[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard(this.entry);

  final _Entry entry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => showModalBottomSheet(
          context: context,
          showDragHandle: true,
          builder: (_) => _InquirySheet(entry),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: colors.primaryContainer,
                child: Icon(entry.icon, color: colors.onPrimaryContainer),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            entry.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        if (entry.badge != null) ...[
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(entry.badge!),
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ],
                    ),
                    Text(entry.subtitle),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _StatusChip(
                          ok: entry.isAvailableNow,
                          okText: 'متواجد الآن',
                          noText: 'غير متواجد الآن',
                        ),
                        _StatusChip(
                          ok: entry.acceptsReps,
                          okText: 'يستقبل المندوبين',
                          noText: 'لا يستقبل المندوبين',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_left, color: colors.outline),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.ok,
    required this.okText,
    required this.noText,
  });

  final bool ok;
  final String okText;
  final String noText;

  @override
  Widget build(BuildContext context) {
    final color = ok ? Colors.green.shade700 : Colors.red.shade700;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ok ? Icons.check_circle : Icons.cancel, size: 16, color: color),
          const SizedBox(width: 4),
          Text(ok ? okText : noText,
              style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}

/// نافذة الاستفسار: تجيب على سؤالي التواجد الآن واستقبال المندوبين
class _InquirySheet extends StatefulWidget {
  const _InquirySheet(this.entry);

  final _Entry entry;

  @override
  State<_InquirySheet> createState() => _InquirySheetState();
}

class _InquirySheetState extends State<_InquirySheet> {
  bool _askedAvailability = false;
  bool _askedReps = false;

  @override
  Widget build(BuildContext context) {
    final e = widget.entry;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              e.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(e.subtitle, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text('📞 ${e.phone}', textAlign: TextAlign.center),
            const SizedBox(height: 20),
            _QuestionTile(
              question: 'هل هو متواجد الآن؟',
              icon: Icons.access_time,
              asked: _askedAvailability,
              ok: e.isAvailableNow,
              answer: e.isAvailableNow
                  ? 'نعم، متواجد الآن.\nأوقات الدوام: ${e.hoursText}'
                  : 'لا، غير متواجد الآن.\nأوقات الدوام: ${e.hoursText}',
              onAsk: () => setState(() => _askedAvailability = true),
            ),
            const SizedBox(height: 12),
            _QuestionTile(
              question: 'هل يستقبل المندوبين؟',
              icon: Icons.badge_outlined,
              asked: _askedReps,
              ok: e.acceptsReps,
              answer: e.acceptsReps
                  ? 'نعم، يستقبل المندوبين.'
                      '${e.repsTime != null ? '\nوقت الاستقبال: ${e.repsTime}' : ''}'
                  : 'لا، لا يستقبل المندوبين.',
              onAsk: () => setState(() => _askedReps = true),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionTile extends StatelessWidget {
  const _QuestionTile({
    required this.question,
    required this.icon,
    required this.asked,
    required this.ok,
    required this.answer,
    required this.onAsk,
  });

  final String question;
  final IconData icon;
  final bool asked;
  final bool ok;
  final String answer;
  final VoidCallback onAsk;

  @override
  Widget build(BuildContext context) {
    if (!asked) {
      return OutlinedButton.icon(
        onPressed: onAsk,
        icon: Icon(icon),
        label: Text(question),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      );
    }

    final color = ok ? Colors.green.shade700 : Colors.red.shade700;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ok ? Icons.check_circle : Icons.cancel, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(question,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(answer, style: TextStyle(color: color)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
