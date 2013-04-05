//
//  MMRoomViewController.m
//  Marshmallow
//
//  Created by Fabio Pelosin on 29/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import "MMRoomViewController.h"

#import "AFImageRequestOperation.h"
#import "MMGravatarHelper.h"

#import "MMTableCellViews.h"

#import "MMUser.h"
#import "IFToastingKit.h"

#import "IFToastingRoomStreamClient.h"
#import "MMRoomController.h"

#import "MMNotificationManager.h"
#import "CoreData+MagicalRecord.h"

// TODO
#import "MMAccountsController.h"
#import "ZWEmoji.h"
#import "MMRoomTableViewCellList.h"

#import "MarshmallowTableViewCellsConstants.h"
#import "MarshmallowConstants.h"

#import "TwitterText.h"

//------------------------------------------------------------------------------

@interface MMRoomViewController () <NSTableViewDelegate, NSTableViewDataSource, NSTextViewDelegate, MMRoomControllerDelegate, MMRoomTableViewCellListDelegate>

@property NSDateFormatter *dateFormatter;

@property MMRoomController *roomController;
@property IFToastingKit *apiClient;

@property MMRoomTableViewCellList *cellList;

@property NSMutableDictionary *sampleCells;
@property NSCache *imagesByURL;

@end

//------------------------------------------------------------------------------

@implementation MMRoomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (!self) {
    return nil;
  }

  _cellList    = [MMRoomTableViewCellList new];
  [_cellList setDelegate:self];
  _sampleCells = [NSMutableDictionary new];
  _imagesByURL = [NSCache new];

  return self;
}

- (void)loadView
{
  [super loadView];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.textView.delegate = self;

  [self.tableView setBackgroundColor:[NSColor colorWithCalibratedWhite:0.946 alpha:1.000]];
  NSNib *cellNib = [[NSNib alloc] initWithNibNamed:@"MMUserTableCellView" bundle:nil];
  [self.tableView registerNib:cellNib forIdentifier:@"MMUserTableCellView"];


  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateStyle:NSDateFormatterNoStyle];
  [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
  [dateFormatter setLocale:[NSLocale currentLocale]];
  self.dateFormatter = dateFormatter;

  self.apiClient = [[MMAccountsController sharedInstance] apiClient];
}

//------------------------------------------------------------------------------
#pragma mark - IBActions
//------------------------------------------------------------------------------

// TODO: show the message as temporary.
// and confirm it in the hook.
// and also an error icon to the cell wich allows to resend the message.
- (IBAction)postMessage:(NSString*)messageBody
{
  [self.statusLabel setStringValue:@"Posting..."];
  [[self roomController] postMessage:messageBody];
}


//------------------------------------------------------------------------------
#pragma mark - Private Helpers
//------------------------------------------------------------------------------


- (void)joinRoom
{

  if ([[MMAccountsController sharedInstance] authenticate]) {
    self.statusLabel.stringValue = @"Joining Rooms";

    // TODO
    self.roomController = [MMRoomController new];
    self.roomController.roomID = self.roomID;
    self.roomController.authorizationToken = _apiClient.authorizationToken;
    self.roomController.currentUserID = self.userID;
    self.roomController.delegate = self;
    self.roomController.apiClient = _apiClient;
    [self.roomController openConnection];

    [self.apiClient getRoomWithID:self.roomID success:^(IFToastingRoom *room) {
      self.statusLabel.stringValue = [NSString stringWithFormat:@"%lu User - Room: %@", room.users.count, room.name];
    } failure:^(NSError *error) {
      NSLog(@"%@", error);
    }];
  } else {
    [[NSAlert alertWithMessageText:@"Missing authentication token"
                     defaultButton:nil
                   alternateButton:nil
                       otherButton:nil
         informativeTextWithFormat:@"Set your authorization token in the preferences and restart the app :-)"] runModal];
  }
}

- (void)leaveRoom {
  self.statusLabel.stringValue = @"Joining Rooms";
  [self.roomController closeConnection];
}

- (IBAction)reloadData:(id)sender{
  [self.roomController refreh];
}

- (void)loadUserWithID:(NSString*)userID {
  // TODO

  [self.apiClient getUserWithID:userID success:^(IFToastingUser *apiUser) {
    MMUser *user = [MMUser MR_findFirstByAttribute:@"userID" withValue:userID];
    if (!user) {
      user = [MMUser MR_createEntity];
    }
    [self configureUser:user apiUser:apiUser];
    [[NSManagedObjectContext MR_defaultContext]  MR_saveToPersistentStoreAndWait];
    [self loadImageForUser:user];

  } failure:^(NSError *error) {
    [[NSAlert alertWithError:error] runModal];
  }];
}

