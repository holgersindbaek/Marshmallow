//
//  MMCampFireTableCellView.h
//  Marshmallow
//
//  Created by Fabio Pelosin on 18/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import <Cocoa/Cocoa.h>
#import "MMGroupedTableViewCell.h"
#import "MMIntrisicSizedTextField.h"

@interface MMTextMessageTableCellView : MMGroupedTableViewCell

@property NSTextView *messageTextField;

@end
