# 🛠️ Seafood Store Tools & Editing Guide — ٹولز گائیڈ

یہ گائیڈ ان تمام ٹولز اور پیکجز کی تفصیل فراہم کرتی ہے جو اس ایپ میں استعمال ہوئے ہیں، اور یہ بھی بتاتی ہے کہ انہیں کیسے تبدیل (Edit) کیا جا سکتا ہے۔

---

## 📦 پیکجز کا تعارف / Packages Introduction

### 1. Provider (State Management)
- **اردو**: یہ ایپ میں "کارٹ" اور "تھیم" کو مینج کرنے کے لیے استعمال ہوتا ہے۔
- **English**: Used for state management, specifically for cart logic and theme handling.
- **How to Edit**: 
    - `lib/providers/cart_provider.dart` میں جا کر آپ کارٹ میں آئٹم شامل کرنے یا ڈیلیٹ کرنے کی لاجک بدل سکتے ہیں۔

### 2. Google Fonts
- **اردو**: ٹیکسٹ کو خوبصورت بنانے کے لیے "Poppins" فونٹ کا استعمال کیا گیا ہے۔
- **English**: Implements professional typography using the Poppins font family.
- **How to Edit**: 
    - فونٹ بدلنے کے لیے `lib/theme/app_theme.dart` میں `GoogleFonts.poppins()` کو کسی دوسرے فونٹ (جیسے `lato`) سے بدل دیں۔

### 3. Dio (Network Service)
- **اردو**: یہ مستقبل میں انٹرنیٹ سے ڈیٹا لانے کے لیے استعمال ہوگا۔
- **English**: Ready-to-use HTTP client for future REST API integration.
- **How to Edit**: 
    - جب آپ اصلی بیک اینڈ جوڑیں گے تو `lib/services/mock_api_service.dart` میں Dio کا استعمال کرتے ہوئے `get` ریکویسٹ لکھیں گے۔

### 4. Animate Do & Staggered Animations
- **اردو**: ایپ میں داخل ہوتے وقت جو سموتھ اینیمیشنز نظر آتی ہیں وہ ان کی وجہ سے ہیں۔
- **English**: Provides smooth fade-in, slide, and stagger loading effects for a premium feel.
- **How to Edit**: 
    - سکرینز پر `FadeInUp` یا `BounceIn` جیسے ویجیٹس کو تبدیل کر کے اینیمیشن کا انداز بدل سکتے ہیں۔

### 5. Carousel Slider
- **اردو**: ہوم سکرین پر چلنے والے بینرز (Banners) کے لیے۔
- **English**: Handles the sliding banners and product carousels on the home screen.
- **How to Edit**: 
    - `lib/screens/home_screen.dart` میں سلائیڈر کی اسپیڈ اور آئٹمز کی تعداد بدلی جا سکتی ہے۔

---

## 🛠️ ہاس تبدیلیاں / Essential Customizations

### 🐟 مصنوعات (Products) کو کیسے بدلیں؟
اگر آپ نئی مچھلی یا کوئی اور پراڈکٹ شامل کرنا چاہتے ہیں یا پرانی کی قیمت بدلنا چاہتے ہیں:
1. فائل اوپن کریں: `lib/services/mock_api_service.dart`
2. `products` لسٹ میں جا کر `SeafoodProduct` کا ڈیٹا ایڈٹ کریں۔
3. آپ تصویر کا لنک (`image`), قیمت (`price`), اور نام (`name`) بدل سکتے ہیں۔

### 🎨 رنگ اور ڈیزائن (Colors & Design)
ایپ کی لہروں جیسے رنگ بدلنے کے لیے:
1. فائل اوپن کریں: `lib/theme/app_theme.dart`
2. وہاں موجود `primaryColor` (جو کہ گہرا نیلا/سمندری رنگ ہے) کو اپنے برانڈ کے مطابق بدل دیں۔

### 🛒 کارٹ اور چیک آؤٹ (Cart & Checkout)
اگر آپ چیک آؤٹ کے مراحل بدلنا چاہتے ہیں:
1. فائل: `lib/screens/checkout_flow.dart`
2. یہاں آپ ایڈریس فارم یا پیمنٹ آپشنز میں نئی فیلڈز شامل کر سکتے ہیں۔

---

## 🗺️ پروجیکٹ کا ڈھانچہ / File Structure

```
seafood_store_app/
├── lib/
│   ├── main.dart            # ایپ کا آغاز
│   ├── models/              # ڈیٹا سٹرکچر (Product, Category)
│   ├── providers/           # کارٹ مینجمنٹ (State)
│   ├── screens/             # تمام سکرینز (Home, Details, Cart)
│   ├── services/            # ڈیٹا سروس (Mock API)
│   ├── theme/               # رنگ اور فونٹس
│   └── widgets/             # چھوٹے دوبارہ استعمال ہونے والے بٹن/کارڈز
```

---

**Author / مصنف**: Zeeshan  
**Update Note**: کسی بھی بڑی تبدیلی سے پہلے `pubspec.yaml` میں ورژن چیک کر لیں۔
