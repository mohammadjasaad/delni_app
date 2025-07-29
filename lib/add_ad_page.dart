import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' show basename;

class AddAdPage extends StatefulWidget {
  final String userEmail;
  final String userToken;

  const AddAdPage({Key? key, required this.userEmail, required this.userToken}) : super(key: key);

  @override
  State<AddAdPage> createState() => _AddAdPageState();
}

class _AddAdPageState extends State<AddAdPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<XFile> _selectedImages = [];

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    setState(() {
      _selectedImages = images;
    });
  }

  Future<void> _submitAd() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى اختيار صور للإعلان")),
      );
      return;
    }

    try {
      var uri = Uri.parse('https://delni.co/api/ads');
      var request = http.MultipartRequest('POST', uri);

      request.fields['title'] = _titleController.text;
      request.fields['price'] = _priceController.text;
      request.fields['description'] = _descriptionController.text;
      request.fields['city'] = 'دمشق'; // مؤقتًا
      request.fields['category'] = 'سيارات'; // مؤقتًا
      request.fields['user_id'] = '1'; // مؤقتًا

      for (var image in _selectedImages) {
        var file = await http.MultipartFile.fromPath(
          'images[]',
          image.path,
          filename: basename(image.path),
        );
        request.files.add(file);
      }

      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ تم نشر الإعلان بنجاح")),
        );
        setState(() {
          _selectedImages.clear();
          _titleController.clear();
          _descriptionController.clear();
          _priceController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ فشل النشر: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ خطأ أثناء الاتصال بالخادم: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة إعلان جديد'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'عنوان الإعلان'),
                validator: (value) => value == null || value.isEmpty ? 'يرجى إدخال العنوان' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'السعر'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'يرجى إدخال السعر' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'الوصف'),
                maxLines: 5,
                validator: (value) => value == null || value.isEmpty ? 'يرجى إدخال الوصف' : null,
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _pickImages,
                icon: const Icon(Icons.photo),
                label: const Text('اختيار صور'),
              ),
              const SizedBox(height: 10),
              _selectedImages.isNotEmpty
                  ? Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _selectedImages.map((img) {
                        return Image.file(
                          File(img.path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        );
                      }).toList(),
                    )
                  : const Text("لم يتم اختيار صور بعد"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitAd,
                child: const Text('🟡 نشر الإعلان'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
