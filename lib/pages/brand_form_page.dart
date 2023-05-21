import 'package:flutter/material.dart';
import 'package:shoe_brand/models/brand.dart';
import 'package:shoe_brand/services/database_service.dart';

class BrandFormPage extends StatefulWidget {
  final Brand? brand;
  const BrandFormPage({Key? key, this.brand}) : super(key: key);

  @override
  State<BrandFormPage> createState() => _BrandFormPageState();
}

class _BrandFormPageState extends State<BrandFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    if (widget.brand != null) {
      _nameController.text = widget.brand!.name;
      _descController.text = widget.brand!.description;
    }
  }

  Future<void> _onSave() async {
    final name = _nameController.text;
    final description = _descController.text;

    if (widget.brand != null) {
      await _databaseService.updateBrand(
          Brand(id: widget.brand!.id, name: name, description: description));
    } else {
      await _databaseService
          .insertBrand(Brand(name: name, description: description));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.brand == null ? 'Add a new brand' : 'Edit brand'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter name of the brand here',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descController,
              maxLines: 7,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter description about the brand here',
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 45.0,
              child: ElevatedButton(
                onPressed: _onSave,
                child: const Text(
                  'Save the Brand',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
