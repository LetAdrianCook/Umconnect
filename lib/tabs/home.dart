import "package:flutter/material.dart";
import "package:um_connect/comp/bottomnav.dart";
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
  int _selectedIndex = 0;
  final AuthService _authService = AuthService();
  TextEditingController _searchController = TextEditingController();
  int currentPageIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.red),
        title: const Text(
          "Chats",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFC62828),
              fontSize: 25),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      bottomNavigationBar: BottomBar(
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          }),
      drawer: UmDrawer(),
      body: Column(
        children: [
          Expanded(
            child: _buildUserList(context),
          ),
        ],
      ),
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
                border: Border.all(
                  color: Color(0xFFFFC62828),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).colorScheme.secondary,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  icon: Icon(
                    Icons.search,
                    color: Color(0xFFFFC62828),
                    size: 25,
                  ),
                  hintText: 'Search by email',
                  hintStyle: TextStyle(
                    fontSize: 17,
                    color: Color(0xFFFFC62828),
                  ),
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
