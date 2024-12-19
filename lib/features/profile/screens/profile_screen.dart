import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterriverpod/core/providers/firebase_providers.dart';
import 'package:flutterriverpod/features/auth/presentation/auth/screens/sign_in_screen.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/constants.dart';

class MyProfile extends ConsumerStatefulWidget {
  static String path = '/profile';
  static String name = 'profile';

  const MyProfile({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends ConsumerState<MyProfile> {
  bool isUpdate = true;
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userState = ref.read(authNotifierProvider.notifier);
    nameController.text = userState.authUser.name ?? "";
    emailController.text = userState.authUser.email ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My Profile"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showChangeStatusSheet(context: context);
          },
          child: Icon(
            Icons.logout,
            color: Colors.red,
          ),
        ),
        body: _buildUi(context, ref));
  }

  Widget _buildUi(BuildContext context, WidgetRef ref,
      {bool isLoading = false}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Align(
            alignment: Alignment.topCenter,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: CircleAvatar(
                    radius: 50,
                    child: Text(
                      'A',
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Email',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Spacing.hmed,
              TextFormField(
                style: Theme.of(context).textTheme.bodyMedium,
                readOnly: isUpdate,
                controller: emailController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).secondaryHeaderColor)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Email',
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  showChangeStatusSheet({required BuildContext context}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Are you sure want to perform this action?'),
            content: const Text('Your data will be removed'),
            actions: [
              FilledButton(
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.red)),
                  onPressed: () {
                      final authProvider = ref.watch(authNotifierProvider.notifier);
                      authProvider.signOut(() {
                       context.goNamed('signIn');
                      });


                  },
                  child: const Text(
                    'Yes',
                  )),
              TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }
}
