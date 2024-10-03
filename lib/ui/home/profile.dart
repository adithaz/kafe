import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kafe/data/models/user_model.dart';
import 'package:kafe/service/shared_preferences_service.dart';
import 'package:kafe/widgets/custom_edit_profile.dart';
import 'package:kafe/ui/setting_screen.dart';
import 'package:kafe/widgets/custom_arrow_button.dart';
import 'package:page_transition/page_transition.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final SharedPreferencesService _prefs = SharedPreferencesService();
  UserModel currentUser = UserModel();
  double screenWidth = 0;
  double screenHeight = 0;
  double _profileSize = 0;

  @override
  void initState() {
    super.initState();
    initLocale();
    getUser();
  }

  void getUser() async {
    UserModel? user = await _prefs.getUser();
    setState(() {
      currentUser = user!;
    });
  }

  void initLocale() async {
    await initializeDateFormatting('id', "");
  }

  String formatJoinDate(String dateString) {
    try {
      DateTime parsedDate = DateFormat("dd-MM-yyyy HH:mm:ss").parse(dateString);
      return DateFormat("dd MMMM yyyy", "id").format(parsedDate);
    } catch (e) {
      return "-";
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    _profileSize = screenWidth / 2.3;

    return Stack(
      children: [
        Image.asset(
          "assets/images/bg-coffee2.png",
          width: screenWidth,
        ),
        SafeArea(
          child: Container(
            margin: const EdgeInsets.only(
              top: 20,
            ),
            alignment: Alignment.topCenter,
            child: Text(
              "Profil",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: _profileSize,),
                    CustomArrowButton(
                      title: "Profil",
                      subTitle: "Ubah profil",
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child: EditProfileWidget(user: currentUser),
                            curve: Curves.ease,
                            duration: const Duration(milliseconds: 500),
                          ),
                        );

                        if (result != null) {
                          getUser();
                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 12,),
                    CustomArrowButton(
                      title: "Pengaturan",
                      subTitle: "Ubah preferensi",
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: SettingScreen(user: currentUser,),
                            curve: Curves.ease,
                            duration: const Duration(milliseconds: 500),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12,),
                    CustomArrowButton(
                      title: "Bergabung Sejak", 
                      subTitle: formatJoinDate(currentUser.created),
                    ),
                    const SizedBox(height: 200,),
                  ],
                ),
              ),
              Transform.translate(
                offset: Offset(0, -(_profileSize / 2)),
                child: SizedBox(
                  width: screenWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: _profileSize,
                        width: _profileSize,
                        padding: const EdgeInsets.all(6),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(1000),
                          child: currentUser.photoURL != "null" ? Image.network(
                            currentUser.photoURL,
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
                      Text(
                        currentUser.username,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        currentUser.email,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
