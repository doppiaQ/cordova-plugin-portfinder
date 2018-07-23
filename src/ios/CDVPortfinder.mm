//
//  CDVPortfinder.mm
//  Cordova Portfinder Plugin
//
//  Created by Emanuele on 23/07/18.
//  Copyright © 2018 Group4Business. All rights reserved.
//

#import <sys/socket.h>
#import <arpa/inet.h>

#import <Cordova/CDV.h>
#import "CDVPortfinder.h"

#define ANY_INTERFACE @"0.0.0.0"

@interface CDVPortfinder () {}
@end

@implementation CDVPortfinder

#pragma mark - Cordova Methods

- (void)getPort:(CDVInvokedUrlCommand*)command
{
    NSString* defPort = [command.arguments objectAtIndex:0];

    if (defPort && ![defPort isEqualToString:@"undefined"]) {
        [CDVPortfinder getPortWithDefaultPort:[defPort intValue] host:[ANY_INTERFACE UTF8String] completionHandler:^(int port) {
            [self cdvSendGetPortResult:command port:port];
        }];
    } else {
        [CDVPortfinder getPortWithHost:[ANY_INTERFACE UTF8String] completionHandler:^(int port) {
            [self cdvSendGetPortResult:command port:port];
        }];
    }
}

- (void)getPortWithHost:(CDVInvokedUrlCommand*)command
{
    NSString* host = [command.arguments objectAtIndex:0];
    NSString* defPort = [command.arguments objectAtIndex:1];

    if (defPort && ![defPort isEqualToString:@"undefined"]) {
        [CDVPortfinder getPortWithDefaultPort:[defPort intValue] host:[host UTF8String] completionHandler:^(int port) {
            [self cdvSendGetPortResult:command port:port];
        }];
    } else {
        [CDVPortfinder getPortWithHost:[host UTF8String] completionHandler:^(int port) {
            [self cdvSendGetPortResult:command port:port];
        }];
    }
}

- (void)cdvSendGetPortResult:(CDVInvokedUrlCommand*)command port:(int)port
{
    CDVPluginResult* pluginResult = nil;
    if(port < 0){
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Port not found..."];
    }else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:port];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark - Static Methods

+(int)getPortWithHost:(const char *)host{
    return [CDVPortfinder getPortWithDefaultPort:1024 host:host];
}


+(int)getPortWithDefaultPort:(int)port host:(const char *)host{
    int maxPort = port + 20;
    BOOL found = false;
    while (!(found = [CDVPortfinder testSocketServerWithHost:host port:port]) && (port += 2) < maxPort) {};
    return found? port : -1;
}


+(void)getPortWithHost:(const char *)host completionHandler:(void (^)(int port))completionHandler{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        completionHandler([CDVPortfinder getPortWithHost:host]);
    });
}


+(void)getPortWithDefaultPort:(int)port host:(const char *)host completionHandler:(void (^)(int port))completionHandler{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        completionHandler([CDVPortfinder getPortWithDefaultPort:port host:host]);
    });
}


+(BOOL)testSocketServerWithHost:(const char *)host port:(int)port{
    int ipv4_socket_tcp, ipv4_socket_udp, errore;
    struct sockaddr_in sin_tcp, sin_udp;
    
    // TCP
    memset(&sin_tcp, 0, sizeof(sin_tcp));
    sin_tcp.sin_len = sizeof(sin_tcp);
    sin_tcp.sin_family = AF_INET; /* Address family */
    sin_tcp.sin_port = htons(port); /* Or a specific port */
    sin_tcp.sin_addr.s_addr = inet_addr(host); /* inet_addr(host) | INADDR_ANY */
    
    ipv4_socket_tcp = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
    
    errore = bind(ipv4_socket_tcp, (struct sockaddr *)&sin_tcp, sizeof(sin_tcp));
    if (errore == -1){
        close(ipv4_socket_tcp);
        return false;
    }
    
    errore = listen(ipv4_socket_tcp, 1);
    if (errore == -1){
        close(ipv4_socket_tcp);
        return false;
    }
    
    // UDP
    memset(&sin_udp, 0, sizeof(sin_udp));
    sin_udp.sin_len = sizeof(sin_udp);
    sin_udp.sin_family = AF_INET; /* Address family */
    sin_udp.sin_port = htons(port); /* Or a specific port */
    sin_udp.sin_addr.s_addr = inet_addr(host); /* inet_addr(host) | INADDR_ANY */
    
    ipv4_socket_udp = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
    
    errore = bind(ipv4_socket_udp, (struct sockaddr *)&sin_udp, sizeof(sin_udp));
    if (errore == -1){
        close(ipv4_socket_tcp);
        close(ipv4_socket_udp);
        return false;
    }
    
    close(ipv4_socket_tcp);
    close(ipv4_socket_udp);
    return true;
}

@end
