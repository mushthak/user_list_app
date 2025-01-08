import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/user_list_controller.dart';
import '../state/user_list_state.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load users when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserListController>().loadUsers();
    });
  }

  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New User'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(hintText: 'Enter name'),
          autofocus: true,
          onSubmitted: (_) => _addUser(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _addUser(context),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addUser(BuildContext context) {
    if (_nameController.text.isEmpty) return;

    context.read<UserListController>().addUser(_nameController.text);
    _nameController.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: Consumer<UserListController>(
        builder: (context, controller, child) {
          final state = controller.state;

          if (state.status == UserListStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == UserListStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage ?? 'An error occurred'),
                  ElevatedButton(
                    onPressed: () => controller.loadUsers(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.users.isEmpty) {
            return const Center(
              child: Text('No users found'),
            );
          }

          return ListView.builder(
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final user = state.users[index];
              return Dismissible(
                key: Key(user.id.toString()),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => controller.deleteUser(user.id),
                child: ListTile(
                  title: Text(user.displayName),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddUserDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
