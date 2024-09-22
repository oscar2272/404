import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interview_app/provider/user_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  //static const baseUrl = "http://10.0.2.2:8000";
  static const baseUrl = "http://127.0.0.1:8000";
  XFile? image;
  String? imageUrl;
  String? oldImageUrl;
  late String message;
  final ImagePicker picker = ImagePicker();
  bool isPickingImage = false;
  final TextEditingController nicknameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    imageUrl = Provider.of<UserProvider>(context, listen: false).user!.imageUrl;
    oldImageUrl =
        Provider.of<UserProvider>(context, listen: false).user!.imageUrl;
    nicknameController.text =
        Provider.of<UserProvider>(context, listen: false).user!.nickname;
  }

  Future<void> pickImage() async {
    var status = await Permission.camera.status;
    await Permission.camera.request();

    // print(status.isPermanentlyDenied); ios
    // print(status.isDenied); android
    // print(status.isPermanentlyDenied && status.isDenied);
    if (status.isPermanentlyDenied && status.isDenied) {
      _showPermissionDeniedDialog();
      return;
    }
    try {
      // 권한이 허용된 경우에만 이미지 선택기 열기
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          image = pickedFile;
        });
      }
    } catch (e) {
      // 이미지 선택 실패 시 예외 처리
      //print("Image picking failed: $e");
    } finally {
      setState(() {
        isPickingImage = false;
      });
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('권한 필요')),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('이 기능을 사용하려면 설정에서 권한을 허용해주세요.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                openAppSettings(); // 앱 설정으로 이동
                Navigator.of(context).pop();
              },
              child: const Text('설정 열기'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateProfile(String nickname, XFile? image, int userId) async {
    message = await Provider.of<UserProvider>(context, listen: false)
        .updateProfile(nickname, image, userId);

    if (!mounted) return;
    if (message == '성공') {
      // 프로필 업데이트 성공 메시지일 경우
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('성공적으로 프로필을 업데이트했습니다.')),
      );
      Navigator.pop(context, true); // 이전 화면으로 돌아감
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> _resetProfile() async {
    await Provider.of<UserProvider>(context, listen: false).resetImage(
        Provider.of<UserProvider>(context, listen: false).user!.userId);
    image = null;
    // ignore: use_build_context_synchronously
    await Provider.of<UserProvider>(context, listen: false).fetchUserData();
  }

  void _showResetProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('프로필 이미지 초기화'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('기본 프로필 이미지로 변경하시겠습니까?'),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await _resetProfile();

                    // 비동기 작업 후에 UI를 업데이트하기 전에 mounted 체크
                    if (!mounted) return;

                    setState(() {
                      imageUrl =
                          Provider.of<UserProvider>(context, listen: false)
                              .user!
                              .imageUrl;
                    });
                  },
                  child: const Text('확인'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final TextEditingController emailController = TextEditingController(
        text: Provider.of<UserProvider>(context, listen: false).user!.email);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: width * 100 / 430,
        leading: TextButton(
          onPressed: () {
            if (oldImageUrl !=
                Provider.of<UserProvider>(context, listen: false)
                    .user!
                    .imageUrl) {
              Navigator.pop(context, true);
            } else {
              Navigator.pop(context, false);
            }
          },
          child: const Text("Cancel"),
        ),
        title: const Text("Edit Profile"),
        actions: [
          SizedBox(
            width: width * 100 / 430,
            child: TextButton(
              onPressed: () {
                _updateProfile(
                    nicknameController.text,
                    image,
                    Provider.of<UserProvider>(context, listen: false)
                        .user!
                        .userId);
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

                    backgroundImage: image != null
                        ? FileImage(File(image!.path)) // 선택된 이미지
                        : NetworkImage('$baseUrl$imageUrl') as ImageProvider,
                  ),
                  Positioned(
                    bottom: -10,
                    right: -5,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: width * 15 / 430,
                          backgroundColor: Colors.white, // 원의 배경색 설정
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.blue,
                            size: width * 25 / 430,
                          ),
                          onPressed: pickImage,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: -10,
                    left: -5,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: width * 15 / 430,
                          backgroundColor: Colors.white, // 원의 배경색 설정
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                            size: width * 25 / 430,
                          ),
                          onPressed: _showResetProfileDialog,
                        ),
                      ],
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
            TextField(
              controller: nicknameController,
              decoration: const InputDecoration(
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
