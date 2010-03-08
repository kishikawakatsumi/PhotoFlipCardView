//
//  RootViewController.h
//  PhotoFlipCardView
//
//  Created by Kishikawa Katsumi on 10/03/06.
//  Copyright Kishikawa Katsumi 2010. All rights reserved.
//

#import "PhotoFlipCardView.h"

@interface RootViewController : UIViewController<PhotoFlipCardViewDataSource, PhotoFlipCardViewDelegate> {
    PhotoFlipCardView *thumbnailView;
}

@end
