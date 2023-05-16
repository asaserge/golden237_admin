import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/apis.dart';
import '../widgets/custom_input.dart';
import '../widgets/header_widget.dart';
import '../widgets/submit_button.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {

  final TextEditingController _controllerEmail = TextEditingController();
  final _formKeyUser = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),

        actions: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('Pending (0)'),
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderWidget(
                text: 'You will be able to invite a user to create an account on Golden237 store',
                image: 'assets/icons/user-icon.png',
              ),

              const SizedBox(height: 25),

              Form(
                key: _formKeyUser,
                child: CustomInput(
                  controller: _controllerEmail,
                  hintText: 'User\'s Email',
                  maxCount: 35,
                  label: 'Email',
                  prefixIcon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required!';
                    }
                    if (!(regex.hasMatch(value))) {
                      return "Enter a valid email address!";
                    }
                    return null;
                  },
                  textInputType: TextInputType.emailAddress,
                  onChange: (val){

                  },
                ),
              ),

              const SizedBox(height: 35),

              SubmitButton(
                text: 'Invite User',
                isEnabled: true,
                isLoading: isLoading,
                onPressed: () async{
                  if(_formKeyUser.currentState!.validate()){
                    Apis.client.auth.admin.inviteUserByEmail(_controllerEmail.text)
                        .then((value) {
                      Get.snackbar('Success!', 'An invite email has been sent to ${_controllerEmail.text} '
                          'successfully!',
                          borderRadius: 5, backgroundColor: Colors.green,
                          colorText: Colors.white, duration: const Duration(seconds: 6));
                      Navigator.of(context).pop();
                    });
                    setState(() {
                      isLoading = false;
                    });

                  }
                  else{
                    return;
                  }
                },
              ),

              const SizedBox(height: 15),

            ],
          ),
        ),
      ),
    );
  }

}

RegExp regex = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

