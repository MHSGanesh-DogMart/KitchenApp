import 'dart:io';

import '../core/config/api_endpoints.dart';
import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../core/services/toast_service.dart';
import '../core/utils/logger.dart';
import '../models/menu_item.dart';

/// Handles all menu (dish) operations for the authenticated kitchen.
/// Talks to /api/kitchen/menu — list, add, edit, delete, on/off.
class MenuApiController {
  MenuApiController._();
  static final MenuApiController instance = MenuApiController._();

  /// GET all menu items for the logged-in kitchen.
  Future<List<MenuItem>> fetchMenus() async {
    try {
      final res = await ApiClient.instance.get(ApiEndpoints.menu);
      if (res.statusCode == 200 && res.data != null) {
        final list = (res.data['data'] as List?) ?? [];
        return list
            .map((e) => MenuItem.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
    } on ApiException catch (e) {
      ToastService.error(e.message);
    } catch (e) {
      AppLogger.e('fetchMenus failed: $e');
    }
    return [];
  }

  /// POST a new menu item.
  Future<MenuItem?> addMenu(Map<String, dynamic> body) async {
    return _writeMenu(
      () => ApiClient.instance.post(ApiEndpoints.menu, body: body),
      fallbackError: 'Failed to add dish',
    );
  }

  /// PUT — edit an existing menu item.
  Future<MenuItem?> updateMenu(String id, Map<String, dynamic> body) async {
    return _writeMenu(
      () => ApiClient.instance.put(ApiEndpoints.menuById(id), body: body),
      fallbackError: 'Failed to update dish',
    );
  }

  /// PATCH availability — turn a dish on/off. Returns true on success.
  Future<bool> setAvailability(String id, bool isAvailable) async {
    try {
      final res = await ApiClient.instance.patch(
        ApiEndpoints.menuAvailability(id),
        body: {'isAvailable': isAvailable},
      );
      if (res.statusCode == 200 && res.data?['success'] == true) {
        // Dynamic toast straight from the server message.
        final msg = res.data?['message']?.toString();
        if (msg != null && msg.isNotEmpty) ToastService.success(msg);
        return true;
      }
    } on ApiException catch (e) {
      ToastService.error(e.message);
    } catch (e) {
      AppLogger.e('setAvailability failed: $e');
    }
    return false;
  }

  /// DELETE a menu item by id. Returns true on success.
  Future<bool> deleteMenu(String id) async {
    try {
      final res = await ApiClient.instance.delete(ApiEndpoints.menuById(id));
      if (res.statusCode == 200 && res.data?['success'] == true) {
        ToastService.success(res.data['message']?.toString() ?? 'Dish deleted');
        return true;
      }
      ToastService.error(res.data?['message']?.toString() ?? 'Failed to delete');
    } on ApiException catch (e) {
      ToastService.error(e.message);
    } catch (e) {
      AppLogger.e('deleteMenu failed: $e');
      ToastService.error('Failed to delete dish');
    }
    return false;
  }

  /// Upload a dish photo → returns the hosted image URL (or null).
  Future<String?> uploadImage(File file) async {
    try {
      final result = await ApiClient.instance.uploadImage(
        path: ApiEndpoints.upload,
        file: file,
        folder: 'menu',
        fieldName: 'image',
      );
      return result?['fileUrl'];
    } on ApiException catch (e) {
      ToastService.error(e.message);
    } catch (e) {
      AppLogger.e('uploadImage failed: $e');
      ToastService.error('Image upload failed');
    }
    return null;
  }

  // ── shared create/update handler ──
  Future<MenuItem?> _writeMenu(
    Future Function() request, {
    required String fallbackError,
  }) async {
    try {
      final res = await request();
      final ok = res.statusCode == 200 || res.statusCode == 201;
      if (ok && res.data?['success'] == true && res.data?['data'] != null) {
        ToastService.success(res.data['message']?.toString() ?? 'Saved');
        return MenuItem.fromJson(Map<String, dynamic>.from(res.data['data']));
      }
      ToastService.error(res.data?['message']?.toString() ?? fallbackError);
    } on ApiException catch (e) {
      ToastService.error(e.message);
    } catch (e) {
      AppLogger.e('$fallbackError: $e');
      ToastService.error(fallbackError);
    }
    return null;
  }
}
