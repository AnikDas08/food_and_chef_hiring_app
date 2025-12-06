import 'package:flutter/cupertino.dart';


import 'chef_item.dart';

Widget recommended() {
  return ListView.builder(
    itemCount: 10,
    scrollDirection: Axis.horizontal,
    itemBuilder: (context, index) {
      return chefItem();
    },
  );
}
