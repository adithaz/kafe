import 'package:flutter/material.dart';
import 'package:kafe/custom_theme.dart';
import 'package:kafe/data/models/preference_model.dart';
import 'package:kafe/data/models/user_model.dart';
import 'package:kafe/service/firestore_service.dart';
import 'package:kafe/service/shared_preferences_service.dart';
import 'package:kafe/service/ui_service.dart';
import 'package:kafe/widgets/custom_preference_list_settings.dart';
import 'package:kafe/widgets/custom_primary_button.dart';
import 'package:kafe/widgets/custom_settings_switch.dart';

class SettingScreen extends StatefulWidget {
  final UserModel user;
  final bool showOtherSettings;
  const SettingScreen({super.key, this.showOtherSettings = true, required this.user});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final FirestoreService _firestore = FirestoreService();
  final SharedPreferencesService _prefs = SharedPreferencesService();
  final UIService _ui = UIService();
  double screenWidth = 0;
  double screenHeight = 0;
  bool _isCenterCity = false;
  bool _isOuterCity = false;
  bool _isCrowded = false;
  bool _isQuiet = false;

  List<MapEntry<bool, String>> pairKey = [];
  List<String> _prefLocation = [];
  List<String> _selectedFacilities = [];
  final List<String> _facilitiesList = [
    "Wi-Fi",
    "Tempat Mengisi Daya",
    "Toilet",
    "Area Parkir",
    "Area Outdoor",
    "Area Bebas Rokok",
    "Area Bermain Anak",
    "Hewan Peliharaan",
    "Ruang Meeting",
    "Bayar Non-Tunai",
  ];

  List<String> _selectedAtmosphere = [];
  final List<String> _atmosphereList = [
    "Bersih & Rapi",
    "Minimalis",
    "Estetik",
    "Nyaman",
    "Sejuk",
    "Modern",
    "Ramah Lingkungan",
    "Klasik",
    "Rumahan",
  ];

  @override
  void initState() {
    super.initState();
    getPreference();
  }

  void getPreference() {
    _selectedFacilities = widget.user.preference!.preferFacilities;
    _selectedAtmosphere = widget.user.preference!.preferAtmosphere;
    _prefLocation = widget.user.preference!.preferLocation;

    for(int i = 0; i < _prefLocation.length; i++) {
      if(_prefLocation[i] == "Tengah Kota") {
        setState(() {
          _isCenterCity = true;
        });
      } else if(_prefLocation[i] == "Pinggir Kota") {
        setState(() {
          _isOuterCity = true;
        });
      } else if(_prefLocation[i] == "Ramai") {
        setState(() {
          _isCrowded = true;
        });
      } else if(_prefLocation[i] == "Tenang") {
        setState(() {
          _isQuiet = true;
        });
      }
    }
  }

  void _onExit() {
    Navigator.pop(context);
    Navigator.pop(context);
  }

  Widget _divider() {
    return Container(
      height: 1,
      width: screenWidth,
      color: Colors.black26,
      margin: const EdgeInsets.symmetric(
        vertical: 12,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundMain,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
              Row(
                children: [
                  widget.showOtherSettings ? GestureDetector(
                    onTap: () {
                      Feedback.forTap(context);
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.keyboard_arrow_left,
                      size: 35,
                    ),
                  ) : const SizedBox(),
                  Text(
                    "Pengaturan",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              Text(
                "Ubah preferensi dan pengaturan sesuai dengan keinginan kamu!",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 20,),
              Text(
                "Fasilitas",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6,),
              CustomPreferenceListSettings(
                list: _facilitiesList,
                chosenList: _selectedFacilities,
                onTap: (v) {
                  if(_selectedFacilities.contains(v)) {
                    _selectedFacilities.remove(v);
                  } else {
                    _selectedFacilities.add(v);
                  }
                },
              ),
              const SizedBox(height: 6,),
              _divider(),
              Text(
                "Lokasi",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              CustomSettingsSwitch(
                text: "Tengah Kota",
                value: _isCenterCity,
                onTap: (v) {
                  setState(() {
                    _isCenterCity = v;
                    _isOuterCity = !v;
                  });
                },
              ),
              CustomSettingsSwitch(
                text: "Pinggir Kota",
                value: _isOuterCity,
                onTap: (v) {
                  setState(() {
                    _isCenterCity = !v;
                    _isOuterCity = v;
                  });
                },
              ),
              CustomSettingsSwitch(
                text: "Ramai",
                value: _isCrowded,
                onTap: (v) {
                  setState(() {
                    _isCrowded = v;
                    _isQuiet = !v;
                  });
                },
              ),
              CustomSettingsSwitch(
                text: "Tenang",
                value: _isQuiet,
                onTap: (v) {
                  setState(() {
                    _isCrowded = !v;
                    _isQuiet = v;
                  });
                },
              ),
              _divider(),
              Text(
                "Suasana",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6,),
              CustomPreferenceListSettings(
                list: _atmosphereList,
                chosenList: _selectedAtmosphere,
                onTap: (v) {
                  if(_selectedAtmosphere.contains(v)) {
                    _selectedAtmosphere.remove(v);
                  } else {
                    _selectedAtmosphere.add(v);
                  }
                },
              ),
              const SizedBox(height: 24,),
              CustomPrimaryButton(
                buttonText: "Simpan",
                onTap: () {
                  Feedback.forTap(context);
                  if(_selectedFacilities.isEmpty) {
                    _handleError("Pilih setidaknya 1 fasilitas");
                  } else if(!_isOuterCity && !_isCenterCity) {
                    _handleError("Pilih antara tengah kota atau pinggir kota");
                  } else if(!_isQuiet && !_isCrowded) {
                    _handleError("Pilih antara ramai atau tenang");
                  } else if(_selectedAtmosphere.isEmpty) {
                    _handleError("Pilih setidaknya 1 suasana");
                  } else {
                    _handleSavePreference();
                  }
                },
              ),
              const SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSavePreference() async {
    _handleLoading(true);
    pairKey = [
      MapEntry(_isCenterCity, "Tengah Kota"),
      MapEntry(_isOuterCity, "Pinggir Kota"),
      MapEntry(_isCrowded, "Ramai"),
      MapEntry(_isQuiet, "Tenang"),
    ];

    List<MapEntry<bool, String>> filteredPairs = pairKey.where((pair) => pair.key).toList();
    setState(() {
      _prefLocation = filteredPairs.map((pair) => pair.value).toList();
    });

    PreferenceModel pref = PreferenceModel(
      preferFacilities: _selectedFacilities,
      preferAtmosphere: _selectedAtmosphere,
      preferLocation: _prefLocation,
    );

    UserModel newUser = UserModel(
      uid: widget.user.uid,
      email: widget.user.email,
      username: widget.user.username,
      photoURL: widget.user.photoURL,
      preference: pref,
      created: widget.user.created,
    );

    await _firestore.updateUserProfile(newUser);
    await _prefs.saveUser(newUser);
    _handleLoading(false);
    _handleInformationDialog(
      "Informasi",
      "Preferensi berhasil disimpan!",
      "Baik",
      _onExit,
    );
  }

  void _handleLoading(bool show) {
    if(show) {
      _ui.showSimpleLoadingDialog(context);
    } else {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  void _handleInformationDialog(String title, String desc, String buttonText, VoidCallback onTap) {
    _ui.showSimpleInformationDialog(
      context,
      title,
      desc,
      buttonText,
      onTap,
    );
  }

  void _handleError(String message) {
    _ui.showSimpleSnackBar(context, message);
  }
}