- (void)configureUser:(MMUser*)user apiUser:(IFToastingUser *)apiUser {
  user.admin = [NSNumber numberWithBool:apiUser.admin];
  user.avatarURL = [apiUser.avatarURL absoluteString];
  user.createdAt = apiUser.createdAt;
  user.emailAddress = apiUser.emailAddress;
  user.userID = apiUser.userID;
  user.name = apiUser.name;
  user.type = apiUser.type;
}

- (void)loadImageForUser:(MMUser*)user {

  NSURL *avatarURL = [NSURL URLWithString:user.avatarURL];
  if ([[avatarURL absoluteString] rangeOfString:@"missing/avatar.gif"].location != NSNotFound) {
    NSString *email = user.emailAddress;

    if ([email rangeOfString:@"@gmail.com"].location != NSNotFound) {
      NSError *error = NULL;
      NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\+.*@" options:NSRegularExpressionCaseInsensitive error:&error];
      email = [regex stringByReplacingMatchesInString:email options:0 range:NSMakeRange(0, [email length]) withTemplate:@"@"];
    }

    avatarURL = [MMGravatarHelper URLForGravatarWithEmail:email imageSize:nil defaultImage:nil];
  }
  NSURLRequest *request = [NSURLRequest requestWithURL:avatarURL];
  AFImageRequestOperation *image_operation = [AFImageRequestOperation imageRequestOperationWithRequest:request success:^(NSImage *image) {
    user.avatar = image;
    [[NSManagedObjectContext MR_defaultContext]  MR_saveToPersistentStoreAndWait];
    [self.tableView reloadData];
  }];

  [image_operation start];

}

- (MMUser*)userForMessage:(IFToastingMessage*)message
{
  return [self userWithID:message.userID];
}

- (MMUser*)userWithID:(NSString*)userID
{
  return [MMUser MR_findFirstByAttribute:@"userID" withValue:userID];
}

- (BOOL)isCurrentUser:(IFToastingUser*)user
{
  return [user.userID isEqualToString:self.userID];
}

//------------------------------------------------------------------------------
#pragma mark - TableViewDelegate & DataSource
//------------------------------------------------------------------------------

/**
 Returns the count  of the cells based on the cellList.
 */
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  return [self.cellList.cells count];
}

/**
 Returns the cell based on the cellListItem.
 */
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  NSTableCellView *cell;
  MMRoomTableViewCellListItem* item = [self.cellList.cells objectAtIndex:row];
  if ([item.type isEqualToString:@"User"])
  {
    MMUser *user = [self userWithID:item.userID];
    cell = [self _cellForUser:user];
  }
  else if ([item.type isEqualToString:@"Info"]) {
    cell = [self _cellForInfo:item.reppresentedValue];
  }
  else
  {
    IFToastingMessage *message = item.reppresentedValue;
    cell = [self _cellForMessage:message];
    if ([cell isKindOfClass:[MMGroupedTableViewCell class]]) {
      [(MMGroupedTableViewCell *)cell setEndOfGroup:item.endOfGroup];
    }
  }
  return cell;
}

/**
 Returns the height of the cell taking into account if the cell is a user
 cell or a message cell.
 */
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {

  CGFloat height = 0;
  MMRoomTableViewCellListItem* item = [self.cellList.cells objectAtIndex:row];

  if ([item.type isEqualToString:@"User"])
  {
    height = kUserTableViewCellHeight;
  }
  else if ([item.type isEqualToString:@"Info"])
  {
    height = 300;
  }
  else
  {
    IFToastingMessage *message = item.reppresentedValue;
    if (message.typeGroup == IFToastingMessageTypeGroupUserPost)
    {
      height = [self _heightForMessage:message];
    }
    else
    {
      height = 32;
    }
  }

  return height;
}

/**
 Disable the selection in the TableView.
 */
- (BOOL)selectionShouldChangeInTableView:(NSTableView *)aTableView
{
  return NO;
}

//------------------------------------------------------------------------------
#pragma mark - TableViewDelegate & DataSource Private Helpers
//------------------------------------------------------------------------------

/**
 Returns the height of a cell containing an user Post.
 */
