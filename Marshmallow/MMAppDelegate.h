//
//  MMAppDelegate.h
//  Marshmallow
//
//  Created by Fabio Pelosin on 18/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import <Cocoa/Cocoa.h>

@interface MMAppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, readonly) NSWindowController *preferencesWindowController;

- (IBAction)newWindow:(id)sender;
- (IBAction)openPreferences:(id)sender;
- (IBAction)reloadData:(id)sender;

@end
