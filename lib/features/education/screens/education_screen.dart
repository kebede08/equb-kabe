import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Basics', 'Savings', 'Loans', 'Tips'];

  final List<_Article> _articles = const [
    _Article(
      title: 'What is Equb?',
      summary: 'Learn the basics of the traditional Ethiopian rotating savings system and how it works.',
      category: 'Basics',
      readMinutes: 3,
      icon: Icons.info_outline,
      color: AppColors.primary,
      content: '''Equb is a traditional Ethiopian rotating savings and credit association (ROSCA). A group of trusted individuals agree to contribute a fixed amount of money at regular intervals. Each cycle, one member receives the entire pool — the "equb" — until every member has received it once.

**How it works:**
• Members agree on a contribution amount and frequency (weekly, monthly, etc.)
• Each round, one member is selected (by lottery or agreement) to receive the full pool
• The cycle continues until all members have received the pool once
• The process can repeat for multiple rounds

**Benefits:**
• Encourages disciplined saving
• Provides access to a lump sum without bank loans
• Builds community trust and accountability
• No interest charged between members''',
    ),
    _Article(
      title: 'How to Start an Equb Group',
      summary: 'Step-by-step guide to creating and managing your own Equb savings group.',
      category: 'Basics',
      readMinutes: 5,
      icon: Icons.group_add_outlined,
      color: AppColors.secondary,
      content: '''Starting an Equb group requires careful planning and trust among members.

**Step 1: Choose your members**
Select 5–20 trusted people — family, friends, or colleagues. Trust is the foundation of a successful Equb.

**Step 2: Set the rules**
• Contribution amount (e.g., ETB 1,000/month)
• Payment frequency (weekly, bi-weekly, monthly)
• Payout order (lottery, rotation, or agreement)
• Late payment penalties

**Step 3: Elect an administrator**
The admin collects contributions, tracks payments, and distributes the pool. Choose someone reliable and organized.

**Step 4: Document everything**
Keep written records of all contributions and payouts. Use this app to track everything digitally.

**Step 5: Start the cycle**
Begin collecting contributions and distribute the first pool according to your agreed order.''',
    ),
    _Article(
      title: 'Smart Savings Strategies',
      summary: 'Maximize your savings with these proven strategies for Equb members.',
      category: 'Savings',
      readMinutes: 4,
      icon: Icons.savings_outlined,
      color: AppColors.info,
      content: '''Being part of an Equb is just one part of a healthy savings strategy. Here are tips to make the most of it.

**1. Join multiple groups**
Participating in 2–3 Equb groups with different payout schedules gives you more frequent access to lump sums.

**2. Plan your payout**
Before you receive the pool, decide exactly how you'll use it — business investment, emergency fund, or a major purchase.

**3. Never miss a payment**
Late payments damage trust and may result in penalties. Set reminders or automate payments.

**4. Build an emergency fund**
Keep 3–6 months of expenses saved separately so you never need to borrow from your Equb pool.

**5. Track your progress**
Use the Reports section to monitor your total savings over time and stay motivated.''',
    ),
    _Article(
      title: 'Understanding Equb Loans',
      summary: 'How loans work within your Equb group and what to consider before borrowing.',
      category: 'Loans',
      readMinutes: 4,
      icon: Icons.account_balance_outlined,
      color: AppColors.warning,
      content: '''Some Equb groups offer short-term loans to members from the group's accumulated funds.

**How Equb loans work:**
• A member requests a loan from the group fund
• The group admin or committee approves or rejects the request
• Interest is typically low (3–10%) compared to banks
• Repayment is usually within 1–3 months

**Before you borrow:**
✓ Only borrow what you can repay on time
✓ Understand the interest rate and total repayment amount
✓ Have a clear plan for how you'll use the funds
✓ Communicate openly with your group admin

**Risks to avoid:**
• Borrowing to cover daily expenses (sign of financial stress)
• Taking multiple loans simultaneously
• Missing repayment deadlines — this affects your group standing

**Tip:** Use loans for income-generating activities like small business investments, not consumption.''',
    ),
    _Article(
      title: 'Avoiding Common Equb Mistakes',
      summary: 'Learn from the most common pitfalls that cause Equb groups to fail.',
      category: 'Tips',
      readMinutes: 3,
      icon: Icons.warning_amber_outlined,
      color: AppColors.error,
      content: '''Many Equb groups fail due to avoidable mistakes. Here's what to watch out for.

**Mistake 1: Trusting strangers**
Only join or create groups with people you know personally. Fraud is the #1 cause of Equb failure.

**Mistake 2: No written agreement**
Always document the rules, contribution amounts, and payout schedule in writing before starting.

**Mistake 3: No backup plan for defaults**
Decide in advance what happens if a member can't pay. Will others cover temporarily? Is there a penalty?

**Mistake 4: Poor record keeping**
Keep detailed records of every payment. This app helps you track everything digitally.

**Mistake 5: Group too large**
Groups of 8–15 members tend to work best. Too large and coordination becomes difficult.

**Mistake 6: Mixing business with friendship**
Set clear boundaries. Money disputes can damage relationships. Keep everything transparent and documented.''',
    ),
    _Article(
      title: 'Digital vs Traditional Equb',
      summary: 'How digital Equb platforms are modernizing the traditional savings system.',
      category: 'Tips',
      readMinutes: 3,
      icon: Icons.phone_android_outlined,
      color: AppColors.secondary,
      content: '''Traditional Equb has been practiced for centuries, but digital platforms are transforming how it works.

**Traditional Equb challenges:**
• Manual record keeping prone to errors
• Cash handling risks
• Difficult to manage large groups
• No transparency for all members
• Geographic limitations

**Digital Equb advantages:**
✓ Automatic payment tracking and reminders
✓ Transparent records visible to all members
✓ Secure digital payments
✓ Easy group management from anywhere
✓ Instant notifications for payments and payouts
✓ Historical reports and analytics

**This app gives you:**
• Real-time contribution tracking
• Automated payment reminders
• Secure loan management
• Detailed financial reports
• Group communication tools

Embrace digital tools while maintaining the community trust that makes Equb special.''',
    ),
  ];

  List<_Article> get _filtered {
    if (_selectedCategory == 'All') return _articles;
    return _articles.where((a) => a.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Financial Education', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                    SizedBox(height: 4),
                    Text('Learn how to make the most of your Equb', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category filter
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((cat) {
                        final selected = cat == _selectedCategory;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedCategory = cat),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: selected ? AppColors.primary : AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: selected ? AppColors.primary : AppColors.border),
                            ),
                            child: Text(
                              cat,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: selected ? Colors.white : AppColors.textGray,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Featured article
                if (_selectedCategory == 'All') ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: const Text('Featured', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _FeaturedCard(article: _articles.first, onTap: () => _openArticle(context, _articles.first)),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: const Text('All Articles', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  ),
                ],
              ],
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final articles = _selectedCategory == 'All' ? _filtered.skip(1).toList() : _filtered;
                  if (index >= articles.length) return null;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ArticleCard(article: articles[index], onTap: () => _openArticle(context, articles[index])),
                  );
                },
                childCount: _selectedCategory == 'All' ? _filtered.length - 1 : _filtered.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openArticle(BuildContext context, _Article article) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _ArticleDetailScreen(article: article)),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final _Article article;
  final VoidCallback onTap;
  const _FeaturedCard({required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(article.category, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 12),
            Text(article.title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(article.summary, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.white70, size: 14),
                const SizedBox(width: 4),
                Text('${article.readMinutes} min read', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Read Now', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final _Article article;
  final VoidCallback onTap;
  const _ArticleCard({required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
          boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: article.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(article.icon, color: article.color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: article.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(article.category, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: article.color)),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.access_time, size: 12, color: AppColors.textGray),
                      const SizedBox(width: 3),
                      Text('${article.readMinutes} min', style: const TextStyle(fontSize: 11, color: AppColors.textGray)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(article.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark)),
                  const SizedBox(height: 4),
                  Text(article.summary, style: const TextStyle(fontSize: 12, color: AppColors.textGray, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppColors.textGray, size: 20),
          ],
        ),
      ),
    );
  }
}

