import 'package:get/get.dart';
import '../model/user_model.dart';

class UserController extends GetxController {
  var userList = <User>[].obs;
  var filteredList = <User>[].obs;
  var page = 1.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  void fetchUsers() {
    var users = List.generate(
        43,
        (index) => User(
              name: 'Chayan $index',
              phone: '1234567890',
              city: 'Indore $index',
              imageUrl:
                  'https://media.istockphoto.com/id/973481674/photo/stylish-man-posing-on-grey-background.jpg?s=612x612&w=0&k=20&c=zn4YXiU1RX4-DHz8XNSSB3PoEKBxpfeFtRTESWX6OWQ=',
              rupee: index % 100,
            ));
    userList.addAll(users);
    filteredList.addAll(users.take(20).toList());
  }

  void loadMore() {
    page.value++;
    var moreUsers = userList.skip((page.value - 1) * 20).take(20).toList();
    filteredList.addAll(moreUsers);
  }

  void filterList(String query) {
    if (query.isEmpty) {
      filteredList.value = userList.take(page.value * 20).toList();
    } else {
      filteredList.value = userList
          .where((user) {
            return user.name.toLowerCase().contains(query.toLowerCase()) ||
                user.phone.contains(query) ||
                user.city.toLowerCase().contains(query.toLowerCase());
          })
          .take(page.value * 20)
          .toList();
    }
  }

  void updateRupee(int index, int newRupee) {
    userList[index].rupee = newRupee;
    filteredList[index].rupee = newRupee;
    userList.refresh();
    filteredList.refresh();
  }
}
