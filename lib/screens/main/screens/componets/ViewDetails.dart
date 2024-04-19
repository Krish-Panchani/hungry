import 'package:flutter/material.dart';
import 'package:hunger/components/appBar.dart';
import 'package:hunger/components/myDrawer.dart';
import 'package:hunger/constants.dart';
import 'package:hunger/models/UserModal.dart';

class ViewDetailsScreen extends StatefulWidget {
  final UserData userData;

  const ViewDetailsScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<ViewDetailsScreen> createState() => _ViewDetailsScreenState();
}

class _ViewDetailsScreenState extends State<ViewDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: const MyDrawer(
        showLogOut: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: kPrimaryColor,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 90,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                      ),
                      border: Border.all(
                        color: kPrimaryColor,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.location_on_sharp,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 50),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.userData.fname,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  widget.userData.address,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.white,
                              backgroundColor: Colors.white,
                              visualDensity: const VisualDensity(
                                horizontal: -2,
                                vertical: -2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(
                                  color: kPrimaryColor,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              '1.0 km',
                              style: const TextStyle(
                                fontSize: 16,
                                color: kPrimaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          widget.userData.details,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Divider(
                                color: kPrimaryColor,
                                thickness: 2,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Basic Details",
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: kPrimaryColor,
                                thickness: 2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                  text: 'Contact No. : ', style: kTextStyleB),
                              TextSpan(
                                  text: widget.userData.phone,
                                  style: kTextStyleN),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                  text: 'Who can get the food? : ',
                                  style: kTextStyleB),
                              TextSpan(text: 'Every One', style: kTextStyleN),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                  text: 'Any min. Price for food? : ',
                                  style: kTextStyleB),
                              TextSpan(text: '0 Rs.', style: kTextStyleN),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Divider(
                          color: kPrimaryColor,
                          thickness: 2,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: kPrimaryColor,
                          ),
                          onPressed: () {},
                          icon: const Icon(Icons.directions),
                          label: const Text(
                            'Get Directions',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
