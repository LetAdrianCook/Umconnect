import "package:flutter/material.dart";
import "package:um_connect/comp/drawer.dart";
import "package:um_connect/comp/usersintile.dart";
import "package:um_connect/services/auth/auth_service.dart";
import "package:um_connect/services/chat/chatservice.dart";
import "package:um_connect/tabs/umchat.dart";

class Home extends StatefulWidget {
  Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ChatService _chatService = ChatService();

  final AuthService _authService = AuthService();
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Um Connect"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      drawer: UmDrawer(),
      body: _buildUserList(context),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }

  // Add a semicolon here
  Widget _buildUserList(BuildContext context) {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("error");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<Map<String, dynamic>> filteredUsers = snapshot.data!
            .where((userData) => userData["email"]
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();

        return Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.secondary,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search by email',
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  setState(() {
                    filteredUsers = snapshot.data!
                        .where((userData) => userData["email"]
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                  });
                },
              ),
            ),
            Expanded(
              child: ListView(
                children: filteredUsers
                    .map<Widget>(
                        (userData) => _buildUserListItem(userData, context))
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserInTiles(
        text: userData["email"],
        profilePic: userData["image"],
        dname: userData["name"],
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UmChat(
                  receiverID: userData['uid'],
                  receiverEmail: userData["email"],
                ),
              ));
        },
      );
    } else {
      return Container();
    }
  }
}
