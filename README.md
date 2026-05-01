# Alfabet

Репозиторий на GitHub: **https://github.com/unomat20b/alphabet**

После пуша в `main` можно включить автодеплой веб-сборки на Timeweb (`…/public_html/alphabet/`). Нужны те же секреты, что и у `intellectshop.frontend`: `TIMEWEB_SSH_KEY`, `TIMEWEB_HOST`, `TIMEWEB_USER`, `TIMEWEB_REMOTE_PATH` (путь к **корню** `public_html`, без `/alphabet`). Workflow: `.github/workflows/deploy-web-timeweb.yml`.

---

Alfabet is a Flutter application for experimenting with different alphabets. You can choose Georgian or Hindi and transform Russian text into letters of the selected script.
Full letter lists are stored in `lib/data/alphabets/georgian_alphabet.dart` and `lib/data/alphabets/hindi_alphabet.dart`.
Button dictionaries with Russian phonetic equivalents reside in `lib/data/alphabets/georgian_button_map.dart` and `lib/data/alphabets/hindi_button_map.dart`.

## Repository structure

* `lib/` – application code
  * `app.dart`, `main.dart` – app entry points
  * `data/` – alphabet definitions and layouts
  * `logic/` – text transformation helpers
  * `screens/` – app screens
  * `widgets/` – reusable UI components
* `test/` – unit tests for the logic and widgets
* Platform folders (`android`, `ios`, `linux`, `macos`, `windows`, `web`) – build targets

## Development notes

Whenever something is fixed or adjusted, the change is kept in version control and important updates are noted in this README for easier navigation of the project history.

## Running the app

1. Ensure you have Flutter installed.
2. Run `flutter pub get` to fetch dependencies.
3. Launch with `flutter run` for your desired platform (mobile, desktop or web).

Tests can be executed with `flutter test`.

### Building for Telegram

Run `flutter build web` to create the web build in `build/web`. The generated
`index.html` already initializes the Telegram WebApp API so the app works as a
mini application when hosted over HTTPS and linked from your bot.

**Important:** the app uses the path URL strategy (see `lib/main.dart`). When
served from a static host you must configure request rewriting so that every
route points to `index.html`. Without this, navigation in the web build or
Telegram mini app may result in 404 errors.

## Запуск и сборка для Web (Chrome)

### Быстрый запуск в браузере (Chrome)

```sh
flutter run -d chrome
```

### Сборка релизной версии для деплоя

```sh
flutter build web
```

Готовые файлы появятся в папке `build/web`. Их можно заливать на сервер для работы через HTTPS и в Telegram Mini App.

### Запуск в режиме профилирования (profile)

```sh
flutter run -d chrome --profile
```

### Запуск в режиме разработки (hot reload)

```sh
flutter run -d chrome --debug
```

### Локальный сервер для проверки production-сборки

```sh
flutter build web
flutter serve
```

или с помощью любого статического сервера, например:

```sh
cd build/web
python3 -m http.server 8080
```

---

**Важно:**
- Для работы в Telegram Mini App приложение должно быть доступно по HTTPS.
- Если деплоите в подпапку, укажите правильный `<base href="/your-subfolder/">` в `web/index.html`.
- Для корректной работы роутинга на сервере настройте отдачу `index.html` для всех путей (SPA rewrite).

## Planned features

- More alphabets and language options.
- Ability to save user preferences.
- Support for running the app as a Telegram mini app.

