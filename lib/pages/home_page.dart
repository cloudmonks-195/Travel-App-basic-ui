import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore integration
import 'package:Viator/pages/accomodation_finder.dart';
import 'package:Viator/utils/styles.dart';
import 'package:Viator/pages/profile_page.dart';
import 'package:Viator/pages/explore_page.dart';
import 'package:flutter/foundation.dart'; // To use kIsWeb

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _hoveredPopularIndex = -1; // To track hover in Popular Destinations
  int _hoveredRecommendedIndex = -1; // To track hover in Recommended For You

  // Map of custom messages for each destination
  final Map<String, String> destinationMessages = {
    'Mahakumbh Mela':
        'Experience the grand spiritual gathering in India! --> After arriving at Prayagraj Junction, take an auto-rickshaw or taxi to Triveni Sangam, the site of Mahakumbh Mela. Follow signs to M.G. Marg, then head towards Daraganj or Sangam. Upon reaching, local transport like buses and trolleys will guide you to the Mela grounds.',
    'Rajasthan':
        'Discover the royal heritage and vibrant culture of Rajasthan.--> From Jaipur Railway Station, take a taxi or auto-rickshaw to Hawa Mahal. You can explore nearby attractions like Amber Fort and City Palace by local transport.',
    'Taj Mahal':
        'A symbol of love and one of the wonders of the world.--> From Agra Cantt. Railway Station, take a cab to the Taj Mahal East Gate. It\'s a short ride to the monument.',
    'Goa':
        'Relax on the beautiful beaches and enjoy the nightlife of Goa.--> From Dabolim Airport, take a taxi to Calangute Beach or Baga Beach. Public buses or hired bikes are great for exploring.',
    'Kerala':
        'Explore the backwaters, beaches, and rich culture of Kerala.--From Trivandrum Railway Station, hire a taxi to Kovalam Beach or Alleppey Backwaters. Use local transport like boats or autorickshaws for short distances.',
    'Ladakh':
        'An adventurous destination with breathtaking landscapes--> Fly to Leh Airport, then hire a taxi to Pangong Lake or Nubra Valley. Local transport and rented bikes are ideal for short distances.',
    'Jaipur':
        'The Pink City awaits with its forts, palaces, and vibrant markets.--From Jaipur Junction, take an auto or taxi to Hawa Mahal or Amber Fort. Jaipur is well-connected by rickshaws and taxis for easy sightseeing.',
  };

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ExplorePage(),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AccommodationFinder(),
        ),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfilePage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 212, 20, 90),
                Color.fromARGB(255, 251, 176, 59),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar or introductory section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'TravelApp',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.notifications, color: Colors.white),
                      onPressed: () {
                        // Handle notification action
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Search bar
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Search for destinations...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Popular Destinations
                _buildSectionTitle('Popular Destinations'),
                const SizedBox(height: 10),
                _buildHorizontalList(
                  [
                    {
                      'title': 'Mahakumbh Mela',
                      'image': 'assets/mahakumbh.jpg'
                    },
                    {'title': 'Rajasthan', 'image': 'assets/rajasthan.jpg'},
                    {'title': 'Taj Mahal', 'image': 'assets/taj_mahal.jpg'},
                  ],
                  true, // This indicates Popular Destinations
                ),
                const SizedBox(height: 20),
                // Recommended for You
                _buildSectionTitle('Recommended For You'),
                const SizedBox(height: 10),
                _buildHorizontalList(
                  [
                    {'title': 'Goa', 'image': 'assets/goa.jpg'},
                    {'title': 'Kerala', 'image': 'assets/kerala.jpg'},
                    {'title': 'Ladakh', 'image': 'assets/ladakh.jpg'},
                    {'title': 'Jaipur', 'image': 'assets/jaipur.jpg'},
                  ],
                  false, // This indicates Recommended For You
                ),
                const SizedBox(height: 20),
                // Event Updates and Notifications
                _buildSectionTitle('Event Updates and Notifications'),
                const SizedBox(height: 10),
                _buildEventUpdatesSection(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 94,
        child: BottomNavigationBar(
          iconSize: 29,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.black,
          backgroundColor: white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined), label: 'Explore'),
            BottomNavigationBarItem(icon: Icon(Icons.hotel), label: 'Hotels'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outlined), label: 'Person'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildHorizontalList(List<Map<String, String>> items, bool isPopular) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildDestinationCard(
              item['title']!, item['image']!, index, isPopular);
        },
      ),
    );
  }

  Widget _buildDestinationCard(
      String title, String imagePath, int index, bool isPopular) {
    return GestureDetector(
      onTap: () {
        // Fetch the custom message based on the destination title
        String customMessage =
            destinationMessages[title] ?? 'No message available';

        // Show the dialog with the custom message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(' $title'),
            content: Text(customMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
      child: kIsWeb // Check if it's a web platform
          ? MouseRegion(
              onEnter: (_) {
                setState(() {
                  if (isPopular) {
                    _hoveredPopularIndex = index;
                  } else {
                    _hoveredRecommendedIndex = index;
                  }
                });
              },
              onExit: (_) {
                setState(() {
                  if (isPopular) {
                    _hoveredPopularIndex = -1;
                  } else {
                    _hoveredRecommendedIndex = -1;
                  }
                });
              },
              child: AnimatedScale(
                scale: (isPopular
                            ? _hoveredPopularIndex
                            : _hoveredRecommendedIndex) ==
                        index
                    ? 1.2
                    : 1.0, // Enlarge only the hovered image in the respective section
                duration: const Duration(milliseconds: 300),
                child: Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      width: double.infinity,
                      color: Colors.black54,
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Container(
              // For non-web platforms, no hover effect
              width: 150,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  color: Colors.black54,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildEventUpdatesSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('events').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading events.'));
        }

        final events = snapshot.data?.docs ?? [];

        if (events.isEmpty) {
          return const Center(child: Text('No events available.'));
        }

        return Column(
          children: events.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return ListTile(
              leading: data['imageUrl'] != null &&
                      data['imageUrl'].startsWith('http')
                  ? ClipOval(
                      child: Image.network(
                        data['imageUrl'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 50),
                      ),
                    )
                  : const CircleAvatar(
                      radius: 25,
                      child: Icon(Icons.event),
                    ),
              title: Text(data['title'] ?? 'Event'),
              subtitle: Text(data['description'] ?? 'Description'),
              onTap: () {
                // Show detailed information
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(data['title'] ?? 'Event'),
                    content: Text(data['description'] ?? 'Description'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}
