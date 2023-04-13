import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:buniess_case/business_logic/screens/home/data.dart';
import 'package:buniess_case/business_logic/screens/home/myMap/MapScreen.dart';
import 'package:buniess_case/business_logic/screens/home/profil.dart';
import 'package:permission_handler/permission_handler.dart';

class Model {
  final List<dynamic> items;

  Model({required this.items});

  factory Model.fromJson(List<dynamic> json) {
    final items = json.map((itemJson) {
      final type = itemJson['type'] as String;
      final content = itemJson['content'] as Map<String, dynamic>;
      switch (type) {
        case 'profile':
          return Profile.fromJson(content);
        case 'map':
          return MapItem.fromJson(content);
        case 'data':
          return DataItem.fromJson(content);
        default:
          throw ArgumentError('Invalid type: $type');
      }
    }).toList();
         return Model(items: items);
  }
}



class Profile  {
  final String image;
  final String name;
  final String email;

  Profile({required this.image, required this.name, required this.email});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      image: json['image'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
}

class MapItem {
  final String title;
  final String pin;
  final double? lat;

  final double? lng;

  MapItem(
      {required this.title,
      required this.pin,
      required this.lat,
      required this.lng});

  factory MapItem.fromJson(Map<String, dynamic> json) {
    return MapItem(
      title: json['title'] as String,
      pin: json['pin'] as String,
      lat: json['lat'] as double,
      lng: json['lng'] as double,
    );
  }
}

class DataItem {
  final String title;
  final String source;
  final String value;

  DataItem({required this.title, required this.source, required this.value});

  factory DataItem.fromJson(Map<String, dynamic> json) {
    return DataItem(
      title: json['title'] as String,
      source: json['source'] as String,
      value: json['value'] as String,
    );
  }
}

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Model? _artModel;

  final List<String>? imageList = [
    'https://nystudio107.com/img/blog/_1200x675_crop_center-center_82_line/image_optimzation.jpg.webp',
    'https://www.publicdomainpictures.net/pictures/320000/velka/background-image.png',
    'https://www.gettyimages.pt/gi-resources/images/Homepage/Hero/PT/PT_hero_42_153645159.jpg',
    'https://149695847.v2.pressablecdn.com/wp-content/uploads/2019/07/image_rec_lib_banner-1024x576.jpg',
    'https://cdn.britannica.com/74/5074-050-4BE7B9CB/Flag-Togo.jpg',
  ];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final jsonString = await rootBundle.loadString('assets/data.json');
    try {
      final jsonData = json.decode(jsonString) as List<dynamic>;
      _artModel = Model.fromJson(jsonData);
    } catch (e) {
      print('Error loading data: $e');
    }
    setState(() {});
  }

  Future<void> loadDataHttp() async {
    try {
      final response = await http.get(Uri.parse(
          'https://raw.githubusercontent.com/tonidetoni/gozem-test/master/data.json'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        _artModel = Model.fromJson(jsonData);
      } else {
        print('Error loading data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading data: $e');
    }
    setState(() {});
  }

  Future<bool> _requestLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final result = await Geolocator.requestPermission();
      if (result == LocationPermission.denied) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (_artModel == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(body: Builder(builder: (context) {
        return Scaffold(
            backgroundColor: const Color(0xfff5f7fa),
            body: Column(children: [
              Stack(
                children: [
                  GradientContainer(size),
                  Positioned(
                      top: size.height * .15,
                      left: 130,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset("assets/images/logo_white.png",
                                width: 100, height: 100),
                            /*Text(
                                  "App",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26),
                                ),*/
                          ]))
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          // Add an Expanded widget here
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _artModel!.items.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = _artModel!.items[index];
                              switch (item.runtimeType) {
                                case Profile:
                                  final profile = item as Profile;
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Profil(
                                                mail: profile.email,
                                                img: profile.image,
                                                names: profile.name)),
                                      );
                                    },
                                    child: CardField(
                                      size,
                                      Colors.blue,
                                      const Icon(
                                        Icons.account_box,
                                        color: Colors.white,
                                      ),
                                      'Profil',
                                      '',
                                    ),
                                  );
                                case MapItem:
                                  final map = item! as MapItem;
                                  return GestureDetector(
                                    onTap: () async {

                                      final permission =
                                          await Geolocator.checkPermission();
                                      if (permission ==
                                          LocationPermission.denied) {
                                           await Permission.location.request();
                                        if (await Permission.location.isGranted) {
                                          //
                                          Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                          builder: (context) => MapScreen(
                                            long: map.lng,
                                              lat: map.lat)),
                                                      );
                                        } else {

                              Navigator.push(
                              context,
                              MaterialPageRoute(
                              builder: (context) => MapScreen(
                              long: map.lng,
                              lat: map.lat)),
                              );

                                        }
                                      }

                              Navigator.push(
                              context,
                              MaterialPageRoute(
                              builder: (context) => MapScreen(
                              long: map.lng,
                              lat: map.lat)),
                              );
                                    },
                                    child: CardField(
                                      size,
                                      Colors.orange,
                                      const Icon(
                                        Icons.map,
                                        color: Colors.white,
                                      ),
                                      map.title,
                                      '(${map.lat}, ${map.lng})',
                                    ),
                                  );
                                case DataItem:
                                  final data = item as DataItem;
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Data()),
                                      );
                                    },
                                    child: CardField(
                                      size,
                                      Colors.green,
                                      const Icon(
                                        Icons.data_usage,
                                        color: Colors.white,
                                      ),
                                      data.title,
                                      data.value,
                                    ),
                                  );
                                default:
                                  throw ArgumentError(
                                      'Invalid item type: ${item.runtimeType}');
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                child: CarouselSlider.builder(
                  itemCount: imageList?.length,
                  itemBuilder:
                      (BuildContext context, int index, int pageIndex) =>
                          Container(
                    child: Image.network(
                      imageList![index],
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                  options: CarouselOptions(
                    height: 180.0,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    viewportFraction: 0.8,
                  ),
                ),
              ),
            ]));
      }));
    }
  }
}

Container GradientContainer(Size size) {
  return Container(
    height: size.height * .3,
    width: size.width,
    decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
        image: DecorationImage(
            image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover)),
    child: Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
          gradient:
              LinearGradient(colors: [Color(0xFFDC4A4A), Color(0xFFA64040)])),
    ),
  );
}

Widget CardField(
  Size size,
  Color color,
  Icon icon,
  String title,
  String subtitle,
) {
  return Padding(
    padding: const EdgeInsets.all(2),
    child: Card(
        child: SizedBox(
            height: size.height * .1,
            width: size.width * .39,
            child: Center(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: color,
                  child: icon,
                ),
                title: Text(
                  title,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                subtitle: Text(
                  subtitle,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ),
            ))),
  );
}
