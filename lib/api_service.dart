// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;

// class ApiService {
//   final String apiUrl =
//       'http://<108.136.161.14>:5000/predict'; // Replace with actual Ip

//   Future<Map<String, dynamic>?> sendImage(File imageFile) async {
//     try {
//       final bytes = await imageFile.readAsBytes();
//       final base64Image = base64Encode(bytes);

//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'image': base64Image}),
//       );

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         print('Request failed: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       print('Error sending image: $e');
//       return null;
//     }
//   }
// }