class _ArticleDetailScreen extends StatelessWidget {
  final _Article article;
  const _ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: article.color,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [article.color, article.color.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(24, 80, 24, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                      child: Text(article.category, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 8),
                    Text(article.title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: AppColors.textGray),
                      const SizedBox(width: 4),
                      Text('${article.readMinutes} min read', style: const TextStyle(fontSize: 13, color: AppColors.textGray)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ..._parseContent(article.content),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _parseContent(String content) {
    final lines = content.split('\n');
    final widgets = <Widget>[];

    for (final line in lines) {
      if (line.isEmpty) {
        widgets.add(const SizedBox(height: 12));
      } else if (line.startsWith('**') && line.endsWith('**')) {
        widgets.add(Text(
          line.replaceAll('**', ''),
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark),
        ));
        widgets.add(const SizedBox(height: 6));
      } else if (line.startsWith('•') || line.startsWith('✓') || line.startsWith('✗')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Text(line, style: const TextStyle(fontSize: 14, color: AppColors.textDark, height: 1.5)),
        ));
      } else {
        widgets.add(Text(line, style: const TextStyle(fontSize: 14, color: AppColors.textDark, height: 1.6)));
        widgets.add(const SizedBox(height: 4));
      }
    }

    return widgets;
  }
}

class _Article {
  final String title;
  final String summary;
  final String category;
  final int readMinutes;
  final IconData icon;
  final Color color;
  final String content;

  const _Article({
    required this.title,
    required this.summary,
    required this.category,
    required this.readMinutes,
    required this.icon,
    required this.color,
    required this.content,
  });
}
