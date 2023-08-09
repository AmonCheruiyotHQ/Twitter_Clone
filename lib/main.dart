import 'package:flutter/material.dart';
import 'package:twitterclone/signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home:   const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _signInKey = GlobalKey();
  final _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RegExp emailValid = RegExp(r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+\@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _signInKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Image(image: AssetImage('assets/twitter_blue.png'),width: 100),
            const SizedBox(height: 20,),
            const Text(
              "Log in to Twitter",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15,30, 15, 0),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30)
                ),
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "Enter an Email",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical:15, horizontal: 20 )
                  ),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }else if(!emailValid.hasMatch(value)){
                    return "Please enter a valid email ";
                  }
                  return null;
                } 
              ),
            ),//email
            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30)
                ),
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Password",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical:15, horizontal: 20 )
                ),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }else if(value.length <6){
                    return " Password must be at least 6 characters";
                  }
                  return null;
                } 
              ),
            ),//password
            Container(
              width: 250,
              decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(30)),
              child: TextButton(
                onPressed: () {
                  if (_signInKey.currentState!.validate()) {
                    debugPrint("Email: ${_emailController.text}");
                    debugPrint("Password: ${_passwordController.text}");
                  }
                },
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 18),),
              ),
            ),
            TextButton(onPressed: () { 
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SignUp()));
             },
            child: const Text("Don't have an account? Sign up here"))
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
