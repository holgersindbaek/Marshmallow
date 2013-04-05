//
//  MMGroupedTableViewCell.m
//  Marshmallow
//
//  Created by Fabio Pelosin on 30/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import "MMGroupedTableViewCell.h"
#import "RBLResizableImage.h"
#import "MarshmallowTableViewCellsConstants.h"
#import "MarshmallowConstants.h"

@interface MMGroupedTableViewCell ()

@property RBLResizableImage *separatorImage;
@property RBLResizableImage *endOfGroupImage;

@end

@implementation MMGroupedTableViewCell

- (id)initWithFrame:(NSRect)frameRect
{

  CGFloat width = frameRect.size.width;
  CGFloat height = frameRect.size.height;

  self = [super initWithFrame:CGRectMake(0, 0, width, height)];
  if (!self) {
    return nil;
  }

  CGFloat bottomHeight = 20;

  _backgroundFillImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, bottomHeight, width, height - bottomHeight)];
  [_backgroundFillImageView setImageScaling:NSImageScaleAxesIndependently];
  [_backgroundFillImageView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
  [self addSubview:_backgroundFillImageView];

  _backgroundBottomImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, width, bottomHeight)];
  [_backgroundBottomImageView setImageScaling:NSImageScaleAxesIndependently];
  [_backgroundBottomImageView setAutoresizingMask:NSViewWidthSizable|NSViewMaxYMargin];
  [self addSubview:_backgroundBottomImageView];

  _separatorImage = kTVCMessageBottomSeparatorImage;
  [_separatorImage setCapInsets:NSEdgeInsetsMake(18, 40, 1, 40)];
  _endOfGroupImage = kTVCMessageBottomEndImage;
  [_endOfGroupImage setCapInsets:NSEdgeInsetsMake(10, 40, 1, 40)];

  RBLResizableImage *fillImage = kTVCMessageFillImage;
  [fillImage setCapInsets:NSEdgeInsetsMake(1, 40, 1, 40)];
  self.backgroundFillImageView.image = fillImage;

  self.backgroundBottomImageView.image = _endOfGroupImage;

  _dateTextField = [[NSTextField alloc] initWithFrame:CGRectMake(50, height - 18, 35, 18)];
  [_dateTextField setAutoresizingMask:NSViewMaxXMargin|NSViewMinYMargin];
  [_dateTextField setBezeled:NO];
  [_dateTextField setDrawsBackground:NO];
  [_dateTextField setEditable:NO];
  [_dateTextField setSelectable:NO];
  [_dateTextField setStringValue:@"15:30"];
  [_dateTextField setDrawsBackground:YES];
  [_dateTextField setFont:kMMFont];
  [_dateTextField setTextColor:kMMLightTextColor];
  [self addSubview:_dateTextField];

  _contentView = [[NSView alloc] initWithFrame:CGRectMake(100, bottomHeight, 200, height - bottomHeight)];
  [_contentView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
  [self addSubview:_contentView];
  return self;
}

- (id)init
{
  return [self initWithFrame:CGRectMake(0, 0, 350, 240)];
}

+ (CGFloat)preferredHeight;
{
  return 50.0;
}

- (CGFloat)preferredHeightWithWitdth:(CGFloat)width;
{
  return [[self class] preferredHeight];
}

- (void)setEndOfGroup:(BOOL)endOfGroup
{
  _endOfGroup = endOfGroup;
  if (endOfGroup) {
    self.backgroundBottomImageView.image = self.endOfGroupImage;
  } else
  {
    self.backgroundBottomImageView.image = self.separatorImage;
  }
}

- (void)setUnread:(BOOL)unread
{
  if (unread) {
//    [self.dateTextField setDrawsBackground:YES];
//    [self.dateTextField setBackgroundColor:[NSColor colorWithCalibratedRed:0.264 green:0.399 blue:0.550 alpha:1.000]];
    [_dateTextField setTextColor:[NSColor colorWithCalibratedRed:0.264 green:0.399 blue:0.550 alpha:1.000]];
    [_dateTextField setFont:kMMBoldFont];

  } else
  {
    [self.dateTextField setDrawsBackground:NO];
    [_dateTextField setTextColor:kMMLightTextColor];
    [_dateTextField setFont:kMMFont];
  }
}

@end
