
import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const SkillExchangeApp());
}

class SkillExchangeApp extends StatelessWidget {
  const SkillExchangeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Community Skill Exchange',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF087F8C),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F8FA),
      ),
      home: const MainPage(),
    );
  }
}

class SkillRequest {
  String name;
  String skill;
  String status;

  SkillRequest(this.name, this.skill, {this.status = 'Pending'});
}

class SkillSession {
  String partner;
  String skill;
  String date;
  bool completed;

  SkillSession(
    this.partner,
    this.skill,
    this.date, {
    this.completed = false,
  });
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedTab = 0;

  String userName = 'Kavya';
  String email = 'kavya@example.com';
  String bio = 'Learning new skills and sharing knowledge.';
  String skillLevel = 'Beginner';

  List<String> mySkills = ['Python', 'Communication'];
  List<String> categories = [
    'Programming',
    'Design',
    'Communication',
    'Data Science',
    'Cooking',
  ];

  final List<Map<String, String>> partners = [
    {
      'name': 'Ananya',
      'skill': 'Flutter',
      'level': 'Intermediate',
      'rating': '4.8',
    },
    {
      'name': 'Rahul',
      'skill': 'Python',
      'level': 'Beginner',
      'rating': '4.6',
    },
    {
      'name': 'Priya',
      'skill': 'UI Design',
      'level': 'Advanced',
      'rating': '4.9',
    },
    {
      'name': 'Arjun',
      'skill': 'Data Science',
      'level': 'Intermediate',
      'rating': '4.7',
    },
  ];

  final List<SkillRequest> requests = [];
  final List<SkillSession> sessions = [];
  final List<String> chatMessages = [
    'Welcome to your practice room!',
    'Introduce yourself and start learning.',
  ];

  String searchText = '';
  String levelFilter = 'All';
  String selectedPartner = 'Ananya';
  String selectedSkill = 'Flutter';

  int completedSessions = 0;
  int feedbackCount = 0;
  double averageRating = 0;
  int learningMinutes = 0;
  int timerSeconds = 0;
  Timer? practiceTimer;
  bool timerRunning = false;
  bool isAdmin = false;

