import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:secure_storage/services/secure_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // * StatusBar & NavigationBar Color
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.deepPurpleAccent,
      systemNavigationBarColor: Colors.deepPurpleAccent,
    ),
  );

  // * Orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Text Animations',
      theme: ThemeData.light(),
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _name = TextEditingController();
  final _birthday = MaskedTextController(mask: '00/00/0000');
  Map<String, bool> chosenPets = {'Cat': false, 'Dog': false, 'Other': false};
  DateTime selectedDate = DateTime.now();
  bool _isCleared = false;

  Future getData() async {
    final name = await SecureStorage.getString(key: SecureStorage.key(StorageKeys.NAME)) ?? '';
    final date = await SecureStorage.getString(key: SecureStorage.key(StorageKeys.BIRTHDAY)) ?? '';
    final pets = await SecureStorage.getList(key: SecureStorage.key(StorageKeys.PETS)) ?? [];
    return [name, date, pets];
  }

  Future checkStorage() async {
    final data = await getData();

    setState(() {
      if (data[0].isEmpty && data[1].isEmpty && data[2].isEmpty) {
        _isCleared = true;
      } else {
        _isCleared = false;
      }
    });
  }

  Future init() async {
    final data = await getData();
    await checkStorage();
    setState(() {
      _name.text = data[0];
      _birthday.text = data[1];
      if (data[2].isNotEmpty) {
        for (int i = 0; i < chosenPets.length; i++) {
          if (data[2].contains(chosenPets.keys.toList()[i])) {
            chosenPets[chosenPets.keys.toList()[i]] = true;
          }
        }
      }else{
        for (int i = 0; i < chosenPets.length; i++) {
          chosenPets[chosenPets.keys.toList()[i]] = false;
        }
      }
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.width / 4 - 20;
    final width = MediaQuery.of(context).size.width / 4;

    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            // * Lock & Title
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 25.0),
                        child: Center(
                          child: Icon(
                            Icons.lock,
                            color: Colors.white,
                            size: 80,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0.0,
                        right: 0.0,
                        child: IconButton(
                            splashRadius: 1,
                            onPressed: () async {
                              await SecureStorage.clearStorage();
                              await init();
                            },
                            icon: Icon(
                              CupertinoIcons.delete_solid,
                              color: _isCleared
                                  ? Colors.white
                                  : CupertinoColors.destructiveRed,
                              size: 26,
                            ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'Secure Storage',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30.0),
                  // * Name
                  const Text(
                    '  Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  TextField(
                    controller: _name,
                    cursorColor: Colors.white,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Sardorbek',
                      hintStyle: const TextStyle(
                        color: Colors.white60,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.white60,
                        size: 28,
                      ),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            const BorderSide(color: Colors.white, width: 3),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            const BorderSide(color: Colors.white, width: 3),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            const BorderSide(color: Colors.white, width: 3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  // * Birthday
                  const Text(
                    '  Birthday',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  TextField(
                    controller: _birthday,
                    cursorColor: Colors.white,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '31/08/2002',
                      hintStyle: const TextStyle(
                        color: Colors.white60,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      prefixIcon: IconButton(
                        onPressed: () => _selectDate(context),
                        icon:
                            const Icon(Icons.date_range, color: Colors.white60),
                        iconSize: 28,
                      ),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            const BorderSide(color: Colors.white, width: 3),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            const BorderSide(color: Colors.white, width: 3),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            const BorderSide(color: Colors.white, width: 3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  // * Pets
                  const Text(
                    '  Pets',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            chosenPets['Cat'] = !chosenPets['Cat']!;
                          });
                        },
                        child: Container(
                          height: height,
                          width: width,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: chosenPets['Cat']!
                                ? Colors.white
                                : Colors.white24,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            chosenPets.keys.toList()[0],
                            style: TextStyle(
                              color: chosenPets['Cat']!
                                  ? Colors.deepPurpleAccent
                                  : Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            chosenPets['Dog'] = !chosenPets['Dog']!;
                          });
                        },
                        child: Container(
                          height: height,
                          width: width,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: chosenPets['Dog']!
                                ? Colors.white
                                : Colors.white24,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            chosenPets.keys.toList()[1],
                            style: TextStyle(
                              color: chosenPets['Dog']!
                                  ? Colors.deepPurpleAccent
                                  : Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            chosenPets['Other'] = !chosenPets['Other']!;
                          });
                        },
                        child: Container(
                          height: height,
                          width: width,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: chosenPets['Other']!
                                ? Colors.white
                                : Colors.white24,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            chosenPets.keys.toList()[2],
                            style: TextStyle(
                              color: chosenPets['Other']!
                                  ? Colors.deepPurpleAccent
                                  : Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 4.7,
                  ),
                  // * Save Button
                  ElevatedButton(
                    onPressed: () async {
                      List<String> data = [];
                      for (int i = 0; i < chosenPets.length; i++) {
                        if (chosenPets.values.toList()[i]) {
                          data.add(chosenPets.keys.toList()[i]);
                        }
                      }

                      await SecureStorage.storeString(
                        key: SecureStorage.key(StorageKeys.NAME),
                        data: _name.text.trim(),
                      );
                      await SecureStorage.storeString(
                        key: SecureStorage.key(StorageKeys.BIRTHDAY),
                        data: _birthday.text.trim(),
                      );
                      await SecureStorage.storeList(
                        key: SecureStorage.key(StorageKeys.PETS),
                        data: data,
                      );

                      await checkStorage();
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size.fromWidth(300),
                      minimumSize: const Size.fromHeight(45),
                      primary: Colors.white,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _selectDate(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buildMaterialDatePicker(context);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(context);
    }
  }

  buildCupertinoDatePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (picked) {
                if (picked != null && picked != selectedDate) {
                  setState(() {
                    selectedDate = picked;
                    _birthday.text = "${selectedDate.toLocal()}"
                        .substring(0, 10)
                        .split('-')
                        .reversed
                        .toString();
                  });
                }
              },
              initialDateTime: selectedDate,
              minimumYear: 2000,
              maximumYear: 2025,
            ),
          );
        });
  }

  buildMaterialDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2023),
      initialEntryMode: DatePickerEntryMode.calendar,
      initialDatePickerMode: DatePickerMode.day,
      // selectableDayPredicate: _decideWhichDayToEnable,
      // helpText: 'Select date',
      cancelText: 'Cancel',
      confirmText: 'OK',
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
      fieldLabelText: 'Date',
      fieldHintText: 'Date/Month/Year',
      builder: (context, child) {
        return Theme(
          data: ThemeData().copyWith(
            colorScheme: const ColorScheme.dark(
              surface: Colors.deepPurpleAccent,
              onSurface: Colors.black,
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _birthday.text = "${selectedDate.toLocal()}"
            .substring(0, 10)
            .split('-')
            .reversed
            .toString();
      });
    }
  }
}