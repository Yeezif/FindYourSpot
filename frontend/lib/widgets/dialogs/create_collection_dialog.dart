import 'package:flutter/material.dart';
import 'package:findyourspot/widgets/widgets/create_collection_form.dart';
import 'package:findyourspot/services/api_service.dart';

class CreateCollectionDialog extends StatelessWidget {
  final ApiService apiService;

  const CreateCollectionDialog({
    super.key,
    required this.apiService,
    
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 0.8,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: CreateCollectionForm(
            apiService: apiService,
          ),
        ),
      ),
    );
  }
}
