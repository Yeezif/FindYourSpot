import 'package:findyourspot/widgets/messages/messages.dart';
import 'package:flutter/material.dart';
import 'package:findyourspot/widgets/dialogs/create_collection_dialog.dart';
import 'package:findyourspot/services/api_service.dart';
import 'package:findyourspot/models/collection.dart';

class CreateCollectionButton extends StatelessWidget {
  final ApiService apiService;
  final Function(Collection)? onCollectionCreated;

  const CreateCollectionButton({
    super.key,
    required this.apiService,
    this.onCollectionCreated,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: FloatingActionButton(
        heroTag: 'create_collection_button',
        onPressed: () async {
          final newCollection = await showDialog<Collection>(
            context: context,
            builder: (context) => Center(
              child: CreateCollectionDialog(apiService: apiService),
            ),
          );

          

          if (newCollection != null && onCollectionCreated != null) {
            onCollectionCreated!(newCollection);
            SuccessMessage.show(context, 'Collection created successfully!');
          }

          
        },
        child: const Icon(
          Icons.add_rounded,
          size: 40,
        ),
      ),
    );
  }
}