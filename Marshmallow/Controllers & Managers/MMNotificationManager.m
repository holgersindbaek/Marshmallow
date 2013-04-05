
//
//  MMNotificationManager.m
//  Marshmallow
//
//  Created by Fabio Pelosin on 22/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import "MMNotificationManager.h"

@implementation MMNotificationManager

- (id)init
{
  self = [super init];
  if (!self) {
    return nil;
  }

  _userIDS = @[];
  [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];

  return self;
}

- (void)showNotificationForMessage:(IFToastingMessage*)message userName:(NSString*)userName room:(NSString*)room
{
  if ([self.userIDS containsObject:message.userID]) {
    return;
  }
  
  [self showNotificationWithTitle:nil informative:nil];
  NSString *title;
  NSString *informative;

  switch (message.type) {
    case IFToastingMessageTypeText:
    case IFToastingMessageTypePaste:
    {
      title = [NSString stringWithFormat:@"%@\n%@", userName, room];
      informative = message.body;
      break;
    }

    case IFToastingMessageTypeTweet:
    case IFToastingMessageTypeSound:
    case IFToastingMessageTypeUpload:
    {
      title = [NSString stringWithFormat:@"%@ - %@", userName, room];
      informative = message.stringType;
      break;
    }

    default:
    {
      break;
    }
  }

  [self showNotificationWithTitle:title informative:informative];
}

- (void)showNotificationWithTitle:(NSString*)title informative:(NSString*)informative;
{
  NSUserNotification *notification = [[NSUserNotification alloc] init];
  notification.title = title;
  notification.informativeText = informative;
  notification.soundName = [self soundName];
  [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

///-----------------------------------------------------------
#pragma mark - Private Helpers
///-----------------------------------------------------------

- (NSString*)soundName
{
  return @"Purr";
  return NSUserNotificationDefaultSoundName;
}

///-----------------------------------------------------------
#pragma mark - NSUserNotificationCenterDelegate
///-----------------------------------------------------------

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
  return YES;
}


///-----------------------------------------------------------
#pragma mark - Class methods
///-----------------------------------------------------------

+ (NSArray*)availableSoundNames
{
  NSString *systemSoundsPath = @"/System/Library/Sounds";
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSArray *contents = [fileManager contentsOfDirectoryAtPath:systemSoundsPath error:nil];
  NSMutableArray *names = [NSMutableArray new];
  [contents enumerateObjectsUsingBlock:^(NSString *fileName, NSUInteger idx, BOOL *stop) {
    if ([fileName rangeOfString:@".aiff"].location != NSNotFound) {
      NSString *name = [fileName stringByReplacingOccurrencesOfString:@".aiff" withString:@""];
      [names addObject:name];
    }
  }];
  return names;
}

+ (MMNotificationManager *)sharedManager;
{
  static MMNotificationManager *_sharedManager = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedManager = [[self alloc] init];
  });

  return _sharedManager;
}

@end






