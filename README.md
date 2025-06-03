# Medialab1HERFlutter

📦 Opleverdocument – Valpreventie App in Flutter
🧍‍♀️ Doel van de applicatie
Deze mobiele applicatie is ontwikkeld ter ondersteuning van ouderen bij valpreventie. De app gebruikt de camera om lichaamshoudingen te herkennen en geeft feedback bij risicovolle situaties.

De app is gebouwd in Flutter en getest op Android. De ontwikkeling voldoet aan de volgende oplevercriteria:

Gebruik van een nieuwe techniek: Flutter

Getest met eindgebruikers

Documentatie voor installatie en oplevering (dit bestand)

📁 Projectinformatie
Naam project: Valpreventie App

Framework: Flutter

Ontwikkelomgeving: Android Studio

Platform: Android (met ondersteuning voor iOS via Flutter)

Camera & ML: Pose-detectie met TensorFlow Lite

⚙️ Installatiehandleiding
🔧 Benodigdheden
Android Studio (laatste versie)

Flutter SDK (minimaal versie 3.x)

Android emulator of fysiek Android-apparaat

Git geïnstalleerd

Eventueel: Xcode voor iOS-builds (optioneel)

📥 Stappen
Clone het project

bash
Kopiëren
Bewerken
git clone https://github.com/jouwgebruikersnaam/valpreventie-app.git
cd valpreventie-app
Open het project in Android Studio

Open Android Studio → "Open an existing project" → selecteer de map valpreventie-app.

Installeer dependencies Open de terminal binnen Android Studio en voer uit:

bash
Kopiëren
Bewerken
flutter pub get
Run de app

Selecteer een emulator of verbonden Android-toestel.

Klik op ▶️ Run of voer uit:

bash
Kopiëren
Bewerken
flutter run
Camera permissies

Zorg ervoor dat de app toestemming krijgt om de camera te gebruiken.

Deze zijn reeds opgenomen in het AndroidManifest.xml.

📈 Toekomstige uitbreidingen
Inbouwen van waarschuwingen of meldingen bij gevaarlijke houdingen

Uitbreiding met meer houdingscategorieën

Verbinden met zorgdashboards of databases

iOS-ondersteuning testen op Apple-apparaten


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
