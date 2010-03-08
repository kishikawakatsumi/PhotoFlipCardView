//
//  PhotoFlipCardViewAppDelegate.m
//  PhotoFlipCardView
//
//  Created by Kishikawa Katsumi on 10/03/06.
//  Copyright Kishikawa Katsumi 2010. All rights reserved.
//

#import "PhotoFlipCardViewAppDelegate.h"
#import "RootViewController.h"

@implementation PhotoFlipCardViewAppDelegate

@synthesize window;
@synthesize navigationController;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}

@end
