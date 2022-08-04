import 'package:flutter/material.dart';
import 'package:pagination_demo/model/http_service.dart';
import 'package:pagination_demo/model/notification.dart' as noti;

class MyHomePage extends StatefulWidget {
  final Icon image;

  MyHomePage({required this.image});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final httpService = HttpService();
  List<noti.Notficationlist> notificationList = [];
  int _pageNumber = 1;
  late bool _error = false;
  late int totalPages;
  bool _isFirstLoading = false;
  bool _isLoadMoreRunning = false;
  bool _hasNextPage = true;
  late ScrollController _scrollController;

  void _firstLoad() async {
    try {
      setState(() {
        _isFirstLoading = true;
      });
      noti.Notification notification =
          (await httpService.getNotifications(_pageNumber));
      notificationList.addAll(notification.data.notficationlist);
      totalPages = (notification.data.count ~/ 10).toInt();
      setState(() {
        _isFirstLoading = false;
      });
    } catch (e) {
      print("error --> $e");
      setState(() {
        _isFirstLoading = false;
        _error = true;
      });
    }
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoading == false &&
        _isLoadMoreRunning == false &&
        _scrollController.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _pageNumber += 1; // Increase _page by 1
      try {
        noti.Notification notification =
            (await httpService.getNotifications(_pageNumber));
        if (notification.data.notficationlist.isNotEmpty) {
          setState(() {
            notificationList.addAll(notification.data.notficationlist);
          });
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        print("error --> $err");
        setState(() {
          _error = true;
        });
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _firstLoad();
    _scrollController = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_loadMore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Messages'),
        ),
        body: buildNotification());
  }

  Widget buildNotification() {
    if (notificationList.isEmpty) {
      if (_isFirstLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (_error) {
        return Center(
          child: errorDialog(size: 20),
        );
      }
    }
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              controller: _scrollController,
              itemCount: notificationList.length,
              itemBuilder: (ctx, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Text((index + 1).toString()),
                    title: Text(notificationList[index].title),
                    subtitle: Text(notificationList[index].message),
                  ),
                );
              }),
        ),
        if (_isLoadMoreRunning)
          const Padding(
            padding: EdgeInsets.all(8),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        if (_error) errorDialog(size: 20),
        if (!_hasNextPage)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: const Center(
              child: Text('You have fetched all the content'),
            ),
          )
      ],
    );
  }

  Widget errorDialog({required double size}) {
    return SizedBox(
      height: 180,
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'An error occurred when fetching the notifications.',
            style: TextStyle(
                fontSize: size,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          const SizedBox(
            height: 10,
          ),
          FlatButton(
              onPressed: () {
                setState(() {
                  _error = false;
                  _loadMore();
                });
              },
              child: const Text(
                "Retry",
                style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
              )),
        ],
      ),
    );
  }
}
