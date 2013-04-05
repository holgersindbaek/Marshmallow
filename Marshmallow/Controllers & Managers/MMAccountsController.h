//
//  MMAccountsController.h
//  Marshmallow
//
//  Created by Fabio Pelosin on 23/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import <Foundation/Foundation.h>
#import <IFToastingKit/IFToastingKit.h>

@interface MMAccountsController : NSObject

+ (instancetype)sharedInstance;

@property IFToastingKit *apiClient;

- (BOOL)authenticate;

@end
