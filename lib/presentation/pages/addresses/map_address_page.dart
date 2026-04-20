import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../viewmodels/addresses/map_address_viewmodel.dart';
import 'map_confirmation_page.dart';

class MapAddressPage extends StatefulWidget {
  const MapAddressPage({super.key});

  @override
  State<MapAddressPage> createState() => _MapAddressPageState();
}

class _MapAddressPageState extends State<MapAddressPage> {
  final MapAddressViewModel vm = MapAddressViewModel();
  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;
  LatLng _currentLocation = const LatLng(10.9639, -74.7964); // Default: Santa Marta, Colombia
  Set<Marker> _markers = {};
  bool _isLoadingLocation = true;
  bool _hasMapError = false;

  @override
  void initState() {
    super.initState();
    vm.addListener(_onVm);
    _searchController.addListener(() => vm.filter(_searchController.text));
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      // Request location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, use default location
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 10),
        );
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          _updateMarkers();
          _isLoadingLocation = false;
        });
        // Move camera to current location
        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: _currentLocation, zoom: 15),
          ),
        );
      } else {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      print('Error getting location: $e');
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  void _updateMarkers() {
    _markers = {
      Marker(
        markerId: const MarkerId('current_location'),
        position: _currentLocation,
        infoWindow: const InfoWindow(title: 'Mi ubicación actual'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    };
  }

  void _onVm() => setState(() {});

  @override
  void dispose() {
    vm.removeListener(_onVm);
    _searchController.dispose();
    _mapController?.dispose();
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Agregar una dirección', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
      centerTitle: true,
      leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
      backgroundColor: Colors.white,
      elevation: 1,
      actions: [
        if (vm.selected.isNotEmpty)
          IconButton(icon: const Icon(Icons.check, color: Color(0xFF4B2AAD)), onPressed: _openConfirmation),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildMapSection(),
        _buildSearchBar(),
        if (vm.selected.isNotEmpty) _buildSelectionIndicator(),
        Expanded(child: _buildStreetList()),
      ],
    );
  }

  Widget _buildMapSection() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Stack(
        children: [
          if (_isLoadingLocation)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Color(0xFF4B2AAD)),
                  const SizedBox(height: 16),
                  const Text('Cargando ubicación...', style: TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
            )
          else if (_hasMapError)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.amber.shade700),
                  const SizedBox(height: 16),
                  Text(
                    'Google Maps no está disponible',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Usa la opción manual para agregar tu dirección',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text('Volver'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B2AAD),
                    ),
                  ),
                ],
              ),
            )
          else ...[
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLocation,
                zoom: 15,
              ),
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              compassEnabled: true,
              mapToolbarEnabled: true,
              zoomControlsEnabled: true,
              style: _getMapStyle(),
              onCameraMove: (CameraPosition position) {
                _currentLocation = position.target;
                _markers = {
                  Marker(
                    markerId: const MarkerId('selected'),
                    position: _currentLocation,
                  ),
                };
                setState(() {});
              },
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                margin: const EdgeInsets.symmetric(horizontal: 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.06), blurRadius: 6, offset: Offset(0, 2)),
                  ],
                ),
                child: const Text(
                  'Tu ubicación se muestra en azul',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getMapStyle() {
    return '[{"elementType":"geometry","stylers":[{"color":"#f5f5f5"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#f5f5f5"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},{"featureType":"road.arterial","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#dadada"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#c9c9c9"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]}]';
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.06), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(hintText: 'Buscar calle...', border: InputBorder.none, hintStyle: TextStyle(color: Colors.grey)),
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
              if (_searchController.text.isNotEmpty)
                IconButton(icon: const Icon(Icons.clear, size: 20), onPressed: () {
                  _searchController.clear();
                }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color.fromRGBO(245, 166, 35, 0.1),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF4B2AAD), size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text('Seleccionado: ${vm.selected}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade800))),
          TextButton(
            onPressed: () {
              vm.select('');
            },
            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            child: const Text('Cambiar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF4B2AAD))),
          ),
        ],
      ),
    );
  }

  Widget _buildStreetList() {
    return ListView.builder(
      itemCount: vm.filtered.length,
      itemBuilder: (context, index) {
        final street = vm.filtered[index];
        final isSelected = street == vm.selected;
        return Material(
          color: isSelected ? Color.fromRGBO(245, 166, 35, 0.1) : Colors.white,
          child: InkWell(
            onTap: () => vm.select(street),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 0.5))),
              child: Row(
                children: [
                  Icon(Icons.place_outlined, color: isSelected ? const Color(0xFF4B2AAD) : Colors.grey.shade600, size: 20),
                  const SizedBox(width: 16),
                  Expanded(child: Text(street, style: TextStyle(fontSize: 16, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal, color: isSelected ? const Color(0xFF4B2AAD) : Colors.black87))),
                  if (isSelected) const Icon(Icons.check, color: Color(0xFF4B2AAD), size: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openConfirmation() async {
    if (vm.selected.isEmpty) return;
    final result = await Navigator.of(context).push<String?>(MaterialPageRoute(builder: (_) => MapConfirmationPage(initialAddress: vm.selected)));
    if (result != null && result.isNotEmpty) {
      if (!mounted) return;
      Navigator.pop(context, result);
    }
  }
}
