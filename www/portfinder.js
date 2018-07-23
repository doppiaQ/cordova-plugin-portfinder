
var argscheck = require('cordova/argscheck');
var exec = require('cordova/exec');

var PLUGIN_NAME = 'Portfinder';

var Portfinder = {
    /**
     * Get a free port
     *
     * @param {number} defaultPort The default port to use available. (OPTIONAL)
     */
    getPort: function (defaultPort) {
        var args = arguments;
        return new Promise(function(resolve, reject){
            try {
                argscheck.checkArgs('N', `${PLUGIN_NAME}.getPort`, args);
                exec(function(port){
                    resolve(parseInt(port));
                }, reject, PLUGIN_NAME, 'getPort', [`${defaultPort}`]);
            } catch (error) {
                reject(error);
            }
        });
    },

    /**
     * Get a free port with host
     *
     * @param {string} host The host you want to use.
     * @param {number} defaultPort The default port to use available. (OPTIONAL)
     */
    getPortWithHost: function (host, defaultPort) {
        var args = arguments;
        return new Promise(function(resolve, reject){
            try {
                argscheck.checkArgs('sN', `${PLUGIN_NAME}.getPortWithHost`, args);
                exec(function(port){
                    resolve(parseInt(port));
                }, reject, PLUGIN_NAME, 'getPortWithHost', [host, `${defaultPort}`]);
            } catch (error) {
                reject(error);
            }
        });
    }
}

module.exports = Portfinder;
