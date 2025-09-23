import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../providers/clothing_provider.dart';
import '../models/clothing.dart';
import '../models/clothing_category.dart';
import '../services/image_service.dart';

class AddClothingView extends HookConsumerWidget {
  const AddClothingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final selectedCategory = useState<ClothingCategory?>(null);
    final selectedImage = useState<File?>(null);
    final isLoading = useState(false);
    final clothingNotifier = ref.watch(clothingNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Clothing'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo section (1/3 equivalent height)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: double.infinity,
                    child: InkWell(
                      onTap: () => _pickImage(selectedImage),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: selectedImage.value != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  selectedImage.value!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_a_photo,
                                    size: 48,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tap to add photo',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Name input
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Clothing Name',
                      border: OutlineInputBorder(),
                      hintText: 'Enter clothing name',
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 24),
                  
                  // Category selection
                  Text(
                    'Category',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ClothingCategory.values.map((category) {
                      final isSelected = selectedCategory.value == category;
                      return FilterChip(
                        label: Text(category.displayName),
                        selected: isSelected,
                        onSelected: (selected) {
                          selectedCategory.value = selected ? category : null;
                        },
                        selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                        checkmarkColor: Theme.of(context).primaryColor,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          
          // Complete button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: isLoading.value ||
                          nameController.text.trim().isEmpty ||
                          selectedCategory.value == null
                      ? null
                      : () => _addClothing(
                            context,
                            clothingNotifier,
                            nameController.text.trim(),
                            selectedCategory.value!,
                            selectedImage.value,
                            isLoading,
                          ),
                  icon: isLoading.value
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check),
                  label: Text(isLoading.value ? 'Adding...' : 'Complete'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ValueNotifier<File?> selectedImage) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      // Handle error
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> _addClothing(
    BuildContext context,
    ClothingNotifier clothingNotifier,
    String name,
    ClothingCategory category,
    File? imageFile,
    ValueNotifier<bool> isLoading,
  ) async {
    isLoading.value = true;
    
    try {
      // Save image to app directory
      String? assetPath;
      
      if (imageFile != null) {
        assetPath = await ImageService.saveImage(imageFile);
      }
      
      final clothing = Clothing(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        assetPath: assetPath,
        category: category,
        createdAt: DateTime.now(),
      );
      
      await clothingNotifier.addClothing(clothing);
      
      if (context.mounted) {
        context.pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding clothing: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}