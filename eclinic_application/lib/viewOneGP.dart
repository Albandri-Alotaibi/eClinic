
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:myapp/style/Mycolors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'model/socialLinks.dart';
import 'package:url_launcher/url_launcher.dart';
import '';





class viewOneGP extends StatefulWidget {
  viewOneGP({super.key, required this.GPid});
  var GPid;
  @override
  State<viewOneGP> createState() => _viewOneGPState();
}

class _viewOneGPState extends State<viewOneGP> {
void initState() {
    // TODO: implement initState
    super.initState();
     print(widget.GPid.runtimeType);
     print(widget.GPid);
     retrieve();
  }

  

var GPname;
var GPcategory;


var CodeLink='';
var Students;
var Fileurl;
List<socialLinks> SocialLinks = []; //availableHours

retrieve() async {
 final snap = await FirebaseFirestore.instance
        .collection("GPlibrary")
        .doc(widget.GPid)
        .get();
     
     Fileurl=await snap['FileUrl'];
     print(Fileurl);

    if (snap.data()!.containsKey('CodeLink') == true) {
      CodeLink=snap['CodeLink'];
    }
     
    Students=await snap['Students'];
    print(Students.length);

  for (var i = 0; i < Students.length; i++) {
            final DocumentSnapshot docRef2 = await Students[i].get(); 
            print(docRef2['firstname']);
           var haveSocialAccount=docRef2['socialmedia'];

           if(haveSocialAccount!= 'None'){
             print("inside not None");
            var medType= docRef2['socialmedia'];
            var link= docRef2['socialmediaaccount'];
            var Firstname=docRef2['firstname'];
            setState(() {
            SocialLinks.add(new socialLinks(
              studentName: Firstname,
              mediaType: medType,
               link: link, 
                ));
          });
           }
}

}

  @override
  Widget build(BuildContext context) {

         return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,//Mycolors.BackgroundColor
              body: 
              //SingleChildScrollView(
                //child: 
                Center(
                child: Column(
                      children: <Widget>[
            
           const SizedBox(height: 50,),
           ElevatedButton(child: Text('open'),
           onPressed: ()=> openFile(
          url:Fileurl,
          fileName:'file.pdf',

           )
           ),
 const SizedBox(height: 50,),
           if(CodeLink != '')
          new RichText(
                                                text: new TextSpan(
                                                  //text: 'Meeting Link : ',
                                                  children: [
                                                    new TextSpan(
                                                      // style: defaultText,
                                                      text: "Github repository link : ",
                                                      style: TextStyle(
                                                          color: Mycolors
                                                              .mainColorBlack,
                                                          fontFamily: 'main',
                                                          fontSize: 15),
                                                    ),
                                                    new TextSpan(
                                                      //new TextStyle(color: Colors.blue)
                                                      text: 'Click here \n',
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontFamily: 'main',
                                                          fontSize: 15),
                                                      recognizer:
                                                          new TapGestureRecognizer()
                                                            ..onTap = () {
                                                              launch(CodeLink); //''+BookedAppointments[index].meetingInfo+''
                                                            },
                                                    ),
                                                  ],
                                                ),
                                              ),

              
           
          





           
  const SizedBox(height: 300,),
  if(SocialLinks.length !=0)
  Expanded(
          child: SizedBox(
            height: 50,
            child: new GridView.builder(
  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3,
                crossAxisSpacing: 60,
                mainAxisSpacing: 10),
                            itemCount:
                                SocialLinks.length, 
                            itemBuilder: ((context, index) {
                              if (index < SocialLinks.length) {
                                if(SocialLinks[index].mediaType=='WhatsApp'){
                           return  Container(
                              child: ListView(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Text('     '),
                                            GestureDetector(
                                              onTap:  (){
                                                launch(SocialLinks[index].link);
                                              },
                                              child: Image.asset(
                                                'assets/images/whatsapp.png',
                                               // name: 'ff',
                                                width: 40,
                                                height: 40,

                                                //fit: BoxFit.cover,
                                              ),
                                            ),
                                            Text('   '+ SocialLinks[index].studentName),
                                          ],
                                        ),
                                      //Text("vvvv")
                                       ],
                                    ),
                                    //Text('xxxxxx')
                               
                             
                              );
                                }
                                else if(SocialLinks[index].mediaType=='Twitter'){
                                  return  Container(
                              child: ListView(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                         Text('     '),
                                        GestureDetector(
                                          onTap:  (){
                                            launch(SocialLinks[index].link);
                                          },
                                          child: Image.asset(
                                            'assets/images/twitter.png', // On click should redirect to an URL
                                            width: 40,
                                            height: 40,
                                            //fit: BoxFit.cover,
                                          ),
                                        ), 
                                        Text('   '+ SocialLinks[index].studentName),
                                      ],
                                    ),
                                   // Text("vvvv")
                                  
                                  ],
                                ),
                              );
                                }
                                else if(SocialLinks[index].mediaType=='LinkedIn'){
                                  return  Container(
                              child: ListView(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                         Text('     '),
                                        GestureDetector(
                                          onTap:  (){
                                            launch(SocialLinks[index].link);
                                          },
                                          child: Image.asset(
                                            'assets/images/linkedin.png', // On click should redirect to an URL
                                            width: 40,
                                            height: 40,
                                            //fit: BoxFit.cover,
                                          ),
                                        ),
                                       Text('   '+ SocialLinks[index].studentName),
                                       ],
                                    )
                                  ],
                                ),
                              );
                                }else{
                                  return Row();
                                }
                                } 
                              else {
                                return Row();
                               }
                            }
                            )
                            ),
          )
          ),




  
  const SizedBox(height: 50,),
   
                  
                  
                  
                  
                  
  
                   ]
                )
                )
              )
          
         );
  
  
  }//end build 


socialMediaCreation(){

  //  for (int i = 0; i < BookedAppointments.length; i++) {
  
  //  }
















}




Future openFile({required String url, String? fileName}) async{
      final file= await downloadFile(url, fileName!);
      if(file==null)return;

      print('Path: ${file.path}');

      OpenFile.open(file.path);


}

Future<File?> downloadFile(String url, String name) async{
final appStorage = await getApplicationDocumentsDirectory();
final file= File('${appStorage.path}/$name');

try{
final response= await Dio().get(
     url,
     options: Options(
      responseType: ResponseType.bytes,
      followRedirects: false,
      receiveTimeout:0,
     ),
);

final raf= file.openSync(mode: FileMode.write);
raf.writeFromSync(response.data);
await raf.close();

return file;
}
catch(e){
  return null;
}

}







}//end class
