//
//  MMAppDelegate.m
//  Marshmallow
//
//  Created by Fabio Pelosin on 18/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import "MMAppDelegate.h"
#import "AFHTTPRequestOperationLogger.h"
#import "CoreData+MagicalRecord.h"
#import "MASPreferencesWindowController.h"

#import "MMGeneralPreferencesViewController.h"
#import "MMMainWindowController.h"

#import "MMNotificationManager.h"


//------------------------------------------------------------------------------

@interface MMAppDelegate ()

@property NSMutableArray *windowControllers;

@end


//------------------------------------------------------------------------------

@implementation MMAppDelegate


//------------------------------------------------------------------------------
#pragma mark - NSApplicationDelegate
//------------------------------------------------------------------------------

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                       diskCapacity:20 * 1024 * 1024
                                                           diskPath:[NSString stringWithFormat:@"%@/Library/Caches/%@", NSHomeDirectory(), [[NSProcessInfo processInfo] processName]]];
  [NSURLCache setSharedURLCache:URLCache];
  [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@ "MyDatabase.sqlite"];
  [[AFHTTPRequestOperationLogger sharedLogger] setLevel:AFLoggerLevelDebug];
//  [[AFHTTPRequestOperationLogger sharedLogger] startLogging];

  _windowControllers = [NSMutableArray new];
  [self newWindow:self];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
  [MagicalRecord cleanUp];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
  return NO;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
  NSWindowController *controller = [self.windowControllers lastObject];
  if (controller) {
    [controller showWindow:self];
  } else {
    [self newWindow:self];
  }
  return YES;
}


//------------------------------------------------------------------------------
#pragma mark - IBActions
//------------------------------------------------------------------------------

- (IBAction)newWindow:(id)sender
{
	MMMainWindowController *controller = [MMMainWindowController new];
  [self.windowControllers addObject:controller];
	[controller showWindow:self];
}

- (IBAction)openPreferences:(id)sender;
{
  [self.preferencesWindowController showWindow:self];
}

- (IBAction)reloadData:(id)sender;
{
  id controller = [self currentWindowController];
  if ([controller respondsToSelector:@selector(reloadData:)]) {
    [controller reloadData:sender];
  }
}


//------------------------------------------------------------------------------
#pragma mark - Menu Validation
//------------------------------------------------------------------------------

-(BOOL)validateMenuItem:(NSMenuItem*)theMenuItem
{
  BOOL enable = [self respondsToSelector:[theMenuItem action]];
	if ([theMenuItem action] == @selector(newDocument:))
	{
			enable = NO;
	}
	return enable;
}


//------------------------------------------------------------------------------
#pragma mark - Window Controllers
//------------------------------------------------------------------------------

@synthesize preferencesWindowController = _preferencesWindowController;

- (NSWindowController *)preferencesWindowController
{
  if (_preferencesWindowController == nil)
  {
    NSViewController *generalViewController = [[MMGeneralPreferencesViewController alloc] initWithNibName:@"MMGeneralPreferencesViewController" bundle:nil];
    NSArray *controllers = @[generalViewController];

    NSString *title = NSLocalizedString(@"Preferences", @"Common title for Preferences window");
    _preferencesWindowController = [[MASPreferencesWindowController alloc] initWithViewControllers:controllers title:title];
  }
  return _preferencesWindowController;
}

- (id)currentWindowController
{
  return [[NSApp keyWindow] windowController];
}



@end
