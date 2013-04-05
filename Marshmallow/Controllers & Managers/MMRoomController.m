//
//  MMCampFireRoomController.m
//  Marshmallow
//
//  Created by Fabio Pelosin on 23/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import "MMRoomController.h"
#import "IFToastingKit.h"
#import "IFToastingRoomStreamClient.h"

///-----------------------------------------------------------
/// Private Interface
///-----------------------------------------------------------

@interface MMRoomController () <IFToastingRoomStreamClientDelegate>

@end

///-----------------------------------------------------------
/// Implementation
///-----------------------------------------------------------

@implementation MMRoomController

- (id)init
{
  self = [super init];
  if (!self) {
    return nil;
  }


  return self;
}

- (void)openConnection;
{
  [self loadRecentMessages];
  [self.apiClient joinRoom:self.roomID success:^(AFHTTPRequestOperation *operation) {
    [self startStream];
  } failure:^(NSError *error) {
    [self handleError:error];
  }];
}

- (void)closeConnection;
{
  
}

#define IFToastingMessageTypeTweetRegEx @" *https://twitter.com/\\w+/status/[0-9]+ *"
#define IFToastingMessageTypeSoundRegEx @" */play \\w+ *"

- (void)postMessage:(NSString*)body;
{
  IFToastingMessageUserPostType type;

  NSPredicate *twitterTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", IFToastingMessageTypeTweetRegEx];
  NSPredicate *soundTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", IFToastingMessageTypeSoundRegEx];

  if ([[body componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] count] > 1) {
    type = IFToastingMessageTypePaste;
  }
  else if ([twitterTest evaluateWithObject:body]) {
    type = IFToastingMessageTypeTweet;
  }
  else if ([soundTest evaluateWithObject:body]) {
    type = IFToastingMessageTypeSound;
  }
  else {
    type = IFToastingMessageTypeText;
  }

  [self.apiClient createMessageWithBody:body type:type room:self.roomID success:^(IFToastingMessage *message) {
    //    [self appendMessage:message];
    [self.delegate roomController:self didConfirmPost:body message:message];

  } failure:^(NSError *error) {
    [[NSAlert alertWithError:error] runModal];
  }];
}

- (void)clearUnreadMessages
{
  [self handleNewMessages:@[self.messages.lastObject]];
}

- (BOOL)isMessageUnread:(NSString*)messageID
{
  IFToastingMessage *message = nil;
  NSUInteger index = [self.messages indexOfObjectPassingTest:^BOOL (id obj, NSUInteger idx, BOOL *stop) {
    return [message.messageID isEqualToString:messageID];
    *stop = true;
  }];
  if (index != NSNotFound) {
    message = [self.messages objectAtIndex:index];
  }
  return message.createdAt == [message.createdAt laterDate:self.lastReadMessageDate];
}

- (void)refreh {
  [self loadRecentMessages];
}

///-----------------------------------------------------------
#pragma mark - Private Helpers
///-----------------------------------------------------------

- (void)handleNewMessages:(NSArray*)messages;
{
  if (self.trackUnreadMessages) {
    self.unreadMessagesCount += messages.count;
    [self.delegate roomControllerDidUpdateUnreadMessages:self];
  } else {
    IFToastingMessage *message = messages.lastObject;
    if (message.createdAt == [message.createdAt laterDate:self.lastReadMessageDate])
    {
      self.lastReadMessageID = message.messageID;
      self.lastReadMessageDate = message.createdAt;
    }
  }
}

- (void)startStream
{
  IFToastingRoomStreamClient *streamClient = [[IFToastingRoomStreamClient alloc] initWithRoom:self.roomID];
  [streamClient setDelegate:self];
  [streamClient setAuthorizationToken:self.authorizationToken];
  [streamClient openConnection];
}

- (void)loadRecentMessages
{
  [self.apiClient getRecentMessagesForRoom:self.roomID success:^(NSArray *messages) {
    self.messages = [messages mutableCopy];
    [self handleNewMessages:messages];
    [self.delegate roomControllerDidUpdateMessagesList:self];
  } failure:^(NSError *error) {
    [self handleError:error];
  }];
}

- (void)handleError:(NSError*)error
{
  [[NSAlert alertWithError:error] runModal];
}

- (void)loadAlternativeViewForMessage:(IFToastingMessage*)message
{
  //  NSView *view = nil;
  //  [self.delegate roomController:self didReceiveAlternativeView:nil message:message];
}

- (void)addNewMessages:(NSArray*)messages
{
  [self.messages addObjectsFromArray:messages];
  // Check if the new messages come after the message stored;
  [self restoreMessageListIntegrity];
}

/*
 Restores the integrity of the messages ensuring that they are unique and sorted.
 */
- (void)restoreMessageListIntegrity
{
  // Uniq
  // Sort
}

///-----------------------------------------------------------
#pragma mark - Stream
///-----------------------------------------------------------

- (void)client:(IFToastingRoomStreamClient *)client didReceiveMessage:(IFToastingMessage *)message
{
  [self loadAlternativeViewForMessage:message];
  [self handleNewMessages:@[message]];
  [self.messages addObject:message];
  [self.delegate roomController:self didReceiveNewMessage:message];
}

- (void)client:(IFToastingRoomStreamClient *)client didFailWithError:(NSError *)error
{
  [self handleError:error];
}


@end









