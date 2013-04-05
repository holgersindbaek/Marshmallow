//
//  MMRoomTableViewCellList.m
//  Marshmallow
//
//  Created by Fabio Pelosin on 30/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import "MMRoomTableViewCellList.h"




//------------------------------------------------------------------------------

@interface MMRoomTableViewCellList ()

@property NSMutableArray *cells;
@property NSMutableDictionary *temporaryMessages;
@property NSUInteger temporaryIDCount;

@end




//------------------------------------------------------------------------------

@implementation MMRoomTableViewCellList

- (id)init
{
  self = [super init];
  if (self) {

    _cells = [NSMutableArray new];
    _temporaryMessages = [NSMutableDictionary new];
  }
  return self;
}

- (void)clearMessagesList;
{
  self.cells = [NSMutableArray new];
}

- (void)appendMessage:(IFToastingMessage*)message
{

  // Disable time stamps.
  if (message.type == IFToastingMessageTypeTimestamp) {
    return;
  }

  MMRoomTableViewCellListItem *lastItem = self.cells.lastObject;
  NSString *lastUserID = lastItem.userID;
  NSTimeInterval timeInterval = [message.createdAt timeIntervalSinceDate:lastItem.message.createdAt];

  BOOL previousMessageHasGroup = (lastItem.isGroupped);
  BOOL messageWantsGroup = (message.typeGroup == IFToastingMessageTypeGroupUserPost);
  BOOL usersMatch = [lastUserID isEqualToString:message.userID];
  BOOL bigTimeInterval = timeInterval > 10 * 60;
  BOOL shouldInsertUserCell = messageWantsGroup && (!usersMatch || !previousMessageHasGroup || bigTimeInterval);

  // open previus message if needed if needed.
  BOOL shouldReopenPreviusMessageGroup = previousMessageHasGroup && messageWantsGroup && usersMatch && !shouldInsertUserCell;
  if (shouldReopenPreviusMessageGroup) {
    lastItem.endOfGroup = FALSE;
  }

  // Insert User cell.
  if (shouldInsertUserCell) {
    MMRoomTableViewCellListItem *userItem  = [MMRoomTableViewCellListItem new];
    userItem.reppresentedValue = message.userID;
    userItem.userID = message.userID;
    userItem.type = @"User";
    [self.cells addObject:userItem];
  }

  // Insert Message cell.
  MMRoomTableViewCellListItem *messageItem = [MMRoomTableViewCellListItem new];
  messageItem.reppresentedValue = message;
  messageItem.message = message;
  messageItem.userID = message.userID;
  messageItem.type = @"Message";
  messageItem.endOfGroup = TRUE;
  messageItem.isGroupped = messageWantsGroup;
  [self.cells addObject:messageItem];
}

- (NSUInteger)addMessagePreview:(IFToastingMessage*)message;
{
  NSUInteger temporaryID = self.temporaryIDCount++;
  NSString *boxedID = [[NSNumber numberWithUnsignedInteger:temporaryID] stringValue];
  self.temporaryMessages[boxedID] = message;
  [self appendMessage:message];
  return temporaryID;
}

- (void)confirmMessagePreview:(NSUInteger)temporaryID message:(IFToastingMessage*)confirmedMessage
{
  NSNumber *boxedID = [NSNumber numberWithUnsignedInteger:temporaryID];
  IFToastingMessage *temporaryMessage = self.temporaryMessages[boxedID];
  NSUInteger index = [self.cells indexOfObject:temporaryMessage];
  [self.cells replaceObjectAtIndex:index withObject:confirmedMessage];
}

- (void)addInformation:(NSDictionary*)info forMessage:(IFToastingMessage*)message;
{
  NSUInteger index = [self.cells indexOfObjectPassingTest:^BOOL(MMRoomTableViewCellListItem *item, NSUInteger idx, BOOL *stop) {
    return [item.message.messageID isEqualToString:message.messageID];
  }];

  MMRoomTableViewCellListItem *infoItem = [MMRoomTableViewCellListItem new];
  infoItem.reppresentedValue = info;
  infoItem.message = message;
  infoItem.userID = message.userID;
  infoItem.type = @"Info";
  infoItem.isGroupped = TRUE;

  MMRoomTableViewCellListItem *previusItem = [self.cells objectAtIndex:index];
  if (previusItem.endOfGroup) {
    previusItem.endOfGroup = FALSE;
    infoItem.endOfGroup = TRUE;
  }

  
  [self.cells insertObject:infoItem atIndex:index+1];
  [self.delegate cellList:self didInsertRowAtIndex:index+1];
}

@end

//------------------------------------------------------------------------------

@implementation MMRoomTableViewCellListItem

@end
