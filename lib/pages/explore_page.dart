import 'package:flutter/material.dart'
    show
        AlertDialog,
        Alignment,
        AppBar,
        AssetImage,
        BoxDecoration,
        BuildContext,
        Card,
        CircleAvatar,
        Color,
        Colors,
        Column,
        Container,
        CrossAxisAlignment,
        EdgeInsets,
        FontWeight,
        Icon,
        IconButton,
        Icons,
        LinearGradient,
        ListTile,
        ListView,
        MaterialApp,
        Navigator,
        Scaffold,
        SearchDelegate,
        SizedBox,
        State,
        StatefulWidget,
        Text,
        TextButton,
        TextStyle,
        Widget,
        runApp,
        showDialog,
        showSearch;

// Location model to hold data about famous locations
class Location {
  final String name;
  final String imageUrl;
  final double travelCost;
  final String address; // New field for address

  Location(
      {required this.name,
      required this.imageUrl,
      required this.travelCost,
      required this.address}); // Include address in constructor
}

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<Location> locations = [
    Location(
        name: 'Taj Mahal',
        imageUrl: 'assets/taj_mahal.jpg',
        travelCost: 5000.0,
        address: 'Taj Mahal, Agra, Uttar Pradesh, India'),
    Location(
        name: 'Jaipur',
        imageUrl: 'assets/jaipur.jpg',
        travelCost: 4000.0,
        address: 'Jaipur, Rajasthan, India'),
    Location(
        name: 'MahaKumbh Mela',
        imageUrl: 'assets/mahakumbh.jpg',
        travelCost: 4000.0,
        address: 'Prayagraj, Uttar Pradesh, India'),
    Location(
        name: 'Goa',
        imageUrl: 'assets/goa.jpg',
        travelCost: 6000.0,
        address: 'Goa, India'),
    Location(
        name: 'Kerala',
        imageUrl: 'assets/kerala.jpg',
        travelCost: 5500.0,
        address: 'Kerala, India'),
    Location(
        name: 'Rajasthan',
        imageUrl: 'assets/rajasthan.jpg',
        travelCost: 4500.0,
        address: 'Rajasthan, India'),
    Location(
        name: 'Ladakh',
        imageUrl: 'assets/ladakh.jpg',
        travelCost: 7000.0,
        address: 'Ladakh, India'),
  ];

  List<Location> filteredLocations = [];

  @override
  void initState() {
    super.initState();
    filteredLocations = locations;
  }

  void filterSearchResults(String query) {
    setState(() {
      filteredLocations = locations
          .where((location) =>
              location.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 212, 20, 90), // Start color
            Color.fromARGB(255, 251, 176, 59), // End color
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Make Scaffold transparent
        appBar: AppBar(
          title: const Text('Explore India'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: LocationSearchDelegate(
                    locations,
                    filterSearchResults,
                  ),
                );
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: filteredLocations.length,
          itemBuilder: (context, index) {
            final location = filteredLocations[index];
            return Card(
              elevation: 5.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10.0),
                title: Text(
                  location.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle:
                    Text('Travel Cost: ₹${location.travelCost.toString()}'),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(location.imageUrl),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(location.name),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Estimated cost to travel: ₹${location.travelCost.toString()}'),
                          const SizedBox(height: 10),
                          Text('Address: ${location.address}'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class LocationSearchDelegate extends SearchDelegate {
  final List<Location> locations;
  final Function(String) onQueryChanged;

  LocationSearchDelegate(this.locations, this.onQueryChanged);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          onQueryChanged(query);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredLocations = locations
        .where((location) =>
            location.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredLocations.length,
      itemBuilder: (context, index) {
        final location = filteredLocations[index];
        return ListTile(
          title: Text(location.name),
          subtitle: Text('Travel Cost: ₹${location.travelCost.toString()}'),
          onTap: () {
            // Show location details on selection
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(location.name),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Estimated cost to travel: ₹${location.travelCost}'),
                    const SizedBox(height: 10),
                    Text('Address: ${location.address}'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredLocations = locations
        .where((location) =>
            location.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredLocations.length,
      itemBuilder: (context, index) {
        final location = filteredLocations[index];
        return ListTile(
          title: Text(location.name),
          subtitle: Text('Travel Cost: ₹${location.travelCost.toString()}'),
          onTap: () {
            // Show location details on selection
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(location.name),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Estimated cost to travel: ₹${location.travelCost}'),
                    const SizedBox(height: 10),
                    Text('Address: ${location.address}'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ExplorePage(),
  ));
}
