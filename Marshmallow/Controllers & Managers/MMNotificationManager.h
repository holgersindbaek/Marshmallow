//
//  MMNotificationManager.h
//  Marshmallow
//
//  Created by Fabio Pelosin on 22/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import <Foundation/Foundation.h>
#import "IFToastingMessage.h"

@interface MMNotificationManager : NSObject <NSUserNotificationCenterDelegate>

@property NSArray *userIDS;

- (void)showNotificationForMessage:(IFToastingMessage*)message userName:(NSString*)userName room:(NSString*)room;
- (void)showNotificationWithTitle:(NSString*)title informative:(NSString*)informative;

+ (MMNotificationManager *)sharedManager;

+ (NSArray*)availableSoundNames;

@end
