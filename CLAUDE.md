# CLAUDE.md

## Project Overview

This is a Flutter-based POS (Point of Sale) and Inventory Management System built for small retail businesses.

Main features:
- Product management
- Inventory management
- Stock tracking
- Billing workflow
- Dashboard analytics
- Offline-first data handling
- Firebase synchronization

The project should be treated as a production-level application.

---

# Technology Stack

## Frontend
- Flutter
- Dart
- Material 3

## State Management
- GetX

## Dependency Injection
- GetIt

## Architecture
- Clean Architecture
- Feature-based modular architecture

## Backend
- Firebase
- Firebase Authentication
- Cloud Firestore

## Local Database
- Hive
- Custom Storage Service

## Responsive Design
Supports:
- Mobile
- Tablet
- Web/Desktop

Using:
- AdaptiveLayout
- Breakpoints
- Responsive extensions

---

# Folder Architecture

The project follows this structure:
lib
├── app
│   ├── app.dart
│   └── bootstrap.dart
├── app_initializer.dart
├── core
│   ├── config
│   │   ├── constants
│   │   │   ├── categories.dart
│   │   │   └── typedefs.dart
│   │   ├── responsive
│   │   │   ├── adaptive_layout.dart
│   │   │   ├── breakpoints.dart
│   │   │   ├── device_type.dart
│   │   │   └── responsive_extension.dart
│   │   ├── routes
│   │   │   ├── app_pages.dart
│   │   │   └── app_routes.dart
│   │   └── theme
│   │       ├── app_colors.dart
│   │       ├── app_radius.dart
│   │       ├── app_spacing.dart
│   │       ├── app_text_theme.dart
│   │       └── app_theme.dart
│   ├── di
│   │   ├── init_dependencies.dart
│   │   └── init_dependencies_main.dart
│   ├── errors
│   │   └── failure.dart
│   ├── exceptions
│   │   ├── firebase_auth_exceptions.dart
│   │   ├── firebase_exception.dart
│   │   ├── format_exceptions.dart
│   │   └── platform_exceptions.dart
│   ├── extensions
│   │   ├── inventory_product_x.dart
│   │   └── stock_transactions_type_x.dart
│   ├── firebase
│   │   └── shop_firebase_service.dart
│   ├── helper
│   │   ├── bill_dashboard_extension.dart
│   │   ├── date.dart
│   │   └── generate_sku.dart
│   ├── indicators
│   │   └── progress_indicator.dart
│   ├── network
│   │   └── connection_checker.dart
│   ├── services
│   │   └── storage
│   │       └── storage_service.dart
│   ├── snackbars
│   │   └── snackbars.dart
│   └── usecases
│       └── usecases.dart
├── dummy_data.dart
├── dummy_products.dart
├── features
│   ├── authentication
│   │   ├── data
│   │   │   ├── data_source
│   │   │   │   └── authentication_remote_data_source.dart
│   │   │   └── repository_impl
│   │   │       └── authentication_repository_impl.dart
│   │   ├── domain
│   │   │   ├── repository
│   │   │   │   └── authentication_repository.dart
│   │   │   └── usecases
│   │   │       ├── login_user.dart
│   │   │       └── request_shop_registration.dart
│   │   └── presentation
│   │       ├── controller
│   │       │   ├── login_controller.dart
│   │       │   └── register_shop_controller.dart
│   │       ├── views
│   │       │   ├── login_page.dart
│   │       │   ├── mobile_layout.dart
│   │       │   ├── register_shop_page.dart
│   │       │   ├── tablet_layout.dart
│   │       │   └── web_layout.dart
│   │       └── widgets
│   │           ├── login_form.dart
│   │           └── register_shop_link.dart
│   ├── dashboard
│   │   ├── data
│   │   ├── domain
│   │   └── presentation
│   │       ├── controller
│   │       │   ├── dashboard_shell_binding.dart
│   │       │   └── dashboard_shell_controller.dart
│   │       ├── layout
│   │       │   ├── dashboard_mobile_body.dart
│   │       │   ├── dashboard_mobile_layout.dart
│   │       │   ├── dashboard_tablet_body.dart
│   │       │   ├── dashboard_tablet_layout.dart
│   │       │   ├── dashboard_web_body.dart
│   │       │   └── dashboard_web_layout.dart
│   │       ├── models
│   │       │   ├── dashboard_card_model.dart
│   │       │   └── dashboard_menu.dart
│   │       ├── pages
│   │       │   └── dashboard_page.dart
│   │       └── widgets
│   │           ├── category_pie_chart.dart
│   │           ├── chart_card.dart
│   │           ├── dashboard_drawer_navigation.dart
│   │           ├── legend_row.dart
│   │           ├── low_stocks.dart
│   │           ├── recent_transactions.dart
│   │           └── sales_line_chart.dart
│   ├── inventory
│   │   ├── data
│   │   │   ├── data_source
│   │   │   │   ├── local
│   │   │   │   │   ├── brand_local_data_source.dart
│   │   │   │   │   ├── category_local_data_source.dart
│   │   │   │   │   ├── product_local_data_source.dart
│   │   │   │   │   └── stock_local_data_source.dart
│   │   │   │   └── remote
│   │   │   │       ├── brand_remote_data_source.dart
│   │   │   │       ├── category_remote_data_source.dart
│   │   │   │       ├── product_remote_data_source.dart
│   │   │   │       └── stock_remote_data_source.dart
│   │   │   ├── models
│   │   │   │   ├── brand
│   │   │   │   │   ├── brand_model.dart
│   │   │   │   │   └── brand_model.g.dart
│   │   │   │   ├── category
│   │   │   │   │   ├── category_model.dart
│   │   │   │   │   └── category_model.g.dart
│   │   │   │   ├── product_image_model.dart
│   │   │   │   ├── product_image_model.g.dart
│   │   │   │   ├── product_model.dart
│   │   │   │   ├── product_model.g.dart
│   │   │   │   ├── product_price_model.dart
│   │   │   │   ├── product_price_model.g.dart
│   │   │   │   ├── product_settings_model.dart
│   │   │   │   ├── product_settings_model.g.dart
│   │   │   │   ├── product_tax_model.dart
│   │   │   │   ├── product_tax_model.g.dart
│   │   │   │   ├── product_variant_model.dart
│   │   │   │   ├── product_variant_model.g.dart
│   │   │   │   ├── stock
│   │   │   │   │   ├── stock_model.dart
│   │   │   │   │   └── stock_model.g.dart
│   │   │   │   ├── tax_type.dart
│   │   │   │   └── tax_type.g.dart
│   │   │   └── repository_impl
│   │   │       ├── brand_repository_impl.dart
│   │   │       ├── category_repository_impl.dart
│   │   │       ├── product_repository_impl.dart
│   │   │       └── stock_repository_impl.dart
│   │   ├── domain
│   │   │   ├── entities
│   │   │   │   ├── brand_entity.dart
│   │   │   │   ├── category_entity.dart
│   │   │   │   ├── product_entity.dart
│   │   │   │   ├── stock_batch_entity.dart
│   │   │   │   ├── stock_entity.dart
│   │   │   │   ├── stock_movement_entity.dart
│   │   │   │   ├── supplier_entity.dart
│   │   │   │   ├── unit_entity.dart
│   │   │   │   └── warehouse_entity.dart
│   │   │   ├── repositories
│   │   │   │   ├── brand_repository.dart
│   │   │   │   ├── category_repository.dart
│   │   │   │   ├── product_repository.dart
│   │   │   │   ├── stock_repository.dart
│   │   │   │   ├── supplier_repository.dart
│   │   │   │   ├── unit_repository.dart
│   │   │   │   └── warehouse_repository.dart
│   │   │   ├── usecases
│   │   │   │   ├── brand
│   │   │   │   │   ├── add_brand_usecase.dart
│   │   │   │   │   ├── delete_brand_usecase.dart
│   │   │   │   │   ├── get_brand_by_id_usecase.dart
│   │   │   │   │   ├── get_brand_or_create_usecase.dart
│   │   │   │   │   ├── get_brands_usecase.dart
│   │   │   │   │   └── update_brand_usecase.dart
│   │   │   │   ├── category
│   │   │   │   │   ├── add_category_usecase.dart
│   │   │   │   │   ├── delete_category_usecase.dart
│   │   │   │   │   ├── get_categories_usecase.dart
│   │   │   │   │   ├── get_category_id_usecase.dart
│   │   │   │   │   └── update_category_usecase.dart
│   │   │   │   ├── product
│   │   │   │   │   ├── add_product_usecase.dart
│   │   │   │   │   ├── delete_product_usecase.dart
│   │   │   │   │   ├── get_product_by_barcode_usecase.dart
│   │   │   │   │   ├── get_product_by_sku_usecase.dart
│   │   │   │   │   ├── get_product_usecase.dart
│   │   │   │   │   ├── get_products_usecase.dart
│   │   │   │   │   ├── search_products_usecase.dart
│   │   │   │   │   └── update_product_usecase.dart
│   │   │   │   └── stock
│   │   │   │       ├── create_stock_usecase.dart
│   │   │   │       ├── get_product_stocks_usecase.dart
│   │   │   │       └── get_stocks_usecase.dart
│   │   │   └── value_objects
│   │   │       ├── product_image.dart
│   │   │       ├── product_price.dart
│   │   │       ├── product_settings.dart
│   │   │       ├── product_tax.dart
│   │   │       └── product_variant.dart
│   │   └── presentation
│   │       ├── controller
│   │       │   ├── add_product_controller.dart
│   │       │   └── inventory_controller.dart
│   │       ├── views
│   │       │   ├── add_product
│   │       │   │   ├── add_product_mobile_layout.dart
│   │       │   │   ├── add_product_page.dart
│   │       │   │   ├── add_product_tablet_layout.dart
│   │       │   │   └── add_product_web_layout.dart
│   │       │   ├── inventory_page.dart
│   │       │   ├── mobile_layout.dart
│   │       │   ├── product_detail_page.dart
│   │       │   ├── tablet_layout.dart
│   │       │   └── web_layout.dart
│   │       └── widgets
│   │           ├── add_product
│   │           │   ├── add_product_textfield.dart
│   │           │   ├── field_label.dart
│   │           │   ├── image_upload_grid.dart
│   │           │   ├── product_dropdown.dart
│   │           │   ├── radio_tile.dart
│   │           │   └── section_card.dart
│   │           ├── delete_dialog.dart
│   │           ├── empty_state.dart
│   │           ├── inventory_data_table.dart
│   │           ├── inventory_filter_bar.dart
│   │           ├── inventory_header_bar.dart
│   │           ├── inventory_product_card.dart
│   │           ├── inventory_search_bar.dart
│   │           ├── inventory_stat_panel.dart
│   │           ├── loading_widget.dart
│   │           └── status_chip.dart
│   └── user
│       ├── data
│       │   ├── data_source
│       │   │   ├── user_local_data_source.dart
│       │   │   └── user_remote_data_source.dart
│       │   ├── models
│       │   │   ├── firebase_config_model.dart
│       │   │   ├── firebase_config_model.g.dart
│       │   │   ├── shop_model.dart
│       │   │   ├── shop_model.g.dart
│       │   │   ├── user_model.dart
│       │   │   └── user_model.g.dart
│       │   └── repository_impl
│       │       └── user_repository_impl.dart
│       ├── domain
│       │   ├── entity
│       │   │   ├── shop_entity.dart
│       │   │   ├── user_entity.dart
│       │   │   └── user_entity.g.dart
│       │   ├── repository
│       │   │   └── user_repository.dart
│       │   └── usecases
│       │       ├── get_shop_by_id.dart
│       │       └── get_user_by_id.dart
│       └── presentation
│           ├── controller
│           │   └── user_controller.dart
│           └── views
│               └── fetching_details_page.dart
├── firebase_options.dart
└── main.dart


