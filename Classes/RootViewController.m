//
//  RootViewController.m
//  PhotoFlipCardView
//
//  Created by Kishikawa Katsumi on 10/03/06.
//  Copyright Kishikawa Katsumi 2010. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

- (void)dealloc {
    [super dealloc];
}

- (void)loadView {
    self.wantsFullScreenLayout = YES;
    
	UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
    contentView.backgroundColor = [UIColor blackColor];
	self.view = contentView;
	[contentView release];
    
	thumbnailView = [[PhotoFlipCardView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
	thumbnailView.delegate = self;
	thumbnailView.dataSource = self;
	thumbnailView.scrollIndicatorInsets = UIEdgeInsetsMake(64.0f, 0.0f, 0.0f, 0.0f);
	thumbnailView.contentInset = UIEdgeInsetsMake(64.0f, 0.0f, 0.0f, 0.0f);
	[contentView addSubview:thumbnailView];
	[thumbnailView release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Flip Card Photo View";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark PhotoFlipCardViewDataSource Methods

- (NSUInteger)photoFlipCardViewNumberOfImages:(PhotoFlipCardView *)photoFlipCardView {
	return 158;
}

- (UIImage *)photoFlipCardView:(PhotoFlipCardView *)photoFlipCardView thumbnailAtIndex:(NSUInteger)index {
    NSBundle *mainBundle = [NSBundle mainBundle];
    return [UIImage imageWithContentsOfFile:[mainBundle pathForResource:[NSString stringWithFormat:@"$$%04d.jpg", index] ofType:nil]];
}

- (UIImage *)photoFlipCardView:(PhotoFlipCardView *)photoFlipCardView imageAtIndex:(NSUInteger)index {
    NSBundle *mainBundle = [NSBundle mainBundle];
    return [UIImage imageWithContentsOfFile:[mainBundle pathForResource:[NSString stringWithFormat:@"%04d.jpg", index] ofType:nil]];
}

@end
