//
//  MMEnterKickMessageTableCellView.m
//  Marshmallow
//
//  Created by Fabio Pelosin on 18/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import "MMInformativeTableCellView.h"
#import "MarshmallowConstants.h"

@implementation MMInformativeTableCellView {
  NSTextField *_textField;
}

- (id)initWithFrame:(NSRect)frameRect
{

  CGFloat width = frameRect.size.width;
  CGFloat height = frameRect.size.height;

  self = [super initWithFrame:CGRectMake(0, 0, width, height)];
  if (!self) {
    return nil;
  }

  _dateTextField = [[NSTextField alloc] initWithFrame:CGRectMake(50, height - 18, 35, 18)];
  [_dateTextField setAutoresizingMask:NSViewMaxXMargin|NSViewMinYMargin];
  [_dateTextField setBezeled:NO];
  [_dateTextField setEditable:NO];
  [_dateTextField setSelectable:NO];
  [_dateTextField setDrawsBackground:NO];
  [_dateTextField setFont:kMMFont];
  [_dateTextField setTextColor:kMMLighterTextColor];
  [self addSubview:_dateTextField];

  _textField = [[NSTextField alloc] initWithFrame:CGRectMake(100, height - 18, 364, 18)];
  [_textField setAutoresizingMask:NSViewWidthSizable|NSViewMinYMargin];
  [_textField setBezeled:NO];
  [_textField setEditable:NO];
  [_textField setSelectable:NO];
  [_textField setDrawsBackground:NO];
  [_textField setFont:kMMFont];
  [_textField setTextColor:kMMLighterTextColor];
  self.textField = _textField;
  [self addSubview:_textField];
  return self;
}

@end
