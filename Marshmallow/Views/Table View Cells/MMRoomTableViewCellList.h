//
//  MMRoomTableViewCellList.h
//  Marshmallow
//
//  Created by Fabio Pelosin on 30/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import <Foundation/Foundation.h>
#import "IFToastingKit.h"

@protocol MMRoomTableViewCellListDelegate;

@interface MMRoomTableViewCellList : NSObject

@property (readonly) NSMutableArray *cells;
@property id<MMRoomTableViewCellListDelegate> delegate;

- (void)clearMessagesList;
- (void)appendMessage:(IFToastingMessage*)message;
- (NSUInteger)addMessagePreview:(IFToastingMessage*)message;
- (void)confirmMessagePreview:(NSUInteger)temporaryID message:(IFToastingMessage*)confirmedMessage;
- (void)addInformation:(NSDictionary*)info forMessage:(IFToastingMessage*)message;

@end

@protocol MMRoomTableViewCellListDelegate <NSObject>

- (void)cellList:(MMRoomTableViewCellList*)cellList didInsertRowAtIndex:(NSUInteger)index;

@end

//------------------------------------------------------------------------------

@interface MMRoomTableViewCellListItem : NSObject

@property NSString *type;
@property id reppresentedValue;



@property NSString* userID;

@property IFToastingMessage* message;
@property BOOL isGroupped;
@property BOOL endOfGroup;

@end
