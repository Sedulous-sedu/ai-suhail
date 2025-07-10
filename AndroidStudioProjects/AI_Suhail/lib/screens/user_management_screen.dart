import 'package:flutter/material.dart';
import '../services/user_data_storage.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  List users = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => loading = true);
    users = await UserDataStorage.getUsers();
    setState(() => loading = false);
  }

  Future<void> _deleteUser(int index) async {
    users.removeAt(index);
    await UserDataStorage.saveAllUsers(users);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Management')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? const Center(child: Text('No users found.'))
              : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(user['name'] != null && user['name'].isNotEmpty ? user['name'][0] : '?'),
                        ),
                        title: Text(user['name'] ?? ''),
                        subtitle: Text('${user['email']}\nProvider: ${user['provider']}'),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteUser(index),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

