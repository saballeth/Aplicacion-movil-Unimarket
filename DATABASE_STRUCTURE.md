# Arquitectura de base de datos

## 1. Visión general

UniMarket utiliza una **arquitectura de base de datos relacional** diseñada para soportar un marketplace de estudiantes universitarios. La estructura está optimizada para la arquitectura Clean Architecture + MVVM del proyecto.

### Capas de datos
```
Presentación (UI)
    ↓
Viewmodels/Cubits
    ↓
Usecases
    ↓
Repositories (Interfaces)
    ↓
Repository Implementation + Datasources
    ↓
Local (SQLite) / Remote (API REST)
```

## 2. Diagrama Entidad-Relación

```
┌─────────────┐
│   USERS     │
├─────────────┤
│ id (PK)     │
│ email       │
│ password    │
│ name        │
│ phone       │
│ role_id (FK)│◄───┐
│ profile_pic │    │
│ created_at  │    │
│ updated_at  │    │
└─────────────┘    │
       │            │
       │         ┌──┴──────────────┐
       ▼         │                  ▼
   ┌────────────────────┐    ┌──────────────┐
   │ ENTREPRENEURS      │    │ ROLES        │
   ├────────────────────┤    ├──────────────┤
   │ id (PK)            │    │ id (PK)      │
   │ user_id (FK)       │    │ name         │ (consumer, entrepreneur, admin)
   │ business_name      │    │ permissions  │
   │ owner_name         │    └──────────────┘
   │ category           │
   │ phone              │
   │ address            │
   │ description        │
   │ verification_level │
   │ status             │
   │ created_at         │
   └────────────────────┘
          │
          ▼
   ┌──────────────────┐
   │ ENTREPRENEUR_DOCS│
   ├──────────────────┤
   │ id (PK)          │
   │ entrepreneur_id  │
   │ doc_type         │
   │ file_url         │
   │ status           │
   │ verified_at      │
   └──────────────────┘

   ┌──────────────────┐       ┌──────────────┐
   │ BANK_ACCOUNTS    │◄──────┤ ENTREPRENEURS│
   ├──────────────────┤       └──────────────┘
   │ id (PK)          │
   │ entrepreneur_id  │
   │ bank_name        │
   │ account_number   │
   │ account_type     │
   │ verified         │
   │ balance          │
   └──────────────────┘

┌─────────────────────┐
│    PRODUCTS         │
├─────────────────────┤
│ id (PK)             │
│ entrepreneur_id (FK)│◄─────┬───────────────────┐
│ name                │      │                   │
│ description         │      │                   │
│ category_id (FK)    │      │                   │
│ price               │      │                   │
│ discount_price      │      │                   │
│ stock               │      │                   │
│ images_url          │      │                   │
│ rating              │      │                   │
│ is_featured         │      │                   │
│ created_at          │      │                   │
└─────────────────────┘      │                   │
          │                  │                   │
          ▼                  ▼                   ▼
   ┌─────────────┐    ┌────────────┐    ┌──────────────┐
   │ CATEGORIES  │    │ REVIEWS    │    │ FAVORITES    │
   ├─────────────┤    ├────────────┤    ├──────────────┤
   │ id (PK)     │    │ id (PK)    │    │ id (PK)      │
   │ name        │    │ product_id │    │ user_id (FK) │
   │ icon        │    │ user_id    │    │ product_id   │
   └─────────────┘    │ rating     │    │ created_at   │
                      │ comment    │    └──────────────┘
                      │ created_at │
                      └────────────┘

┌─────────────────────┐
│    CART_ITEMS       │
├─────────────────────┤
│ id (PK)             │
│ user_id (FK)        │
│ product_id (FK)     │
│ quantity            │
│ added_at            │
└─────────────────────┘

┌──────────────────────┐
│    ORDERS            │
├──────────────────────┤
│ id (PK)              │
│ user_id (FK)         │
│ total_amount         │
│ status               │
│ payment_status       │
│ shipping_address     │
│ delivery_date        │
│ created_at           │
└──────────────────────┘
         │
         ▼
┌──────────────────────┐
│    ORDER_ITEMS       │
├──────────────────────┤
│ id (PK)              │
│ order_id (FK)        │
│ product_id (FK)      │
│ quantity             │
│ unit_price           │
│ subtotal             │
└──────────────────────┘

┌──────────────────────┐
│    PAYMENTS          │
├──────────────────────┤
│ id (PK)              │
│ order_id (FK)        │
│ method               │
│ amount               │
│ transaction_id       │
│ status               │
│ created_at           │
└──────────────────────┘

┌──────────────────────┐
│    ADDRESSES         │
├──────────────────────┤
│ id (PK)              │
│ user_id (FK)         │
│ alias                │
│ street               │
│ number               │
│ city                 │
│ state                │
│ postal_code          │
│ is_default           │
│ latitude             │
│ longitude            │
└──────────────────────┘

┌──────────────────────────┐
│   ADMIN_REPORTS          │
├──────────────────────────┤
│ id (PK)                  │
│ report_type              │
│ period_start             │
│ period_end               │
│ total_users              │
│ total_sales              │
│ revenue                  │
│ top_products             │
│ created_at               │
└──────────────────────────┘
```

## 3. Especificación de tablas

