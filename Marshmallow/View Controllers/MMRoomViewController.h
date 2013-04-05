//
//  MMRoomViewController.h
//  Marshmallow
//
//  Created by Fabio Pelosin on 29/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import <Cocoa/Cocoa.h>

@interface MMRoomViewController : NSViewController

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTextField *statusLabel;
@property (assign) IBOutlet NSTextView *textView;

@property  NSString *roomID;
@property  NSString *userID;

- (IBAction)reloadData:(id)sender;
- (void)joinRoom;
- (void)windowDidResize;

@end
