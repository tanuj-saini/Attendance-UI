import 'package:attendence/Screen/UserDashBord/userDashBController.dart';
import 'package:attendence/Utils/Colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDashBoard extends StatelessWidget {
  final UserDashboardController controller = Get.put(UserDashboardController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                controller.logout();
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              )),
        ],
        title: Obx(() => Text(
              "Hi! ${controller.userRepos.userModelU.value.name}",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
        backgroundColor: AppColors.navy,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Obx(
                  () => Text('${controller.userRepos.userModelU.value.name}')),
              accountEmail: Obx(() => Text(
                  '${controller.userRepos.userModelU.value.emailAddress}')),
              currentAccountPicture: Obx(
                () => CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      controller.userRepos.userModelU.value.imageUrl != null &&
                              controller.userRepos.userModelU.value.imageUrl!
                                  .isNotEmpty
                          ? NetworkImage(
                              controller.userRepos.userModelU.value.imageUrl!)
                          : AssetImage('assets/Logo.svg'),
                  backgroundColor: Colors.transparent,
                ),
              ),
              decoration: BoxDecoration(color: AppColors.navy),
            ),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Obx(() =>
                        Text('${controller.userRepos.userModelU.value.name}')),
                    subtitle: Obx(() => Text(
                        '${controller.userRepos.userModelU.value.emailAddress}')),
                  ),
                  ListTile(
                    leading: Icon(Icons.lock),
                    title: Text('Password'),
                    subtitle: Text('••••••••'),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                controller.logout();
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              _buildUserDetails(controller),
              SizedBox(height: 20),
              _buildCourseAndClassroomInput(controller, screenWidth),
              SizedBox(height: 20),
              _buildImagePicker(controller),
              SizedBox(height: 35),
              _buildSubmitButton(controller, screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserDetails(UserDashboardController controller) {
    return Column(
      children: [
        TextFormField(
          controller: TextEditingController(
            text: controller.userRepos.userModelU.value.name ?? 'Name',
          ),
          enabled: false,
          decoration: InputDecoration(
            labelText: 'Name',
            hintText: 'Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        SizedBox(height: 15),
        TextFormField(
          controller: TextEditingController(
            text: controller.userRepos.userModelU.value.rollNumber ??
                'Roll Number',
          ),
          enabled: false,
          decoration: InputDecoration(
            labelText: 'Roll Number',
            hintText: 'Roll Number',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseAndClassroomInput(
      UserDashboardController controller, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Obx(
            () => TextFormField(
              cursorColor: AppColors.navy,
              controller: controller.userRepos.classNumberController.value,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.navy,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: 'Classroom Number (*optional)',
                hintText: 'Classroom Number',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),
        SizedBox(width: screenWidth * 0.05),
        Obx(
          () => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
              border: Border.all(color: AppColors.navy, width: 2.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedCourse.value,
                icon: Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
                iconSize: 28,
                elevation: 16,
                style: TextStyle(color: Colors.black, fontSize: 16),
                onChanged: (String? newValue) {
                  controller.selectedCourse.value = newValue!;
                },
                dropdownColor: Colors.white,
                items: controller.courseCodes
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePicker(UserDashboardController controller) {
    return GestureDetector(
      onTap: controller.selectImage,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(10),
        dashPattern: [10, 4],
        strokeCap: StrokeCap.round,
        child: Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Obx(
            () => controller.imageBytes.value ==
                    null // Use .value to access the reactive value
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_outlined, size: 40),
                      SizedBox(height: 15),
                      Text(
                        'Click a Photo',
                        style: TextStyle(
                            fontSize: 15, color: Colors.grey.shade400),
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(
                      controller.imageBytes.value!, // Access .value here
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(
      UserDashboardController controller, double screenWidth) {
    return Center(
      child: SizedBox(
        width: screenWidth * 0.6,
        child: Obx(
          () => ElevatedButton(
            onPressed:
                controller.isLoadingData.value || controller.scanning.value
                    ? null
                    : () async {
                        await controller.handleAttendanceSubmission();
                      },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.navy,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: controller.isLoadingData.value || controller.scanning.value
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : const Text(
                    "Mark Attendance",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
