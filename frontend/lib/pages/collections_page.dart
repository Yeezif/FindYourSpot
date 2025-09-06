import 'package:findyourspot/widgets/widgets/app_bar_collection_detail.dart';
import 'package:findyourspot/widgets/widgets/app_bar_collections.dart';
import 'package:flutter/material.dart';
import 'package:findyourspot/services/api_service.dart';
import 'package:findyourspot/models/collection.dart';
import 'package:findyourspot/widgets/buttons/collections/create_collection_button.dart';

class CollectionsPage extends StatefulWidget {
  final ApiService apiService;

  const CollectionsPage({
    super.key,
    required this.apiService,
  });

  @override
  State<CollectionsPage> createState() => _CollectionsPageState();

}

class _CollectionsPageState extends State<CollectionsPage> {
  late Future<List<Collection>> _futureCollections;

  @override
  void initState() {
    super.initState();
    _futureCollections = widget.apiService.getLoggedInUserCollections();
  }

  Future<void> _refreshCollections() async {
    setState(() {
      _futureCollections = widget.apiService.getLoggedInUserCollections();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBarCollections(),

      body: Stack(
        children: [

          FutureBuilder<List<Collection>>(
            future: _futureCollections,
            builder: (context, snapshot) {

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No collections found'));
              }

              final collections = snapshot.data!;

              return ListView.builder(
                itemCount: collections.length,
                itemBuilder: (context, index) {
                  final collection = collections[index];
                  return ListTile(
                    title: Text(collection.title),
                    subtitle: Text(collection.description),
                    trailing: Text("${collection.spots.length} Spots"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CollectionDetailPage(collection: collection),
                        ),
                      );
                    },
                  );
                },
              );

            }

          ),

          Positioned(
            bottom: 14,
            right: 14,
            child: CreateCollectionButton(
              apiService: widget.apiService,
              onCollectionCreated: (_) => _refreshCollections(),
            ),
          )

        ],

      )

      
    );
  }

}

class CollectionDetailPage extends StatelessWidget {
  final Collection collection;

  const CollectionDetailPage({
    super.key, 
    required this.collection
  });

  @override
  Widget build(BuildContext context) {
    final spots = collection.spots;
    
    return Scaffold(
      appBar: AppBarCollectionDetail(collection: collection),


    );
  }
}