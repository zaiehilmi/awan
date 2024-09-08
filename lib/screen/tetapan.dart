import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';

class SkrinTetapan extends HookWidget {
  const SkrinTetapan({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        const SizedBox(height: 5),
        FCard(
          title: const Text('Account'),
          subtitle: const Text(
              'Make changes to your account here. Click save when you are done.'),
          child: Column(
            children: [
              const FTextField(
                label: Text('Name'),
                hint: 'John Renalo',
              ),
              const SizedBox(height: 10),
              const FTextField(
                label: Text('Email'),
                hint: 'john@doe.com',
              ),
              const SizedBox(height: 16),
              FButton(
                label: const Text('Save'),
                onPress: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
