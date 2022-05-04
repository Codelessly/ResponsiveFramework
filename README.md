![Screenshots](packages/Responsive%20Cover.png)
# Responsive Framework
[![Flutter Responsive](https://img.shields.io/badge/flutter-responsive-brightgreen.svg?style=flat-square)](https://github.com/Codelessly/ResponsiveFramework) [![Pub release](https://img.shields.io/pub/v/responsive_framework.svg?style=flat-square)](https://pub.dev/packages/responsive_framework) [![GitHub Release Date](https://img.shields.io/github/release-date/Codelessly/ResponsiveFramework.svg?style=flat-square)](https://github.com/Codelessly/ResponsiveFramework) [![GitHub issues](https://img.shields.io/github/issues/Codelessly/ResponsiveFramework.svg?style=flat-square)](https://github.com/Codelessly/ResponsiveFramework/issues) [![GitHub top language](https://img.shields.io/github/languages/top/Codelessly/ResponsiveFramework.svg?style=flat-square)](https://github.com/Codelessly/ResponsiveFramework) [![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/Codelessly/ResponsiveFramework.svg?style=flat-square)](https://github.com/Codelessly/ResponsiveFramework) [![Awesome Flutter](https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square)](https://github.com/Solido/awesome-flutter) [![Libraries.io for GitHub](https://img.shields.io/librariesio/github/Codelessly/ResponsiveFramework.svg?style=flat-square)](https://libraries.io/github/Codelessly/ResponsiveFramework) [![License](https://img.shields.io/badge/License-BSD%200--Clause-orange.svg?style=flat-square)](https://opensource.org/licenses/0BSD)

![Screenshots](packages/Responsive%20Demo.gif)

> ### Responsiveness made simple

Responsive Framework adapts your UI to different screen sizes automatically. Create your UI once and have it display pixel perfect on mobile, tablet, and desktop!

### The Problem
Supporting multiple display sizes often means recreating the same layout multiple times. Under the traditional _Bootstrap_ approach, building responsive UI is time consuming, frustrating and repetitive. Furthermore, getting everything pixel perfect is near impossible and simple edits take hours.

![Screenshots](packages/Bad%20Viewport%20Selector%20Animated.gif)

### The Solution
Use Responsive Framework to automatically scale your UI.

> **ResponsiveBreakpoint.autoScale(600);**

## Demo

### [Minimal Website](https://gallery.codelessly.com/flutterwebsites/minimal/?utm_medium=link&utm_campaign=demo)

A demo website built with the Responsive Framework. [View Code](https://github.com/Codelessly/FlutterMinimalWebsite)

### [Flutter Website](https://gallery.codelessly.com/flutterwebsites/flutterwebsite/?utm_medium=link&utm_campaign=demo)

The flutter.dev website recreated in Flutter. [View Code](https://github.com/Codelessly/FlutterWebsite)

### [Pub.dev Website](https://gallery.codelessly.com/flutterwebsites/pub/?utm_medium=link&utm_campaign=demo)

The pub.dev website recreated in Flutter. [View Code](https://github.com/Codelessly/FlutterPubWebsite)

## Quick Start

[![Pub release](https://img.shields.io/pub/v/responsive_framework.svg?style=flat-square)](https://pub.dev/packages/responsive_framework)

Import this library into your project:

```yaml
responsive_framework: ^latest_version
```

Add `ResponsiveWrapper.builder` to your MaterialApp or CupertinoApp.
```dart
import 'package:responsive_framework/responsive_framework.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => ResponsiveWrapper.builder(
          child,
          maxWidth: 1200,
          minWidth: 480,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.resize(480, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.resize(1000, name: DESKTOP),
          ],
          background: Container(color: Color(0xFFF5F5F5))),
      initialRoute: "/",
    );
  }
}
```
That's it!

## AutoScale

![Screenshots](packages/Scale%20Resize%20Comparison.gif)

AutoScale shrinks and expands your layout *proportionally*, preserving the exact look of your UI.
This eliminates the need to manually adapt layouts to mobile, tablet, and desktop.

```dart
ResponsiveBreakpoint.autoScale(600);
```

Flutter's default behavior is resize which Responsive Framework respects. AutoScale is off by default and can be enabled at breakpoints by setting `autoScale` to `true`.

## Breakpoints

![Screenshots](packages/Device%20Preview.gif)

Breakpoints control responsive behavior at different screen sizes.

```dart
ResponsiveWrapper(
    child,
    breakpoints: [
        ResponsiveBreakpoint.resize(600, name: MOBILE),
        ResponsiveBreakpoint.autoScale(800, name: TABLET),
        ResponsiveBreakpoint.autoScale(1200, name: DESKTOP),
    ],
)
```
Breakpoints give you fine-grained control over how your UI displays.

## Introductory Concepts

These concepts helps you start using the Responsive Framework and build an responsive app quickly.

### Scale vs Resize

Flutter's default behavior is to resize your layout when the screen dimensions change. Resizing a layout stretches it in the direction of an unconstrained width or height. Any constrained dimension stays fixed which is why mobile app UIs look tiny on desktop. The following example illustrates the difference between resizing and scaling.

![Screenshots](packages/AppBar%20Scale%20vs%20Resize%20Comparison.png)

An AppBar widget looks correct on a phone. When viewed on a desktop however, the AppBar is too short and the title looks too small.
Here is what happens under each behavior: 
1. Resizing (default) - the AppBar's width is double.infinity so it stretches to fill the available width. The Toolbar height is fixed and stays 56dp.
2. Scaling - the AppBar's width stretches to fill the available width. The height scales proportionally using an aspect ratio automatically calculated from the nearest `ResponsiveBreakpoint`. As the width increases, the height increases proportionally.

When scaled, the AppBar looks correct on desktop, up to a certain size. Once the screen becomes too wide, the AppBar starts to appear too large. This is where breakpoints come in.

### Breakpoint Configuration

To adapt to a wide variety of screen sizes, set breakpoints to control responsive behavior.

```dart
ResponsiveWrapper(
    child,
    maxWidth: 1200,
    minWidth: 480,
    defaultScale: true,
    breakpoints: [
        ResponsiveBreakpoint.resize(480, name: MOBILE),
        ResponsiveBreakpoint.autoScale(800, name: TABLET),
        ResponsiveBreakpoint.resize(1000, name: DESKTOP),
        ResponsiveBreakpoint.autoScale(2460, name: '4K'),
    ],
)
```

An arbitrary number of breakpoints can be set. Resizing/scaling behavior can be mixed and matched.
- below 480: resize on small screens to avoid cramp and overflow errors.
- 480-800: resize on phones for native widget sizes.
- 800-1000: scale on tablets to avoid elements appearing too small.
- 1000+: resize on desktops to use available space. 
- 2460+: scale on extra large 4K displays so text is still legible and widgets are not spaced too far apart.

## Additional Resources

### Resocoder Tutorial

The wonderful people at Resocoder created a great tutorial video and article walking through the usage of the Responsive Framework at the link below.

[View Responsive Framework Tutorial](https://resocoder.com/2021/10/03/create-responsive-flutter-apps-with-minimal-effort/)

### Project Wiki

No project wiki exists yet unfortunately. That means this is an opportunity for you to create and maintain the wiki for one of the most popular Flutter packages. This package needs **your** help with documentation!

Please reach out via the contact links below if you are interested.

## About

Responsive Framework was created out of a desire for a better way to manage responsiveness. The ability to automatically adapt UI to different sizes opens up a world of possibilities. Here at Codelessly, we're building a Flutter app UI and website builder, development tools, and UI templates to increase productivity. If that sounds interesting, you'll want to subscribe to updates below 😎

Responsive Framework is licensed under Zero-Clause BSD and released as Emailware. If you like this project or it helped you, please subscribe to updates. Although it is not required, you might miss the goodies we share!

<a href="https://codelessly.com/?utm_medium=banner&utm_campaign=newsletter_subscribe" target="_blank"><img src="https://raw.githubusercontent.com/Codelessly/ResponsiveFramework/master/packages/Email%20Newsletter%20Signup.png"></a>

## Badges 🏆

Now you can proudly display the time and headache saved by using Responsive Framework with a supporter's badge.

[![Pub release](https://img.shields.io/badge/flutter-responsive-brightgreen.svg?style=flat-square)](https://github.com/Codelessly/ResponsiveFramework) 

```
[![Flutter Responsive](https://img.shields.io/badge/flutter-responsive-brightgreen.svg?style=flat-square)](https://github.com/Codelessly/ResponsiveFramework)
```
<img alt="Built Responsive" src="https://raw.githubusercontent.com/Codelessly/ResponsiveFramework/master/packages/Built%20Responsive%20Badge.png"/>

```html
<a href="https://github.com/Codelessly/ResponsiveFramework">
  <img alt="Built Responsive"
       src="https://raw.githubusercontent.com/Codelessly/ResponsiveFramework/master/packages/Built%20Responsive%20Badge.png"/>
</a>
```
<img alt="Built with Responsive Framework" src="https://raw.githubusercontent.com/Codelessly/ResponsiveFramework/master/packages/Built%20with%20Responsive%20Badge.png"/>

```html
<a href="https://github.com/Codelessly/ResponsiveFramework">
  <img alt="Built with Responsive Framework"
       src="https://raw.githubusercontent.com/Codelessly/ResponsiveFramework/master/packages/Built%20with%20Responsive%20Badge.png"/>
</a>
```

## Contributors ❤️

**Design:** 
* [Ray Li](https://github.com/searchy2)

**Development:** 
* [Ray Li](https://github.com/searchy2)
* [Spencer Lindemuth](https://github.com/SpencerLindemuth)
* *add yourself here by contributing*

**Sponsor:** [Codelessly - Flutter App UI and Website Builder](https://codelessly.com/?utm_medium=link&utm_campaign=direct)

<a href="mailto:ray@codelessly.com">
  <img alt="Codelessly Email"
       src="https://lh3.googleusercontent.com/yN_m90WN_HSCohXdgC2k91uSTk9dnYfoxTYwG_mv_l5_05dV2CzkQ1B6rEqH4uqdgjA=w96" />
</a>
<a href="https://codelessly.com/?utm_medium=icon&utm_campaign=direct">
  <img alt="Codelessly Website"
       src="https://lh3.googleusercontent.com/YmMGcgeO7Km9-J9vFRByov5sb7OUKetnKs8pTi0JZMDj3GVJ61GMTcTlHB7u9uHDHag=w96" />
</a>
<a href="https://twitter.com/BuildCodelessly">
  <img alt="Codelessly Twitter"
       src="https://lh3.ggpht.com/lSLM0xhCA1RZOwaQcjhlwmsvaIQYaP3c5qbDKCgLALhydrgExnaSKZdGa8S3YtRuVA=w96" />
</a>
<a href="https://github.com/Codelessly">
  <img alt="Codelessly GitHub"
       src="https://lh3.googleusercontent.com/L15QqmKK7Vl-Ag1ZxaBqNQlXVEw58JT2BDb-ef5t2eboDh0pPSLjDgi3-aQ3Opdhhyk=w96" />
</a>
<br></br>

Flutter is a game-changing technology that will revolutionize not just development, but software itself. A big thank you to the Flutter team for building such an amazing platform 💙 

<a href="https://github.com/flutter/flutter">
  <img alt="Flutter"
       src="https://raw.githubusercontent.com/Codelessly/ResponsiveFramework/master/packages/Flutter%20Logo%20Banner.png" />
</a>
 
## License

    BSD Zero Clause License

    Copyright © 2020 Codelessly

    Permission to use, copy, modify, and/or distribute this software for any
    purpose with or without fee is hereby granted.

    THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
    REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
    AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
    INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
    LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
    OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
    PERFORMANCE OF THIS SOFTWARE.
