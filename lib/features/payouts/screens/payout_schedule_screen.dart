import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../groups/screens/create_group_screen.dart';

class PayoutScheduleScreen extends StatefulWidget {
  final String groupId;
  final PayoutMethod method;
  final double contributionAmount;
  final int totalMembers;

  const PayoutScheduleScreen({
    super.key,
    required this.groupId,
    required this.method,
    required this.contributionAmount,
    required this.totalMembers,
  });

  @override
  State<PayoutScheduleScreen> createState() => _PayoutScheduleScreenState();
}

class _PayoutScheduleScreenState extends State<PayoutScheduleScreen> {
  // Mock members
  late List<_Member> _members;
  int _currentRound = 2; // currently on round 2
  double _bidAmount = 0;

  @override
  void initState() {
    super.initState();
    _members = [
      _Member(id: '1', name: 'Kebede Deleleg', phone: '+251947642560', round: 1, hasPaid: true, isAdmin: true),
      _Member(id: '2', name: 'Tigist Alemu', phone: '+251922345678', round: 2, hasPaid: false, isAdmin: false),
      _Member(id: '3', name: 'Dawit Haile', phone: '+251933456789', round: 3, hasPaid: false, isAdmin: false),
      _Member(id: '4', name: 'Liya Worku', phone: '+251944567890', round: 4, hasPaid: false, isAdmin: false),
      _Member(id: '5', name: 'Samuel Tesfaye', phone: '+251955678901', round: 5, hasPaid: false, isAdmin: false),
    ];
  }

