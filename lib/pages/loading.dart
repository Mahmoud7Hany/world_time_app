// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  getData() async {
    // api الحصول علي البيانات من
    Response response = await get(
        Uri.parse('http://worldtimeapi.org/api/timezone/Africa/Cairo'));
    // Map الي json لتحويل الوقت من
    Map receivedData = jsonDecode(response.body);
    // لي وقت حقيقي اقدر اتعامل معه api لتحويل الوقت الحاصل عليه من
    DateTime datetime = DateTime.parse(receivedData["utc_datetime"]);
    int offset = int.parse(receivedData['utc_offset'].substring(0, 3));
    DateTime realTime = datetime.add(Duration(hours: offset));
    // اللي وقت حقيقي اقدر استخدمه api لتنسيق الوقت ولتحويل  intl الحاصل عليه من مكتبه DateFormat بيتم استخدام
    String timeNow = DateFormat('h:mm a').format(realTime);
    //  لعرض مكان التوقيت مثلا الساعه كام في القاهره [يظهر اسم المنطقه]
    String timeZone = receivedData['timezone'];
    // Loading واحذف الصفحه اللي تحته اللي هتكون هيا صفحه HomePage هنا بقول له بعد ما تخلص الحصول علي البيانات روح لصفحه
    Navigator.pushReplacementNamed(context, '/homePage', arguments: {
      'time': timeNow,
      'location': timeZone,
    });
  }

// يتم تفعيل هذا المثود كل مره بيتم فتح فيه التطبيق تلقائي
  @override
  void initState() {
    super.initState();
    // روح افتح الصفحه الرئسيه واعرض البيانات التي تم الحصول عليه api هنا بقول له بعد استلام البيانات من
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitWaveSpinner(
              duration: Duration(seconds: 5),
              waveColor: Colors.redAccent,
              trackColor: Colors.amber,
              color: Colors.black38,
              size: 125.0,
            ),
            SizedBox(height: 16),
            Text(
              "...جاري التحميل",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
