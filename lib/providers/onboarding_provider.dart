import 'dart:io';
import 'package:flutter/foundation.dart';
import '../core/config/api_endpoints.dart';
import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../core/services/toast_service.dart';
import '../core/utils/logger.dart';
import '../core/notifications/notification_service.dart';
import 'auth_provider.dart';

class OnboardingProvider extends ChangeNotifier {
  // --- Onboarding Registration State ---
  String _phone = '';
  int _tier = 1;

  // Step 2: Identity & KYC
  String _selfieUrl = '';
  String _name = '';
  String _dob = '';
  String _whatsapp = '';
  String _altContact = '';
  String _aadhaarNo = '';
  String _aadhaarUrl = '';
  String _panNo = '';
  String _panUrl = '';

  // Step 3: Kitchen & Safety
  String _cookingUrl = '';
  String _storageUrl = '';
  String _sinkUrl = '';
  double _lat = 17.4451;
  double _lng = 78.3502;
  bool _isVegOnly = false;
  String _address = '';

  // Step 3b: FSSAI Assist
  bool _hasExistingFssai = false;
  String _fssaiNumber = '';
  String _fssaiExpiry = '';

  // Step 5: Operations & Consents
  bool _mealBreakfast = false;
  bool _mealLunch = true;
  bool _mealDinner = true;
  int _capacity = 0;
  String _cutoffNotice = '2 hours';
  Set<String> _offDays = {};
  String _packagingType = 'Eco-friendly box';
  String _deliveryMode = 'Platform delivery';

  bool _consentHygiene = false;
  bool _consentTnC = false;
  bool _consentPhotos = false;

  bool _submitting = false;

  // --- Getters ---
  String get phone => _phone;
  int get tier => _tier;
  String get selfieUrl => _selfieUrl;
  String get name => _name;
  String get dob => _dob;
  String get whatsapp => _whatsapp;
  String get altContact => _altContact;
  String get aadhaarNo => _aadhaarNo;
  String get aadhaarUrl => _aadhaarUrl;
  String get panNo => _panNo;
  String get panUrl => _panUrl;
  String get cookingUrl => _cookingUrl;
  String get storageUrl => _storageUrl;
  String get sinkUrl => _sinkUrl;
  double get lat => _lat;
  double get lng => _lng;
  bool get isVegOnly => _isVegOnly;
  String get address => _address;
  bool get hasExistingFssai => _hasExistingFssai;
  String get fssaiNumber => _fssaiNumber;
  String get fssaiExpiry => _fssaiExpiry;
  bool get mealBreakfast => _mealBreakfast;
  bool get mealLunch => _mealLunch;
  bool get mealDinner => _mealDinner;
  int get capacity => _capacity;
  String get cutoffNotice => _cutoffNotice;
  Set<String> get offDays => _offDays;
  String get packagingType => _packagingType;
  String get deliveryMode => _deliveryMode;
  bool get consentHygiene => _consentHygiene;
  bool get consentTnC => _consentTnC;
  bool get consentPhotos => _consentPhotos;
  bool get submitting => _submitting;

  // --- Setters / Modifiers ---
  void setPhone(String p) {
    _phone = p;
    final cleaned = p.replaceFirst('+91', '').replaceAll(' ', '').trim();
    if (cleaned.length == 10) {
      _whatsapp = cleaned;
    }
    notifyListeners();
  }

  void setTier(int t) {
    _tier = t;
    notifyListeners();
  }

  void updateField({
    String? name,
    String? dob,
    String? whatsapp,
    String? altContact,
    String? aadhaarNo,
    String? panNo,
    bool? isVegOnly,
    bool? hasExistingFssai,
    String? fssaiNumber,
    String? fssaiExpiry,
    double? lat,
    double? lng,
    bool? mealBreakfast,
    bool? mealLunch,
    bool? mealDinner,
    int? capacity,
    String? cutoffNotice,
    Set<String>? offDays,
    String? packagingType,
    String? deliveryMode,
    bool? consentHygiene,
    bool? consentTnC,
    bool? consentPhotos,
    String? address,
  }) {
    if (name != null) _name = name;
    if (dob != null) _dob = dob;
    if (whatsapp != null) _whatsapp = whatsapp;
    if (altContact != null) _altContact = altContact;
    if (aadhaarNo != null) _aadhaarNo = aadhaarNo;
    if (panNo != null) _panNo = panNo;
    if (isVegOnly != null) _isVegOnly = isVegOnly;
    if (hasExistingFssai != null) _hasExistingFssai = hasExistingFssai;
    if (fssaiNumber != null) _fssaiNumber = fssaiNumber;
    if (fssaiExpiry != null) _fssaiExpiry = fssaiExpiry;
    if (lat != null) _lat = lat;
    if (lng != null) _lng = lng;
    if (address != null) _address = address;
    if (mealBreakfast != null) _mealBreakfast = mealBreakfast;
    if (mealLunch != null) _mealLunch = mealLunch;
    if (mealDinner != null) _mealDinner = mealDinner;
    if (capacity != null) _capacity = capacity;
    if (cutoffNotice != null) _cutoffNotice = cutoffNotice;
    if (offDays != null) _offDays = offDays;
    if (packagingType != null) _packagingType = packagingType;
    if (deliveryMode != null) _deliveryMode = deliveryMode;
    if (consentHygiene != null) _consentHygiene = consentHygiene;
    if (consentTnC != null) _consentTnC = consentTnC;
    if (consentPhotos != null) _consentPhotos = consentPhotos;
    notifyListeners();
  }