- (CGFloat)_heightForMessage:(IFToastingMessage*)message
{
  Class cellClass = _cellClassForPostType(message.userPostType);
  NSString *className = NSStringFromClass(cellClass);

  MMGroupedTableViewCell *sampleCell = self.sampleCells[className];
  if (!sampleCell)
  {
    sampleCell = [cellClass new];
    self.sampleCells[className] = sampleCell;
  }

  [self _configurePostCell:sampleCell withMessage:message];
  CGFloat width = self.tableView.frame.size.width;
  CGFloat height = [sampleCell preferredHeightWithWitdth:width];
  return height;
}

/**
 Configures a a cell reppresenting an user Post according to the message type.
 */
- (void)_configurePostCell:(MMGroupedTableViewCell *)cell withMessage:(IFToastingMessage*)message
{
  switch (message.userPostType) {
    case IFToastingMessageTypeText:
    case IFToastingMessageTypePaste:
    case IFToastingMessageTypeSound:
      [self _configureTextMessageCell:(MMTextMessageTableCellView*)cell message:message];
      break;

    case IFToastingMessageTypeUpload:
      [self _configureUploadMessageCell:(MMUploadTableCellView *)cell message:message];
      break;

    case IFToastingMessageTypeTweet:
      [self _configureTweetMessageCell:(MMTweetMessageTableCellView *)cell message:message];
      break;
  }

}

// TODO
Class _cellClassForPostType(IFToastingMessageUserPostType type)
{
  Class class;
  switch (type) {
    case IFToastingMessageTypeText:
    case IFToastingMessageTypeSound:
    case IFToastingMessageTypePaste:
      class = [MMTextMessageTableCellView class];
      break;

    case IFToastingMessageTypeTweet:
      class = [MMTweetMessageTableCellView class];
      break;

    case IFToastingMessageTypeUpload:
      class = [MMUploadTableCellView class];
      break;
  }

  return class;
}

//------------------------------------------------------------------------------
#pragma mark - Cells
//------------------------------------------------------------------------------

- (NSTableCellView *)_cellForUser:(MMUser*)user;
{
  MMUserTableCellView *cell = [self.tableView makeViewWithIdentifier:@"MMUserTableCellView" owner:self];
  if (user) {
    cell.authorTextField.stringValue = user.name;
    cell.imageView.image = user.avatar;
  }
  return cell;
}

- (NSTableCellView *)_cellForMessage:(IFToastingMessage*)message;
{
  if (message.typeGroup == IFToastingMessageTypeGroupUserPost )
  {
    Class cellClass = _cellClassForPostType(message.userPostType);
    MMGroupedTableViewCell *cell = [self dequeCellWithClass:cellClass];
    [self _configurePostCell:cell withMessage:message];
    return cell;
  }
  else
  {
    MMInformativeTableCellView *cell = [self dequeCellWithClass:[MMInformativeTableCellView class]];
    [self _configureInformativeCell:cell withMessage:message];
    return cell;
  }
}

- (NSTableCellView *)_cellForInfo:(NSDictionary*)info;
{
  MMInfoTableCellView *cell = [self dequeCellWithClass:[MMInfoTableCellView class]];
  NSImage *image = info[@"Image"];
  cell.imageView.image = image;
  return cell;
}


- (id)dequeCellWithClass:(Class)class
{
  NSString *identifier = NSStringFromClass(class);
  MMUploadTableCellView *cell = [self.tableView makeViewWithIdentifier:identifier owner:self];
  if (!cell) {
    cell = [class new];
    cell.identifier = identifier;
  }
  return cell;
}


//------------------------------------------------------------------------------
#pragma mark - Configuring Post Cells
//------------------------------------------------------------------------------


- (void)_configureTextMessageCell:(MMTextMessageTableCellView*)cell message:(IFToastingMessage*)message {
  NSAttributedString *body = [self _attributedStringForMessageBody:message.body];
  [cell.messageTextField.textStorage setAttributedString:body];
  cell.dateTextField.stringValue = [self.dateFormatter stringFromDate:message.createdAt];
}


- (void)_configurePasteMessageCell:(MMTextMessageTableCellView*)cell message:(IFToastingMessage*)message {
  [cell.messageTextField setString:message.body];
  cell.dateTextField.stringValue = [self.dateFormatter stringFromDate:message.createdAt];
}

