import 'package:image_picker/image_picker.dart';

Future<String> pickImage(ImageSource source) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: source);
  return pickedFile?.path ?? '';
}
