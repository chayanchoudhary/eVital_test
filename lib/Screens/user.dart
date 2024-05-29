import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/user_controllers.dart';
import '../model/user_model.dart';

class UserListScreen extends StatelessWidget {
  final UserController userController = Get.put(UserController());

  UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Center(child: Text('User List')),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Colors.amber, // Gold color
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (query) {
                    userController.filterList(query);
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    labelText: 'Search by name, phone, or city',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: userController.filteredList.length + 1,
                  itemBuilder: (context, index) {
                    if (index == userController.filteredList.length) {
                      if (userController.filteredList.length <
                          userController.userList.length) {
                        return ElevatedButton(
                          onPressed: userController.loadMore,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black, // Text color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            elevation: 5,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                          ),
                          child: const Text('Load More'),
                        );
                      } else {
                        return Container();
                      }
                    }
                    User user = userController.filteredList[index];
                    return Column(
                      children: [
                        ListTile(
                          tileColor: Colors.black12,
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.imageUrl),
                            radius: 40.0,
                            child: Image.network(
                              user.imageUrl,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return Container();
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          title: Text(user.name),
                          subtitle: Text(
                              'Phone: ${user.phone}, City: ${user.city}, Rupee: ${user.rupee}'),
                          trailing: Text(user.rupee > 50 ? 'High' : 'Low'),
                          onTap: () {
                            _showEditDialog(context, index, user.rupee);
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        )
                      ],
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, int index, int currentRupee) {
    TextEditingController rupeeController =
        TextEditingController(text: currentRupee.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          title: const Text('Update Rupee'),
          content: TextField(
            controller: rupeeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Rupee',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Get.back();
              },
            ),
            InkWell(
                onTap: () {
                  int newRupee = int.parse(rupeeController.text);
                  userController.updateRupee(index, newRupee);
                  Get.back();
                },
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Center(
                    child: Text('Update'),
                  ),
                ))
          ],
        );
      },
    );
  }
}
