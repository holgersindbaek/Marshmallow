//
//  MMIntrisicSizedTextField.m
//  Marshmallow
//
//  Created by Fabio Pelosin on 18/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import "MMIntrisicSizedTextField.h"

@implementation MMIntrisicSizedTextField

-(NSSize)intrinsicContentSize
{
  if ( ![self.cell wraps] ) {
    return [super intrinsicContentSize];
  }

  NSRect frame = [self frame];

  // CGFloat width = MIN(self.frame.size.width, self.preferredMaxLayoutWidth) ;
  CGFloat width = self.preferredMaxLayoutWidth;

  // Make the frame very high, while keeping the width
  frame.size.width = width;
  frame.size.height = CGFLOAT_MAX;
  [self.cell setWraps:TRUE];


  // Calculate new height within the frame
  // with practically infinite height.
  CGFloat height = [self.cell cellSizeForBounds:frame].height;

  return NSMakeSize(width, height);
}


@end
