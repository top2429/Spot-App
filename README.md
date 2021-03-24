# Spot

```sql
CREATE TABLE IF NOT EXISTS public.users (
  id uuid references auth.users not null primary key,
  name varchar(18) UNIQUE,
  description varchar(320),
  image_url text,
  
  constraint username_length check (char_length(username) >= 4)
);
comment on table public.users is 'Holds all of users profile information';

alter table public.users enable row level security;
create policy "Public profiles are viewable by everyone." on profiles for select using (true);
create policy "Users can insert their own profile." on profiles for insert with check (auth.uid() = id);
create policy "Users can update own profile." on profiles for update using (auth.uid() = id);


CREATE TABLE IF NOT EXISTS public.posts (
  id uuid not null primary key DEFAULT uuid_generate_v4 (),
  creator_uid uuid references public.users not null,
  created_at timestamp with time zone default timezone('utc' :: text, now()) not null,
  video_url text,
  thumbnail_url text,
  gif_url text,
  description varchar(320),
  location geography(POINT)
);
comment on table public.posts is 'Holds all the video posts.';

CREATE TABLE IF NOT EXISTS public.comments (
  id uuid not null primary key,
  post_id uuid references public.posts not null,
  creator_uid uuid references public.users not null,
  created_at timestamp with time zone default timezone('utc' :: text, now()) not null,
  text varchar(320)
);
comment on table public.comments is 'Holds all of the comments created by the users.';

CREATE TABLE IF NOT EXISTS public.likes (
    id uuid not null primary key,
    post_id uuid references public.posts not null,
    creator_uid uuid references public.users not null,
    created_at timestamp with time zone default timezone('utc' :: text, now()) not null
);
comment on table public.likes is 'Holds all of the like data created by thee users.';

CREATE TABLE IF NOT EXISTS public.hashtags (
    id uuid not null primary key,
    text varchar(120) UNIQUE,
    created_at timestamp with time zone default timezone('utc' :: text, now()) not null
);
comment on table public.hashtags is 'Holds list of hashtags. ';

CREATE TABLE IF NOT EXISTS public.posts_hashtags (
    id uuid not null primary key,
    video_id uuid references public.posts not null,
    hashtag_id uuid references public.hashtags not null
);
comment on table public.posts_hashtags is 'Holds relationships between posts and hashtags';

CREATE TABLE IF NOT EXISTS public.follow (
    following_user_id uuid references auth.users not null,
    followed_user_id uuid references auth.users not null,
    followed_at timestamp with time zone default timezone('utc' :: text, now()) not null,
    PRIMARY KEY (following_user_id, followed_user_id)
);
comment on table public.follow is 'Creates follow follower relationships.';
```

[![Very Good Ventures][logo]][very_good_ventures_link]

Developed with 💙 by [Very Good Ventures][very_good_ventures_link] 🦄

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

A Very Good Flutter Starter Project created by the [Very Good Ventures Team][very_good_ventures_link].

Generated by the [Very Good CLI][very_good_cli_link] 🤖

---

## Getting Started 🚀

This project contains 3 flavors:

- development
- staging
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```

_\*Spot works on iOS, Android, and Web._

---

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---

## Working with Translations 🌐

This project relies on [flutter_localizations][flutter_localizations_link] and follows the [official internationalization guide for Flutter][internationalization_link].

### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. Then add a new key/value and description

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. Use the new string

```dart
import 'package:spot/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include the new locale.

```xml
    ...

    <key>CFBundleLocalizations</key>
	<array>
		<string>en</string>
		<string>es</string>
	</array>

    ...
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. Add the translated strings to each `.arb` file:

`app_en.arb`

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

`app_es.arb`

```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    }
}
```

[coverage_badge]: coverage_badge.svg
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logo]: https://raw.githubusercontent.com/VeryGoodOpenSource/very_good_analysis/main/assets/vgv_logo.png
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
[very_good_ventures_link]: https://verygood.ventures/?utm_source=github&utm_medium=banner&utm_campaign=core
