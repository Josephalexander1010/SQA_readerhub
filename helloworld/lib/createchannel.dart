// lib/createchannel.dart
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateChannelPage extends StatefulWidget {
  const CreateChannelPage({super.key});

  @override
  State<CreateChannelPage> createState() => _CreateChannelPageState();
}

class _CreateChannelPageState extends State<CreateChannelPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  XFile? _pickedFile;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    _descriptionController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final bool isFormValid = _nameController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty;
    if (_isButtonEnabled != isFormValid) {
      setState(() {
        _isButtonEnabled = isFormValid;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        setState(() {
          _pickedFile = file;
        });
      }
    } catch (e) {
      debugPrint('Gagal mengambil gambar: $e');
    }
  }

  void _createChannel() {
    if (!_isButtonEnabled) return;

    final newChannelData = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': '[M]${_nameController.text}',
      'description': _descriptionController.text,
      'avatar': _pickedFile?.path,
      'isAsset': false,
      'isNetwork': kIsWeb,
      // --- PERBAIKAN DI SINI: HAPUS 'const' ---
      'subChannels': [
        {'name': 'General'},
        {'name': 'Announcements'},
      ],
      // ----------------------------------------
    };

    Navigator.pop(context, newChannelData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4A3F8F)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Channel',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A3F8F),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _buildPfp(),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4A3F8F),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(text: 'Channel Name'),
                  TextSpan(
                    text: '*',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: ' (max 25 character)',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              maxLength: 25,
              decoration: InputDecoration(
                hintText: 'Enter your Channel Name',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
                counterText: '',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: _buildTextFieldBorder(),
                enabledBorder: _buildTextFieldBorder(),
                focusedBorder: _buildTextFieldBorder(isFocused: true),
              ),
            ),
            const SizedBox(height: 20),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(text: 'Channel Description'),
                  TextSpan(
                    text: '*',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: ' (max 700 character)',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLength: 700,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: 'Enter your Channel Description',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
                counterText: '',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: _buildTextFieldBorder(),
                enabledBorder: _buildTextFieldBorder(),
                focusedBorder: _buildTextFieldBorder(isFocused: true),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isButtonEnabled ? _createChannel : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A3F8F),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      const Color(0xFF4A3F8F).withAlpha((255 * 0.5).round()),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Create',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPfp() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: ClipOval(
        child: _pickedFile == null
            ? const Center(
                child: Text(
                  'Your\nChannel\nPFP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    height: 1.2,
                  ),
                ),
              )
            : (kIsWeb
                ? Image.network(
                    _pickedFile!.path,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(_pickedFile!.path),
                    fit: BoxFit.cover,
                  )),
      ),
    );
  }

  OutlineInputBorder _buildTextFieldBorder({bool isFocused = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: isFocused ? const Color(0xFF4A3F8F) : const Color(0xFFD9D9D9),
        width: 1,
      ),
    );
  }
}
