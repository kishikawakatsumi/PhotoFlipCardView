//
//  PhotoFlipCardViewAppDelegate.h
//  PhotoFlipCardView
//
//  Created by Kishikawa Katsumi on 10/03/06.
//  Copyright Kishikawa Katsumi 2010. All rights reserved.
//

@interface PhotoFlipCardViewAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

