import 'package:flutter/material.dart';
import 'mock_data.dart'; // Import your mock data file

class AccommodationFinder extends StatefulWidget {
  const AccommodationFinder({Key? key}) : super(key: key);

  @override
  _AccommodationFinderState createState() => _AccommodationFinderState();
}

class _AccommodationFinderState extends State<AccommodationFinder> {
  final TextEditingController _areaController = TextEditingController();
  final List<String> accommodationTypes = ['Hotels', 'Resorts', 'Homestays'];
  final List<String> areas = [
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Pune',
    'Goa',
    'Chennai',
    'Hyderabad',
    'Kolkata',
    'Jaipur',
    'Agra',
    'Udaipur',
    'Kerala',
    'Kashmir',
    'Mysore',
    'Lucknow',
    'Varanasi'
  ]; // List of predefined areas (cities or regions)

  String? selectedType;
  String? selectedArea; // To hold selected area
  RangeValues budgetRange = const RangeValues(1000, 5000);
  List<Map<String, dynamic>> searchResults = [];

  void _searchAccommodations() {
    final minPrice = budgetRange.start.round();
    final maxPrice = budgetRange.end.round();
    final area = selectedArea ?? ''; // Get selected area

    if (selectedType == null || area.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a type and area')),
      );
      return;
    }

    // Fetch results based on criteria
    final results = MockData.searchAccommodations(
      type: selectedType!,
      minPrice: minPrice,
      maxPrice: maxPrice,
      area: area,
    );

    setState(() {
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accommodation Finder'),
        backgroundColor: const Color.fromARGB(255, 212, 20, 90),
      ),
      body: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Search by Area',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Dropdown for selecting area
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                value: selectedArea,
                hint: const Text('Select Area'),
                items: areas.map((area) {
                  return DropdownMenuItem<String>(
                    value: area,
                    child: Text(area),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedArea = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Select Accommodation Type',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Dropdown for selecting accommodation type
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                value: selectedType,
                hint: const Text('Choose Type'),
                items: accommodationTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedType = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Set Your Budget Range',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              RangeSlider(
                values: budgetRange,
                min: 500,
                max: 10000,
                divisions: 20,
                labels: RangeLabels(
                  '₹${budgetRange.start.round()}',
                  '₹${budgetRange.end.round()}',
                ),
                onChanged: (values) {
                  setState(() {
                    budgetRange = values;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _searchAccommodations,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Center(
                  child: Text(
                    'Search',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (searchResults.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final result = searchResults[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(result['name']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Location: ${result['location']}'),
                              Text('Price: ₹${result['price']}'),
                              if (result['nearby'] != null)
                                Text(
                                  'Nearby: ${result['nearby'].join(', ')}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
