
import 'package:flutter/material.dart';

class Restaurant {
  final String name;
  final double distance;
  final String imageUrl;

  Restaurant({
    required this.name,
    required this.distance,
    required this.imageUrl,
  });
}

class RestaurantList extends StatelessWidget {
  final List<Restaurant> restaurants = [
    Restaurant(
      name: 'Iskon Temple',
      distance: 2.5,
      imageUrl:
          'https://yometro.com/images/places/iskcon-temple-ahmedabad.jpg',
    ),
    Restaurant(
      name: 'Seva Cafe',
      distance: 1.8,
      imageUrl:'https://miles2smile.files.wordpress.com/2014/03/1-2014-01-223.jpg'
    ),
    Restaurant(
      name: 'Jivan Cheritable Trust',
      distance: 0.9,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCtBfTZ2gD4gFRFcHqteZ1R9H3MAk5F8IJGA&usqp=CAU',
    ),
    Restaurant(
      name: 'Ahar Kendra',
      distance: 3.9,
      imageUrl:'https://pbs.twimg.com/media/E4ZToNXVEAIZdvu?format=jpg'
    ),
    // Add more restaurants as needed
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        return RestaurantCard(restaurant: restaurants[index]);
      },
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  RestaurantCard({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromRGBO(172, 223, 135, 600.0),
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Image.network(
            restaurant.imageUrl,
            height: 150.0,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  'Distance: ${restaurant.distance} km',
                  style: TextStyle(fontSize: 16.0),
                ),
                // SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                      ),
                      onPressed: () {
                        // Handle direction button press
                      },
                      icon: Icon(Icons.directions, color: Colors.white,),
                      label: Text('Directions', style: TextStyle(color: Colors.white),),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
