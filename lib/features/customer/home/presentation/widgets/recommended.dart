import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import 'chef_item.dart';

Widget recommended() {
  return GetBuilder<HomeController>(
    builder: (controller) {
      // Show loading indicator while fetching location or chefs
      if (controller.isLoadingLocation || controller.isLoadingChefs) {
        return Center(
          child: CircularProgressIndicator(
            color: Color(0xffFD713F),
          ),
        );
      }

      // Show message if no chefs found
      if (controller.nearbyChefsList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_off,
                size: 48,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'No nearby chefs found',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () => controller.refreshChefs(),
                child: Text(
                  'Retry',
                  style: TextStyle(
                    color: Color(0xffFD713F),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      // Display the list of nearby chefs
      return ListView.builder(
        itemCount: controller.nearbyChefsList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return chefItem(
            chef: controller.nearbyChefsList[index],
          );
        },
      );
    },
  );
}