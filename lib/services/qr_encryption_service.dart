import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class QREncryptionService {
  static Map<String, Object?> decryptData(String encryptedText) {
    try {
      // Clean up the encrypted text (remove quotes and spaces if present)
      final data = encryptedText.trim().replaceAll('"', '').replaceAll(' ', '');

      // Prepare the key - ensure it's exactly 32 bytes (256 bits)
      final key = _prepareKey(dotenv.env['QR_ENCRYPTION_SECRET_KEY'] ?? '');

      // Create a fixed IV of 16 zeros to match the C# implementation
      final iv = IV(Uint8List(16));

      // Create an encrypter with the key
      final encrypter = Encrypter(AES(
        key,
        mode: AESMode.cbc,
        padding: 'PKCS7',
      ));

      // Decrypt the data
      final encrypted = Encrypted.fromBase64(data);
      final decrypted = encrypter.decrypt(encrypted, iv: iv);
      return json.decode(decrypted);
    } catch (e) {
      return {"response": 'Error decrypting: $e'};
    }
  }

  static String encryptData(String data) {
    // Prepare the key - ensure it's exactly 32 bytes (256 bits)
    final key = _prepareKey(dotenv.env['QR_ENCRYPTION_SECRET_KEY'] ?? '');

    // Create a fixed IV of 16 zeros to match the C# implementation
    final iv = IV(Uint8List(16));

    // Create an encrypter with the key
    final encrypter = Encrypter(AES(
      key,
      mode: AESMode.cbc,
      padding: 'PKCS7',
    ));

    // Encrypt the data
    final encrypted = encrypter.encrypt(data, iv: iv);

    // Return the base64 encoded encrypted data
    return encrypted.base64;
  }

  // Helper method to ensure the key is exactly 32 bytes
  static Key _prepareKey(String secretKey) {
    // If the key is shorter than 32 bytes, pad it
    // If it's longer, hash it to get exactly 32 bytes
    if (secretKey.length == 32) {
      return Key(Uint8List.fromList(utf8.encode(secretKey)));
    } else if (secretKey.length < 32) {
      // Pad the key with zeros to make it 32 bytes
      String paddedKey = secretKey.padRight(32, '0');
      return Key(Uint8List.fromList(utf8.encode(paddedKey.substring(0, 32))));
    } else {
      // Hash the key to get exactly 32 bytes
      final keyBytes = utf8.encode(secretKey);
      final digest = sha256.convert(keyBytes);
      return Key(Uint8List.fromList(digest.bytes));
    }
  }
}
