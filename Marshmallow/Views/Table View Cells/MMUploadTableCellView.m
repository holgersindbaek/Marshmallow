//
//  MMUploadTableCellView.m
//  Marshmallow
//
//  Created by Fabio Pelosin on 31/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import "MMUploadTableCellView.h"
#import "MarshmallowTableViewCellsConstants.h"
#import "MarshmallowConstants.h"

# define kImageViewWidth 32
# define kTextMargin 24

@implementation MMUploadTableCellView

- (id)initWithFrame:(NSRect)frameRect
{
  CGFloat height = [[self class] preferredHeight];
  frameRect.size.height = height;

  self = [super initWithFrame:frameRect];
  if (!self) {
    return nil;
  }

  CGFloat textHeight = 18;
  CGFloat contentWidth = self.contentView.frame.size.width;
  CGFloat contentHeight = self.contentView.frame.size.height;
  CGRect messageFrame = CGRectMake(kImageViewWidth + kTextMargin, (contentHeight - textHeight)/2, contentWidth - (kImageViewWidth + kTextMargin), textHeight);
  _messageTextField = [[NSTextField alloc] initWithFrame:messageFrame];
  [_messageTextField setAutoresizingMask:NSViewWidthSizable|NSViewMaxYMargin];
  [_messageTextField setBezeled:NO];
  [_messageTextField setDrawsBackground:NO];
  [_messageTextField setAllowsEditingTextAttributes:YES];
  [_messageTextField setEditable:NO];
  [_messageTextField setSelectable:YES];
  [_messageTextField setFont:kMMFont];
  [_messageTextField setTextColor:kMMTextColor];
  [self.contentView addSubview:_messageTextField];

  // TODO: Bug it does not compress
  [_messageTextField setContentCompressionResistancePriority:NSLayoutPriorityFittingSizeCompression forOrientation:NSLayoutConstraintOrientationHorizontal];
  [[_messageTextField cell] setLineBreakMode:NSLineBreakByTruncatingMiddle];

//  [_messageTextField setDrawsBackground:YES];
//  [_messageTextField setBackgroundColor:[NSColor redColor]];

  _messageImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, kImageViewWidth, kImageViewWidth)];
  [_messageImageView setImageScaling:NSImageScaleProportionallyUpOrDown];
  [_messageImageView setAutoresizingMask:NSViewMaxXMargin|NSViewMaxYMargin];
  [self.contentView addSubview:_messageImageView];

  return self;
}

+ (CGFloat)preferredHeight;
{
  return 60.0;
}

@end
