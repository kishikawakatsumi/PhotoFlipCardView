//
//  PhotoFlipCardView.h
//  PhotoFlipCardView
//
//  Created by Kishikawa Katsumi on 10/03/06.
//  Copyright 2010 Kishikawa Katsumi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NUMBER_OF_COLUMNS 4

@class PhotoFlipCardThumbnail;

@interface PhotoFlipCardView : UIView<UITableViewDelegate, UITableViewDataSource> {
    UITableView *thumbnailView;
    id delegate;
    id dataSource;
    struct {
        unsigned int dataSourceNumberOfImages:1;
        unsigned int dataSourceThumbnailAtIndex:1;
        unsigned int dataSourceImageAtIndex:1;
    } flags;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) id dataSource;
@property (nonatomic) UIEdgeInsets contentInset;
@property (nonatomic) UIEdgeInsets scrollIndicatorInsets;

@end

@protocol PhotoFlipCardViewDataSource
@optional
- (NSUInteger)photoFlipCardViewNumberOfImages:(PhotoFlipCardView *)photoFlipCardView;
- (UIImage *)photoFlipCardView:(PhotoFlipCardView *)photoFlipCardView thumbnailAtIndex:(NSUInteger)index;
- (UIImage *)photoFlipCardView:(PhotoFlipCardView *)photoFlipCardView imageAtIndex:(NSUInteger)index;
@end

@protocol PhotoFlipCardViewDelegate
@optional
- (void)photoFlipCardView:(PhotoFlipCardView *)photoFlipCardView didSelectThumnailAtIndex:(NSUInteger)index;
@end
