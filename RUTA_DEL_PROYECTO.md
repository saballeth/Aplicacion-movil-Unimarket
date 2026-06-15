# 📱 UNIMARKET - Análisis General del Proyecto

## Visión general

**UNIMARKET** es una aplicación móvil de marketplace universitario que conecta a estudiantes emprendedores (Entrepreneurs) con consumidores (Consumers) en un entorno controlado. La plataforma permite compra/venta de productos, gestión de pedidos, y búsqueda inteligente de productos mediante un motor de búsqueda tabú.

### Estado actual
- **Frontend**: 80% completo (Flutter, Material Design 3, BLoC architecture)
- **Backend**: 5% completo (Necesita implementación)
- **Motor de Búsqueda**: 0% (Pendiente de desarrollo)
- **Base de Datos**: 20% (Estructura definida, falta integración)

---

## Arquitectura del proyecto

```
UNIMARKET/
├── lib/                          # Código Flutter (Front-end)
│   ├── domain/                   # Entidades y casos de uso
│   ├── data/                     # Repositorios e implementaciones
│   ├── presentation/             # UI Pages y Cubits (State Management)
│   └── core/                     # Inyección de dependencias
├── backend/                      # (PENDIENTE) API REST/GraphQL
├── search_engine/                # (PENDIENTE) Motor de Búsqueda Tabú
└── database/                     # (PENDIENTE) Scripts y migraciones
```

### Tecnologías principales
- **Mobile**: Flutter + Dart
- **State Management**: BLoC (flutter_bloc)
- **Dependency Injection**: get_it
- **Local Storage**: SharedPreferences + SQLite
- **HTTP Client**: Dio
- **Backend**: (Pendiente definir: Node.js/Python/Golang)
- **Database**: (Pendiente definir: PostgreSQL/MySQL)

---

## Componentes implementados

### Funcionalidades completadas
1. **Autenticación** (Mock - sin backend)
   - Login/Registro de usuarios
   - Manejo de roles (Consumer, Entrepreneur, Admin)

2. **Catálogo de productos**
   - Visualización de productos
   - Filtrado por tienda/categoría
   - Vista de detalles de producto

3. **Carrito de compras**
   - Agregar/eliminar productos
   - Cálculo de totales

4. **Checkout (3 pasos)**
   - Selección de dirección
   - Selección de método de envío
   - Procesamiento de pago

5. **Gestión de ordenes**
   - Visualización de órdenes
   - Seguimiento de estado
   - Historial de compras

6. **Sistema de perfiles**
   - Gestión de dirección
   - Preferencias de usuario
   - Ajustes de aplicación

---

## Componentes pendientes

### 1. **Backend API**
- Autenticación JWT
- Endpoints de productos
- Endpoints de órdenes
- Endpoints de usuarios

### 2. **Motor de búsqueda Tabú** 
- Algoritmo de búsqueda por tabú
- Indexación de productos
- Ranking de relevancia

### 3. **Base de Datos Productiva** 
- Migración a PostgreSQL/MySQL
- Conexión con backend
- Gestión de transacciones

### 4. **Integración Payment Gateway** 
- Pasarela de pagos real
- Manejo de pagos exitosos/fallidos

### 5. **Sistema de notificaciones**
- Notificaciones de órdenes
- Push notifications
- Email notifications

---

## Arquitectura pendiente

1. **Backend Stack**: ¿Node.js/Python/Golang?
2. **Database**: ¿PostgreSQL/MySQL?
3. **Payment Gateway**: ¿Stripe/Mercado Pago/PayPal?
4. **Search Engine**: ¿Elasticsearch/Meilisearch/SQL Full-Text?
5. **Hosting**: ¿AWS/Google Cloud/Azure?

---

# Sección de tareas tecnicas

## Tareas técnicas por prioridad

### FASE 1: Infraestructura base

#### Backend setup
- [ ] Inicializar proyecto backend (Node.js + Express / Python + FastAPI)
- [ ] Configurar base de datos (PostgreSQL/MySQL)
- [ ] Implementar autenticación JWT
- [ ] Definir estructura de API REST endpoints
- [ ] Configurar CORS para Flutter app

#### Estructura del backend
```
backend/
├── src/
│   ├── auth/           # Módulo de autenticación
│   ├── products/       # Gestión de productos
│   ├── orders/         # Gestión de órdenes
│   ├── users/          # Gestión de usuarios
│   ├── middleware/     # Auth, logging, etc
│   └── config/         # Configuraciones
├── migrations/         # Scripts de base de datos
├── tests/              # Unit & Integration tests
└── docker-compose.yml  # Contenedores
```

