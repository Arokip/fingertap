import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fingertap/data/user.dart';
import 'package:fingertap/hive_constants.dart';
import 'package:fingertap/screen/home_screen.dart';
import 'package:fingertap/widget/back_button_aligned.dart';
import 'package:fingertap/widget/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({
    super.key,
    this.username,
  });

  final String? username;

  @override
  State<NewUserScreen> createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.username ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[400],
        body: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              'assets/applifting_logo.svg',
              width: 400,
              colorFilter: ColorFilter.mode(
                Colors.grey[700]!,
                BlendMode.color,
              ),
            ),
            if (widget.username != null) const BackButtonAligned(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Gap(120),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: TextField(
                    controller: _controller,
                    maxLines: 1,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Username',
                      filled: true,
                      fillColor: Colors.grey[500],
                      contentPadding: const EdgeInsets.only(left: 16, bottom: 6, top: 8),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[800]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const Gap(64),
                MenuButton(
                  onPressed: () async {
                    final userName = _controller.text;
                    if (userName.isNotEmpty) {
                      Hive.box(HiveConstants.tapGameBox).put(HiveConstants.userName, userName);
                      final docUser = FirebaseFirestore.instance.collection('users').doc(userName);
                      docUser.get().then((fireUser) {
                        final timeRegistered = fireUser.data()?['timeRegistered'];
                        getDeviceName().then((deviceName) {
                          final user = User(
                            name: userName,
                            deviceName: deviceName,
                            highScore: HighScore(),
                            timeRegistered: timeRegistered ?? DateTime.now().toIso8601String(),
                          );
                          if (timeRegistered == null) docUser.set(user.toJson());
                          if (widget.username == null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeScreen()),
                            );
                          } else {
                            Navigator.pop(context);
                          }
                        });
                      });
                    }
                  },
                  text: 'Continue',
                  fontSize: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getDeviceName() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      return (await deviceInfo.androidInfo).model;
    } else if (Platform.isIOS) {
      return (await deviceInfo.iosInfo).utsname.machine;
    }
    return '';
  }
}
