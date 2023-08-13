import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitterclone/models/tweet.dart';
import 'package:twitterclone/pages/create.dart';
import 'package:twitterclone/providers/tweet_provider.dart';
import 'package:twitterclone/providers/user_providoer.dart';
import 'package:twitterclone/pages/settings.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LocalUser currentUser = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(preferredSize: const Size.fromHeight(4),child: Container(color: Colors.grey, height: 1,),),
        centerTitle: true,
        title: const Image(image: AssetImage('assets/twitter_blue.png'), width: 50 ,),
        leading: Builder(builder: (context) {
          return GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(currentUser.user.profilePicture),
              ),
            ),
          );
        }),
        
      ),
      body: ref.watch(feedProvider).when(
        data: (List<Tweet> tweets){
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(color: Colors.black,),
            itemCount: tweets.length, itemBuilder: (context,count) {
            return ListTile(
              leading: CircleAvatar(foregroundImage: NetworkImage(tweets[count].profilePicture)),
              title: Text( tweets[count].name,style: const TextStyle(fontWeight: FontWeight.bold),),
              subtitle: Text(tweets[count].tweet,style: const TextStyle(color: Colors.black, fontSize: 16)),);
          });
      }, 
      error: (error, stackTrace)=> const Center(
        child: Text('Error') ),
        loading: () => const CircularProgressIndicator()),
      //)
      drawer: Drawer(
          child: Column(
        children: [
          Image.network(currentUser.user.profilePicture),
          ListTile(
            title: Text(
              "Hello. ${currentUser.user.name}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          ListTile(
            title: const Text("Settings"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const SettingsPage()));
            },
          ),
          ListTile(
            title: const Text("Signout"),
            onTap: () {
                FirebaseAuth.instance.signOut();
                ref.read(userProvider.notifier).logout();
            },
          )
        ],
      )),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CreateTweet()));
      }, child:  const Icon(Icons.add), ) ,
    );
  }
}
