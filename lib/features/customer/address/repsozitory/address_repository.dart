// lib/features/address/repository/address_repository.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../config/api/api_end_point.dart';
import '../../../../services/api/api_service.dart';
import '../data/address_model.dart';

class AddressRepository {
  // ── Address CRUD ─────────────────────────────────────────

  static Future<AddressListResponse?> getAddresses({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await ApiService.get(
      "${ApiEndPoint.address}?page=$page&limit=$limit",
    );
    if (response.statusCode == 200) {
      return AddressListResponse.fromJson(response.data);
    }
    return null;
  }

  static Future<AddressModel?> createAddress(Map<String, dynamic> body) async {
    final response = await ApiService.post(ApiEndPoint.address, body: body);
    if ((response.statusCode == 200 || response.statusCode == 201)) {
      return AddressModel.fromJson(response.data['data']);
    }
    return null;
  }

  static Future<AddressModel?> getAddressById(String id) async {
    final response = await ApiService.get("${ApiEndPoint.address}/$id");
    if (response.statusCode == 200) {
      return AddressModel.fromJson(response.data['data']);
    }
    return null;
  }

  /// PUT update address by ID
  static Future<AddressModel?> updateAddress(
      String id, Map<String, dynamic> body) async {
    final response =
    await ApiService.patch("${ApiEndPoint.address}/$id", body: body);
    if (response.statusCode == 200) {
      return AddressModel.fromJson(response.data['data']);
    }
    return null;
  }

  static Future<bool> deleteAddress(String id) async {
    final response = await ApiService.delete("${ApiEndPoint.address}/$id");
    return response.statusCode == 200;
  }

  // ── Google Places Autocomplete ───────────────────────────

  /// Returns list of suggestions with keys: place_id, description,
  /// main_text, secondary_text
  static Future<List<Map<String, dynamic>>> getPlaceSuggestions(
      String query) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json"
        "?input=${Uri.encodeComponent(query)}"
        "&key=${ApiEndPoint.googleMapsApiKey}";

    final response = await ApiService.get(url);
    if (response.statusCode == 200) {
      final predictions = response.data['predictions'] as List? ?? [];
      return predictions.map<Map<String, dynamic>>((p) {
        final structured = p['structured_formatting'] ?? {};
        return {
          'place_id': p['place_id'] ?? '',
          'description': p['description'] ?? '',
          'main_text': structured['main_text'] ?? '',
          'secondary_text': structured['secondary_text'] ?? '',
        };
      }).toList();
    }
    return [];
  }

  /// Returns lat, lng, and a formatted details string from a place_id
  static Future<Map<String, dynamic>?> getPlaceDetail(String placeId) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/details/json"
        "?place_id=$placeId"
        "&fields=geometry,address_components,formatted_address"
        "&key=${ApiEndPoint.googleMapsApiKey}";

    final response = await ApiService.get(url);
    if (response.statusCode == 200) {
      final result = response.data['result'];
      if (result == null) return null;

      final loc = result['geometry']?['location'];
      final components = result['address_components'] as List? ?? [];

      // Build a details string: road + sublocality + city + country
      String details = _buildDetailsFromComponents(components);

      return {
        'lat': (loc?['lat'] ?? 0).toDouble(),
        'lng': (loc?['lng'] ?? 0).toDouble(),
        'details': details,
      };
    }
    return null;
  }

  static String _buildDetailsFromComponents(List components) {
    String road = '';
    String sub = '';
    String city = '';
    String country = '';

    for (final c in components) {
      final types = List<String>.from(c['types'] ?? []);
      final name = c['long_name'] ?? '';
      if (types.contains('route')) road = name;
      if (types.contains('sublocality_level_1') ||
          types.contains('sublocality')) {
        sub = name;
      }
      if (types.contains('locality')) city = name;
      if (types.contains('country')) country = name;
    }

    return [road, sub, city, country]
        .where((e) => e.isNotEmpty)
        .join(', ');
  }

  // ══════════════════════════════════════════════════════════
  //  REVERSE GEOCODING (Lat/Lng → Address)
  // ══════════════════════════════════════════════════════════

  /// Fetch address details from latitude and longitude (reverse geocoding).
  /// Uses the SAME _buildDetailsFromComponents as getPlaceDetail so the
  /// address field and details field are built identically to suggestion picks.
  ///
  /// Returns:
  ///   - address : area name  — sublocality + city  (fills the Address field)
  ///   - details : road + sublocality + city + country (fills Details Address)
  ///   - lat     : provided latitude
  ///   - lng     : provided longitude
  static Future<Map<String, dynamic>?> getPlaceDetailFromCoordinates(
      double latitude, double longitude) async {
    try {
      final String url =
          'https://maps.googleapis.com/maps/api/geocode/json'
          '?latlng=$latitude,$longitude'
          '&key=${ApiEndPoint.googleMapsApiKey}';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final results = json['results'] as List?;

        if (results != null && results.isNotEmpty) {
          // Use the first result's address_components — same source as
          // getPlaceDetail — so we can reuse _buildDetailsFromComponents.
          final firstResult = results[0] as Map<String, dynamic>;
          final List components =
              firstResult['address_components'] as List? ?? [];

          // ── address field ──────────────────────────────────────────
          // Build a short human-readable area label: sublocality + city
          // This mirrors what the user sees as "main_text" in suggestions.
          String sub = '';
          String city = '';
          for (final c in components) {
            final types = List<String>.from(c['types'] ?? []);
            final name = (c['long_name'] ?? '') as String;
            if (types.contains('sublocality_level_1') ||
                types.contains('sublocality')) {
              sub = name;
            }
            if (types.contains('locality')) city = name;
          }
          final String address =
          [sub, city].where((e) => e.isNotEmpty).join(', ');

          // ── details field ──────────────────────────────────────────
          // Reuse the exact same helper as getPlaceDetail:
          // road + sublocality + city + country
          final String details = _buildDetailsFromComponents(components);

          return {
            'address': address.isNotEmpty
                ? address
                : firstResult['formatted_address'] ?? '',
            'details': details,
            'lat': latitude,
            'lng': longitude,
          };
        }
      }
      return null;
    } catch (e) {
      print('Error fetching place detail from coordinates: $e');
      return null;
    }
  }
}