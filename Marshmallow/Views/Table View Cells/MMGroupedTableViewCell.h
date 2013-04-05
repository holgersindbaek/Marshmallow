//
//  MMGroupedTableViewCell.h
//  Marshmallow
//
//  Created by Fabio Pelosin on 30/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import <Cocoa/Cocoa.h>

@interface MMGroupedTableViewCell : NSTableCellView

@property (readonly) NSTextField *dateTextField;
@property (readonly) NSImageView *backgroundFillImageView;
@property (readonly) NSImageView *backgroundBottomImageView;
@property (readonly) NSView *contentView;

@property (nonatomic) BOOL endOfGroup;
@property (nonatomic) BOOL unread;


+ (CGFloat)preferredHeight;

- (CGFloat)preferredHeightWithWitdth:(CGFloat)width;

// Default initializer
- (id)init;

@end
