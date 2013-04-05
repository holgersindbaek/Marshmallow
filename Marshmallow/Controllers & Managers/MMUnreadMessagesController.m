//
//  MMUnreadMessagesController.m
//  Marshmallow
//
//  Created by Fabio Pelosin on 23/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import "MMUnreadMessagesController.h"
#import <AFHTTPRequestOperation.h>

NSString * const IFToastingRoomWasUpdatedNotification = @"it.irrationalfab.campfire.room.update";

@implementation MMUnreadMessagesController

- (id)initWithRoomID:(NSString*)roomID {
  self = [super init];
  if (!self) {
    return nil;
  }

  _roomID = roomID;

  return self;
}

- (void)dealloc {
  [self stopLogging];
}

- (void)startLogging {
//  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HTTPOperationDidStart:) name:IFToastingRoomWasUpdatedNotification object:nil];
}

- (void)stopLogging {
//  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
