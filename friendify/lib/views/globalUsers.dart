import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:friendify/controllers/userProfileCrud.dart';
import 'package:friendify/models/userProfile.dart';
import 'package:friendify/views/navigationBar.dart';
import 'package:friendify/views/userProfile.dart';



class GlobalUsersPage extends StatefulWidget {

  GlobalUsersPage({super.key});

  @override
  State<GlobalUsersPage> createState() => _GlobalUsersPageState();
}


class _GlobalUsersPageState extends State<GlobalUsersPage> {
  late List<GlobalUser> users = [];

  // My original unfiltered list - reset the list when search is cleared
  late List<GlobalUser> originalUsers = [];

  @override
  void initState() {
    super.initState();
    getAllUsers();
  }

  Future<void> getAllUsers() async {
    QuerySnapshot<Map<String, dynamic>> usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    List<GlobalUser> userList = usersSnapshot.docs
        .map((DocumentSnapshot<Map<String, dynamic>> doc) {
          Map<String, dynamic> data = doc.data()!;
          return GlobalUser(name: data['name'], imageUrl: data['profilePicture'], email:data['email']);
        })
        .toList();

    setState(() {
      users = userList;
      originalUsers = userList;
    });
  }

  // Function for 'search'
  void onSearchTextChanged(String text) {
    setState(() {
      users = originalUsers.where((user) {
        return user.name.toLowerCase().contains(text.toLowerCase());
      }).toList();
    });
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      title: const Text('Global Users'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
        },
      ),
    ),
    body: Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: const TextStyle(color: Colors.black),
              onChanged: onSearchTextChanged,
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.purple),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: users.length,
              itemBuilder: (context, index) {
                return UserCard(user: users[index]);
              },
            ),
          ),
        ],
      ),
    ),
    bottomNavigationBar: CustomBottomNavBar(currentIndex: 0),
  );
}
}

class GlobalUser {
  final String name;
  final String imageUrl;
  final String email;

  GlobalUser({required this.name, required this.imageUrl, required this.email});
}

class UserCard extends StatelessWidget {
  final GlobalUser user;

  const UserCard({required this.user});

 
 @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        UserProfileCrud userProfileCrud = UserProfileCrud();
        UserProfile? userProfile = await userProfileCrud.getUserByEmail(user.email);
        print(user.email);
        print(userProfile?.name);
        print(userProfile?.email);
        if (userProfile != null) {
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfileScreen(userProfile: userProfile),
            ),
          );
        } else {
          print('User not found for email: ${user.email}');
        }
      },
      child: Card(
        color: Colors.white,
        elevation: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user.imageUrl),
            ),
            const SizedBox(height: 8),
            Text(user.name),
          ],
        ),
      ),
    );
  }
}