  double get _poolAmount => widget.contributionAmount * widget.totalMembers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Payout Schedule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showMethodInfo(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Method banner
            _MethodBanner(method: widget.method),
            const SizedBox(height: 16),

            // Pool summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _PoolStat(label: 'Pool Amount', value: Formatters.formatBirr(_poolAmount)),
                  Container(width: 1, height: 40, color: Colors.white30),
                  _PoolStat(label: 'Current Round', value: '$_currentRound / ${_members.length}'),
                  Container(width: 1, height: 40, color: Colors.white30),
                  _PoolStat(label: 'Members', value: '${_members.length}'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Method-specific action
            if (widget.method == PayoutMethod.lottery) _buildLotterySection(),
            if (widget.method == PayoutMethod.bidding) _buildBiddingSection(),

            const SizedBox(height: 20),

            // Schedule list
            Row(
              children: [
                const Text('Payout Schedule', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _methodColor(widget.method).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _methodLabel(widget.method),
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _methodColor(widget.method)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ..._members.map((m) => _RoundCard(
              member: m,
              poolAmount: _poolAmount,
              isCurrentRound: m.round == _currentRound,
              method: widget.method,
              onSwap: widget.method == PayoutMethod.rotation ? () => _showSwapDialog(context, m) : null,
              onBid: widget.method == PayoutMethod.bidding && !m.hasPaid ? () => _showBidDialog(context, m) : null,
            )),

            const SizedBox(height: 80),
          ],
        ),
      ),
      // Lottery draw FAB
      floatingActionButton: widget.method == PayoutMethod.lottery
          ? FloatingActionButton.extended(
              onPressed: () => _showLotteryDraw(context),
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.casino_outlined, color: Colors.white),
              label: const Text('Draw Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            )
          : null,
    );
  }

  Widget _buildLotterySection() {
    final current = _members.firstWhere((m) => m.round == _currentRound, orElse: () => _members.first);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            child: const Icon(Icons.casino_outlined, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Current Round Winner', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                Text(current.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                Text('Round $_currentRound · ${Formatters.formatBirr(_poolAmount)}', style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
            child: const Text('ACTIVE', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _buildBiddingSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.gavel_outlined, color: AppColors.warning, size: 22),
              const SizedBox(width: 8),
              const Text('Current Bidding Round', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Highest bid so far: ${_bidAmount > 0 ? Formatters.formatPercent(_bidAmount) : "No bids yet"}',
            style: const TextStyle(fontSize: 13, color: AppColors.textGray),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showBidDialog(context, _members.first),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning, foregroundColor: Colors.white),
              icon: const Icon(Icons.gavel_outlined, size: 18),
              label: const Text('Place Your Bid', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  void _showLotteryDraw(BuildContext context) {
    final eligible = _members.where((m) => !m.hasPaid).toList();
    if (eligible.isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _LotteryDrawDialog(
        members: eligible,
        poolAmount: _poolAmount,
        onComplete: (winner) {
          Navigator.pop(ctx);
          setState(() {
            final idx = _members.indexWhere((m) => m.id == winner.id);
            if (idx != -1) _members[idx] = _members[idx].copyWith(hasPaid: true);
            _currentRound++;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('🎉 ${winner.name} wins ${Formatters.formatBirr(_poolAmount)}!'),
              backgroundColor: AppColors.secondary,
              duration: const Duration(seconds: 3),
            ),
          );
        },
      ),
    );
  }

  void _showSwapDialog(BuildContext context, _Member member) {
    final others = _members.where((m) => m.id != member.id && !m.hasPaid).toList();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Swap Round with ${member.name}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 4),
            Text('Round ${member.round} → Select who to swap with', style: const TextStyle(fontSize: 13, color: AppColors.textGray)),
            const SizedBox(height: 16),
            ...others.map((m) => ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primaryLight,
                child: Text(m.name[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
              ),
              title: Text(m.name),
              subtitle: Text('Round ${m.round}'),
              trailing: const Icon(Icons.swap_horiz, color: AppColors.primary),
              onTap: () {
                Navigator.pop(ctx);
                setState(() {
                  final aIdx = _members.indexWhere((x) => x.id == member.id);
                  final bIdx = _members.indexWhere((x) => x.id == m.id);
                  final tempRound = _members[aIdx].round;
                  _members[aIdx] = _members[aIdx].copyWith(round: _members[bIdx].round);
                  _members[bIdx] = _members[bIdx].copyWith(round: tempRound);
                  _members.sort((a, b) => a.round.compareTo(b.round));
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Rounds swapped: ${member.name} ↔ ${m.name}'),
                    backgroundColor: AppColors.secondary,
                  ),
                );
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showBidDialog(BuildContext context, _Member member) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Place a Bid'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bidding for Round ${member.round}', style: const TextStyle(color: AppColors.textGray, fontSize: 13)),
            const SizedBox(height: 4),
            Text('Pool: ${Formatters.formatBirr(_poolAmount)}', style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Interest % you offer',
                hintText: 'e.g. 5',
                suffixText: '%',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 8),
            const Text('This % will be shared among all other members.', style: TextStyle(fontSize: 11, color: AppColors.textGray)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final bid = double.tryParse(ctrl.text) ?? 0;
              Navigator.pop(ctx);
              if (bid > _bidAmount) {
                setState(() => _bidAmount = bid);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Bid of ${Formatters.formatPercent(bid)} placed by ${member.name}!'),
                    backgroundColor: AppColors.secondary,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Bid must be higher than current ${Formatters.formatPercent(_bidAmount)}'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
            child: const Text('Submit Bid', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showMethodInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_methodIcon(widget.method), color: _methodColor(widget.method), size: 24),
                const SizedBox(width: 10),
                Text(_methodLabel(widget.method), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 12),
            Text(_methodDescription(widget.method), style: const TextStyle(fontSize: 14, color: AppColors.textGray, height: 1.6)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Color _methodColor(PayoutMethod m) {
    switch (m) {
      case PayoutMethod.lottery: return AppColors.primary;
      case PayoutMethod.rotation: return AppColors.secondary;
      case PayoutMethod.bidding: return AppColors.warning;
    }
  }

  IconData _methodIcon(PayoutMethod m) {
    switch (m) {
      case PayoutMethod.lottery: return Icons.casino_outlined;
      case PayoutMethod.rotation: return Icons.swap_horiz_outlined;
      case PayoutMethod.bidding: return Icons.gavel_outlined;
    }
  }

  String _methodLabel(PayoutMethod m) {
    switch (m) {
      case PayoutMethod.lottery: return 'Lottery Draw';
      case PayoutMethod.rotation: return 'Fixed Rotation';
      case PayoutMethod.bidding: return 'Bidding';
    }
  }

  String _methodDescription(PayoutMethod m) {
    switch (m) {
      case PayoutMethod.lottery:
        return 'Each cycle, a random draw selects which member receives the pool. All members have an equal chance. The draw is transparent and visible to everyone.';
      case PayoutMethod.rotation:
        return 'Members receive the pool in a pre-agreed order. The order is set when the group starts. Members can swap rounds by mutual agreement.';
      case PayoutMethod.bidding:
        return 'Members bid an interest percentage to receive the pool early. The highest bidder wins. The interest they offer is distributed equally among all other members.';
    }
  }
}

// ── Round Card ───────────────────────────────────────────────────────────────

class _RoundCard extends StatelessWidget {
  final _Member member;
  final double poolAmount;
  final bool isCurrentRound;
  final PayoutMethod method;
  final VoidCallback? onSwap;
  final VoidCallback? onBid;

  const _RoundCard({
    required this.member,
    required this.poolAmount,
    required this.isCurrentRound,
    required this.method,
    this.onSwap,
    this.onBid,
  });

  @override
  Widget build(BuildContext context) {
    final color = member.hasPaid
        ? AppColors.secondary
        : isCurrentRound
            ? AppColors.primary
            : AppColors.textGray;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCurrentRound ? AppColors.primaryLight.withOpacity(0.4) : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCurrentRound ? AppColors.primary : AppColors.border,
          width: isCurrentRound ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Round number
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: member.hasPaid
                  ? Icon(Icons.check, color: color, size: 18)
                  : Text('${member.round}', style: TextStyle(fontWeight: FontWeight.w700, color: color, fontSize: 14)),
            ),
          ),
          const SizedBox(width: 12),

          // Member info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(member.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark)),
                    if (member.isAdmin) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                        child: const Text('Admin', style: TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ],
                ),
                Text(
                  member.hasPaid
                      ? 'Received ${Formatters.formatBirr(poolAmount)}'
                      : isCurrentRound
                          ? 'Current round · ${Formatters.formatBirr(poolAmount)}'
                          : 'Upcoming · Round ${member.round}',
                  style: TextStyle(fontSize: 12, color: member.hasPaid ? AppColors.secondary : AppColors.textGray),
                ),
              ],
            ),
          ),

          // Action button
          if (onSwap != null)
            IconButton(
              icon: const Icon(Icons.swap_horiz, color: AppColors.secondary, size: 22),
              tooltip: 'Swap round',
              onPressed: onSwap,
            )
          else if (onBid != null)
            TextButton(
              onPressed: onBid,
              child: const Text('Bid', style: TextStyle(color: AppColors.warning, fontWeight: FontWeight.w700)),
            )
          else if (member.hasPaid)
            const Icon(Icons.check_circle, color: AppColors.secondary, size: 22)
          else if (isCurrentRound)
            const Icon(Icons.radio_button_checked, color: AppColors.primary, size: 22)
          else
            const Icon(Icons.radio_button_unchecked, color: AppColors.border, size: 22),
        ],
      ),
    );
  }
}