Every feature must maintain separation of concerns.

---

# Clean Architecture Rules

## Data Layer


Responsibilities:
- Firebase operations
- Local database operations
- API communication
- Model conversion

Rules:
- Data layer must not contain UI logic.
- Datasources only handle data fetching/storage.
- Repository implementations connect datasources with domain repositories.
- Models should map correctly with entities.

---

## Domain Layer


Responsibilities:
- Business rules
- Application logic
- Pure Dart objects

Rules:
- No Flutter imports.
- No Firebase dependency.
- No UI dependency.
- Entities are the source of truth.

---

## Presentation Layer


Responsibilities:
- UI rendering
- User interaction
- State management

Rules:
- Controllers handle UI state.
- Widgets should be reusable.
- Avoid business logic inside widgets.
- Pages should remain clean.

---

# Current Feature Structure

## Authentication

Handles:
- User login
- Shop registration
- Authentication flow


## Dashboard

Handles:
- Sales overview
- Inventory statistics
- Charts
- Recent transactions


## Inventory

Main module.

Handles:

- Products
- Categories
- Brands
- Stock
- Suppliers
- Units
- Warehouses



---

# UI Guidelines

Follow existing design system.

Use:
core/config/theme/

For:

- Colors
- Spacing
- Radius
- Typography

