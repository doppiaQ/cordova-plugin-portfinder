//
//  CDVPortfinder.h
//  Cordova Portfinder Plugin
//
//  Created by Emanuele on 23/07/18.
//  Copyright © 2018 Group4Business. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

@interface CDVPortfinder : CDVPlugin
{}

- (void)getPort:(CDVInvokedUrlCommand*)command;
- (void)getPortWithHost:(CDVInvokedUrlCommand*)command;

+(int)getPortWithHost:(const char *)host;
+(int)getPortWithDefaultPort:(int)defPort host:(const char *)host;
+(void)getPortWithHost:(const char *)host completionHandler:(void (^)(int port))completionHandler;
+(void)getPortWithDefaultPort:(int)defPort host:(const char *)host completionHandler:(void (^)(int port))completionHandler;

@end