- (void)_configureUploadMessageCell:(MMUploadTableCellView*)cell message:(IFToastingMessage*)message {
  NSString *extension = [message.body pathExtension];
  NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFileType:extension];
  [cell.messageImageView setImage:icon];
  [cell.messageTextField setStringValue:message.body];
  [cell setUnread: TRUE];
  cell.dateTextField.stringValue = [self.dateFormatter stringFromDate:message.createdAt];
}

- (void)_configureTweetMessageCell:(MMTweetMessageTableCellView*)cell message:(IFToastingMessage*)message {

  NSImage *icon = [self.imagesByURL objectForKey:message.tweet.authorAvatarUrl];
  if (!icon) {
    icon = [NSImage imageNamed:NSImageNameUser];
  }

  [cell.messageImageView setImage:icon];
  NSAttributedString *body = [self _attributedStringForTweet:message.tweet.message];
  [cell.messageTextField setAttributedStringValue:body];
  [cell setUnread: TRUE];
  cell.dateTextField.stringValue = [self.dateFormatter stringFromDate:message.createdAt];
}

- (void)_configureInformativeCell:(MMInformativeTableCellView*)cell withMessage:(IFToastingMessage*)message {
  NSString *informative;
  switch (message.typeGroup) {
    case IFToastingMessageTypeGroupUserEvent:
      informative = [self _informativeForUserEventMessage:message];
      break;

    case IFToastingMessageTypeGroupRoomEvent:
      informative = [self _informativeForRoomEventMessage:message];
      break;

    case IFToastingMessageTypeGroupOther:
      informative = [self _informativeForOtherEventMessage:message];
      break;

    default:
      [NSException raise:@"Attempt to ask informative for message with wrong type group." format:@"message: %@", message];
      break;
  }
  cell.textField.stringValue = informative;
  cell.dateTextField.stringValue = [self.dateFormatter stringFromDate:message.createdAt];
}

- (NSString*)_informativeForUserEventMessage:(IFToastingMessage*)message
{
  MMUser *user = [self userForMessage:message];
  NSString *result;


  switch (message.userEventType) {
    case IFToastingMessageTypeIdle:
      result = [NSString stringWithFormat:@"%@ is idle", user.name];
      break;
    case IFToastingMessageTypeUnidle:
      result = [NSString stringWithFormat:@"%@ is back", user.name];
      break;
    case IFToastingMessageTypeEnter:
      result = [NSString stringWithFormat:@"%@ joined the room", user.name];
      break;
    case IFToastingMessageTypeLeave:
    case IFToastingMessageTypeKick:
      result = [NSString stringWithFormat:@"%@ left the room", user.name];
      break;
  }

  return result;
}

/*
 */
- (NSString*)_informativeForOtherEventMessage:(IFToastingMessage*)message
{
  NSString *result;
  switch (message.otherEventType) {
    case IFToastingMessageTypeAdvertisement:
      result = [NSString stringWithFormat:@"Advertisement: %@", message.body];
      break;
    case IFToastingMessageTypeSystem:
      result = [NSString stringWithFormat:@"System message: %@", message.body];
      break;
  }

  return result;
}

/**
 TODO: handle time stamps?
 */
- (NSString*)_informativeForRoomEventMessage:(IFToastingMessage*)message
{
  NSString *result;
  switch (message.roomEventType) {
    case IFToastingMessageTypeAllowGuests:
      result = @"Guest are allowed in the room";
      break;
    case IFToastingMessageTypeDisallowGuests:
      result = @"Guest are not allowed in the room";
      break;
    case IFToastingMessageTypeLock:
      result = @"Room locked";
      break;
    case IFToastingMessageTypeUnlock:
      result = @"Room unlocked";
      break;
    case IFToastingMessageTypeTopicChange:
      result = @"Room topic changed";
      break;
    case IFToastingMessageTypeConferenceCreated:
      result = @"Conference started";
      break;
    case IFToastingMessageTypeConferenceFinished:
      result = @"Conference finished";
      break;
    case IFToastingMessageTypeTimestamp:
      result = @"Time stamp";
      break;
  }

  return result;
}


//------------------------------------------------------------------------------
#pragma mark - Configuring Post Cells
//------------------------------------------------------------------------------




//------------------------------------------------------------------------------
#pragma mark - NSTextViewDelegate
//------------------------------------------------------------------------------

- (void)textDidEndEditing:(NSNotification *)notification
{
  NSString *message = self.textView.string;
  if (message && ![message isEqualToString:@""]) {
    [self postMessage:message];
    [self.textView setString:@""];
  }
  [self.view.window makeFirstResponder:self.textView];
}

