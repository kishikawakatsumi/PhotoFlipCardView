//
//  PhotoFlipCardThumbnail.h
//  PhotoFlipCardView
//
//  Created by Kishikawa Katsumi on 10/03/06.
//  Copyright 2010 Kishikawa Katsumi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoFlipCardView.h"

@interface PhotoFlipCardThumbnail : UITableViewCell {
    id delegate;
    id dataSource;
	NSMutableArray *buttons;
    UIImage *fullImage;
    UIView *dimView;
    CGRect thumbFrame;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) id dataSource;
@property (nonatomic, readonly) NSMutableArray *buttons;

@end

@protocol PhotoFlipCardThumbnailDataSource
- (UIImage *)photoFlipCardThumbnail:(PhotoFlipCardThumbnail *)photoFlipCardThumbnail imageAtIndex:(NSUInteger)index;
@end

@protocol PhotoFlipCardThumbnailDelegate
@optional
- (void)photoFlipCardThumbnail:(PhotoFlipCardThumbnail *)photoFlipCardThumbnail didSelectThumnailAtIndex:(NSUInteger)index;
@end
