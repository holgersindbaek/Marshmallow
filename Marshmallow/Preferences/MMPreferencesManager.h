//
//  MMPreferences.h
//  Marshmallow
//
//  Created by Fabio Pelosin on 22/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import <Foundation/Foundation.h>

@interface MMPreferencesManager : NSObject

+(NSString*)authorizationToken;

+(void)setAuthorizationToken:(NSString*)token;

@end
