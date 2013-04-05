//
//  MMUserTableCellView.m
//  Marshmallow
//
//  Created by Fabio Pelosin on 30/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import "MMUserTableCellView.h"
#import "RBLResizableImage.h"
#import "MarshmallowTableViewCellsConstants.h"

@implementation MMUserTableCellView

- (void)awakeFromNib {
  [self.imageView setWantsLayer:YES];
  [self.imageView.layer setCornerRadius:self.imageView.frame.size.width / 2.0];
  [self.imageView.layer setMasksToBounds:TRUE];

  RBLResizableImage *background = kTVCUserBackgroundImage;
  [background setCapInsets:NSEdgeInsetsMake(0, 40, 0, 40)];
  self.backgroundImageView.image = background;

}

@end
