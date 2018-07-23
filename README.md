---
title: Portfinder
description: Find a free port.
---

# cordova-plugin-portfinder

This plugin defines a global `portfinder` object.
Although the object is in the global scope, it is not available until after the `deviceready` event.

```js
document.addEventListener("deviceready", onDeviceReady, false);
function onDeviceReady() {
    // Get a free port, 1234 default
    portfinder.getPort(1234).then((port) => {
        console.info(port);
    }).catch((e) => {
        console.warn(e);
    });
}
```

## Installation

    cordova plugin add cordova-plugin-portfinder

## Properties

- portfinder.getPort
- portfinder.getPortWithHost

## portfinder.getPort

Get a free port. 
This method accept an optional default port as a parameter.

### Examples

```js
    portfinder.getPort().then((port) => {
        console.info(port);
    }).catch((e) => {
        console.warn(e);
    });

    portfinder.getPort(1234).then((port) => {
        console.info(port);
    }).catch((e) => {
        console.warn(e);
    });
```

## portfinder.getPortWithHost

Get a free port with a specific host address.
This method accept an optional default port as a parameter.

### Example

```js
    portfinder.getPortWithHost('192.168.1.50').then((port) => {
        console.info(port);
    }).catch((e) => {
        console.warn(e);
    });

    portfinder.getPortWithHost('192.168.1.50', 1234).then((port) => {
        console.info(port);
    }).catch((e) => {
        console.warn(e);
    });
```

## Supported Platforms

- Android
- iOS
