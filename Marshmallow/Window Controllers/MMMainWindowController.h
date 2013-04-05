//
//  MMMainWindowController.h
//  Marshmallow
//
//  Created by Fabio Pelosin on 29/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import <Cocoa/Cocoa.h>

@interface MMMainWindowController : NSWindowController <NSWindowDelegate>

@property (weak) IBOutlet NSView *viewContainer;

- (IBAction)reloadData:(id)sender;

@end