#### Database Schema
- [ ] Crear tabla `users` (id, email, password_hash, role, created_at)
- [ ] Crear tabla `products` (id, name, description, price, store_id, stock)
- [ ] Crear tabla `orders` (id, user_id, total, status, created_at)
- [ ] Crear tabla `order_items` (order_id, product_id, quantity, price)
- [ ] Crear tabla `addresses` (id, user_id, street, city, country, is_default)
- [ ] Crear índices para búsqueda optimizada

### FASE 2: Integración API 

#### Endpoints Core
- [ ] `POST /auth/register` - Registro de usuario
- [ ] `POST /auth/login` - Login + JWT token
- [ ] `GET /products` - Listar productos (con paginación)
- [ ] `GET /products/:id` - Detalle de producto
- [ ] `GET /orders` - Listar órdenes del usuario
- [ ] `POST /orders` - Crear orden
- [ ] `PATCH /orders/:id/status` - Actualizar estado de orden
- [ ] `GET /users/me` - Datos del usuario actual
- [ ] `POST /addresses` - Crear dirección

#### Cambios en Flutter
- [ ] Reemplazar mock repositories con Dio HTTP client
- [ ] Integrar autenticación JWT (guardar token en SharedPreferences)
- [ ] Manejar errores HTTP (401, 403, 500)
- [ ] Implementar refresh token logic
- [ ] Agregar interceptores para logging

### FASE 3: Motor de búsqueda Tabú 

#### Opción 1: Solución simple (SQL Full-Text search)
```sql
-- PostgreSQL
SELECT * FROM products 
WHERE to_tsvector('spanish', name || ' ' || description) @@ plainto_tsquery('spanish', 'search_term')
ORDER BY ts_rank(...) DESC;
```

#### Opción 2: Solución avanzada
- [ ] Instalar y configurar Elasticsearch
- [ ] Crear índices de productos
- [ ] Implementar algoritmo de búsqueda tabú
- [ ] Integrar con backend (cliente de Elasticsearch)

#### Algoritmo de búsqueda Tabú
```
function tabuSearch(query, products, iterations=100):
    bestSolution = initialSolution(query, products)
    tabuList = []
    
    for i in range(iterations):
        candidates = generateNeighbors(bestSolution)
        nonTabuCandidates = [c for c in candidates if c not in tabuList]
        
        if nonTabuCandidates:
            bestCandidate = selectBest(nonTabuCandidates)
            if better(bestCandidate, bestSolution):
                bestSolution = bestCandidate
            tabuList.add(bestCandidate)
            
            if len(tabuList) > tabuListSize:
                tabuList.remove(first)
    
    return bestSolution
```

### FASE 4: Pagos y notificaciones

#### Payment Gateway Integration
- [ ] Registrar cuenta en Stripe/Mercado Pago
- [ ] Implementar endpoint `/payments/create-intent`
- [ ] Integrar Stripe Flutter package en app
- [ ] Manejar webhooks de pago exitoso/fallido
- [ ] Actualizar estado de orden tras pago

#### Sistema de notificaciones
- [ ] Firebase Cloud Messaging setup
- [ ] Enviar notificaciones cuando:
  - [ ] Orden confirmada
  - [ ] Orden enviada
  - [ ] Orden entregada
- [ ] Sistema de email (SendGrid/Mailgun)

### FASE 5: Testing y deployment

#### Testing Backend
- [ ] Unit tests (mínimo 70% coverage)
- [ ] Integration tests para endpoints críticos
- [ ] Tests de autenticación/autorización
- [ ] Load testing con Locust/JMeter

#### Testing Flutter
- [ ] Widget tests para UI crítica
- [ ] Integration tests de flujo checkout
- [ ] Tests de estado management (BLoC)

#### Deployment
- [ ] Dockerizar backend
- [ ] Configurar CI/CD (GitHub Actions)
- [ ] Deploy a servidor de staging
- [ ] Deploy a producción

#### Monitoreo
- [ ] Configurar Sentry para error tracking
- [ ] Setup de logs centralizados
- [ ] Alertas de performance

---

## 📋 Checklist técnico detallado

### Backend
- [ ] Repository pattern implementado
- [ ] Validación de entrada en todos los endpoints
- [ ] Manejo de errores centralizado
- [ ] Rate limiting
- [ ] CORS configurado correctamente
- [ ] Documentación de API (Swagger/OpenAPI)
- [ ] Versionado de API (/v1/products)

