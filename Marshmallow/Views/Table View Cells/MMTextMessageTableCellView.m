//
//  MMCampFireTableCellView.m
//  Marshmallow
//
//  Created by Fabio Pelosin on 18/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import "MMTextMessageTableCellView.h"
#import "MarshmallowConstants.h"
#import "NS(Attributed)String+Geometrics.h"

@interface MMTextMessageTableCellView () <NSTextViewDelegate>
@end

@implementation MMTextMessageTableCellView

- (id)init
{
  CGFloat width = 350;
  CGFloat height = 240;

  self = [super initWithFrame:CGRectMake(0, 0, width, height)];
  if (!self) {
    return nil;
  }

  _messageTextField = [[NSTextView alloc] initWithFrame:self.contentView.bounds];
  [_messageTextField setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
  [_messageTextField setLinkTextAttributes:nil];
  [_messageTextField setDrawsBackground:NO];
  [_messageTextField setEditable:NO];
  [_messageTextField setSelectable:YES];
  [_messageTextField setFont:kMMFont];
  [_messageTextField setTextColor:kMMTextColor];
  [_messageTextField setDelegate:self];

  [self.contentView addSubview:_messageTextField];

  return self;
}

#define ktextFieldHorizontalMargin (350 - 200)
#define ktextFieldVerticalMargin   (240 - 220)

- (CGFloat)preferredHeightWithWitdth:(CGFloat)width {
  CGFloat widthDelta = self.frame.size.width - self.messageTextField.frame.size.width;
  CGFloat heightDelta = self.frame.size.height - self.messageTextField.frame.size.height;
  CGFloat height = [self.messageTextField.attributedString heightForWidth:width - widthDelta];
  return height + heightDelta;
}


/**
 Removes the selection from the cell once it looses focus.
 - http://stackoverflow.com/questions/4907798/how-can-i-know-when-nstextview-loses-focus
 */
- (void)textDidEndEditing:(NSNotification *)notification
{
  [self.messageTextField setSelectedRange:NSMakeRange(0,0)];
}

/**
 Disable menu that makes sense only when the text field is editable.
 */
- (NSMenu *)textView:(NSTextView *)view menu:(NSMenu *)menu forEvent:(NSEvent *)event atIndex:(NSUInteger)charIndex;
{
  [menu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem *item, NSUInteger idx, BOOL *stop) {
    if (item.action == @selector(cut:) || item.action == @selector(paste:)) {
      [menu removeItem:item];
    }
    else {
      [item.submenu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem *submenuItem, NSUInteger idx, BOOL *sub_stop) {
        if (submenuItem.action == @selector(orderFrontFontPanel:) || submenuItem.action == @selector(checkSpelling:) || submenuItem.action == @selector(toggleSmartInsertDelete:)) {
          [menu removeItem:item];
          *sub_stop = true;
        }
      }];
    }
  }];
  return menu;
}




@end
