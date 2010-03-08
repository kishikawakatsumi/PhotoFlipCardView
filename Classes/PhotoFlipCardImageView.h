//
//  PhotoFlipCardImageView.h
//  PhotoFlipCardView
//
//  Created by Kishikawa Katsumi on 10/03/06.
//  Copyright 2010 Kishikawa Katsumi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoImageView;

@interface PhotoFlipCardImageView : UIView<UIScrollViewDelegate> {
    id delegate;
    UIImage *image;
    
    UIScrollView *imageScrollView;
    
    PhotoImageView *imageView;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) UIImage *image;

@end

@protocol PhotoFlipCardImageViewDelegate<NSObject>
- (void)photoFlipCardImageViewSingleTapped:(PhotoFlipCardImageView *)photoFlipCardImageView;
@end
