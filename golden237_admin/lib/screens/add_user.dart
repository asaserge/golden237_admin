import 'package:flutter/material.dart';

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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
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
                key: _formKey,
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
                onPressed: () {
                  if(_formKey.currentState!.validate()){
                    //Todo invite user
                  }
                  else{
                    return;
                  }
                },
                isLoading: false,
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

