import 'package:example/service/service.dart';
import 'package:example/widgets/like_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_shop_flutter/page/page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> data = [];
  ApiService service = ApiService();
  List<String> videoWatched = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    List<Map<String, dynamic>> response = await service.mapData(1, 4);
    setState(() {
      data = response;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("\n data length: ${data.length} \n");
    return Scaffold(
      body: VideoShopFlutter(
        updateLastSeenPage: (_) {},
        lastSeenPage: (videoWatched.isEmpty) ? 0 : (videoWatched.length - 1),
        listData: data,
        videoWatched: videoWatched,
        pageSize: 4,
        enableBackgroundContent: true,
        loadMore: (page, pageSize) async {
          //just for test__
          debugPrint("load more...");
          debugPrint("Video $videoWatched");
          List<Map<String, dynamic>> newData =
              await service.mapData((page + 2), 4);
          if (newData.isNotEmpty) {
            setState(() {
              data = [...data, ...newData];
            });
          }
          //_______________
        },
        likeWidget: (video, updateData) {
          return LikeWidget(
            likes: video?.likes ?? 0,
            liked: video?.liked ?? false,
            updateData: updateData,
            id: video?.id,
          );
        },
      ),
    );
  }
}
