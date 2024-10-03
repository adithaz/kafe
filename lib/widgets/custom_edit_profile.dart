import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kafe/custom_theme.dart';
import 'package:kafe/data/models/user_model.dart';
import 'package:kafe/service/firestore_service.dart';
import 'package:kafe/service/shared_preferences_service.dart';
import 'package:kafe/service/storage_service.dart';
import 'package:kafe/service/ui_service.dart';
import 'package:kafe/widgets/custom_primary_button.dart';
import 'custom_form_field.dart';

class EditProfileWidget extends StatefulWidget {
  final UserModel user;
  const EditProfileWidget({super.key, required this.user});

  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  final FirestoreService _firestore = FirestoreService();
  final StorageService _storage = StorageService();
  final UIService _ui = UIService();
  final SharedPreferencesService _prefs = SharedPreferencesService();
  TextEditingController usernameController = TextEditingController();
  double screenWidth = 0;
  double screenHeight = 0;
  double _profileSize = 0;
  File? pickedImage;

  bool isMounted = false;

  @override
  void initState() {
    super.initState();
    usernameController.text = widget.user.username;
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isMounted = true;
      });
    });
  }

  void _onExit(bool pop) async {
    setState(() {
      isMounted = false;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if(pop) {
        Navigator.pop(context, "RESULT");
      } else {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    _profileSize = screenWidth / 2.3;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GestureDetector(
            onTap: () {
              _onExit(false);
            },
            child: AnimatedOpacity(
              opacity: isMounted ? 1 : 0,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              child: Container(
                height: screenHeight,
                width: screenWidth,
                color: Colors.black26,
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20,),
                GestureDetector(
                  onTap: () async {
                    pickedImage = await _ui.pickImage(ImageSource.gallery);
                    setState(() {});
                  },
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        height: _profileSize,
                        width: _profileSize,
                        margin: const EdgeInsets.only(
                          top: 12,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(1000),
                          child: pickedImage != null ? Image.file(
                            pickedImage!,
                            fit: BoxFit.cover,
                          ) : widget.user.photoURL != "null" ? Image.network(
                            widget.user.photoURL,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                              return Image.asset('assets/images/user-profile-placeholder.jpg');
                            },
                          ) : Image.asset(
                            "assets/images/user-profile-placeholder.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12,),
                CustomFormField(controller: usernameController, label: "Username", hint: "Masukan username kamu"),
                const SizedBox(height: 20,),
                CustomPrimaryButton(
                  buttonText: "Simpan",
                  onTap: () {
                    final username = usernameController.text.toString().trim();

                    if(username.isEmpty) {
                      _handleError("Username tidak boleh dikosongkan!");
                    } else if(username.length < 5) {
                      _handleError("Username harus terdiri dari minimal 5 karakter!");
                    } else if(username.contains(" ")) {
                      _handleError("Username tidak boleh berisi spasi");
                    } else {
                      UserModel newUser = UserModel(
                        uid: widget.user.uid,
                        email: widget.user.email,
                        username: username,
                        photoURL: widget.user.photoURL,
                        preference: widget.user.preference,
                        created: widget.user.created,
                      );

                      _handleEditProfile(newUser);
                    }
                  },
                ),
                const SizedBox(height: 30,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleEditProfile(UserModel user) async {
    if(!(await _firestore.checkUsernameAvailability(user.username)) && user.username != widget.user.username) {
      _handleError("Username ini tidak bisa digunakan!");
    } else {
      _handleLoading(true);
      if(pickedImage != null) {
        final photoURL = await _storage.uploadProfilePicture(pickedImage!, user);

        UserModel newUser = UserModel(
          uid: user.uid,
          email: user.email,
          username: user.username,
          photoURL: photoURL!,
          preference: user.preference,
          created: user.created,
        );

        _handleSaveProfile(newUser);
      } else {
        _handleSaveProfile(user);
      }
    }
  }

  void _handleSaveProfile(UserModel user) async {
    await _firestore.updateUserProfile(user);
    await _prefs.saveUser(user);
    _handleLoading(false);
    _onExit(true);
  }

  void _handleLoading(bool show) {
    if(show) {
      _ui.showSimpleLoadingDialog(context);
    } else {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  void _handleError(String message) {
    _ui.showSimpleSnackBar(context, message);
  }
}
