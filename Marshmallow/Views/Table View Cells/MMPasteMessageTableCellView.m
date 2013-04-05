//
//  MMPastieMessageTableCellView.m
//  Marshmallow
//
//  Created by Fabio Pelosin on 22/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import "MMPasteMessageTableCellView.h"

#define ktextFieldHorizontalMargin (350 - 310)
#define ktextFieldVerticalMargin   (240 - 200)

@implementation MMPasteMessageTableCellView

- (void)awakeFromNib {
  [self.imageView setWantsLayer:YES];
  [self.imageView.layer setCornerRadius:12.0f];
  [self.imageView.layer setMasksToBounds:TRUE];
}

- (CGFloat)preferredHeightWithWitdth:(CGFloat)width {
  [self.textField setPreferredMaxLayoutWidth:width - ktextFieldHorizontalMargin];
  return self.textField.intrinsicContentSize.height + ktextFieldVerticalMargin;
}

@end
