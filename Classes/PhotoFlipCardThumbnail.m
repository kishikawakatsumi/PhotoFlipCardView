//
//  PhotoFlipCardThumbnail.m
//  PhotoFlipCardView
//
//  Created by Kishikawa Katsumi on 10/03/06.
//  Copyright 2010 Kishikawa Katsumi. All rights reserved.
//

#import "PhotoFlipCardThumbnail.h"
#import "PhotoFlipCardImageView.h"

#define THUMBNAIL_WIDTH 75.0f
#define THUMBNAIL_HIGHT 75.0f
#define THUMBNAIL_MARGIN 4.0f

@implementation PhotoFlipCardThumbnail

@synthesize delegate;
@synthesize dataSource;
@synthesize buttons;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    	buttons = [[NSMutableArray alloc] initWithCapacity:4];
        for (int i = 0; i < 4; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.exclusiveTouch = YES;
            button.frame = CGRectMake(THUMBNAIL_MARGIN * (i % NUMBER_OF_COLUMNS + 1) + (THUMBNAIL_WIDTH * (i % NUMBER_OF_COLUMNS)), THUMBNAIL_MARGIN, THUMBNAIL_WIDTH, THUMBNAIL_HIGHT);
            [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [buttons addObject:button];
        }
    }
    return self;
}

- (void)dealloc {
    [buttons release];
    [super dealloc];
}

- (void)buttonTapped:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self performSelector:@selector(highlightButton:) withObject:button afterDelay:0.0];
}

- (void)highlightButton:(UIButton *)button {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    button.highlighted = YES;
    [self performSelector:@selector(showFullImage:) withObject:button afterDelay:0.0];
}

- (void)showFullImage:(UIButton *)button {
    UIView *keyWindow = self.window;
    dimView = [[UIView alloc] initWithFrame:keyWindow.frame];
    dimView.backgroundColor = [UIColor blackColor];
    dimView.alpha = 0.5f;
    [keyWindow addSubview:dimView];
    [dimView release];
    
    UIImageView *thumbView = [[UIImageView alloc] initWithImage:button.currentImage];
    thumbFrame = [self convertRect:button.frame toView:nil];
    thumbView.frame = thumbFrame;
    thumbView.userInteractionEnabled = YES;
    [keyWindow addSubview:thumbView];
    [thumbView release];
    
    button.highlighted = NO;
    
    NSIndexPath *indexPath = [(UITableView *)self.superview indexPathForCell:self];
    NSUInteger column = [buttons indexOfObject:button];
    NSUInteger index = indexPath.row * NUMBER_OF_COLUMNS + column + 1;
    if ([delegate respondsToSelector:@selector(photoFlipCardThumbnail:didSelectThumnailAtIndex:)]) {
        [delegate photoFlipCardThumbnail:self didSelectThumnailAtIndex:index];
    }
    fullImage = [[dataSource photoFlipCardThumbnail:self imageAtIndex:index] retain];
    
    [self performSelector:@selector(flipThumViewToFullView:) withObject:thumbView afterDelay:0.2];
}

- (void)flipThumViewToFullView:(UIView *)thumbView {
    PhotoFlipCardImageView *fullView = [[PhotoFlipCardImageView alloc] initWithFrame:self.window.frame];
    fullView.delegate = self;
    fullView.contentMode = UIViewContentModeScaleAspectFit;
    fullView.image = fullImage;
    [fullImage release];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:thumbView cache:YES];
    thumbView.frame = fullView.frame;
    [thumbView addSubview:fullView];
    [fullView release];
    [UIView commitAnimations];
    
	while([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
		[NSThread sleepForTimeInterval:0.05];
		[[UIApplication sharedApplication] endIgnoringInteractionEvents];
	}
}

- (void)photoFlipCardImageViewSingleTapped:(PhotoFlipCardImageView *)photoFlipCardImageView {
    UIView *thumbView = photoFlipCardImageView.superview;
    
    [UIView beginAnimations:nil context:thumbView];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:thumbView cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(flipAnimationFinished:finished:context:)];
    thumbView.frame = thumbFrame;
    [photoFlipCardImageView removeFromSuperview];
    [UIView commitAnimations];
}

- (void)flipAnimationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
    UIView *thumbView = (UIView *)context;
    [thumbView removeFromSuperview];
    [dimView removeFromSuperview];
}

@end
