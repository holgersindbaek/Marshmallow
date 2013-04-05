//
//  MMGeneralPreferencesViewController.m
//  Marshmallow
//
//  Created by Fabio Pelosin on 22/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import "MMGeneralPreferencesViewController.h"
#import "MMPreferencesManager.h"

@interface MMGeneralPreferencesViewController ()

@end

@implementation MMGeneralPreferencesViewController

//- (id)init
//{
//  return [super initWithNibName:@"GeneralPreferencesView" bundle:nil];
//}

#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString *)identifier
{
  return @"GeneralPreferences";
}

- (NSImage *)toolbarItemImage
{
  return [NSImage imageNamed:NSImageNamePreferencesGeneral];
}

- (NSString *)toolbarItemLabel
{
  return NSLocalizedString(@"General", @"Toolbar item name for the General preference pane");
}

- (void)viewWillAppear
{
  NSString *authorizationToken = [MMPreferencesManager authorizationToken];
  self.authorizationTokeTextField.stringValue = authorizationToken ? authorizationToken : @"";
}

- (void)viewDidDisappear
{

}

- (IBAction)authorizationTokenTextFieldAction:(NSTextField*)sender {
  [MMPreferencesManager setAuthorizationToken:sender.stringValue];
}

@end
