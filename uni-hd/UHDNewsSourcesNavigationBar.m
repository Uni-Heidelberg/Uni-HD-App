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

- (IBAction)sourceButtonPressed:(id)sender;

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


- (void)setSelectedSource:(UHDNewsSource *)selectedSource {
    
    _selectedSource = selectedSource;
    
    [self.logger log:[NSString stringWithFormat:@"Selected source: %@", selectedSource.title] forLevel:VILogLevelDebug];
    
    [self updateSourceButton];
    
}

/*
- (void)setSelectedSourceIndex:(NSUInteger)selectedSourceIndex {

    _selectedSourceIndex = selectedSourceIndex;
    
    [self.logger log:[NSString stringWithFormat:@"selected source index: %lu", selectedSourceIndex] forLevel:VILogLevelDebug];
    
    [self updateSourceButton];
}
*/

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
		//cell.sourceIconImageView.image = [UIImage imageNamed:@"Billiardkugel1"];
        cell.sourceIconImageView.image = nil;
        cell.sourceIconImageView.backgroundColor = [UIColor whiteColor];
	}
	else {
    
		UHDNewsSource *source = [self.sources objectAtIndex:(indexPath.row - 1)];
        if (source.thumbIcon != nil) {
            cell.sourceIconImageView.backgroundColor = [UIColor clearColor];
            cell.sourceIconImageView.image = source.thumbIcon;
        }
        else {
            cell.sourceIconImageView.backgroundColor = [UIColor whiteColor];
            cell.sourceIconImageView.image = nil;
        }
    }

	return cell;
}


#pragma mark - Collection view layout

- (void)adjustItemSize {

	UICollectionViewFlowLayout* collectionViewFlowLayout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;

	collectionViewFlowLayout.itemSize = CGSizeMake(self.itemWidth, self.collectionView.bounds.size.height);
	
	/*
	collectionView.collectionViewLayout.invalidateLayout() // TODO: make sure this works
	collectionView.contentSize = collectionView.collectionViewLayout.collectionViewContentSize() // TODO: check this. contentSize is zeros otherwise and initial scrolling does not work.
	*/
	
	//self.collectionView.contentInset = UIEdgeInsetsMake(0, 0.5 * self.collectionView.bounds.size.width, 0, 0.5 * self.collectionView.bounds.size.width);
	
}

- (void) updateSourceButton {
    
    if (self.selectedSource == nil) {
        [self.sourceButton setTitle:@"All News / Events" forState:UIControlStateNormal];
    }
    else {
        [self.sourceButton setTitle:self.selectedSource.title forState:UIControlStateNormal];
    }
    
    [self.sourceButton sizeToFit];
    
}

- (void)setItemWidth:(CGFloat)itemWidth {

	_itemWidth = itemWidth;
	[self adjustItemSize];
}


// TODO: use UIDynamics features to simulate springs between source items



# pragma mark - Collection view user interaction

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        self.selectedSource = nil;
    }
    else {
        self.selectedSource = self.sources[indexPath.row - 1];
    }
    
    [self.delegate sourcesNavigationBar:self didSelectSource:self.selectedSource];
}


- (IBAction)sourceButtonPressed:(id)sender {
    
    NSIndexPath *indexPath;
    
    if (self.selectedSource == nil) {
        indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    else {
        indexPath = [NSIndexPath indexPathForRow:([self.sources indexOfObject:self.selectedSource] + 1) inSection:0];
    }

    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

@end
