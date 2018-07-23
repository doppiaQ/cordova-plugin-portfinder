// Type definitions for Group4business Cordova Portfinder plugin
// Project: https://github.com/LabDeve/cordova-plugin-portfinder.git

/**
 * This plugin defines a global portfinder object.
 * Although the object is in the global scope, it is not available until after the deviceready event.
 */
interface Portfinder {
    /** Get a free port. */
    getPort: (defaultPort?: number) => Promise<number>
    /** Get a free port with host. */
    getPortWithHost: (host: string, defaultPort?: number) => Promise<number>
}

declare var portfinder: Portfinder;