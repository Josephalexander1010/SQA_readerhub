import 'package:flutter/material.dart';
import 'navbar.dart';

class TopicSelectionPage extends StatefulWidget {
  const TopicSelectionPage({super.key});

  @override
  State<TopicSelectionPage> createState() => _TopicSelectionPageState();
}

class _TopicSelectionPageState extends State<TopicSelectionPage> {
  static const Color primaryPurple = Color(0xFF3E2EA6);

  // sample topic lists (you can fetch from API later)
  final Map<String, List<String>> categories = {
    'Entertainment': ['Car', 'Girls', 'Tiktoker', 'Funny', 'Challenge'],
    'Community': ['Car', 'Girls', 'Tiktoker', 'Funny', 'Challenge'],
    'Events': ['Car', 'Girls', 'Tiktoker', 'Funny', 'Challenge'],
  };

  // store selections per category
  final Map<String, Set<String>> selected = {};

  @override
  void initState() {
    super.initState();
    // initialize sets
    for (var k in categories.keys) selected[k] = <String>{};
  }

  void _toggleSelection(String category, String topic) {
    final set = selected[category]!;
    set.contains(topic) ? set.remove(topic) : set.add(topic);
    setState(() {});
  }

  bool get _hasAnySelection {
    for (var s in selected.values) {
      if (s.isNotEmpty) return true;
    }
    return false;
  }

  void _onContinue() {
    if (!_hasAnySelection) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose at least one topic')),
      );
      return;
    }

    // TODO: send selected topics to backend if needed
    // final payload = selected.map((k, v) => MapEntry(k, v.toList()));

    // After selecting topics, go to main app (NavBar)
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const NavBar()),
    );
  }

  Widget _buildCategory(String category, List<String> topics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // divider + label
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(category,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.black54)),
            ),
            Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
          ],
        ),
        const SizedBox(height: 8),
        // topics list
        Column(
          children: topics.map((t) {
            final checked = selected[category]!.contains(t);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: InkWell(
                onTap: () => _toggleSelection(category, t),
                child: Row(
                  children: [
                    // custom small square checkbox to match Figma (or use Checkbox)
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: checked
                          ? Center(
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: primaryPurple,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Text(t, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // top fixed header with back + step
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back, color: Colors.black87),
                  ),
                  const Expanded(child: SizedBox()),
                  const Text('Step 3/3',
                      style: TextStyle(color: Colors.black54)),
                  const Expanded(child: SizedBox()),
                  const SizedBox(width: 24),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                        'Select the topics that\ninterest you most',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: primaryPurple),
                      ),
                      const SizedBox(height: 18),

                      // build each category
                      for (var entry in categories.entries)
                        _buildCategory(entry.key, entry.value),

                      const SizedBox(height: 18),
                      // Continue button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _onContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryPurple,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28)),
                            elevation: 0,
                          ),
                          child: const Text('Continue →',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),

                      const SizedBox(height: 30),
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