### Tabla principal de usuarios
```sql
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  name TEXT NOT NULL,
  phone TEXT UNIQUE NOT NULL,
  role_id TEXT NOT NULL FOREIGN KEY REFERENCES roles(id),
  profile_pic_url TEXT,
  email_verified BOOLEAN DEFAULT false,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  last_login DATETIME
);
```

### ROLES
```sql
CREATE TABLE roles (
  id TEXT PRIMARY KEY,
  name TEXT UNIQUE NOT NULL, -- 'consumer', 'entrepreneur', 'admin'
  permissions TEXT -- JSON serialized permissions
);
```

### ENTREPRENEURS
```sql
CREATE TABLE entrepreneurs (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL UNIQUE FOREIGN KEY REFERENCES users(id),
  business_name TEXT NOT NULL,
  owner_name TEXT NOT NULL,
  category TEXT NOT NULL,
  phone TEXT,
  address TEXT,
  description TEXT,
  verification_level INTEGER, -- 0-100
  status TEXT DEFAULT 'pending', -- pending, approved, rejected
  rejection_reason TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### ENTREPRENEUR_DOCUMENTS
```sql
CREATE TABLE entrepreneur_documents (
  id TEXT PRIMARY KEY,
  entrepreneur_id TEXT NOT NULL FOREIGN KEY REFERENCES entrepreneurs(id),
  doc_type TEXT NOT NULL, -- 'id', 'business_license', 'tax_id', etc.
  file_url TEXT NOT NULL,
  status TEXT DEFAULT 'pending', -- pending, approved, rejected
  rejection_reason TEXT,
  verified_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### BANK_ACCOUNTS
```sql
CREATE TABLE bank_accounts (
  id TEXT PRIMARY KEY,
  entrepreneur_id TEXT NOT NULL FOREIGN KEY REFERENCES entrepreneurs(id),
  bank_name TEXT NOT NULL,
  account_number TEXT NOT NULL,
  account_holder TEXT NOT NULL,
  account_type TEXT, -- 'savings', 'checking'
  bank_code TEXT,
  verified BOOLEAN DEFAULT false,
  available_balance REAL DEFAULT 0,
  total_earnings REAL DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### CATEGORIES
```sql
CREATE TABLE categories (
  id TEXT PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  icon_url TEXT,
  description TEXT,
  order_by INTEGER,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### PRODUCTS
```sql
CREATE TABLE products (
  id TEXT PRIMARY KEY,
  entrepreneur_id TEXT NOT NULL FOREIGN KEY REFERENCES entrepreneurs(id),
  name TEXT NOT NULL,
  description TEXT,
  category_id TEXT NOT NULL FOREIGN KEY REFERENCES categories(id),
  price REAL NOT NULL,
  discount_price REAL,
  stock INTEGER NOT NULL DEFAULT 0,
  images_url TEXT, -- JSON array serialized
  rating REAL DEFAULT 0,
  review_count INTEGER DEFAULT 0,
  is_featured BOOLEAN DEFAULT false,
  is_active BOOLEAN DEFAULT true,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (entrepreneur_id) REFERENCES entrepreneurs(id)
);
```

### REVIEWS
```sql
CREATE TABLE reviews (
  id TEXT PRIMARY KEY,
  product_id TEXT NOT NULL FOREIGN KEY REFERENCES products(id),
  user_id TEXT NOT NULL FOREIGN KEY REFERENCES users(id),
  rating INTEGER NOT NULL, -- 1-5
  comment TEXT,
  verified_purchase BOOLEAN DEFAULT false,
  helpful_count INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### FAVORITES
```sql
CREATE TABLE favorites (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL FOREIGN KEY REFERENCES users(id),
  product_id TEXT NOT NULL FOREIGN KEY REFERENCES products(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, product_id)
);
```

### CART_ITEMS
```sql
CREATE TABLE cart_items (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL FOREIGN KEY REFERENCES users(id),
  product_id TEXT NOT NULL FOREIGN KEY REFERENCES products(id),
  quantity INTEGER NOT NULL DEFAULT 1,
  added_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, product_id)
);
```

### ORDERS
```sql
CREATE TABLE orders (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL FOREIGN KEY REFERENCES users(id),
  total_amount REAL NOT NULL,
  status TEXT DEFAULT 'pending', -- pending, confirmed, shipped, delivered, cancelled
  payment_status TEXT DEFAULT 'pending', -- pending, completed, failed, refunded
  shipping_address TEXT NOT NULL, -- JSON serialized
  tracking_number TEXT,
  delivery_date DATETIME,
  notes TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### ORDER_ITEMS
```sql
CREATE TABLE order_items (
  id TEXT PRIMARY KEY,
  order_id TEXT NOT NULL FOREIGN KEY REFERENCES orders(id),
  product_id TEXT NOT NULL FOREIGN KEY REFERENCES products(id),
  quantity INTEGER NOT NULL,
  unit_price REAL NOT NULL,
  subtotal REAL NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### PAYMENTS
```sql
CREATE TABLE payments (
  id TEXT PRIMARY KEY,
  order_id TEXT NOT NULL FOREIGN KEY REFERENCES orders(id),
  method TEXT NOT NULL, -- 'credit_card', 'paypal', 'bank_transfer'
  amount REAL NOT NULL,
  transaction_id TEXT UNIQUE,
  status TEXT DEFAULT 'pending', -- pending, completed, failed, refunded
  error_message TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### ADDRESSES
```sql
CREATE TABLE addresses (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL FOREIGN KEY REFERENCES users(id),
  alias TEXT, -- 'home', 'work', etc.
  street TEXT NOT NULL,
  number TEXT,
  city TEXT NOT NULL,
  state TEXT NOT NULL,
  postal_code TEXT NOT NULL,
  country TEXT DEFAULT 'Colombia',
  latitude REAL,
  longitude REAL,
  is_default BOOLEAN DEFAULT false,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### ADMIN_REPORTS
```sql
CREATE TABLE admin_reports (
  id TEXT PRIMARY KEY,
  report_type TEXT NOT NULL, -- 'sales', 'users', 'entrepreneurs', 'products'
  period_start DATE,
  period_end DATE,
  total_users INTEGER,
  active_entrepreneurs INTEGER,
  total_products INTEGER,
  total_orders INTEGER,
  total_sales REAL,
  total_revenue REAL,
  top_products TEXT, -- JSON serialized
  top_entrepreneurs TEXT, -- JSON serialized
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

## 3.2 Motor de búsqueda Tabú (Tabu Search Algorithm)

Este módulo implementa un algoritmo de Búsqueda Tabú que balancea 3 objetivos en conflicto:
1. **Relevancia**: similitud con perfil del usuario
2. **Diversidad**: evitar burbuja de recomendaciones (entropía de categorías)
3. **Equidad**: visibilidad uniforme para emprendedores (especialmente nuevos)

### 3.2.1 Tablas remotas (Supabase/Backend)

#### CATEGORY_EXPOSURE
Rastrea la exposición histórica de categorías para calcular entropía y diversidad

```sql
CREATE TABLE category_exposure (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL FOREIGN KEY REFERENCES users(id),
  category_id TEXT NOT NULL FOREIGN KEY REFERENCES categories(id),
  impressions INTEGER DEFAULT 0, -- veces que la categoría fue mostrada
  clicks INTEGER DEFAULT 0,
  last_seen DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, category_id)
);
```

#### ENTREPRENEUR_IMPRESSIONS
Impresiones por emprendedor para garantizar equidad en la visibilidad

```sql
CREATE TABLE entrepreneur_impressions (
  id TEXT PRIMARY KEY,
  entrepreneur_id TEXT NOT NULL FOREIGN KEY REFERENCES entrepreneurs(id),
  user_id TEXT NOT NULL FOREIGN KEY REFERENCES users(id),
  impressions INTEGER DEFAULT 0,
  clicks INTEGER DEFAULT 0,
  last_impression DATETIME,
  period TEXT, -- 'daily', 'weekly', 'monthly'
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(entrepreneur_id, user_id, period)
);
```

#### RECOMMENDATION_LOGS
Logs detallados para evaluación experimental y auditoría del algoritmo

```sql
CREATE TABLE recommendation_logs (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL FOREIGN KEY REFERENCES users(id),
  product_id TEXT NOT NULL FOREIGN KEY REFERENCES products(id),
  entrepreneur_id TEXT FOREIGN KEY REFERENCES entrepreneurs(id),
  position INTEGER NOT NULL, -- posición en la lista (1-based)
  score_relevance REAL, -- valor objetivo 1: similitud con perfil
  score_diversity REAL, -- valor objetivo 2: contribución a diversidad
  score_equity REAL, -- valor objetivo 3: equidad de emprendedor
  score_final REAL, -- función de compromiso multi-objetivo
  was_clicked BOOLEAN DEFAULT false,
  was_purchased BOOLEAN DEFAULT false,
  algorithm_version TEXT, -- ej: 'tabu_v1.0', 'tabu_v1.1'
  tabu_iteration INTEGER, -- número de iteración del algoritmo
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### 3.2.2 Tablas locales (SQLite Embebido en Dispositivo - Dart/sqflite)

Estas tablas existen **solo en el dispositivo** y no se sincronizan con el servidor. Permiten:
- Procesamiento offline del algoritmo
- Persistencia de lista tabú entre sesiones
- Caché local para filtrado rápido

#### LOCAL_USER_PROFILE
Perfil ligero del usuario almacenado localmente (privado, no viaja al servidor)

```sql
CREATE TABLE local_user_profile (
  user_id TEXT PRIMARY KEY,
  preferred_categories TEXT, -- JSON: ["comida","ropa","libros"]
  price_min REAL DEFAULT 0,
  price_max REAL DEFAULT 999999,
  preferred_entrepreneurs TEXT, -- JSON: lista de IDs
  avg_session_minutes REAL DEFAULT 0,
  search_frequency INTEGER DEFAULT 0,
  last_synced DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

#### TABU_LIST
Lista tabú local persistida entre sesiones

```sql
CREATE TABLE tabu_list (
  id TEXT PRIMARY KEY,
  entity_id TEXT NOT NULL, -- product_id o entrepreneur_id
  entity_type TEXT NOT NULL, -- 'product' | 'entrepreneur'
  reason TEXT, -- 'user_rejected', 'low_rating', 'not_in_stock', etc.
  expires_at DATETIME NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(entity_id, entity_type)
);
```

#### LOCAL_PRODUCTS_CACHE
Caché local de productos para filtrado sin conexión de red

```sql
CREATE TABLE local_products_cache (
  product_id TEXT PRIMARY KEY,
  entrepreneur_id TEXT,
  name TEXT NOT NULL,
  category_id TEXT,
  price REAL,
  discount_price REAL,
  stock INTEGER,
  rating REAL,
  is_active BOOLEAN DEFAULT true,
  cached_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  expires_at DATETIME
);
```

#### TABU_ALGORITHM_STATE
Estado persistente del algoritmo entre ejecuciones

```sql
CREATE TABLE tabu_algorithm_state (
  id TEXT PRIMARY KEY DEFAULT 'singleton',
  iteration INTEGER DEFAULT 0, -- número de iteración actual
  best_score REAL, -- mejor puntuación encontrada
  current_solution TEXT, -- JSON: lista actual de product_ids
  tabu_tenure INTEGER DEFAULT 7, -- duración de la tenencia tabú
  max_iterations INTEGER DEFAULT 50,
  last_run DATETIME,
  execution_time_ms INTEGER, -- tiempo de la última ejecución
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

## 3.3 Módulo de Comunicación

### NOTIFICATIONS
```sql
CREATE TABLE notifications (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL FOREIGN KEY REFERENCES users(id),
  type TEXT NOT NULL, -- 'order_update', 'promo', 'message', 'system'
  title TEXT NOT NULL,
  body TEXT,
  is_read BOOLEAN DEFAULT false,
  action_url TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### MESSAGES
```sql
CREATE TABLE messages (
  id TEXT PRIMARY KEY,
  sender_id TEXT NOT NULL FOREIGN KEY REFERENCES users(id),
  receiver_id TEXT NOT NULL FOREIGN KEY REFERENCES users(id),
  conversation_id TEXT NOT NULL FOREIGN KEY REFERENCES conversations(id),
  product_id TEXT FOREIGN KEY REFERENCES products(id),
  content TEXT NOT NULL,
  is_read BOOLEAN DEFAULT false,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### CONVERSATIONS
```sql
CREATE TABLE conversations (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL FOREIGN KEY REFERENCES users(id),
  entrepreneur_id TEXT NOT NULL FOREIGN KEY REFERENCES users(id),
  last_message_at DATETIME,
  unread_count INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, entrepreneur_id)
);
```

## 3.4 Módulo de promociones

### COUPONS
```sql
CREATE TABLE coupons (
  id TEXT PRIMARY KEY,
  code TEXT UNIQUE NOT NULL,
  entrepreneur_id TEXT FOREIGN KEY REFERENCES entrepreneurs(id), -- NULL = cupón global
  discount_type TEXT NOT NULL, -- 'percentage', 'fixed'
  discount_value REAL NOT NULL,
  min_order_amount REAL DEFAULT 0,
  max_uses INTEGER,
  used_count INTEGER DEFAULT 0,
  expires_at DATETIME,
  is_active BOOLEAN DEFAULT true,
  created_by TEXT NOT NULL, -- user_id
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### COUPON_USES
```sql
CREATE TABLE coupon_uses (
  id TEXT PRIMARY KEY,
  coupon_id TEXT NOT NULL FOREIGN KEY REFERENCES coupons(id),
  user_id TEXT NOT NULL FOREIGN KEY REFERENCES users(id),
  order_id TEXT NOT NULL FOREIGN KEY REFERENCES orders(id),
  discount_amount REAL NOT NULL,
  used_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

## 3.5 Módulo de logística

### SHIPMENTS
```sql
CREATE TABLE shipments (
  id TEXT PRIMARY KEY,
  order_id TEXT NOT NULL FOREIGN KEY REFERENCES orders(id),
  carrier TEXT, -- 'correosdecolumbia', 'dhl', 'fedex', etc.
  tracking_number TEXT,
  status TEXT DEFAULT 'preparing', -- 'preparing', 'shipped', 'in_transit', 'delivered'
  estimated_at DATETIME,
  delivered_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### DELIVERY_ZONES
```sql
CREATE TABLE delivery_zones (
  id TEXT PRIMARY KEY,
  entrepreneur_id TEXT NOT NULL FOREIGN KEY REFERENCES entrepreneurs(id),
  city TEXT NOT NULL,
  neighborhood TEXT,
  delivery_fee REAL NOT NULL,
  estimated_days INTEGER,
  is_active BOOLEAN DEFAULT true,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(entrepreneur_id, city, neighborhood)
);
```

### RETURNS
```sql
CREATE TABLE returns (
  id TEXT PRIMARY KEY,
  order_id TEXT NOT NULL FOREIGN KEY REFERENCES orders(id),
  product_id TEXT NOT NULL FOREIGN KEY REFERENCES products(id),
  user_id TEXT NOT NULL FOREIGN KEY REFERENCES users(id),
  reason TEXT NOT NULL,
  status TEXT DEFAULT 'requested', -- 'requested', 'approved', 'rejected', 'completed'
  refund_amount REAL,
  return_tracking_number TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

## 3.6 Módulo de catálogo extendido

### PRODUCT_VARIANTS
```sql
CREATE TABLE product_variants (
  id TEXT PRIMARY KEY,
  product_id TEXT NOT NULL FOREIGN KEY REFERENCES products(id),
  attribute_name TEXT NOT NULL, -- 'size', 'color', 'material', etc.
  attribute_value TEXT NOT NULL,
  extra_price REAL DEFAULT 0,
  stock INTEGER NOT NULL DEFAULT 0,
  sku TEXT UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(product_id, attribute_name, attribute_value)
);
```

### PRODUCT_TAGS
```sql
CREATE TABLE product_tags (
  id TEXT PRIMARY KEY,
  product_id TEXT NOT NULL FOREIGN KEY REFERENCES products(id),
  tag TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(product_id, tag)
);
```

### PRODUCT_QUESTIONS
```sql
CREATE TABLE product_questions (
  id TEXT PRIMARY KEY,
  product_id TEXT NOT NULL FOREIGN KEY REFERENCES products(id),
  user_id TEXT NOT NULL FOREIGN KEY REFERENCES users(id),
  question TEXT NOT NULL,
  answer TEXT,
  answered_by TEXT FOREIGN KEY REFERENCES users(id), -- entrepreneur
  answered_at DATETIME,
  is_visible BOOLEAN DEFAULT true,
  helpful_count INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

## 3.7 Módulo de búsqueda y recomendaciónes

### SEARCH_HISTORY
```sql
CREATE TABLE search_history (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL FOREIGN KEY REFERENCES users(id),
  query TEXT NOT NULL,
  results_count INTEGER,
  clicked_product_id TEXT FOREIGN KEY REFERENCES products(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### PRODUCT_SIMILARITY
```sql
CREATE TABLE product_similarity (
  id TEXT PRIMARY KEY,
  product_a_id TEXT NOT NULL FOREIGN KEY REFERENCES products(id),
  product_b_id TEXT NOT NULL FOREIGN KEY REFERENCES products(id),
  score REAL NOT NULL, -- 0.0 - 1.0
  method TEXT NOT NULL, -- 'collaborative', 'content'
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(product_a_id, product_b_id)
);
```

## 3.8 Módulo de soporte

### SUPPORT_TICKETS
```sql
CREATE TABLE support_tickets (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL FOREIGN KEY REFERENCES users(id),
  order_id TEXT FOREIGN KEY REFERENCES orders(id),
  subject TEXT NOT NULL,
  description TEXT NOT NULL,
  status TEXT DEFAULT 'open', -- 'open', 'in_progress', 'resolved', 'closed'
  priority TEXT DEFAULT 'medium', -- 'low', 'medium', 'high', 'urgent'
  assigned_to TEXT FOREIGN KEY REFERENCES users(id), -- admin/staff
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  resolved_at DATETIME
);
```

### TICKET_MESSAGES
```sql
CREATE TABLE ticket_messages (
  id TEXT PRIMARY KEY,
  ticket_id TEXT NOT NULL FOREIGN KEY REFERENCES support_tickets(id),
  sender_id TEXT NOT NULL FOREIGN KEY REFERENCES users(id),
  message TEXT NOT NULL,
  is_staff BOOLEAN DEFAULT false,
  attachment_url TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### DISPUTES
```sql
CREATE TABLE disputes (
  id TEXT PRIMARY KEY,
  order_id TEXT NOT NULL FOREIGN KEY REFERENCES orders(id),
  reported_by TEXT NOT NULL FOREIGN KEY REFERENCES users(id),
  against_user_id TEXT NOT NULL FOREIGN KEY REFERENCES users(id),
  reason TEXT NOT NULL,
  description TEXT,
  status TEXT DEFAULT 'open', -- 'open', 'mediation', 'resolved', 'closed'
  resolution TEXT,
  decided_by TEXT FOREIGN KEY REFERENCES users(id), -- admin
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  resolved_at DATETIME
);
```

### ENTREPRENEUR_RATINGS
```sql
CREATE TABLE entrepreneur_ratings (
  id TEXT PRIMARY KEY,
  entrepreneur_id TEXT NOT NULL FOREIGN KEY REFERENCES entrepreneurs(id),
  user_id TEXT NOT NULL FOREIGN KEY REFERENCES users(id),
  order_id TEXT NOT NULL FOREIGN KEY REFERENCES orders(id),
  rating INTEGER NOT NULL, -- 1-5
  comment TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(entrepreneur_id, user_id, order_id)
);
```

## 3.9 Módulo de seguridad

### SESSIONS
```sql
CREATE TABLE sessions (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL FOREIGN KEY REFERENCES users(id),
  token_hash TEXT UNIQUE NOT NULL,
  device TEXT,
  ip_address TEXT,
  expires_at DATETIME NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  last_activity DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### AUDIT_LOGS
```sql
CREATE TABLE audit_logs (
  id TEXT PRIMARY KEY,
  user_id TEXT FOREIGN KEY REFERENCES users(id),
  action TEXT NOT NULL, -- 'create', 'update', 'delete', 'login', 'approve', etc.
  entity_type TEXT NOT NULL, -- 'entrepreneur', 'product', 'order', 'user', etc.
  entity_id TEXT NOT NULL,
  old_value TEXT, -- JSON
  new_value TEXT, -- JSON
  ip_address TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

## 4. Índices Recomendados

```sql
-- Para mejorar búsquedas
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role_id ON users(role_id);
CREATE INDEX idx_products_entrepreneur_id ON products(entrepreneur_id);
CREATE INDEX idx_products_category_id ON products(category_id);
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_reviews_product_id ON reviews(product_id);
CREATE INDEX idx_reviews_user_id ON reviews(user_id);
CREATE INDEX idx_cart_items_user_id ON cart_items(user_id);
CREATE INDEX idx_favorites_user_id ON favorites(user_id);
CREATE INDEX idx_addresses_user_id ON addresses(user_id);
CREATE INDEX idx_entrepreneur_docs_entrepreneur_id ON entrepreneur_documents(entrepreneur_id);
CREATE INDEX idx_bank_accounts_entrepreneur_id ON bank_accounts(entrepreneur_id);

-- Nuevos índices para módulos adicionales
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_messages_sender_id ON messages(sender_id);
CREATE INDEX idx_messages_receiver_id ON messages(receiver_id);
CREATE INDEX idx_messages_conversation_id ON messages(conversation_id);
CREATE INDEX idx_conversations_user_id ON conversations(user_id);
CREATE INDEX idx_conversations_entrepreneur_id ON conversations(entrepreneur_id);
CREATE INDEX idx_coupons_code ON coupons(code);
CREATE INDEX idx_coupons_entrepreneur_id ON coupons(entrepreneur_id);
CREATE INDEX idx_shipments_order_id ON shipments(order_id);
CREATE INDEX idx_delivery_zones_entrepreneur_id ON delivery_zones(entrepreneur_id);
CREATE INDEX idx_returns_order_id ON returns(order_id);
CREATE INDEX idx_product_variants_product_id ON product_variants(product_id);
CREATE INDEX idx_product_tags_product_id ON product_tags(product_id);
CREATE INDEX idx_product_questions_product_id ON product_questions(product_id);
CREATE INDEX idx_search_history_user_id ON search_history(user_id);
CREATE INDEX idx_support_tickets_user_id ON support_tickets(user_id);
CREATE INDEX idx_support_tickets_status ON support_tickets(status);
CREATE INDEX idx_ticket_messages_ticket_id ON ticket_messages(ticket_id);
CREATE INDEX idx_disputes_order_id ON disputes(order_id);
CREATE INDEX idx_entrepreneur_ratings_entrepreneur_id ON entrepreneur_ratings(entrepreneur_id);
CREATE INDEX idx_sessions_user_id ON sessions(user_id);
CREATE INDEX idx_sessions_expires_at ON sessions(expires_at);
CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);

-- Índices para el motor de búsqueda Tabú (Tabu Search)
-- Tablas Remotas
CREATE INDEX idx_category_exposure_user_id ON category_exposure(user_id);
CREATE INDEX idx_category_exposure_category_id ON category_exposure(category_id);
CREATE INDEX idx_entrepreneur_impressions_entrepreneur_id ON entrepreneur_impressions(entrepreneur_id);
CREATE INDEX idx_entrepreneur_impressions_user_id ON entrepreneur_impressions(user_id);
CREATE INDEX idx_entrepreneur_impressions_period ON entrepreneur_impressions(period);
CREATE INDEX idx_recommendation_logs_user_id ON recommendation_logs(user_id);
CREATE INDEX idx_recommendation_logs_product_id ON recommendation_logs(product_id);
CREATE INDEX idx_recommendation_logs_algorithm_version ON recommendation_logs(algorithm_version);
CREATE INDEX idx_recommendation_logs_created_at ON recommendation_logs(created_at);

-- Índices para tablas locales (SQLite embebido)
CREATE INDEX idx_tabu_list_entity_id ON tabu_list(entity_id);
CREATE INDEX idx_tabu_list_expires_at ON tabu_list(expires_at);
CREATE INDEX idx_local_products_cache_category_id ON local_products_cache(category_id);
CREATE INDEX idx_local_products_cache_is_active ON local_products_cache(is_active);
```

## 5. Relaciones principales

| Tabla Origen | Tabla Destino | Tipo | Descripción |
|-------------|---------------|------|-------------|
| users | roles | N:1 | Todo usuario tiene un rol |
| entrepreneurs | users | 1:1 | Un usuario es un emprendedor |
| entrepreneurs | entrepreneur_documents | 1:N | Un emprendedor tiene múltiples documentos |
| entrepreneurs | bank_accounts | 1:N | Un emprendedor tiene múltiples cuentas bancarias |
| entrepreneurs | products | 1:N | Un emprendedor vende múltiples productos |
| products | categories | N:1 | Un producto pertenece a una categoría |
| products | reviews | 1:N | Un producto tiene múltiples reseñas |
| products | favorites | 1:N | Un producto puede estar en favoritos |
| users | reviews | 1:N | Un usuario puede hacer múltiples reseñas |
| users | orders | 1:N | Un usuario puede tener múltiples órdenes |
| users | cart_items | 1:N | Un usuario tiene un carrito |
| users | addresses | 1:N | Un usuario puede tener múltiples direcciones |
| orders | order_items | 1:N | Una orden contiene múltiples items |
| orders | payments | 1:N | Una orden puede tener múltiples pagos |
| products | order_items | 1:N | Un producto puede estar en múltiples órdenes |
| **Comunicación** |  |  |  |
| users | notifications | 1:N | Un usuario recibe múltiples notificaciones |
| users | messages | 1:N | Un usuario puede ser remitente o destinatario |
| conversations | messages | 1:N | Una conversación contiene múltiples mensajes |
| users | conversations | N:M (a través de conversation) | Múltiples usuarios en conversaciones |
| **Promociones** |  |  |  |
| coupons | coupon_uses | 1:N | Un cupón puede usarse múltiples veces |
| coupons | entrepreneurs | N:1 | Cupones específicos por emprendedor |
| orders | coupon_uses | 1:N | Una orden puede usar múltiples cupones |
| **Logística** |  |  |  |
| orders | shipments | 1:N | Una orden puede tener múltiples envíos |
| entrepreneurs | delivery_zones | 1:N | Un emprendedor cubre múltiples zonas |
| orders | returns | 1:N | Una orden puede tener múltiples devoluciones |
| **Catálogo** |  |  |  |
| products | product_variants | 1:N | Un producto tiene múltiples variantes |
| products | product_tags | 1:N | Un producto puede tener múltiples etiquetas |
| products | product_questions | 1:N | Un producto puede tener múltiples preguntas |
| **Búsqueda y recomendación** |  |  |  |
| users | search_history | 1:N | Un usuario tiene histórico de búsquedas |
| products | product_similarity | M:N | Similitud bidireccional entre productos |
| **Soporte** |  |  |  |
| users | support_tickets | 1:N | Un usuario puede crear múltiples tickets |
| support_tickets | ticket_messages | 1:N | Un ticket contiene múltiples mensajes |
| orders | disputes | 1:N | Una orden puede generar un conflicto |
| entrepreneurs | entrepreneur_ratings | 1:N | Un emprendedor recibe múltiples calificaciones |
| **Seguridad** |  |  |  |
| users | sessions | 1:N | Un usuario puede tener múltiples sesiones activas |
| users | audit_logs | 1:N | Un usuario genera múltiples eventos de auditoría |
| **Motor de búsqueda Tabú** |  |  |  |
| users | category_exposure | 1:N | Un usuario tiene exposición por categoría |
| categories | category_exposure | 1:N | Una categoría tiene exposición por usuario |
| users | entrepreneur_impressions | 1:N | Un usuario genera impresiones por emprendedor |
| entrepreneurs | entrepreneur_impressions | 1:N | Un emprendedor recibe impresiones |
| users | recommendation_logs | 1:N | Un usuario tiene registro de recomendaciones |
| products | recommendation_logs | 1:N | Un producto aparece en múltiples recomendaciones |
| entrepreneurs | recommendation_logs | 1:N | Un emprendedor genera múltiples recomendaciones |

## 6. Flujo de datos por rol

### Consumidor
- Búsqueda y navegación de productos con historial
- Agregar a favoritos y consultar preguntas de productos
- Carrito de compras y aplicar cupones
- Realizar órdenes y rastrear envíos
- Dejar reseñas y calificar emprendedores
- Ver historial de órdenes y gestionar devoluciones
- Gestionar direcciones
- Comunicación directa con emprendedores (mensajes)
- Crear tickets de soporte y disputas
- Recibir notificaciones de cambios

**Tablas principales:**
- users, products, cart_items, orders, order_items, payments, reviews, addresses, favorites
- notifications, messages, conversations, coupons, shipments, returns
- product_questions, search_history, support_tickets, disputes, entrepreneur_ratings

### Emprendedor
- Crear y gestionar productos con variantes y etiquetas
- Ver ventas y reportes
- Gestionar banco y retiros
- Cargar documentos de verificación
- Ver órdenes de sus productos y gestionar envíos
- Gestionar inventario y zonas de entrega
- Responder preguntas sobre productos
- Crear y gestionar cupones de descuento
- Comunicación con compradores (mensajes)
- Ver calificaciones como vendedor
- Recibir notificaciones de órdenes y eventos

**Tablas principales:**
- entrepreneurs, products, entrepreneur_documents, bank_accounts, orders, order_items, payments
- product_variants, product_tags, product_questions, coupons
- shipments, delivery_zones, messages, conversations, notifications
- entrepreneur_ratings, search_history, audit_logs

### Administrador
- Aprobar/rechazar emprendedores
- Ver todos los usuarios y gestionar roles
- Generar reportes y ver analytics
- Bloquear usuarios o productos
- Moderar reseñas y preguntas de productos
- Ver logs de auditoría y sesiones
- Gestionar disputas entre usuarios
- Crear cupones globales
- Resolver tickets de soporte
- Acceso a todas las tablas del sistema

**Tablas principales:**
- users, entrepreneurs, products, admin_reports, reviews
- support_tickets, disputes, audit_logs, sessions
- coupons (nivel global), notifications, messages

## 7. Integración con Clean Architecture

```
Entity (Domain Layer)
    ↓
├── ProductEntity
├── UserEntity
├── OrderEntity
├── NotificationEntity
├── MessageEntity
├── etc.
    ↓
Repository Interface (Domain)
    ↓
Model (Data Layer)
    ↓
├── ProductModel (fromJson, toJson)
├── UserModel
├── OrderModel
├── NotificationModel
├── MessageModel
    ↓
Data Source
    ├── Remote (API)
    └── Local (SQLite via sqflite)
    ↓
Repository Implementation
    ↓
Use Case
    ↓
Cubit/ViewModel
    ↓
UI
```

## 8. Consideraciones de seguridad

1. **Passwords:** Hasheadas con algoritmo seguro (bcrypt)
2. **Datos Sensibles:** Tokenización de números de tarjeta
3. **Auditoria:** Todos los cambios deben registrar user_id y timestamp (tabla AUDIT_LOGS)
4. **Validación:** Constraints a nivel de BD
5. **Transacciones:** Para operaciones críticas (pagos, inventario)
6. **Sesiones:** Expiración automática de tokens en tabla SESSIONS
7. **Encriptación:** Datos de banco y documentos deben encriptarse antes de almacenar

## 9. Migración de datos locales a la base de datos

Actualmente la app usa SharedPreferences. La migración debe:

1. Crear repositorio híbrido (local + remoto)
2. Migrar datos de SP a SQLite local
3. Sincronizar con servidor backend
4. Implementar caché estratégico

## 10. Motor de búsqueda Tabú

### Motor de búsqueda Tabú

Se ha agregado un módulo que implementa la búsqueda Tabú multi-objetivo para personalizar recomendaciones de productos mientras balancea tres objetivos en conflicto:

#### Tablas remotas (Supabase)
- **CATEGORY_EXPOSURE:** Rastrea exposición histórica de categorías por usuario para calcular entropía y evitar burbuja de recomendaciones (Objetivo 2: Diversidad)
- **ENTREPRENEUR_IMPRESSIONS:** Contador de impresiones por emprendedor y usuario para garantizar equidad en visibilidad, especialmente para emprendedores nuevos (Objetivo 3: Equidad)
- **RECOMMENDATION_LOGS:** Logs detallados de cada recomendación incluyendo scores de los 3 objetivos, para auditoría y evaluación experimental del algoritmo (Fase 4 de validación)

#### Tablas locales (SQLite embebido - Dart/sqflite)
- **LOCAL_USER_PROFILE:** Perfil ligero del usuario almacenado solo en el dispositivo (no viaja al servidor) con preferencias, rango de precios, y frecuencia de búsqueda
- **TABU_LIST:** Lista tabú persistida entre sesiones con elementos rechazados (productos o emprendedores) y fecha de expiración
- **LOCAL_PRODUCTS_CACHE:** Caché local de productos para permitir filtrado sin conexión de red
- **TABU_ALGORITHM_STATE:** Estado del algoritmo entre ejecuciones (iteración actual, mejor solución, tenencia tabú, último tiempo de ejecución)

**Tres objetivos balanceados:**
1. **Relevancia** (PRODUCT_SIMILARITY): Productos similares al perfil del usuario
2. **Diversidad** (CATEGORY_EXPOSURE): Variedad de categorías para evitar efecto burbuja
3. **Equidad** (ENTREPRENEUR_IMPRESSIONS): Visibilidad equitativa entre vendedores

### Módulos agregados

#### Módulo de Comunicación
- **NOTIFICATIONS:** Sistema de alertas en app y push para usuarios sobre cambios de orden, promociones, mensajes y eventos del sistema
- **MESSAGES:** Chat directo entre comprador y emprendedor sobre productos específicos
- **CONVERSATIONS:** Hilo agrupador que gestiona múltiples mensajes entre usuarios y registra el último mensaje y conteo de no leídos

#### Módulo de promociones
- **COUPONS:** Códigos de descuento configurables por porcentaje o monto fijo, con validez temporal y límites de uso
- **COUPON_USES:** Historial de cada uso de cupón asociado a usuario y orden para auditoría

#### Módulo de logística
- **SHIPMENTS:** Trazabilidad de envíos independiente con transportista, número de seguimiento y estados
- **DELIVERY_ZONES:** Zonas de cobertura configurables por emprendedor con costos y tiempos estimados de entrega
- **RETURNS:** Gestión de devoluciones y cambios con razones, estado de aprobación y montos de reembolso

#### Módulo de Catálogo  
- **PRODUCT_VARIANTS:** Variantes de producto (talla, color, material, etc.) con precios adicionales y SKU independientes
- **PRODUCT_TAGS:** Etiquetas libres para mejorar búsqueda y clasificación de productos
- **PRODUCT_QUESTIONS:** Preguntas y respuestas públicas sobre productos respondidas por el emprendedor

#### Módulo de búsqueda y recomendación
- **SEARCH_HISTORY:** Historial de búsquedas por usuario para análisis de comportamiento y recomendaciones
- **PRODUCT_SIMILARITY:** Matriz precalculada de similitud entre productos usando métodos colaborativos o de contenido

#### Módulo de soporte
- **SUPPORT_TICKETS:** Sistema de tickets con prioridad y asignación a personal de soporte
- **TICKET_MESSAGES:** Mensajes dentro del ticket para comunicación entre usuario y soporte
- **DISPUTES:** Conflictos formales entre comprador y emprendedor con resolución por admin
- **ENTREPRENEUR_RATINGS:** Calificación global del emprendedor separada de la calificación de productos

#### Módulo de Seguridad
- **SESSIONS:** Gestión de sesiones activas por dispositivo con expiración de tokens
- **AUDIT_LOGS:** Trazabilidad completa de todas las acciones críticas del sistema con valores anteriores y nuevos