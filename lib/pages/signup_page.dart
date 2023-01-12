
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../helper/helper_function.dart';
import '../helper/theme.dart';
import '../service/auth.dart';
import '../service/database.dart';
import '../widget/widget.dart';
import 'chatroom.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp(this.toggleView);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController usernameEditingController =
  TextEditingController();

  AuthService authService = AuthService();
  DatabaseMethods databaseMethods = DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? image;
  String? imageUrl;

  singUp() async {

    if(formKey.currentState!.validate()){
      setState(() {

        isLoading = true;
      });
      if (image != null) {
      await uploadFileOnCloudinary(filePath: image??'', resourceType: CloudinaryResourceType.Image);
    }
      await authService.signUpWithEmailAndPassword(emailEditingController.text,
          passwordEditingController.text).then((result){
        if(result != null){

          Map<String,String> userDataMap = {
            "userName" : usernameEditingController.text,
            "profileUrl" : (imageUrl==null) ? "https://i.postimg.cc/0jyBPsWt/user-1.png" : imageUrl??'',
            "userEmail" : emailEditingController.text
          };

          databaseMethods.addUserInfo(userDataMap);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(usernameEditingController.text);
          HelperFunctions.saveUserEmailSharedPreference(emailEditingController.text);

          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => ChatRoom()
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading ? Container(child: const Center(child: CircularProgressIndicator(),),) :  Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 150,),
              GestureDetector(
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  height: 120,
                  width: 120,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: image != null && image!.isNotEmpty ? Image.file(File(image??''),fit: BoxFit.cover,)

                      :Image.asset("assets/images/placeholder.png",fit: BoxFit.cover,),

                ),
                onTap: ()=>getImage(),
              ),
              SizedBox(height: 26,),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      style: simpleTextStyle(),
                      controller: usernameEditingController,
                      validator: (val){
                        return val!.isEmpty || val.length < 3 ? "Enter Username 3+ characters" : null;
                      },
                      decoration: textFieldInputDecoration("username"),
                    ),
                    SizedBox(height: 16,),
                    TextFormField(
                      controller: emailEditingController,
                      style: simpleTextStyle(),
                      validator: (val){
                        return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!) ?
                        null : "Enter correct email";
                      },
                      decoration: textFieldInputDecoration("email"),
                    ),
                    SizedBox(height: 16,),
                    TextFormField(
                      obscureText: true,
                      style: simpleTextStyle(),
                      decoration: textFieldInputDecoration("password"),
                      controller: passwordEditingController,
                      validator:  (val){
                        return val!.length < 6 ? "Enter Password 6+ characters" : null;
                      },

                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: (){
                  singUp();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                           colors: [
                             CupertinoColors.link,
                             CupertinoColors.systemPurple,
                             Colors.redAccent,
                           ],
                      )),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Sign Up",
                    style: biggerTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: simpleTextStyle(),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.toggleView();
                    },
                    child: const Text(
                      "SignIn now",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                         ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );

  }

  getImage() async {
    ImagePicker imagePicker = ImagePicker();
    final file = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      image=file?.path;
    });
  }

  Future<CloudinaryResponse> uploadFileOnCloudinary(
      {required String filePath, required CloudinaryResourceType resourceType}) async {
    String result;
    late CloudinaryResponse response;
    try {
      var cloudinary = CloudinaryPublic('dwib2kec4', 'y651yvim', cache: false);
      response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(filePath, resourceType: resourceType),
      );
    } on CloudinaryException catch (e, s) {
      print(e.message);
      print(e.request);
    }
    setState(() {
      imageUrl = response.url;
    });
    return response;
  }
}