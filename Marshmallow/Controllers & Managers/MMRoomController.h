//
//  MMCampFireRoomController.h
//  Marshmallow
//
//  Created by Fabio Pelosin on 23/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import "IFToastingKit.h"

#import <Foundation/Foundation.h>

///***********************************************************///
/// MMCampFireRoomController
///***********************************************************///

@protocol MMRoomControllerDelegate;

@interface MMRoomController : NSObject

///-----------------------------------------------------------
/// @name Configuration
///-----------------------------------------------------------

@property NSString* roomID;

@property NSString* authorizationToken;

@property NSString* currentUserID;

@property id<MMRoomControllerDelegate> delegate;

@property IFToastingKit *apiClient;


///-----------------------------------------------------------
/// @name Properties
///-----------------------------------------------------------

@property NSString* lastReadMessageID;

@property NSDate* lastReadMessageDate;

@property NSMutableArray* messages;

@property BOOL trackUnreadMessages;

@property NSUInteger unreadMessagesCount;

///-----------------------------------------------------------
/// @name Actions
///-----------------------------------------------------------

- (void)clearUnreadMessages;

- (BOOL)isMessageUnread:(NSString*)messageID;

- (void)refreh;

- (void)openConnection;

- (void)closeConnection;

- (void)postMessage:(NSString*)body;

@end

///***********************************************************///
/// MMCampFireRoomControllerDelegate
///***********************************************************///

@protocol MMRoomControllerDelegate <NSObject>

- (void)roomControllerDidUpdateUnreadMessages:(MMRoomController*)controller;

- (void)roomController:(MMRoomController*)controller didReceiveAlternativeView:(NSView*)view message:(IFToastingMessage*)message;

- (void)roomController:(MMRoomController*)controller didReceiveNewMessage:(IFToastingMessage*)message;

- (void)roomControllerDidUpdateMessagesList:(MMRoomController*)controller;

- (void)roomController:(MMRoomController*)controller didConfirmPost:(NSString*)body message:(IFToastingMessage*)message;

@end
