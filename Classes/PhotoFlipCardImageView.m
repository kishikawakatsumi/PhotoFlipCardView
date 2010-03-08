//
//  PhotoFlipCardImageView.m
//  PhotoFlipCardView
//
//  Created by Kishikawa Katsumi on 10/03/06.
//  Copyright 2010 Kishikawa Katsumi. All rights reserved.
//

#import "PhotoFlipCardImageView.h"

@interface PhotoImageView : UIImageView {
    id delegate;
    BOOL singleTapReady;
    CGPoint tapLocation;
    BOOL multipleTouches;
    BOOL twoFingerTapIsPossible;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, readonly) CGPoint tapLocation;

@end

@protocol PhotoImageViewDelegate <NSObject>
- (void)photoImageViewSingleTapped:(PhotoImageView *)photoImageView;
- (void)photoImageViewDoubleTapped:(PhotoImageView *)photoImageView;
@end

#define DOUBLE_TAP_DELAY 0.35

CGPoint midpointBetweenPoints(CGPoint a, CGPoint b);

@interface PhotoImageView(Private)
- (void)handleSingleTap;
- (void)handleDoubleTap;
- (void)handleTwoFingerTap;
@end

CGPoint midpointBetweenPoints(CGPoint a, CGPoint b) {
    CGFloat x = (a.x + b.x) / 2.0;
    CGFloat y = (a.y + b.y) / 2.0;
    return CGPointMake(x, y);
}

@implementation PhotoImageView

@synthesize delegate;
@synthesize tapLocation;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleSingleTap) object:nil];
    
    if ([[event touchesForView:self] count] > 1) {
        multipleTouches = YES;
    }
    if ([[event touchesForView:self] count] > 2) {
        twoFingerTapIsPossible = NO;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    BOOL allTouchesEnded = ([touches count] == [[event touchesForView:self] count]);
    
    if (!multipleTouches) {
        UITouch *touch = [touches anyObject];
        tapLocation = [touch locationInView:self];
        
        if ([touch tapCount] == 1) {
            [self performSelector:@selector(handleSingleTap) withObject:nil afterDelay:DOUBLE_TAP_DELAY];
        } else if([touch tapCount] == 2) {
            [self handleDoubleTap];
        }
    } else if (multipleTouches && twoFingerTapIsPossible) { 
        if ([touches count] == 2 && allTouchesEnded) {
            int i = 0; 
            int tapCounts[2]; CGPoint tapLocations[2];
            for (UITouch *touch in touches) {
                tapCounts[i]    = [touch tapCount];
                tapLocations[i] = [touch locationInView:self];
                i++;
            }
            if (tapCounts[0] == 1 && tapCounts[1] == 1) {
                tapLocation = midpointBetweenPoints(tapLocations[0], tapLocations[1]);
                [self handleTwoFingerTap];
            }
        } else if ([touches count] == 1 && !allTouchesEnded) {
            UITouch *touch = [touches anyObject];
            if ([touch tapCount] == 1) {
                tapLocation = [touch locationInView:self];
            } else {
                twoFingerTapIsPossible = NO;
            }
        } else if ([touches count] == 1 && allTouchesEnded) {
            UITouch *touch = [touches anyObject];
            if ([touch tapCount] == 1) {
                tapLocation = midpointBetweenPoints(tapLocation, [touch locationInView:self]);
                [self handleTwoFingerTap];
            }
        }
    }
    
    if (allTouchesEnded) {
        twoFingerTapIsPossible = YES;
        multipleTouches = NO;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    twoFingerTapIsPossible = YES;
    multipleTouches = NO;
}

#pragma mark Private

- (void)handleSingleTap {
    if ([delegate respondsToSelector:@selector(photoImageViewSingleTapped:)]) {
        [delegate photoImageViewSingleTapped:self];
    }
}

- (void)handleDoubleTap {
    if ([delegate respondsToSelector:@selector(photoImageViewDoubleTapped:)]) {
        [delegate photoImageViewDoubleTapped:self];
    }
}

- (void)handleTwoFingerTap {
}

@end


@implementation PhotoFlipCardImageView

@synthesize delegate;
@synthesize image;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        
        imageScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        imageScrollView.delegate = self;
        imageScrollView.backgroundColor = [UIColor blackColor];
        imageScrollView.showsHorizontalScrollIndicator = NO;
        imageScrollView.showsVerticalScrollIndicator = NO;
        imageScrollView.bouncesZoom = YES;
        imageScrollView.minimumZoomScale = 1.0f;
        imageScrollView.maximumZoomScale = 2.0f;
        [self addSubview:imageScrollView];
        [imageScrollView release];
        
        imageView = [[PhotoImageView alloc] initWithFrame:self.frame];
        imageView.delegate = self;
        [imageScrollView addSubview:imageView];
        [imageView release];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)setImage:(UIImage *)img {
    imageView.image = img;
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    
    zoomRect.size.height = imageScrollView.frame.size.height / scale;
    zoomRect.size.width  = imageScrollView.frame.size.width  / scale;
    
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}

- (void)photoImageViewSingleTapped:(PhotoImageView *)photoImageView {
    float zoomScale = [imageScrollView zoomScale];
    if (zoomScale > 1.0f) {
        return;
    }
    if ([delegate respondsToSelector:@selector(photoFlipCardImageViewSingleTapped:)]) {
        [delegate photoFlipCardImageViewSingleTapped:self];
    }
}

- (void)photoImageViewDoubleTapped:(PhotoImageView *)photoImageView {
    float zoomScale = [imageScrollView zoomScale];
    CGRect zoomRect;
    if (zoomScale > 1.0f) {
        zoomRect = [self zoomRectForScale:1.0f withCenter:photoImageView.tapLocation];
    } else {
        zoomRect = [self zoomRectForScale:2.0f withCenter:photoImageView.tapLocation];
    }
    
    [imageScrollView zoomToRect:zoomRect animated:YES];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return imageView;
}

@end
