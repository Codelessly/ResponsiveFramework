![Screenshots](images/Responsive Cover.png)
# Responsive Framework
[![Pub release](https://img.shields.io/badge/flutter-responsive-brightgreen.svg?style=flat-square)](https://github.com/Codelessly/ResponsiveFramework) [![Pub release](https://img.shields.io/pub/v/responsive_Framework.svg?style=flat-square)](https://pub.dev/packages/responsive_Framework) [![GitHub Release Date](https://img.shields.io/github/release-date/Codelessly/ResponsiveFramework.svg?style=flat-square)](https://github.com/Codelessly/ResponsiveFramework) [![GitHub issues](https://img.shields.io/github/issues/Codelessly/ResponsiveFramework.svg?style=flat-square)](https://github.com/Codelessly/ResponsiveFramework/issues) [![GitHub top language](https://img.shields.io/github/languages/top/Codelessly/ResponsiveFramework.svg?style=flat-square)](https://github.com/Codelessly/ResponsiveFramework)

Responsive Framework adapts your UI to different screen sizes automatically. Create your UI once and have it display correctly on mobile, tablet, and desktop!
### The Problem
Supporting multiple display sizes often means recreating the same layout multiple times with the traditional _Bootstrap_ approach. This is time consuming, frustrating and repetitive work. Furthermore, getting your designs pixel perfect is near impossible and editing becomes a nightmare.
### The Solution
Use Responsive Framework to automatically resize or scale your UI based on _breakpoints_.

```dart
ResponsiveWrapper(
    child,
    breakpoints: [
        ResponsiveBreakpoint(breakpoint: 600, name: MOBILE),
        ResponsiveBreakpoint(breakpoint: 800, name: TABLET),
        ResponsiveBreakpoint(breakpoint: 1200, name: DESKTOP),
    ],
)
```


## Resize vs Scale

To easily adapt to a wide variety of screen sizes, set breakpoints to proportionally scale or resize a layout.

> ResponsiveBreakpoint(breakpoint: 600, **scale: true**)

This eliminates the need to manually adapt layouts to mobile, tablet, and desktop.

To understand the difference between resizing and scaling, take the following example. 
An AppBar widget looks correct on a phone. When viewed on a desktop however, the AppBar is too short and the title looks too small. This is because Flutter does not scale widgets by default. 
Here is what happens with each behavior: 
1. Resizing (default) - the AppBar's width is double.infinity so it stretches to fill the available width. The Toolbar height is fixed and stays 56dp.
2. Scaling - the AppBar's width stretches to fill the available width. The height scales proportionally using an aspect ratio automatically calculated from the nearest `ResponsiveBreakpoint`. As the width increases, the height increases proportionally.

## Setting Breakpoints

An arbitrary number of breakpoints can be set. Resizing/scaling behavior can be mixed and matched as below.
 - 1400+: scale on extra large 4K displays so text is still legible and widgets are not spaced too far apart.
 - 1400-800: resize on desktops to use available space. 
 - 800-600: scale on tablets to avoid elements appearing too small.
 - 600-350: resize on phones for native widget sizes.
 - below 350: resize on small screens to avoid cramp and overflow errors.\
 
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