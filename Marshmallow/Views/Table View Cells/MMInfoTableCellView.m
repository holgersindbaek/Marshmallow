//
//  MMInfoTableCellView.m
//  Marshmallow
//
//  Created by Fabio Pelosin on 01/02/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import "MMInfoTableCellView.h"

@implementation MMInfoTableCellView {
  NSImageView *_imageView;
}

// http://stackoverflow.com/questions/7781982/implement-drag-from-nsimageview-and-save-image-to-a-file

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
      return nil;
    }

  [self.dateTextField setHidden:TRUE];

  _imageView = [[NSImageView alloc] initWithFrame:self.contentView.bounds];
  [_imageView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
  [_imageView setImageAlignment:NSImageAlignLeft];
  [_imageView setImageScaling:NSImageScaleProportionallyUpOrDown];
  [self.contentView addSubview:_imageView];
  self.imageView = _imageView;

  return self;
}

@end