Never hardcode:

- Colors
- Padding
- Border radius
- Text styles


---

# Responsive Guidelines

Every major screen must support:
Mobile
Tablet
Web/Desktop


Follow existing pattern:


views/

├── mobile_layout.dart
├── tablet_layout.dart
└── web_layout.dart
Use:

- AdaptiveLayout
- DeviceType
- ResponsiveExtension

Do not create separate logic for different screen sizes.

---

# GetX Guidelines

Controllers should handle:

- Observable variables
- Loading states
- Error states
- User actions
- Usecase calls

Avoid:

- Calling repositories directly from widgets.
- Large controllers with unrelated responsibilities.

---

# Widget Guidelines

When creating widgets:

- Prefer reusable widgets.
- Extract complex UI.
- Use const constructors.
- Follow existing naming style.
- Match current Material 3 design.

Before creating a new widget:
- Check if similar widget already exists.
- Reuse existing components.

---

# Code Quality Rules

Always:

- Use null safety.
- Use final wherever possible.
- Use const constructors.
- Keep files focused.
- Follow existing naming conventions.

Avoid:

- Duplicate code.
- Duplicate widgets.
- Temporary hacks.
- Breaking architecture.

---

# Inventory Development Rules

Inventory is the core module.

When modifying inventory:

Understand existing:

- ProductEntity
- ProductModel
- ProductPrice
- ProductTax
- ProductSettings
- ProductVariant
- ProductImage
- Stock entities

Maintain compatibility with:

- Hive storage
- Firebase sync
- Offline support

---

# Testing Guidelines

When adding functionality consider:

- Usecase tests
- Repository tests
- Datasource tests
- Controller tests

Follow existing testing patterns.

---

# Claude Code Working Rules

Before making any major changes:

1. Analyze existing implementation.
2. Explain your approach.
3. List files that will be changed.
4. Wait for confirmation before large refactors.

When creating UI:

- Use existing theme.
- Match current design language.
- Keep responsive support.
- Use reusable widgets.
- Do not create dummy architecture.

When fixing bugs:

- Find the root cause.
- Provide a proper solution.
- Avoid quick hacks.

---

# Current Development Focus

Priority areas:

1. Inventory redesign
2. Product detail screen
3. Add stock workflow
4. Product management
5. POS billing workflow
6. Offline-first improvements

The goal is a scalable, maintainable retail POS application.
