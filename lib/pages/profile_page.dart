import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class UserProfile extends StatefulWidget {
  String name;
  String profileUrl;
  String email;
   UserProfile({Key? key,required this.profileUrl,required this.name,required this.email }) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      leading: GestureDetector(
        child: const Icon(Icons.arrow_back_ios),
        onTap: (){
          Navigator.pop(context);
        },
      ),
      title:  Text(widget.name),
      headerWidget: headerWidget(context),
      actions: [
        Container(
          padding: const EdgeInsets.all(1),
          height: 40,
          width: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            height: 38,
            width: 38,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image.network(widget.profileUrl,fit: BoxFit.cover,),),
        ),
        const SizedBox(width: 20,),
      ],
      body:  [
        const SizedBox(height: 10,),
        const Text("Information",style: TextStyle(
          color: CupertinoColors.link,
          fontWeight: FontWeight.bold,
          fontSize: 25
        ),),
        const SizedBox(height: 10,),
        userInfo(icon: CupertinoIcons.person,name: widget.name),
        userInfo(icon: CupertinoIcons.mail,name: widget.email),
      ],
      fullyStretchable: true,
      backgroundColor: Colors.white,
      appBarColor: CupertinoColors.link,
    );
  }



  Widget headerWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
            child: const Icon(Icons.arrow_back_ios,)),
      ),
      backgroundColor: CupertinoColors.link,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              height: 153,
              width: 153,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                  height: 150,
                  width: 150,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.network(widget.profileUrl,fit: BoxFit.cover,),),
            ),
            const SizedBox(height: 10,),
             Text(
              widget.name,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 30,
                fontWeight: FontWeight.bold
              )
            ),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
  Widget userInfo({name='some text here',icon}){
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(left: 30,right: 30,top: 10),
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
        color: CupertinoColors.link.withOpacity(0.5),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: CupertinoColors.link.withOpacity(1),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(icon,color: Colors.white,size: 30,),
          ),
          SizedBox(width: 15,),
          Text(name,
            style: TextStyle(
               fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),

        ],
      ),
    );
  }

}
