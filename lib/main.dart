import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_app/models/user.dart';
import 'package:sqflite_app/uitil/database_helper.dart';

List _users;
void main() async {
  var db = DatabaseHelper();


/** ADD User
 * when we add we recive integer 1 correct / 0 wrong saved
 * if we run the code again it will save the same user (await db.saveUser(User("Ebrahim","ebrahims"));)
 */
  int savedUser = await db.saveUser(User("hossam", "snsdhfhfn"));
  //print("saveduser:$savedUser");

/**Delete user
*
*/
//int deleteUser=await db.deleteUser(2);
//print(deleteUser);


/** Retrive all user
 * return List we hv to loop 
 * bc we know the list not user type object/ conert it into map using User Class
 * the list will contine users we hv to create a user object from User model
 * we get all user then map them using user.map() by this way we can say user.username/user.password 
 */
  _users = await db.getAllUser();
  for (int i = 0; i < _users.length; i++) {
    User user = User.map(_users[i]);
    //print("Username:${user.username}");
  print("Username:${user.username}, userID:${user.id}");
  }

//GET Count of user
//int count=await db.getCount();
//print(count);

// Get one user
//User user=await db.getUser(1);
//print(user.password);

// update user
 User ana = await db.getUser(1);
  User anaUpdated = User.fromMap({
    "username": "UpdatedAna",
    "password" : "updatedPassword",
    "id"       : 1
  });


  //Update
  await
  db.updateUser(anaUpdated);


















  runApp(MaterialApp(
    title: "Sqfilte",
    home: Home(),
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SQflite"),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
      ),
      //(_) that sign means BuildContext in Widget build above it the same if we (BuildContxt context)
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder:(_,int postion){
          return Card(color: Colors.cyan,
          // elevetion for shadow around the  card or ertfa3
          elevation: 3.0,
          // if we say _users[position].usarname it will return a list we need map so call formMap()
          child: ListTile( title: Text("Username : ${User.fromMap(_users[postion]).username}"),
          subtitle: Text("userID:${User.fromMap(_users[postion]).id}"),
          leading: CircleAvatar(
            backgroundColor: Colors.yellowAccent,
            child: Text("${User.fromMap(_users[postion]).username.substring(0,1)}"),
          ),
          onTap: ()=>debugPrint("password:"),),);
      }),
    );
  }
}