// ── Lottery Draw Dialog ──────────────────────────────────────────────────────

class _LotteryDrawDialog extends StatefulWidget {
  final List<_Member> members;
  final double poolAmount;
  final Function(_Member) onComplete;

  const _LotteryDrawDialog({
    required this.members,
    required this.poolAmount,
    required this.onComplete,
  });

  @override
  State<_LotteryDrawDialog> createState() => _LotteryDrawDialogState();
}

class _LotteryDrawDialogState extends State<_LotteryDrawDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentIndex = 0;
  bool _done = false;
  late _Member _winner;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _startDraw();
  }

  void _startDraw() async {
    for (int i = 0; i < 20; i++) {
      await Future.delayed(Duration(milliseconds: 80 + i * 15));
      if (mounted) {
        setState(() => _currentIndex = (i + 1) % widget.members.length);
      }
    }
    if (mounted) {
      final idx = DateTime.now().millisecond % widget.members.length;
      setState(() {
        _winner = widget.members[idx];
        _done = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 80, height: 80,
            decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
            child: const Icon(Icons.casino_outlined, color: AppColors.primary, size: 40),
          ),
          const SizedBox(height: 16),
          const Text('Drawing Winner...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 20),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 100),
            child: Text(
              _done ? _winner.name : widget.members[_currentIndex].name,
              key: ValueKey(_done ? 'winner' : _currentIndex),
              style: TextStyle(
                fontSize: _done ? 22 : 18,
                fontWeight: FontWeight.w700,
                color: _done ? AppColors.secondary : AppColors.primary,
              ),
            ),
          ),
          if (_done) ...[
            const SizedBox(height: 8),
            Text(
              'Wins ${Formatters.formatBirr(widget.poolAmount)}! 🎉',
              style: const TextStyle(fontSize: 14, color: AppColors.textGray),
            ),
          ],
          const SizedBox(height: 24),
          if (_done)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => widget.onComplete(_winner),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
                child: const Text('Confirm Winner', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            )
          else
            const CircularProgressIndicator(color: AppColors.primary),
        ],
      ),
    );
  }
}

// ── Helper widgets ───────────────────────────────────────────────────────────

class _MethodBanner extends StatelessWidget {
  final PayoutMethod method;
  const _MethodBanner({required this.method});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    String label;
    String desc;

    switch (method) {
      case PayoutMethod.lottery:
        color = AppColors.primary; icon = Icons.casino_outlined;
        label = 'Lottery Draw'; desc = 'Winner selected randomly each cycle';
        break;
      case PayoutMethod.rotation:
        color = AppColors.secondary; icon = Icons.swap_horiz_outlined;
        label = 'Fixed Rotation'; desc = 'Pre-agreed order, swaps allowed';
        break;
      case PayoutMethod.bidding:
        color = AppColors.warning; icon = Icons.gavel_outlined;
        label = 'Bidding'; desc = 'Highest interest bidder wins the pool';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: color)),
              Text(desc, style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PoolStat extends StatelessWidget {
  final String label;
  final String value;
  const _PoolStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}

// ── Data model ───────────────────────────────────────────────────────────────

class _Member {
  final String id;
  final String name;
  final String phone;
  final int round;
  final bool hasPaid;
  final bool isAdmin;

  const _Member({
    required this.id,
    required this.name,
    required this.phone,
    required this.round,
    required this.hasPaid,
    required this.isAdmin,
  });

  _Member copyWith({int? round, bool? hasPaid}) {
    return _Member(
      id: id, name: name, phone: phone,
      round: round ?? this.round,
      hasPaid: hasPaid ?? this.hasPaid,
      isAdmin: isAdmin,
    );
  }
}
