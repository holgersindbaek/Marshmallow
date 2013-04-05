//
//  MMUploadTableCellView.h
//  Marshmallow
//
//  Created by Fabio Pelosin on 31/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import <Cocoa/Cocoa.h>
#import "MMGroupedTableViewCell.h"

@interface MMUploadTableCellView : MMGroupedTableViewCell

@property NSImageView *messageImageView;
@property NSTextField *messageTextField;

@end
