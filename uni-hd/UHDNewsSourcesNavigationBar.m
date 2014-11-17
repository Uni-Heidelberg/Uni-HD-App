//
//  UHDNewsSourcesNavigationBar.m
//  uni-hd
//
//  Created by Kevin Geier on 08.11.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsSourcesNavigationBar.h"
#import "UHDSourceCollectionViewCell.h"
#import "UHDNewsSource.h"


@interface UHDNewsSourcesNavigationBar () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *sourceButton;

@end

@implementation UHDNewsSourcesNavigationBar


- (void)awakeFromNib
{
    [super awakeFromNib];
	self.collectionView.dataSource = self;
	self.collectionView.delegate = self;
	
	self.itemWidth = 50;
}


- (void)layoutSubviews {
	[super layoutSubviews];
	
	[self adjustItemSize];
}


- (void)setSources:(NSArray *)sources {

	_sources = sources;
	[self.collectionView reloadData];
}


#pragma mark - Collection View Controller Datasource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	// one additional item for all sources
	return self.sources.count + 1;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UHDSourceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sourceCollectionViewCell" forIndexPath:indexPath];
	
	if (indexPath.row == 0) {
		// TODO: find suitable icon for all sources
		cell.sourceIconImageView.image = [UIImage imageNamed:@"Billiardkugel1"];
	}
	else {
		UHDNewsSource *source = [self.sources objectAtIndex:(indexPath.row - 1)];
		cell.sourceIconImageView.image = source.thumbIcon;
	}

	return cell;
}

// TODO: implement centering of currently selected source
/*
- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath
               atScrollPosition:(UICollectionViewScrollPosition)scrollPosition
                       animated:(BOOL)animated
*/


#pragma mark - Collection view layout

- (void)adjustItemSize {

	UICollectionViewFlowLayout* collectionViewFlowLayout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;

	collectionViewFlowLayout.itemSize = CGSizeMake(self.itemWidth, self.collectionView.bounds.size.height);
	
	/*
	collectionView.collectionViewLayout.invalidateLayout() // TODO: make sure this works
	collectionView.contentSize = collectionView.collectionViewLayout.collectionViewContentSize() // TODO: check this. contentSize is zeros otherwise and initial scrolling does not work.
	*/
	
	self.collectionView.contentInset = UIEdgeInsetsMake(0, self.itemWidth, 0, self.itemWidth);
	
}


- (void)setItemWidth:(CGFloat)itemWidth {

	_itemWidth = itemWidth;
	[self adjustItemSize];
}

// TODO: use UIDynamics features to simulate springs between source items

@end
