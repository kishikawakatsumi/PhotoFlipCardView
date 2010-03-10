//
//  PhotoFlipCardView.m
//  PhotoFlipCardView
//
//  Created by Kishikawa Katsumi on 10/03/06.
//  Copyright 2010 Kishikawa Katsumi. All rights reserved.
//

#import "PhotoFlipCardView.h"
#import "PhotoFlipCardThumbnail.h"

@implementation PhotoFlipCardView

@synthesize delegate;
@synthesize dataSource;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        thumbnailView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        thumbnailView.delegate = self;
        thumbnailView.dataSource = self;
        thumbnailView.rowHeight = 79.0f;
        thumbnailView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:thumbnailView];
        [thumbnailView release];
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, 4.0f)];
        footerView.backgroundColor = thumbnailView.backgroundColor;
        thumbnailView.tableFooterView = footerView;
        [footerView release];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)setDataSource:(id)d {
    dataSource = d;
    flags.dataSourceNumberOfImages = [dataSource respondsToSelector:@selector(photoFlipCardViewNumberOfImages:)];
    flags.dataSourceThumbnailAtIndex = [dataSource respondsToSelector:@selector(photoFlipCardView:thumbnailAtIndex:)];
    flags.dataSourceImageAtIndex = [dataSource respondsToSelector:@selector(photoFlipCardView:imageAtIndex:)];
}

- (void)setDelegate:(id)d {
    delegate = d;
    flags.delegateDidSelectThumbnailAtIndex = [dataSource respondsToSelector:@selector(photoFlipCardView:didSelectThumnailAtIndex:)];
}

- (UIEdgeInsets)contentInset {
    return thumbnailView.contentInset;
}

- (UIEdgeInsets)scrollIndicatorInsets {
    return thumbnailView.scrollIndicatorInsets;
}

- (void)setContentInset:(UIEdgeInsets)insets {
    thumbnailView.contentInset = insets;
}

- (void)setScrollIndicatorInsets:(UIEdgeInsets)insets {
    thumbnailView.scrollIndicatorInsets = insets;
}

- (UIImage *)photoFlipCardThumbnail:(PhotoFlipCardThumbnail *)photoFlipCardThumbnail imageAtIndex:(NSUInteger)index {
    if (flags.dataSourceImageAtIndex) {
        return [dataSource photoFlipCardView:self imageAtIndex:index];
    }
    return nil;
}

- (void)photoFlipCardThumbnail:(PhotoFlipCardThumbnail *)photoFlipCardThumbnail didSelectThumbnailAtIndex:(NSUInteger)index {
    if (flags.delegateDidSelectThumbnailAtIndex) {
        [delegate photoFlipCardView:self didSelectThumbnailAtIndex:index];
    }
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (flags.dataSourceNumberOfImages) {
        NSInteger numberOfImages = [dataSource photoFlipCardViewNumberOfImages:self];
        if (numberOfImages % NUMBER_OF_COLUMNS) {
            return numberOfImages / NUMBER_OF_COLUMNS + 1;
        } else {
            return numberOfImages / NUMBER_OF_COLUMNS;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"CellIdentifier";
	
	PhotoFlipCardThumbnail *cell = (PhotoFlipCardThumbnail *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[PhotoFlipCardThumbnail alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.dataSource = self;
	}
    
    NSUInteger row = indexPath.row;
    
    UIButton *button0 = [cell.buttons objectAtIndex:0];
    UIButton *button1 = [cell.buttons objectAtIndex:1];
    UIButton *button2 = [cell.buttons objectAtIndex:2];
    UIButton *button3 = [cell.buttons objectAtIndex:3];
    
    UIImage *image0 = nil;
    UIImage *image1 = nil; 
    UIImage *image2 = nil;
    UIImage *image3 = nil; 
    if (flags.dataSourceThumbnailAtIndex) {
        image0 = [dataSource photoFlipCardView:self thumbnailAtIndex:row * NUMBER_OF_COLUMNS + 1];
        image1 = [dataSource photoFlipCardView:self thumbnailAtIndex:row * NUMBER_OF_COLUMNS + 2];
        image2 = [dataSource photoFlipCardView:self thumbnailAtIndex:row * NUMBER_OF_COLUMNS + 3];
        image3 = [dataSource photoFlipCardView:self thumbnailAtIndex:row * NUMBER_OF_COLUMNS + 4];
    }
    
	button0.enabled = image0 != nil;
	button1.enabled = image1 != nil;
	button2.enabled = image2 != nil;
	button3.enabled = image3 != nil;
    
    [button0 setImage:image0 forState:UIControlStateNormal];
    [button1 setImage:image1 forState:UIControlStateNormal];
    [button2 setImage:image2 forState:UIControlStateNormal];
    [button3 setImage:image3 forState:UIControlStateNormal];
	
	return cell;
}

@end
