//
//  MMPastieMessageTableCellView.h
//  Marshmallow
//
//  Created by Fabio Pelosin on 22/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import <Cocoa/Cocoa.h>

@interface MMPasteMessageTableCellView : NSTableCellView

@property (assign) IBOutlet NSTextField *authorTextField;
@property (assign) IBOutlet NSTextField *dateTextField;

@end
