import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  XFile? image;
  final ImagePicker picker = ImagePicker();
  bool isPickingImage = false;
  @override
  void initState() {
    super.initState();
    image = XFile('assets/the1975.jpg');
  }

  Future<void> pickImage() async {
    if (isPickingImage) return; // 이미지 피커가 이미 열려 있는 경우에는 중복 요청을 방지하기 위해 return

    setState(() {
      isPickingImage = true; // 이미지 피커가 열린 상태로 변경
    });

    try {
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          image = XFile(pickedFile.path);
        });
      }
    } catch (e) {
      //print("Image picking failed: $e");
    } finally {
      setState(() {
        isPickingImage = false; // 이미지 피커가 닫힌 상태로 변경
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final TextEditingController emailController =
        TextEditingController(text: 'oscar2272@naver.com');
    return Scaffold(
      appBar: AppBar(
        leadingWidth: width * 100 / 430,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        title: const Text("Edit Profile"),
        actions: [
          SizedBox(
            width: width * 100 / 430,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Done"),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(
            top: height * 60 / 932,
            left: width * 60 / 430,
            right: width * 60 / 430,
            bottom: height * 50 / 932),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: width * 60 / 430, // 원의 반지름 설정
                    foregroundColor: Colors.black,

                    foregroundImage: image == null
                        ? FileImage(File(image!.path))
                        : const AssetImage('assets/the1975.jpg')
                            as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: width * 20 / 430,
                      backgroundColor: Colors.white,
                      child: IconButton(
                          icon:
                              const Icon(Icons.camera_alt, color: Colors.blue),
                          onPressed: pickImage),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 40 / 932), // 간격 추가
            TextField(
              readOnly: true,
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: UnderlineInputBorder(),
              ),
            ),
            SizedBox(height: height * 20 / 932),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Nickname',
                border: UnderlineInputBorder(),
              ),
            ),
            SizedBox(height: height * 20 / 932),
          ],
        ),
      ),
    );
  }
}
