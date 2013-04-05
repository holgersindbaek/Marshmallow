//
//  MMTweetMessageTableCellView.m
//  Marshmallow
//
//  Created by Fabio Pelosin on 31/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import "MMTweetMessageTableCellView.h"
#import "MarshmallowTableViewCellsConstants.h"
#import "MarshmallowConstants.h"

# define kImageViewWidth 32
# define kTextMargin 12

@implementation MMTweetMessageTableCellView

- (id)initWithFrame:(NSRect)frameRect
{
  CGFloat height = [[self class] preferredHeight];
  frameRect.size.height = height;

  self = [super initWithFrame:frameRect];
  if (!self) {
    return nil;
  }

  CGFloat contentWidth = self.contentView.frame.size.width;
  CGFloat contentHeight = self.contentView.frame.size.height;
  CGRect messageFrame = CGRectMake(kImageViewWidth + kTextMargin, 0, contentWidth - (kImageViewWidth + kTextMargin), contentHeight);
  _messageTextField = [[NSTextField alloc] initWithFrame:messageFrame];
  [_messageTextField setAutoresizingMask:NSViewHeightSizable|NSViewWidthSizable];
  [_messageTextField setBezeled:NO];
  [_messageTextField setDrawsBackground:NO];
  [_messageTextField setAllowsEditingTextAttributes:YES];
  [_messageTextField setEditable:NO];
  [_messageTextField setSelectable:YES];
  [_messageTextField setFont:kMMFont];
  [_messageTextField setTextColor:kMMTextColor];
  [self.contentView addSubview:_messageTextField];

  //  [_messageTextField setDrawsBackground:YES];
  //  [_messageTextField setBackgroundColor:[NSColor redColor]];

  _messageImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, contentHeight - kImageViewWidth, kImageViewWidth, kImageViewWidth)];
  [_messageImageView setImageScaling:NSImageScaleProportionallyUpOrDown];
  [_messageImageView setAutoresizingMask:NSViewMaxXMargin|NSViewMinYMargin];
  [self.contentView addSubview:_messageImageView];

  return self;
}

- (CGFloat)preferredHeightWithWitdth:(CGFloat)width {
  CGFloat widthDelta = self.frame.size.width - self.messageTextField.frame.size.width;
  CGFloat heightDelta = self.frame.size.height - self.messageTextField.frame.size.height;
  [self.messageTextField setPreferredMaxLayoutWidth:width - widthDelta];
  CGSize messageSize = [self.messageTextField intrinsicContentSize];
  CGFloat height = messageSize.height + heightDelta;
  return height;
}



@end
