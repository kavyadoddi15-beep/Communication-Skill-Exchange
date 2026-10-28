
import 'package:flutter/material.dart';

// Temporary data for this demo
final List<String> mySkills = [];
final List<String> mySkillDescriptions = [];
final List<String> skillRequests = [];

// HOME SCREEN
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Skill Exchange'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Icon(
              Icons.people_alt,
              size: 75,
              color: Colors.indigo,
            ),
            const SizedBox(height: 12),
            const Text(
              'Welcome to Skill Exchange!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            _menuCard(
              context,
              'Find a Skill',
              'Learn something new',
              Icons.search,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FindSkillScreen(),
                  ),
                );
              },
            ),
            _menuCard(
              context,
              'Share Your Skill',
              'Teach others what you know',
              Icons.school,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ShareSkillScreen(),
                  ),
                );
              },
            ),
            _menuCard(
              context,
              'My Profile',
              'View and edit your details',
              Icons.person,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo, size: 32),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }
}

// FIND A SKILL SCREEN
class FindSkillScreen extends StatelessWidget {
  const FindSkillScreen({super.key});

  final List<String> skills = const [
    'Programming',
    'Drawing',
    'Photography',
    'Cooking',
    'Communication',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find a Skill')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: skills.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const Icon(
                Icons.lightbulb,
                color: Colors.indigo,
              ),
              title: Text(skills[index]),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        SkillDetailsScreen(skill: skills[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// SKILL DETAILS AND REQUEST SCREEN
class SkillDetailsScreen extends StatelessWidget {
  final String skill;

  const SkillDetailsScreen({
    super.key,
    required this.skill,
  });

  void sendRequest(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SkillRequestScreen(skill: skill),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(skill)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.menu_book,
                size: 80,
                color: Colors.indigo,
              ),
              const SizedBox(height: 20),
              Text(
                skill,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Learn this skill from community members '
                'and exchange knowledge with others.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              ElevatedButton.icon(
                onPressed: () => sendRequest(context),
                icon: const Icon(Icons.send),
                label: const Text('Request Skill Exchange'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// SKILL REQUEST SCREEN
class SkillRequestScreen extends StatelessWidget {
  final String skill;

  const SkillRequestScreen({
    super.key,
    required this.skill,
  });

  void submitRequest(BuildContext context) {
    skillRequests.add(skill);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => RequestSubmittedScreen(skill: skill),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skill Exchange Request'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.handshake,
                size: 80,
                color: Colors.indigo,
              ),
              const SizedBox(height: 20),
              const Text(
                'Request Skill Exchange',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'You are requesting to learn $skill. '
                'Would you like to submit this request?',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => submitRequest(context),
                  icon: const Icon(Icons.send),
                  label: const Text('Submit Request'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// REQUEST SUBMITTED SCREEN
class RequestSubmittedScreen extends StatelessWidget {
  final String skill;

  const RequestSubmittedScreen({
    super.key,
    required this.skill,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request Submitted')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                size: 85,
                color: Colors.green,
              ),
              const SizedBox(height: 20),
              const Text(
                'Request Submitted Successfully!',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Your request to learn $skill has been '
                'recorded in this demo.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );
                },
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// SHARE YOUR SKILL SCREEN
class ShareSkillScreen extends StatelessWidget {
  const ShareSkillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Share Your Skill')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.volunteer_activism,
                size: 80,
                color: Colors.indigo,
              ),
              const SizedBox(height: 20),
              const Text(
                'Share what you know!',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Add a skill and help other community members learn.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddSkillScreen(),
                    ),
                  );
                },
                child: const Text('Add Your Skill'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ADD SKILL SCREEN
class AddSkillScreen extends StatefulWidget {
  const AddSkillScreen({super.key});

  @override
  State<AddSkillScreen> createState() => _AddSkillScreenState();
}

class _AddSkillScreenState extends State<AddSkillScreen> {
  final skillController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    skillController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void submitSkill() {
    final skill = skillController.text.trim();
    final description = descriptionController.text.trim();

    if (skill.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete both fields.'),
        ),
      );
      return;
    }

    mySkills.add(skill);
    mySkillDescriptions.add(description);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SkillSubmittedScreen(
          skill: skill,
          description: description,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Your Skill')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: skillController,
              decoration: const InputDecoration(
                labelText: 'Skill Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.school),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Skill Description',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitSkill,
                child: const Text('Submit Skill'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// SKILL SUBMITTED SCREEN
class SkillSubmittedScreen extends StatelessWidget {
  final String skill;
  final String description;

  const SkillSubmittedScreen({
    super.key,
    required this.skill,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skill Submitted')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                size: 80,
                color: Colors.green,
              ),
              const SizedBox(height: 20),
              const Text(
                'Skill submitted successfully!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Skill: $skill',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(description, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );
                },
                child: const Text('Back to Home'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MySkillsScreen(),
                    ),
                  );
                },
                child: const Text('View My Skills'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// PROFILE SCREEN
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'Community Member';
  String userEmail = '';

  Future<void> editProfile() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(
          initialName: userName,
          initialEmail: userEmail,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        userName = result['name'] ?? userName;
        userEmail = result['email'] ?? userEmail;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 48,
              backgroundColor: Colors.indigo,
              child: Icon(
                Icons.person,
                size: 55,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              userName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              userEmail.isEmpty ? 'No email added' : userEmail,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: editProfile,
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MySkillsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.school),
                label: const Text('My Skills'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MyRequestsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.send),
                label: const Text('My Requests'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// EDIT PROFILE SCREEN
class EditProfileScreen extends StatefulWidget {
  final String initialName;
  final String initialEmail;

  const EditProfileScreen({
    super.key,
    required this.initialName,
    required this.initialEmail,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.initialName,
    );
    emailController = TextEditingController(
      text: widget.initialEmail,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void saveProfile() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name and email.'),
        ),
      );
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address.'),
        ),
      );
      return;
    }

    Navigator.pop<Map<String, String>>(
      context,
      {
        'name': name,
        'email': email,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: saveProfile,
                icon: const Icon(Icons.save),
                label: const Text('Save Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// MY SKILLS SCREEN
class MySkillsScreen extends StatelessWidget {
  const MySkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Skills')),
      body: mySkills.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No skills added yet. Add your first skill!',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mySkills.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.indigo,
                      child: Icon(
                        Icons.school,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(mySkills[index]),
                    subtitle: Text(mySkillDescriptions[index]),
                  ),
                );
              },
            ),
    );
  }
}

// MY REQUESTS SCREEN
class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Requests')),
      body: skillRequests.isEmpty
          ? const Center(
              child: Text(
                'No skill exchange requests submitted yet.',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: skillRequests.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.send,
                      color: Colors.indigo,
                    ),
                    title: Text(skillRequests[index]),
                    subtitle: const Text('Request submitted in demo'),
                    trailing: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
