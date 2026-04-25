import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:new_untitled/component/button/common_button.dart';

import '../../../../../component/text/common_text.dart';
import '../../../../common/auth/signup_chef/presentation/controller/sign_up_chef_controller.dart';

class ChefUpdateLocationScreen extends StatefulWidget {
  const ChefUpdateLocationScreen({super.key});

  @override
  State<ChefUpdateLocationScreen> createState() =>
      _ChefUpdateLocationScreenState();
}

class _ChefUpdateLocationScreenState extends State<ChefUpdateLocationScreen> {

  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;
  Timer? _debounce;
  bool _isSubmitting = false;


  String? _selectedAddress;
  LatLng? _selectedLatLng;
  double _distanceKm = 10;
  bool _showMap = false;
  bool _isSearching = false;
  bool _isLoadingLocation = false;
  bool _isSelecting = false;
  List<Map<String, String>> _suggestions = [];

  static const String _apiKey = 'AIzaSyCVoe2GBYsk1jU6E9RFIxhVfsyBCSkMX_w';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {

    if (_isSelecting) return;

    final query = _searchController.text.trim();


    if (query.isEmpty) {
      _debounce?.cancel();
      setState(() {
        _suggestions = [];
        _showMap = false;
        _selectedAddress = null;
        _isSearching = false;
      });
      return;
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _fetchSuggestions(query);
    });
  }

  Future<void> _fetchSuggestions(String query) async {
    if (!mounted) return;
    setState(() => _isSearching = true);

    try {
      final uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json'
            '?input=${Uri.encodeComponent(query)}'
            '&key=$_apiKey',
      );

      final res = await http.get(uri).timeout(const Duration(seconds: 8));
      if (!mounted) return;

      final data = json.decode(res.body);

      if (data['status'] == 'OK') {
        final predictions = data['predictions'] as List;
        setState(() {
          _suggestions = predictions.map<Map<String, String>>((p) {
            final terms = p['terms'] as List? ?? [];
            final title = terms.isNotEmpty
                ? terms[0]['value'].toString()
                : p['description'].toString();
            return {
              'title': title,
              'sub': p['description'].toString(),
              'placeId': p['place_id'].toString(),
            };
          }).toList();
          _showMap = false;
        });
      } else {
        setState(() => _suggestions = []);
      }
    } catch (_) {
      if (mounted) setState(() => _suggestions = []);
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  Future<void> _selectAddress(Map<String, String> item) async {
    _isSelecting = true;
    _debounce?.cancel();

    FocusScope.of(context).unfocus();

    setState(() {
      _selectedAddress = item['sub'];
      _searchController.text = item['sub']!;
      _suggestions = [];
      _isLoadingLocation = true;
      _showMap = false;
    });

    try {
      final uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json'
            "?place_id=${item['placeId']}"
            '&fields=geometry'
            '&key=$_apiKey',
      );

      final res = await http.get(uri).timeout(const Duration(seconds: 8));
      if (!mounted) return;

      final data = json.decode(res.body);

      if (data['status'] == 'OK') {
        final loc = data['result']['geometry']['location'];
        final lat = (loc['lat'] as num).toDouble();
        final lng = (loc['lng'] as num).toDouble();
        final latlng = LatLng(lat, lng);

        setState(() {
          _selectedLatLng = latlng;
          _showMap = true;
        });

        await Future.delayed(const Duration(milliseconds: 400));
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(latlng, _getZoomLevel(_distanceKm)),
        );
      } else {
        _showError('Location not found. Please try again.');
      }
    } on TimeoutException {
      _showError('Request timed out. Check internet.');
    } catch (_) {
      _showError('Something went wrong. Try again.');
    } finally {
      if (mounted) {
        setState(() => _isLoadingLocation = false);
        _isSelecting = false;
      }
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  Set<Circle> _buildCircles() {
    if (_selectedLatLng == null) return {};
    return {
      Circle(
        circleId: const CircleId('cooking_area'),
        center: _selectedLatLng!,
        radius: _distanceKm * 1000,
        fillColor: Colors.orange.withOpacity(0.15),
        strokeColor: Colors.orange.withOpacity(0.5),
        strokeWidth: 2,
      ),
    };
  }

  Set<Marker> _buildMarkers() {
    if (_selectedLatLng == null) return {};
    return {
      Marker(
        markerId: const MarkerId('selected'),
        position: _selectedLatLng!,
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange),
      ),
    };
  }

  double _getZoomLevel(double km) {
    if (km <= 5) return 12;
    if (km <= 15) return 10;
    if (km <= 30) return 9;
    if (km <= 60) return 8;
    return 7;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 60,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const CommonText(
                      text: 'Set Your Cooking Area',
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF272727),
                      textAlign: TextAlign.start,
                      maxLines: 2,
                    ),
                    8.verticalSpace,
                    const CommonText(
                      text: 'Where can you travel to for chef visits to customers? Set your cooking area so that we can help your future customers find you best!',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF777777),
                      textAlign: TextAlign.start,
                      maxLines: 5,
                      overflow: TextOverflow.visible,
                    ),
                    20.verticalSpace,

                    // Search Field (TextField এ CommonText use হয় না)
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF272727),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search address...',
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFFBBBBBB),
                          ),
                          prefixIcon: Icon(Icons.search,
                              color: const Color(0xFF777777), size: 20.sp),
                          suffixIcon: _isSearching
                              ? Padding(
                            padding: EdgeInsets.all(14.w),
                            child: SizedBox(
                              width: 16.w,
                              height: 16.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF777777),
                              ),
                            ),
                          )
                              : _searchController.text.isNotEmpty
                              ? IconButton(
                            icon: Icon(Icons.clear,
                                color: const Color(0xFF777777),
                                size: 18.sp),
                            onPressed: () {
                              _isSelecting = false;
                              _searchController.clear();
                              setState(() {
                                _suggestions = [];
                                _showMap = false;
                                _selectedAddress = null;
                                _selectedLatLng = null;
                              });
                            },
                          )
                              : Icon(Icons.map_outlined,
                              color: const Color(0xFF777777), size: 20.sp),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                      ),
                    ),
                    12.verticalSpace,

                    // Suggestions
                    if (_suggestions.isNotEmpty) ...[
                      const CommonText(
                        text: 'SUGGESTED ADDRESS',
                        fontSize: 11,
                        color: Color(0xFF777777),
                        textAlign: TextAlign.start,
                      ),
                      12.verticalSpace,
                      ..._suggestions.map(
                            (item) => _SuggestionTile(
                          item: item,
                          onTap: () => _selectAddress(item),
                        ),
                      ),
                    ],

                    if (_isLoadingLocation)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.h),
                          child: const CircularProgressIndicator(
                            color: Color(0xFF1C1C1C),
                            strokeWidth: 2,
                          ),
                        ),
                      ),

                    if (_showMap && _selectedLatLng != null) ...[
                      const CommonText(
                        text: 'Order Area Distance',
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF272727),
                        textAlign: TextAlign.start,
                      ),
                      12.verticalSpace,

                      // Distance display
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F7F7),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                        child: Row(
                          children: [
                            CommonText(
                              text: '${_distanceKm.toInt()}',
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF272727),
                              textAlign: TextAlign.start,
                            ),
                            const Spacer(),
                            const CommonText(
                              text: 'Distance',
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF777777),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      4.verticalSpace,

                      // Slider same থাকবে
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: const Color(0xFF1C1C1C),
                          inactiveTrackColor: const Color(0xFFE0E0E0),
                          thumbColor: const Color(0xFF1C1C1C),
                          overlayColor: Colors.black12,
                          trackHeight: 3,
                        ),
                        child: Slider(
                          value: _distanceKm,
                          min: 1,
                          max: 100,
                          onChanged: (val) {
                            setState(() => _distanceKm = val);
                            _mapController?.animateCamera(
                              CameraUpdate.newLatLngZoom(
                                _selectedLatLng!,
                                _getZoomLevel(val),
                              ),
                            );
                          },
                        ),
                      ),
                      12.verticalSpace,

                      // Google Map same থাকবে
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: SizedBox(
                          height: 220.h,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: _selectedLatLng!,
                              zoom: _getZoomLevel(_distanceKm),
                            ),
                            onMapCreated: (controller) {
                              _mapController = controller;
                            },
                            circles: _buildCircles(),
                            markers: _buildMarkers(),
                            zoomControlsEnabled: false,
                            myLocationButtonEnabled: false,
                          ),
                        ),
                      ),
                      24.verticalSpace,
                    ],
                  ],
                ),
              ),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
              child: CommonButton(
                titleText: 'Update Location',
                isLoading: _isSubmitting,
                buttonColor: const Color(0xFF1C1C1C),
                buttonRadius: 14,
                buttonHeight: 54,
                onTap: () async {
                  if (_selectedAddress == null || _selectedLatLng == null) {
                    Get.snackbar(
                      'Message',
                      'Please select an address first.',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  setState(() => _isSubmitting = true);
                  try {
                    final controller = SignUpChefController.instance;
                    await controller.ChefProfileLocationUpdate(
                      cookingAreaDistance: _distanceKm.toInt().toString(),
                      address: _selectedAddress!,
                      lat: _selectedLatLng!.latitude.toString(),
                      lng: _selectedLatLng!.longitude.toString(),
                    );
                  } finally {
                    if (mounted) setState(() => _isSubmitting = false);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  final Map<String, String> item;
  final VoidCallback onTap;

  const _SuggestionTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.location_on_outlined,
              color: const Color(0xFFFF6B35),
              size: 20.sp,
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title']!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF272727),
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    item['sub']!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF777777),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}