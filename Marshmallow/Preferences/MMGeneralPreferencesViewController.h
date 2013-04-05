//
//  MMGeneralPreferencesViewController.h
//  Marshmallow
//
//  Created by Fabio Pelosin on 22/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import <Cocoa/Cocoa.h>
#import "MASPreferencesViewController.h"

@interface MMGeneralPreferencesViewController : NSViewController <MASPreferencesViewController>
@property (weak) IBOutlet NSTextField *authorizationTokeTextField;

@end
