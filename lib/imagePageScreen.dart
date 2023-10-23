import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

class ImagePage extends StatefulWidget {
  final String param;
  const ImagePage({super.key, required this.param});
  @override
  createState() => _ImageState();
}

class _ImageState extends State<ImagePage> {
  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
    }
  }

  //불러온 이미지 서버로 전송한다.
  write() async {
    try {

      if (_image != null) {
        dynamic sendData = _image?.path;
        var formData = FormData.fromMap({
          'originFileName': 'dio.jpg',
          'filePath' : 'exma',
          'image': await MultipartFile.fromFile(sendData)});

        print(formData.toString());
        var res =  await patchUserProfileImage(formData);
        print(res);
      }

    } catch (e) {
      print("인터넷 오류 발생");
    }
  }

  Future<dynamic> patchUserProfileImage(dynamic input) async {
    print("프로필 사진을 서버에 업로드 합니다.");
    var dio = Dio();
    try {
      dio.options.contentType = 'multipart/form-data';
      dio.options.maxRedirects.isFinite;

      // dio.options.headers = {'token': token};
      var response = await dio.post(
        'http://192.168.0.9:18080/vpn/pass/accdtChckDtlsReg/fileResize.do',
        data: input,
      );
      print('성공적으로 업로드했습니다');
      return response.data;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    String title = widget.param;

    return Scaffold(
      backgroundColor: Colors.redAccent,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(title),
      ),
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30, width: double.infinity),
          _buildPhotoArea(),
          const SizedBox(height: 20),
          _buildButton(),
        ],
      ),
    );
   
  }

  Widget _buildPhotoArea() {
    return _image != null
        ? Container(
      width: 300,
      height: 300,
      child: Image.file(File(_image!.path)), //가져온 이미지를 화면에 띄워주는 코드
    )
        : Container(
      width: 300,
      height: 300,
      color: Colors.grey,
    );
  }

  Widget _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            getImage(ImageSource.camera); //getImage 함수를 호출해서 카메라로 찍은 사진 가져오기
          },
          child: const Text("카메라"),
        ),
        const SizedBox(width: 30),
        ElevatedButton(
          onPressed: () {
            getImage(ImageSource.gallery); //getImage 함수를 호출해서 갤러리에서 사진 가져오기
          },
          child: const Text("갤러리"),
        ),
        const SizedBox(width: 30),
        ElevatedButton(
          onPressed: () async {
            await write();
          },
          child: const Text("전송"),
        ),
      ],
    );
  }

  
}