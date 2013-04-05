//
//  MMAccountsController.m
//  Marshmallow
//
//  Created by Fabio Pelosin on 23/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import "MMAccountsController.h"
#import "MMPreferencesManager.h"

@implementation MMAccountsController

- (id)init
{
  self = [super init];
  if (!self) {
    return nil;
  }

  _apiClient = [[IFToastingKit alloc] initWithSubDomain:@"cocoapods"];

  //  [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
  //                                                         selector:@selector(wakeFromSleep:)
  //                                                             name:NSWorkspaceDidWakeNotification
  //                                                           object:nil];

  return self;
}

+ (instancetype)sharedInstance
{
  static id _sharedInstance = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedInstance = [[self alloc] init];
  });

  return _sharedInstance;
}

- (BOOL)authenticate;
{
  NSString *authorizationToken = [MMPreferencesManager authorizationToken];
  if (authorizationToken) {
    [self.apiClient setAuthorizationToken:authorizationToken];
    return true;
  } else {
    return false;
  }
}

@end
