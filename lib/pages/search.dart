
// ignore_for_file: library_private_types_in_public_api

import 'package:chat_app/pages/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../helper/constants.dart';
import '../service/database.dart';
import '../widget/widget.dart';
import 'chat.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchEditingController = TextEditingController();
  QuerySnapshot? searchResultSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async {
    if(searchEditingController.text.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      await databaseMethods.searchByName(searchEditingController.text)
          .then((snapshot){
        searchResultSnapshot = snapshot;
        if (kDebugMode) {
          print("$searchResultSnapshot");
        }
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget userList(){
    return haveUserSearched ? ListView.builder(
        shrinkWrap: true,
        itemCount: searchResultSnapshot?.docs.length,
        itemBuilder: (context, index){
          return userTile(
            searchResultSnapshot?.docs[index].get("userName"),
            searchResultSnapshot?.docs[index].get("userEmail"),
            searchResultSnapshot?.docs[index].get("profileUrl"),
          );
        }) : Container();
  }

  
  sendMessage(String userName){
    List<String> users = [Constants.myName,userName];

    String chatRoomId = getChatRoomId(Constants.myName,userName);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId" : chatRoomId,
    };

    databaseMethods.addChatRoom(chatRoom, chatRoomId);

    Navigator.push(context, MaterialPageRoute(
        builder: (context) => Chat(
          chatRoomId: chatRoomId,
        )
    ));

  }

  Widget userTile(String userName,String userEmail,String profileUrl){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>UserProfile(name: userName,profileUrl: profileUrl, email: userEmail,)));
            },
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              height: 50,
              width: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: CupertinoColors.link,
              ),
              child: Image.network(profileUrl,fit: BoxFit.cover,),
            ),
          ),
          const SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),
              ),
              Text(
                userEmail,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),
              )
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: (){
              sendMessage(userName);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(24)
              ),
              child: const Text("Message",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),),
            ),
          )
        ],
      ),
    );
  }


  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  int searchuser = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: searchuser == 0 ? const Text("Search User") : TextField(
          controller: searchEditingController,
          style: simpleTextStyle(),
          decoration: const InputDecoration(
              hintText: "search username ...",
              hintStyle: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              border: InputBorder.none
          ),
        ),
        elevation: 0.0,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: (){
              setState(() {
                if(searchuser==0){
                  searchuser =1;
                }else{
                  searchuser=0;
                  initiateSearch();
                }
              });
            },
            icon: Icon(searchuser == 0 ? CupertinoIcons.search : Icons.done),
          ),
          const SizedBox(width: 15,),
        ],
      ),
      body: isLoading ? const Center(
        child: CircularProgressIndicator(),
      ) :  Column(
        children: [
          userList()
        ],
      ),
    );
  }
}

