//
//  MMMainWindowController.m
//  Marshmallow
//
//  Created by Fabio Pelosin on 29/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import "MMMainWindowController.h"
#import "MMRoomViewController.h"
#import "IFToastingKit.h"
#import "MMPreferencesManager.h"


//------------------------------------------------------------------------------

@interface MMMainWindowController ()

@property MMRoomViewController *currentViewController;
@property IFToastingKit *apiClient;

@end


//------------------------------------------------------------------------------

@implementation MMMainWindowController

- (id)init
{
  self = [super initWithWindowNibName:@"MMMainWindowController"];
  if (!self) {
    return nil;
  }

  return self;
}

- (void)windowDidLoad
{
  [super windowDidLoad];
  self.window.delegate = self;

  NSButton *closeButton = [self.window standardWindowButton:NSWindowCloseButton];
  [closeButton setTarget:self];
  [closeButton setAction:@selector(closeButtonAction:)];

  self.currentViewController = [[MMRoomViewController alloc] initWithNibName:@"MMRoomViewController" bundle:nil];

  self.currentViewController.roomID = @"537108";
  self.currentViewController.userID = @"1291501";

  NSView *view = self.currentViewController.view;
  [self.viewContainer addSubview:view];


  NSView *contentView = self.viewContainer;
  NSView *customView = view;
  [customView setTranslatesAutoresizingMaskIntoConstraints:NO];

  NSDictionary *views = NSDictionaryOfVariableBindings(customView);

  [contentView addConstraints:
   [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[customView]|"
                                           options:0
                                           metrics:nil
                                             views:views]];

  [contentView addConstraints:
   [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[customView]|"
                                           options:0
                                           metrics:nil
                                             views:views]];


	[view setFrame: [self.viewContainer bounds]];
  [self.currentViewController joinRoom];
}

- (IBAction)reloadData:(id)sender;
{
  [self.currentViewController reloadData:sender];
}

-(void)closeButtonAction:(id)sender
{
  // TODO Notify the app delegate
  // Leave the room
  [self.window close];
}

- (void)windowDidResize:(NSNotification *)notification
{
  [self.currentViewController windowDidResize];
}

@end