//------------------------------------------------------------------------------
#pragma mark - DSCampFireRoomControllerDelegate
//------------------------------------------------------------------------------

- (void)roomControllerDidUpdateUnreadMessages:(MMRoomController*)controller;
{
  NSDockTile *tile = [[NSApplication sharedApplication] dockTile];
  NSString *label = [NSString stringWithFormat:@"%ld", (unsigned long)controller.unreadMessagesCount];
  [tile setBadgeLabel:label];
}

- (void)roomController:(MMRoomController*)controller didReceiveAlternativeView:(NSView*)view message:(IFToastingMessage*)message;
{

}

- (void)roomControllerDidUpdateMessagesList:(MMRoomController*)controller;
{
  NSArray *usersID = [controller.messages valueForKeyPath:@"@distinctUnionOfObjects.userID"];
  usersID = [usersID reject:^BOOL(id userID) {
    return userID == [NSNull null];
  }];

  [usersID each:^(NSString *userID) {
    [self loadUserWithID:userID];
  }];

  [self.cellList clearMessagesList];
  [controller.messages each:^(IFToastingMessage* message) {
    [self.cellList appendMessage:message];
    [self _getTwitterImageForMessageIfNeeded:message];
    [self _getUploadInformationForMessage:message];
  }];
  [self.tableView reloadData];
  [self.tableView scrollToEndOfDocument:nil];
}

- (void)roomController:(MMRoomController*)controller didReceiveNewMessage:(IFToastingMessage*)message;
{
  if ([message.userID isNotEqualTo:self.userID]) {
    MMUser* user = [self userForMessage:message];
    [[MMNotificationManager sharedManager] showNotificationForMessage:message userName:user.name room:@"CocoaPods"];
  }

  [self _getTwitterImageForMessageIfNeeded:message];
  [self _getUploadInformationForMessage:message];

  [self.cellList appendMessage:message];
  [self.tableView reloadData];
  [self.tableView scrollToEndOfDocument:nil];
}

- (void)roomController:(MMRoomController*)controller didConfirmPost:(NSString*)body message:(IFToastingMessage*)message;
{
  self.statusLabel.stringValue = @"Posted";
  // Confirm the message in the tableview
}

//------------------------------------------------------------------------------
#pragma mark - CellListDelegate
//------------------------------------------------------------------------------

- (void)cellList:(MMRoomTableViewCellList*)cellList didInsertRowAtIndex:(NSUInteger)index;
{
  [self.tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:index] withAnimation:NSTableViewAnimationSlideDown];
}

//------------------------------------------------------------------------------
#pragma mark - MetaData
//------------------------------------------------------------------------------

- (void)_getTwitterImageForMessageIfNeeded:(IFToastingMessage*)message;
{
  BOOL isTweet = message.userPostType == IFToastingMessageTypeTweet;
  BOOL hasCachedImage = [self.imagesByURL objectForKey:message.tweet.authorAvatarUrl] ? TRUE : FALSE;

  if (isTweet && !hasCachedImage) {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:message.tweet.authorAvatarUrl]];
    AFImageRequestOperation *image_operation = [AFImageRequestOperation imageRequestOperationWithRequest:request success:^(NSImage *image) {
      [self.imagesByURL setObject:image forKey:message.tweet.authorAvatarUrl];
      MMTweetMessageTableCellView *cell = [self _visibleCellForMessage:message];
      if (cell) {
        [cell.messageImageView setImage:image];
      }
    }];
    [image_operation start];
  }
}

- (void)_getUploadInformationForMessage:(IFToastingMessage*)message;
{
  if (message.userPostType == IFToastingMessageTypeUpload) {

    [self.apiClient getUploadForRoomWithID:self.roomID uploadMessageID:message.messageID success:^(IFToastingUpload *upload) {

      NSURLRequest *request = [NSURLRequest requestWithURL:upload.fullURL];
      AFImageRequestOperation *image_operation = [AFImageRequestOperation imageRequestOperationWithRequest:request success:^(NSImage *image) {
        [self.cellList addInformation:@{@"Image": image} forMessage:message];
      }];
      [image_operation start];

    } failure:^(NSError *error) {
      NSLog(@"%@", error);
    }];
  }
}