### Database
- [ ] Backup strategy definida
- [ ] Índices para queries frecuentes
- [ ] Constraints de integridad referencial
- [ ] Auditoría (created_at, updated_at)
- [ ] Soft deletes si es necesario

### Flutter App
- [ ] Error handling en todas las pantallas
- [ ] Offline mode capability
- [ ] Refresh token implementation
- [ ] Analytics tracking
- [ ] Crash reporting
- [ ] Performance optimization

---

## Stack recomendado

```
Backend:
- Node.js + Express (o Python + FastAPI)
- PostgreSQL
- Redis (cache/sessions)
- Docker + Docker Compose

Search:
- PostgreSQL Full-Text (simple) o Elasticsearch (avanzado)

Pagos:
- Stripe / Mercado Pago API

Notificaciones:
- Firebase Cloud Messaging
- SendGrid/Mailgun

Hosting:
- Backend: Heroku / AWS EC2 / DigitalOcean
- Database: AWS RDS / Google Cloud SQL
- Frontend: Google Play Store / App Store
```

---

# SECCIÓN PARA STAKEHOLDERS / PRODUCT TEAM

## Tareas para el grupo de negocios 

### FASE 1: Planificación y Definición 

#### Business Requirements
- [ ] Definir tipos de usuarios finales y casos de uso
- [ ] Especificar reglas de comisión/pricing
- [ ] Definir política de devoluciones
- [ ] Establecer límites de compra/venta por usuario
- [ ] Definir niveles de verificación de sellers

#### Compliance y Legal
- [ ] Redactar Términos de Servicio
- [ ] Crear Política de Privacidad (GDPR compliant)
- [ ] Definir Política de Reembolsos
- [ ] Términos de protección del comprador/vendedor

#### Market Research
- [ ] Análisis de competencia (Mercado Libre, Shein, Amazon)
- [ ] Identificar pain points de usuarios
- [ ] Validar propuesta de valor

### FASE 2: Experiencia de usuario

#### User research
- [ ] Realizar entrevistas con estudiantes (target audience)
- [ ] Crear user personas
- [ ] Validar flujos críticos (compra, pago, seguimiento)
- [ ] Identificar barreras de adopción

#### Content strategy
- [ ] Guía de categorías de productos
- [ ] Plantillas de descripciones de producto
- [ ] Políticas de imágenes/fotos
- [ ] Contenido onboarding para usuarios nuevos

#### Marketing y growth
- [ ] Definir estrategia de lanzamiento
- [ ] Crear roadmap de features para versión 1.0, 2.0, 3.0
- [ ] Plan de comunicación con usuarios early adopters

### FASE 3: Operaciones

#### Customer support
- [ ] Crear FAQ
- [ ] Definir canales de soporte (chat, email, WhatsApp)
- [ ] Crear templates de respuesta
- [ ] Entrenamiento de equipo de soporte

#### Seller onboarding
- [ ] Crear guía para nuevos sellers
- [ ] Definir requisitos de verificación
- [ ] Crear programa de seller tiers/incentivos
- [ ] Definir límites iniciales (comisión, cantidad de anuncios)

#### Community moderation
- [ ] Políticas de contenido prohibido
- [ ] Proceso de reporte de fraude/abuso
- [ ] Sistema de calificaciones (ratings)

### FASE 4: Monetización

#### Pricing Strategy
- [ ] Definir comisión por transacción (% o monto fijo)
- [ ] Featured listings / Premium ads pricing
- [ ] Subscription options (si aplica)
- [ ] Análisis de competencia de precios

#### Business Metrics
- [ ] KPIs principales (GMV, number of transactions, user retention)
- [ ] Dashboard de métricas de negocio
- [ ] Targets de crecimiento mensual

### FASE 5: Lanzamiento
#### Pre-Launch Checklist
- [ ] Beta testing con grupo de usuarios seleccionados
- [ ] Feedback collection y bug fixing
- [ ] Preparar App Store / Google Play listings
- [ ] Crear materiales de marketing (videos, screenshots, descripciones)

#### Launch Day
- [ ] Coordinar push notifications
- [ ] Monitoreo de servidor/app
- [ ] Atención a preguntas de usuarios
- [ ] Reporte de primeras métricas

#### Post-Launch
- [ ] Medir adopción de usuarios
- [ ] Identificar quick wins para mejorar
- [ ] Plan de iteración para próximas semanas

---


