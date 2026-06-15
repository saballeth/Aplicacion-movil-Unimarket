import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/address_entity.dart';
import '../../../../domain/entities/order_entity.dart';
import '../../../../domain/entities/shipping_option_entity.dart';
import '../../../../domain/usecases/create_order_usecase.dart';
import '../../../../domain/usecases/get_addresses_usecase.dart';
import '../../../../domain/usecases/get_shipping_options_usecase.dart';
import '../../models/cart_item.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final GetAddressesUseCase getAddressesUseCase;
  final GetShippingOptionsUseCase getShippingOptionsUseCase;
  final CreateOrderUseCase createOrderUseCase;

  CheckoutCubit({
    required this.getAddressesUseCase,
    required this.getShippingOptionsUseCase,
    required this.createOrderUseCase,
  }) : super(CheckoutInitial());

  AddressEntity? _selectedAddress;
  ShippingOptionEntity? _selectedShipping;
  List<CartItem>? _cartItems;
  String? _userId;
  String? _storeId;
  String? _storeName;

  AddressEntity? get selectedAddress => _selectedAddress;
  ShippingOptionEntity? get selectedShipping => _selectedShipping;

  // Constantes para cálculos
  static const double TAX_RATE = 0.19; // IVA 19%

  /// Iniciar checkout desde el carrito
  Future<void> initCheckout({
    required String userId,
    required String storeId,
    required String storeName,
    required List<CartItem> cartItems,
  }) async {
    emit(CheckoutLoading());
    try {
      _userId = userId;
      _storeId = storeId;
      _storeName = storeName;
      _cartItems = cartItems;

      // Cargar direcciones disponibles
      final addresses = await getAddressesUseCase(userId);
      _selectedAddress = addresses.isNotEmpty
          ? addresses.firstWhere(
              (addr) => addr.isDefault,
              orElse: () => addresses.first,
            )
          : null;

      if (_selectedAddress == null) {
        emit(CheckoutError('No hay dirección de entrega disponible'));
        return;
      }

      emit(
        CheckoutStep1Addresses(
          addresses: addresses,
          selectedAddress: _selectedAddress,
        ),
      );
    } catch (e) {
      emit(CheckoutError('Error iniciando checkout: ${e.toString()}'));
    }
  }

  /// Avanzar a paso 2: Seleccionar envío
  Future<void> proceedToShipping() async {
    if (_selectedAddress == null || _cartItems == null) {
      emit(CheckoutError('Datos incompletos'));
      return;
    }

    emit(CheckoutLoading());
    try {
      final shippingOptions = await getShippingOptionsUseCase();
      _selectedShipping = shippingOptions.isNotEmpty
          ? shippingOptions.first
          : null;

      final subtotal = _cartItems!.fold(
        0.0,
        (sum, item) => sum + item.totalPrice,
      );

      emit(
        CheckoutStep2Shipping(
          address: _selectedAddress,
          shippingOptions: shippingOptions,
          selectedShipping: _selectedShipping,
          subtotal: subtotal,
        ),
      );
    } catch (e) {
      emit(CheckoutError('Error cargando opciones de envío: ${e.toString()}'));
    }
  }

  /// Cambiar dirección seleccionada
  void selectAddress(AddressEntity address) {
    _selectedAddress = address;
    if (state is CheckoutStep1Addresses) {
      final currentState = state as CheckoutStep1Addresses;
      emit(
        CheckoutStep1Addresses(
          addresses: currentState.addresses,
          selectedAddress: _selectedAddress,
        ),
      );
    }
  }

  /// Cambiar método de envío seleccionado
  void selectShipping(ShippingOptionEntity shipping) {
    _selectedShipping = shipping;
    if (state is CheckoutStep2Shipping) {
      final currentState = state as CheckoutStep2Shipping;
      emit(
        CheckoutStep2Shipping(
          address: currentState.address,
          shippingOptions: currentState.shippingOptions,
          selectedShipping: _selectedShipping,
          subtotal: currentState.subtotal,
        ),
      );
    }
  }

  /// Avanzar a paso 3: Revisión y pago
  void proceedToPayment() {
    if (_selectedAddress == null ||
        _selectedShipping == null ||
        _cartItems == null) {
      emit(CheckoutError('Datos incompletos'));
      return;
    }

    final subtotal = _cartItems!.fold(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );
    final shippingCost = _selectedShipping!.cost;
    final taxAmount = subtotal * TAX_RATE;
    final totalAmount = subtotal + shippingCost + taxAmount;

    emit(
      CheckoutStep3Payment(
        address: _selectedAddress,
        shippingOption: _selectedShipping,
        subtotal: subtotal,
        shippingCost: shippingCost,
        taxAmount: taxAmount,
        totalAmount: totalAmount,
      ),
    );
  }

  /// Procesar pago y crear orden
  Future<void> processPayment({
    required String paymentMethod,
    required Map<String, dynamic> paymentDetails,
  }) async {
    if (_selectedAddress == null ||
        _selectedShipping == null ||
        _cartItems == null ||
        _userId == null ||
        _storeId == null ||
        _storeName == null) {
      emit(CheckoutError('Datos incompletos'));
      return;
    }

    emit(CheckoutProcessing());

    try {
      final subtotal = _cartItems!.fold(
        0.0,
        (sum, item) => sum + item.totalPrice,
      );
      final shippingCost = _selectedShipping!.cost;
      final taxAmount = subtotal * TAX_RATE;
      final totalAmount = subtotal + shippingCost + taxAmount;

      // Convertir CartItems a OrderItems
      final orderItems = _cartItems!
          .map(
            (item) => OrderItemEntity(
              productId: item.product.id,
              productName: item.product.name,
              price: item.product.finalPrice,
              quantity: item.quantity,
              imageUrl: item.product.imageUrl,
            ),
          )
          .toList();

      // Crear la orden
      final order = OrderEntity(
        id: 'ORDER_${DateTime.now().millisecondsSinceEpoch}',
        userId: _userId!,
        storeId: _storeId!,
        storeName: _storeName!,
        items: orderItems,
        deliveryAddress: _selectedAddress!,
        shippingOption: _selectedShipping!,
        subtotal: subtotal,
        shippingCost: shippingCost,
        taxAmount: taxAmount,
        totalAmount: totalAmount,
        status: OrderStatus.pending,
        paymentMethod: paymentMethod,
        createdAt: DateTime.now(),
      );

      // Guardar la orden usando el use case
      final createdOrder = await createOrderUseCase(order);

      // TODO: Integrar con PaymentCubit aquí si es necesario
      // Por ahora simulamos que el pago fue exitoso

      emit(CheckoutSuccess(createdOrder));
    } catch (e) {
      emit(CheckoutError('Error procesando pago: ${e.toString()}'));
    }
  }

  /// Volver al paso anterior
  void goBackToAddresses() {
    if (state is CheckoutStep2Shipping || state is CheckoutStep3Payment) {
      if (_selectedAddress != null && _cartItems != null) {
        initCheckout(
          userId: _userId!,
          storeId: _storeId!,
          storeName: _storeName!,
          cartItems: _cartItems!,
        );
      }
    }
  }

  void goBackToShipping() {
    if (state is CheckoutStep3Payment && _cartItems != null) {
      proceedToShipping();
    }
  }

  // Mock data para desarrollo
  Future<void> loadMockCheckoutData(String userId) async {
    emit(CheckoutLoading());
    try {
      // Simular direcciones
      final addresses = [
        AddressEntity(
          id: '1',
          userId: userId,
          fullName: 'Juan Pérez',
          phone: '3001234567',
          street: 'Calle 45 #23-67',
          city: 'Bogotá',
          state: 'Cundinamarca',
          zipCode: '110111',
          country: 'Colombia',
          apartment: 'Apto 402',
          isDefault: true,
          createdAt: DateTime.now(),
        ),
      ];

      _selectedAddress = addresses[0];
      emit(
        CheckoutStep1Addresses(
          addresses: addresses,
          selectedAddress: _selectedAddress,
        ),
      );
    } catch (e) {
      emit(CheckoutError('Error: ${e.toString()}'));
    }
  }
}