  // --- Document Upload ---
  Future<bool> uploadDocument(String docType, File file) async {
    try {
      AppLogger.i('Uploading $docType document...');
      final cleanPhone = _phone.replaceAll('+', '').replaceAll(' ', '').trim();
      final folderPath = cleanPhone.isNotEmpty ? 'kitchens/$cleanPhone' : 'kitchens/temp_onboarding';
      final response = await ApiClient.instance.uploadImage(
        path: ApiEndpoints.upload,
        file: file,
        folder: folderPath,
      );

      if (response != null && response['fileUrl'] != null) {
        final url = response['fileUrl']!;
        AppLogger.i('Successfully uploaded $docType. URL: $url');
        
        switch (docType) {
          case 'selfie':
            _selfieUrl = url;
            break;
          case 'aadhaar':
            _aadhaarUrl = url;
            break;
          case 'pan':
            _panUrl = url;
            break;
          case 'cooking':
            _cookingUrl = url;
            break;
          case 'storage':
            _storageUrl = url;
            break;
          case 'sink':
            _sinkUrl = url;
            break;
          default:
            break;
        }
        notifyListeners();
        return true;
      }
      return false;
    } on ApiException catch (e) {
      AppLogger.w('ApiException uploading $docType document: ${e.message}');
      ToastService.error(e.message);
      return false;
    } catch (e) {
      AppLogger.e('Unknown error uploading $docType: $e');
      ToastService.error('Failed to upload image. Please try again.');
      return false;
    }
  }

  // --- Submit Onboarding API ---
  Future<String?> submit(AuthProvider auth) async {
    _submitting = true;
    notifyListeners();

    try {
      final fcmToken = NotificationService.instance.token;
      final payload = {
        'name': _name,
        'phone': _phone,
        'tier': _tier,
        'dob': _dob,
        'whatsapp': _whatsapp,
        'altContact': _altContact,
        'aadhaarNo': _aadhaarNo,
        'panNo': _panNo,
        'isVegOnly': _isVegOnly,
        'hasExistingFssai': _hasExistingFssai,
        'fssaiNumber': _fssaiNumber,
        'fssaiExpiry': _fssaiExpiry,
        'lat': _lat,
        'lng': _lng,
        'meals': {
          'breakfast': _mealBreakfast,
          'lunch': _mealLunch,
          'dinner': _mealDinner,
        },
        'capacity': _capacity,
        'cutoffNotice': _cutoffNotice,
        'weeklyOff': _offDays.toList(),
        'packagingType': _packagingType,
        'deliveryMode': _deliveryMode,
        'selfieUrl': _selfieUrl,
        'aadhaarUrl': _aadhaarUrl,
        'panUrl': _panUrl,
        'cookingUrl': _cookingUrl,
        'storageUrl': _storageUrl,
        'sinkUrl': _sinkUrl,
        'fcmToken': fcmToken,
        'address': _address,
      };

      AppLogger.i('Submitting cook onboarding registration...');
      final response = await ApiClient.instance.post(
        ApiEndpoints.submitOnboarding,
        body: payload,
      );

      if (response.statusCode == 200 && response.data != null) {
        final success = response.data['success'] as bool? ?? false;
        final message = response.data['message'] as String? ?? '';
        final responseData = response.data['data'];

        if (success && responseData != null) {
          final token = responseData['token'] as String?;
          final status = responseData['status'] as String? ?? 'Kitchen_Pending';
          if (token != null && token.isNotEmpty) {
            await auth.onLoginSuccess(token);
          }
          
          if (message.isNotEmpty) {
            ToastService.success(message);
          }
          _submitting = false;
          notifyListeners();
          return status;
        } else {
          if (message.isNotEmpty) {
            ToastService.error(message);
          }
        }
      }
      _submitting = false;
      notifyListeners();
      return null;
    } on ApiException catch (e) {
      AppLogger.w('ApiException submitting onboarding: ${e.message}');
      ToastService.error(e.message);
      _submitting = false;
      notifyListeners();
      return null;
    } catch (e) {
      AppLogger.e('Unknown error submitting onboarding: $e');
      ToastService.error(e.toString());
      _submitting = false;
      notifyListeners();
      return null;
    }
  }

  // --- Clear Document ---
  void clearDocument(String docType) {
    switch (docType) {
      case 'selfie':
        _selfieUrl = '';
        break;
      case 'aadhaar':
        _aadhaarUrl = '';
        break;
      case 'pan':
        _panUrl = '';
        break;
      case 'cooking':
        _cookingUrl = '';
        break;
      case 'storage':
        _storageUrl = '';
        break;
      case 'sink':
        _sinkUrl = '';
        break;
      default:
        break;
    }
    notifyListeners();
  }
}
