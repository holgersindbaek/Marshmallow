//
//  MMPreferences.m
//  Marshmallow
//
//  Created by Fabio Pelosin on 22/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import "MMPreferencesManager.h"

@implementation MMPreferencesManager

NSString *const kAuthorizationTokenKey = @"it.irrationalfab.AuthorizationToken";

+(NSString*)authorizationToken;
{
  return [[NSUserDefaults standardUserDefaults] stringForKey:kAuthorizationTokenKey];
}

+(void)setAuthorizationToken:(NSString*)token;
{
  [[NSUserDefaults standardUserDefaults] setObject:token forKey:kAuthorizationTokenKey];
}

@end
