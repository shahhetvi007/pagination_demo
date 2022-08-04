import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pagination_demo/model/notification.dart';

class HttpService {
  final String url =
      "https://wearehere-api.apps.openxcell.dev/app/auth/notificationlist";

  Future<Notification> getNotifications(int pageNumber) async {
    Notification notification;
    print(pageNumber);
    final response = await http.post(Uri.parse(url),
        headers: {
          "Authorization":
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImhhcmRpa0BtYWlsaW5hdG9yLmNvbSIsImlkIjoiNjJiNTdjMmE3YjVmMmQ5ZDgzMmQ3YmM3IiwiaWF0IjoxNjU4OTE2Mjk3fQ.LwPSRvn3NPEKrApsPEMkuu7AbHtgC-2tuMXabjy9xrQ",
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {
            "page": pageNumber,
          },
        ));
    var responseList = json.decode(response.body);
    // print(response.body);
    notification = Notification.fromJson(responseList);
    return notification;
  }
}
