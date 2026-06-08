import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/property_provider.dart';
import '../../../../core/models/property_model.dart';
import '../../../../core/providers/activity_provider.dart';
import '../../../../core/localization/app_localizations.dart';

class EditPropertyDialog extends StatefulWidget {
  final PropertyModel property;

  const EditPropertyDialog({super.key, required this.property});

  @override
  State<EditPropertyDialog> createState() => _EditPropertyDialogState();
}

class _EditPropertyDialogState extends State<EditPropertyDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _address;
  late int _yearBuilt;
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _name = widget.property.name;
    _address = widget.property.address;
    _yearBuilt = widget.property.yearBuilt;
    _imagePath = widget.property.imagePath;
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _imagePath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Edit Property', // Translation key could be used here
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Image Picker Section
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 160,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          image: _imagePath != null
                              ? DecorationImage(
                                  image: FileImage(File(_imagePath!)),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _imagePath == null
                            ? const Center(
                                child: Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: CircleAvatar(
                          backgroundColor: Colors.blue[700],
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                            onPressed: _pickImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  initialValue: _name,
                  decoration: InputDecoration(
                    labelText: 'Property Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                  onSaved: (value) => _name = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _address,
                  decoration: InputDecoration(
                    labelText: 'Address', // Usually localized
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                  onSaved: (value) => _address = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _yearBuilt.toString(),
                  decoration: InputDecoration(
                    labelText: localizations.yearBuilt,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (int.tryParse(value) == null) return 'Enter a valid year';
                    return null;
                  },
                  onSaved: (value) => _yearBuilt = int.parse(value!),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final propProv = context.read<PropertyProvider>();
                      final actProv = context.read<ActivityProvider>();
                      
                      await propProv.updateProperty(
                        widget.property.id,
                        _name,
                        _address,
                        _yearBuilt,
                        _imagePath,
                      );
                      
                      actProv.logActivity(
                        iconCode: 'business',
                        titleKey: 'Property Updated',
                        subtitle: _name,
                      );
                      
                      if (context.mounted) Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