  @override
  void dispose() {
    practiceTimer?.cancel();
    super.dispose();
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void goTo(int index) {
    setState(() => selectedTab = index);
  }

  void sendRequest(String name, String skill) {
    final exists = requests.any(
      (r) => r.name == name &&
          r.skill == skill &&
          r.status != 'Rejected',
    );

    if (exists) {
      showMessage('You already sent this request.');
      return;
    }

    setState(() {
      requests.add(SkillRequest(name, skill));
    });

    showMessage('Learning request sent to $name!');
  }

  void acceptRequest(SkillRequest request) {
    setState(() {
      request.status = 'Accepted';
      sessions.add(
        SkillSession(
          request.name,
          request.skill,
          'Tomorrow, 5:00 PM',
        ),
      );
    });

    showMessage('Request accepted. A session was created!');
  }

  void rejectRequest(SkillRequest request) {
    setState(() {
      request.status = 'Rejected';
    });
    showMessage('Request rejected.');
  }

  void editProfile() {
    final nameController = TextEditingController(text: userName);
    final emailController = TextEditingController(text: email);
    final bioController = TextEditingController(text: bio);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: bioController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'About Me'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty ||
                  emailController.text.trim().isEmpty) {
                showMessage('Name and email are required.');
                return;
              }

              setState(() {
                userName = nameController.text.trim();
                email = emailController.text.trim();
                bio = bioController.text.trim();
              });

              Navigator.pop(dialogContext);
              showMessage('Profile updated successfully!');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void addSkill() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add a Skill'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Skill name',
            hintText: 'e.g. Java, Drawing, Cooking',
          ),
          onSubmitted: (_) {
            saveSkill(controller.text, dialogContext);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => saveSkill(
              controller.text,
              dialogContext,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void saveSkill(String value, BuildContext dialogContext) {
    final skill = value.trim();

    if (skill.isEmpty) {
      showMessage('Enter a skill name.');
      return;
    }

    if (mySkills.any(
      (s) => s.toLowerCase() == skill.toLowerCase(),
    )) {
      showMessage('This skill is already in your profile.');
      return;
    }

    setState(() {
      mySkills.add(skill);
      if (!categories.contains(skill)) {
        categories.add(skill);
      }
    });

    Navigator.pop(dialogContext);
    showMessage('$skill added to your profile!');
  }

  void loginDialog({bool register = false}) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(register ? 'Create Account' : 'Login'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (register)
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full name',
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty
                            ? 'Enter your name'
                            : null,
                  ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (v) {
                    if (v == null ||
                        !RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                            .hasMatch(v.trim())) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  validator: (v) =>
                      v == null || v.length < 4
                          ? 'Use at least 4 characters'
                          : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;

              setState(() {
                email = emailController.text.trim();
                if (register) {
                  userName = nameController.text.trim();
                }
              });

              Navigator.pop(dialogContext);
              showMessage(
                register
                    ? 'Demo account created!'
                    : 'Demo login successful!',
              );
            },
            child: Text(register ? 'Register' : 'Login'),
          ),
        ],
      ),
    );
  }

  void finishSession(SkillSession session) {
    if (session.completed) {
      showMessage('This session is already completed.');
      return;
    }

    setState(() {
      session.completed = true;
      completedSessions++;
    });

    showMessage('Session marked as completed!');
    giveFeedback(session);
  }

  void giveFeedback(SkillSession session) {
    double rating = 5;
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Rate Your Experience'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Session with ${session.partner}'),
              const SizedBox(height: 12),
              const Text('Your rating'),
              DropdownButton<double>(
                value: rating,
                isExpanded: true,
                items: [1, 2, 3, 4, 5]
                    .map(
                      (n) => DropdownMenuItem<double>(
                        value: n.toDouble(),
                        child: Text('$n star${n == 1 ? '' : 's'}'),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setDialogState(() => rating = value);
                  }
                },
              ),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Feedback (optional)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Later'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  averageRating =
                      ((averageRating * feedbackCount) + rating) /
                          (feedbackCount + 1);
                  feedbackCount++;
                });

                Navigator.pop(dialogContext);
                showMessage('Thank you for your feedback!');
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void openPracticeRoom(SkillSession session) {
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Practice with ${session.partner}'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Skill: ${session.skill}'),
                const SizedBox(height: 8),
                Text(
                  timerRunning
                      ? 'Timer running: $timerSeconds seconds'
                      : 'Practice time: $timerSeconds seconds',
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    FilledButton.tonal(
                      onPressed: () {
                        if (timerRunning) {
                          practiceTimer?.cancel();
                          setState(() => timerRunning = false);
                        } else {
                          setState(() => timerRunning = true);
                          practiceTimer = Timer.periodic(
                            const Duration(seconds: 1),
                            (_) {
                              if (!mounted) return;
                              setState(() {
                                timerSeconds++;
                                learningMinutes = timerSeconds ~/ 60;
                              });
                              setDialogState(() {});
                            },
                          );
                        }
                        setDialogState(() {});
                      },
                      child: Text(timerRunning ? 'Pause' : 'Start Timer'),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        practiceTimer?.cancel();
                        setState(() {
                          timerRunning = false;
                          timerSeconds = 0;
                        });
                        setDialogState(() {});
                      },
                      child: const Text('Reset'),
                    ),
                  ],
                ),
                const Divider(),
                SizedBox(
                  height: 140,
                  child: ListView(
                    children: chatMessages
                        .map(
                          (message) => Align(
                            alignment: Alignment.centerLeft,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(message),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                    hintText: 'Write a message',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        final message = messageController.text.trim();
                        if (message.isEmpty) return;

                        setState(() {
                          chatMessages.add('$userName: $message');
                        });
                        messageController.clear();
                        setDialogState(() {});
                      },
                    ),
                  ),
                  onSubmitted: (message) {
                    if (message.trim().isEmpty) return;
                    setState(() {
                      chatMessages.add('$userName: ${message.trim()}');
                    });
                    messageController.clear();
                    setDialogState(() {});
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  Widget pageTitle(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget statCard(String label, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget homePage() {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xFF087F8C),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(26),
              bottomRight: Radius.circular(26),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'COMMUNITY SKILL EXCHANGE',
                style: TextStyle(
                  color: Colors.white70,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Hello, $userName!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 29,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Learn together. Share your skills. Grow together.',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF087F8C),
                    ),
                    onPressed: () => goTo(1),
                    child: const Text('Find Partners'),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                    ),
                    onPressed: addSkill,
                    child: const Text('Add Skill'),
                  ),
                ],
              ),
            ],
          ),
        ),
        pageTitle('Your Learning Overview', 'Track your progress'),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.5,
          children: [
            statCard('My Skills', '${mySkills.length}', Icons.school),
            statCard(
              'Requests',
              '${requests.where((r) => r.status == 'Pending').length}',
              Icons.mail_outline,
            ),
            statCard(
              'Sessions Done',
              '$completedSessions',
              Icons.check_circle_outline,
            ),
            statCard(
              'Feedback Rating',
              feedbackCount == 0
                  ? '—'
                  : averageRating.toStringAsFixed(1),
              Icons.star_outline,
            ),
          ],
        ),
        pageTitle('Quick Actions', 'Choose what you want to do'),
        ListTile(
          leading: const Icon(Icons.search),
          title: const Text('Explore Learning Partners'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => goTo(1),
        ),
        ListTile(
          leading: const Icon(Icons.mail),
          title: const Text('Manage Requests'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => goTo(2),
        ),
        ListTile(
          leading: const Icon(Icons.calendar_month),
          title: const Text('View Sessions'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => goTo(3),
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Edit My Profile'),
          trailing: const Icon(Icons.chevron_right),
          onTap: editProfile,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget explorePage() {
    final filtered = partners.where((partner) {
      final matchesSearch =
          partner['name']!.toLowerCase().contains(searchText.toLowerCase()) ||
          partner['skill']!.toLowerCase().contains(searchText.toLowerCase());

      final matchesLevel =
          levelFilter == 'All' || partner['level'] == levelFilter;

      return matchesSearch && matchesLevel;
    }).toList();

    return Column(
      children: [
        pageTitle('Find Learning Partners', 'Search people and skills'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search name or skill',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => setState(() => searchText = value),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: DropdownButtonFormField<String>(
            value: levelFilter,
            decoration: const InputDecoration(
              labelText: 'Filter by skill level',
              border: OutlineInputBorder(),
            ),
            items: ['All', 'Beginner', 'Intermediate', 'Advanced']
                .map(
                  (level) => DropdownMenuItem(
                    value: level,
                    child: Text(level),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) setState(() => levelFilter = value);
            },
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? const Center(child: Text('No matching partners found.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final partner = filtered[index];
                    final name = partner['name']!;
                    final skill = partner['skill']!;

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                child: Text(name[0]),
                              ),
                              title: Text(
                                name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '$skill • ${partner['level']}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                  Text(partner['rating']!),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                onPressed: () => sendRequest(name, skill),
                                icon: const Icon(Icons.send),
                                label: const Text('Send Learning Request'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget requestsPage() {
    return Column(
      children: [
        pageTitle('Skill Requests', 'Manage incoming and outgoing requests'),
        Expanded(
          child: requests.isEmpty
              ? const Center(
                  child: Text(
                    'No requests yet.\nExplore partners and send a request!',
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(request.name),
                        subtitle: Text(
                          '${request.skill} • ${request.status}',
                        ),
                        isThreeLine: false,
                        trailing: request.status == 'Pending'
                            ? Wrap(
                                spacing: 0,
                                children: [
                                  IconButton(
                                    tooltip: 'Accept',
                                    icon: const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                    onPressed: () => acceptRequest(request),
                                  ),
                                  IconButton(
                                    tooltip: 'Reject',
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => rejectRequest(request),
                                  ),
                                ],
                              )
                            : const Icon(Icons.check_circle_outline),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget sessionsPage() {
    return Column(
      children: [
        pageTitle('Learning Sessions', 'Schedule and practise together'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: scheduleSession,
              icon: const Icon(Icons.add),
              label: const Text('Schedule a Session'),
            ),
          ),
        ),
        Expanded(
          child: sessions.isEmpty
              ? const Center(
                  child: Text(
                    'No sessions scheduled.\nAccept a request or create a session.',
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessions[index];

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            ListTile(
                              leading: const CircleAvatar(
                                child: Icon(Icons.calendar_month),
                              ),
                              title: Text(session.skill),
                              subtitle: Text(
                                '${session.partner}\n${session.date}',
                              ),
                              trailing: Icon(
                                session.completed
                                    ? Icons.check_circle
                                    : Icons.schedule,
                                color: session.completed
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () => openPracticeRoom(session),
                                  icon: const Icon(Icons.chat),
                                  label: const Text('Practice Room'),
                                ),
                                if (!session.completed)
                                  FilledButton(
                                    onPressed: () => finishSession(session),
                                    child: const Text('Complete Session'),
                                  ),
                                if (session.completed)
                                  const Chip(
                                    label: Text('Completed'),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void scheduleSession() {
    String partner = partners.first['name']!;
    String skill = partners.first['skill']!;
    String date = 'Tomorrow, 5:00 PM';

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Schedule a Session'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: partner,
                decoration: const InputDecoration(labelText: 'Partner'),
                items: partners.map((p) {
                  return DropdownMenuItem(
                    value: p['name']!,
                    child: Text(p['name']!),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setDialogState(() {
                      partner = value;
                      skill = partners.firstWhere(
                        (p) => p['name'] == value,
                      )['skill']!;
                    });
                  }
                },
              ),
              DropdownButtonFormField<String>(
                value: skill,
                decoration: const InputDecoration(labelText: 'Skill'),
                items: partners.map((p) {
                  return DropdownMenuItem(
                    value: p['skill']!,
                    child: Text(p['skill']!),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setDialogState(() => skill = value);
                  }
                },
              ),
              DropdownButtonFormField<String>(
                value: date,
                decoration: const InputDecoration(labelText: 'Time'),
                items: [
                  'Today, 6:00 PM',
                  'Tomorrow, 5:00 PM',
                  'Saturday, 10:00 AM',
                  'Sunday, 4:00 PM',
                ].map((time) {
                  return DropdownMenuItem(
                    value: time,
                    child: Text(time),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) setDialogState(() => date = value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  sessions.add(SkillSession(partner, skill, date));
                });
                Navigator.pop(dialogContext);
                showMessage('Session scheduled successfully!');
              },
              child: const Text('Schedule'),
            ),
          ],
        ),
      ),
    );
  }

  Widget profilePage() {
    return ListView(
      children: [
        pageTitle('My Profile', 'Manage your learning information'),
        Center(
          child: CircleAvatar(
            radius: 42,
            child: Text(
              userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
              style: const TextStyle(fontSize: 30),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            userName,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Center(child: Text(email)),
        Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: editProfile,
            icon: const Icon(Icons.edit),
            label: const Text('Edit Profile'),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: ListTile(
            title: const Text('About Me'),
            subtitle: Text(bio.isEmpty ? 'No bio added.' : bio),
          ),
        ),
        Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'My Skills',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: addSkill,
                      icon: const Icon(Icons.add_circle),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 8,
                  children: mySkills
                      .map(
                        (skill) => InputChip(
                          label: Text(skill),
                          onDeleted: () {
                            setState(() => mySkills.remove(skill));
                            showMessage('$skill removed.');
                          },
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                const Text('Experience Level'),
                DropdownButton<String>(
                  value: skillLevel,
                  isExpanded: true,
                  items: ['Beginner', 'Intermediate', 'Advanced']
                      .map(
                        (level) => DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => skillLevel = value);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.bar_chart),
          title: const Text('My Progress'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => goTo(4),
        ),
        ListTile(
          leading: const Icon(Icons.admin_panel_settings),
          title: const Text('Admin Dashboard'),
          trailing: Switch(
            value: isAdmin,
            onChanged: (value) => setState(() => isAdmin = value),
          ),
          subtitle: const Text('Demo mode only; not secure authentication'),
          onTap: () => setState(() => isAdmin = !isAdmin),
        ),
        if (isAdmin)
          Padding(
            padding: const EdgeInsets.all(16),
            child: adminPanel(),
          ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: OutlinedButton.icon(
            onPressed: () => loginDialog(),
            icon: const Icon(Icons.login),
            label: const Text('Login'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: FilledButton.icon(
            onPressed: () => loginDialog(register: true),
            icon: const Icon(Icons.person_add),
            label: const Text('Create Account'),
          ),
        ),
      ],
    );
  }

  Widget adminPanel() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Admin Dashboard',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Demo users: ${partners.length + 1}'),
            Text('Categories: ${categories.length}'),
            Text('Requests: ${requests.length}'),
            Text('Sessions: ${sessions.length}'),
            const Divider(),
            const Text(
              'Skill Categories',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 6,
              children: categories
                  .map(
                    (category) => InputChip(
                      label: Text(category),
                      onDeleted: () {
                        setState(() => categories.remove(category));
                        showMessage('Category removed.');
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 8),
            FilledButton.tonalIcon(
              onPressed: addCategory,
              icon: const Icon(Icons.add),
              label: const Text('Add Category'),
            ),
            const Divider(),
            const Text('Recent Activity'),
            Text('Profile: $userName'),
            Text('Completed sessions: $completedSessions'),
            Text('Feedback received: $feedbackCount'),
          ],
        ),
      ),
    );
  }

  void addCategory() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Category'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Category name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = controller.text.trim();

              if (value.isEmpty) {
                showMessage('Enter a category name.');
                return;
              }

              if (categories.any(
                (c) => c.toLowerCase() == value.toLowerCase(),
              )) {
                showMessage('Category already exists.');
                return;
              }

              setState(() => categories.add(value));
              Navigator.pop(dialogContext);
              showMessage('Category added.');
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget progressPage() {
    final total = sessions.length;
    final progress = total == 0 ? 0.0 : completedSessions / total;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        pageTitle('Progress Dashboard', 'Your learning journey'),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.4,
          children: [
            statCard('Skills', '${mySkills.length}', Icons.school),
            statCard('Completed', '$completedSessions', Icons.check_circle),
            statCard('Practice Minutes', '$learningMinutes', Icons.timer),
            statCard(
              'Average Rating',
              feedbackCount == 0
                  ? '—'
                  : averageRating.toStringAsFixed(1),
              Icons.star,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Session Completion',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(value: progress),
                const SizedBox(height: 8),
                Text(
                  '$completedSessions of $total sessions completed',
                ),
                const SizedBox(height: 16),
                const Text(
                  'Keep learning and practising to improve your skills!',
                ),
              ],
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('Pending Requests'),
            trailing: Text(
              '${requests.where((r) => r.status == 'Pending').length}',
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text('Upcoming Sessions'),
            trailing: Text(
              '${sessions.where((s) => !s.completed).length}',
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      homePage(),
      explorePage(),
      requestsPage(),
      sessionsPage(),
      selectedTab == 4 ? profilePage() : progressPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Skill Exchange',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Progress',
            icon: const Icon(Icons.bar_chart),
            onPressed: () => goTo(5),
          ),
        ],
      ),
      body: selectedTab == 5 ? progressPage() : pages[selectedTab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTab > 4 ? 4 : selectedTab,
        onDestinationSelected: (index) => goTo(index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.mail_outline),
            label: 'Requests',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month),
            label: 'Sessions',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