- (id)_visibleCellForMessage:(IFToastingMessage*)message
{
  NSRect visibleRect = [self.tableView visibleRect];
  NSRange rowsRange = [self.tableView rowsInRect:visibleRect];
  NSIndexSet *rowsIndexSet = [NSIndexSet indexSetWithIndexesInRange:rowsRange];

  NSIndexSet *itemsIndexSet = [self.cellList.cells indexesOfObjectsAtIndexes:rowsIndexSet options:NSEnumerationConcurrent passingTest:^BOOL(MMRoomTableViewCellListItem *item, NSUInteger idx, BOOL *stop) {
    BOOL found = item.message.messageID ==  message.messageID;
    *stop = found;
    return found;
  }];

  if (itemsIndexSet.count != 0) {
    id cell = [self.tableView viewAtColumn:0 row:itemsIndexSet.firstIndex makeIfNecessary:NO];
    return cell;
  }
  return nil;
}


//------------------------------------------------------------------------------
#pragma mark - LiveResize
//------------------------------------------------------------------------------


- (void)windowDidResize
{
  NSRange visibleRows = [self.tableView rowsInRect:self.tableView.visibleRect];
  [NSAnimationContext beginGrouping];
  [[NSAnimationContext currentContext] setDuration:0];
  [self.tableView noteHeightOfRowsWithIndexesChanged:[NSIndexSet indexSetWithIndexesInRange:visibleRows]];
  [NSAnimationContext endGrouping];
}


//------------------------------------------------------------------------------
#pragma mark - NSString Helpers
//------------------------------------------------------------------------------

// http://developer.apple.com/library/mac/#qa/qa2006/qa1487.html
- (NSAttributedString*)_attributedStringForMessageBody:(NSString*)body {


  body = [ZWEmoji stringByReplacingCodesInString:body];
  NSMutableAttributedString *attributed = [self _attributedStringFromString:body];

  NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:(NSTextCheckingTypes)NSTextCheckingTypeLink error:nil];
  NSArray *matches = [detector matchesInString:body options:0 range:NSMakeRange(0, [body length])];
  for (NSTextCheckingResult *match in matches) {
    if ([match resultType] == NSTextCheckingTypeLink) {
      NSURL *url = [match URL];
      NSDictionary *attributes = [self _attributesForLinkWithURL:[url absoluteString]];
      [attributed addAttributes:attributes range:match.range];
    }
  }

  return attributed;
}

- (NSAttributedString*)_attributedStringForTweet:(NSString*)body {
  NSMutableAttributedString *attributed = [self _attributedStringFromString:body];

  NSArray *entities = [TwitterText entitiesInText:body];
  [entities each:^(TwitterTextEntity *entity) {
    NSString *substring = [body substringWithRange:entity.range];
    NSString *url;
    switch (entity.type) {
      case TwitterTextEntityHashtag:
        url = [NSString stringWithFormat:@"https://twitter.com/search?q=%@&src=hash", [substring stringByReplacingOccurrencesOfString:@"#" withString:@"%23"]];
        break;
      case TwitterTextEntityCashtag:
        url = [NSString stringWithFormat:@"https://twitter.com/search?q=%@&src=ctag", [substring stringByReplacingOccurrencesOfString:@"$" withString:@"%24"]];
        break;
      case TwitterTextEntityListName:
      case TwitterTextEntityScreenName:
        url = [NSString stringWithFormat:@"https://twitter.com/%@", [substring stringByReplacingOccurrencesOfString:@"@" withString:@""]];
        break;
      case TwitterTextEntityURL:
        url = substring;
        break;

    }
    NSDictionary *attributes = [self _attributesForLinkWithURL:url];
    [attributed addAttributes:attributes range:entity.range];
  }];

  return attributed;
}

- (NSMutableAttributedString*)_attributedStringFromString:(NSString*)string {
  NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  [paragraphStyle setMaximumLineHeight:18.0];
  [paragraphStyle setMinimumLineHeight:18.0];
  
  NSDictionary *attributes = @{ NSParagraphStyleAttributeName: paragraphStyle,
                                NSFontAttributeName:  kMMFont,
                                NSForegroundColorAttributeName:  kMMTextColor,
                                };
  NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
  return attributed;
}

- (NSDictionary*)_attributesForLinkWithURL:(NSString*)url
{
  NSDictionary *attributes = @{ NSLinkAttributeName: url,
                                NSForegroundColorAttributeName: [NSColor colorWithCalibratedRed:0.264 green:0.399 blue:0.550 alpha:1.000],
                                NSUnderlineStyleAttributeName: [NSNumber numberWithInt:NSSingleUnderlineStyle],
                                NSCursorAttributeName: [NSCursor pointingHandCursor],
                                };
  return attributes;
}


@end
