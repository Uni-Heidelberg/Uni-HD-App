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
#import "UHDNewsViewController.h"


@interface UHDNewsSourcesNavigationBar () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//@property (weak, nonatomic) IBOutlet UIButton *sourceButton;

//- (IBAction)sourceButtonPressed:(id)sender;

@end

@implementation UHDNewsSourcesNavigationBar

- (void)awakeFromNib
{
    [super awakeFromNib];
    
	self.collectionView.dataSource = self;
	self.collectionView.delegate = self;
    self.collectionView.scrollsToTop = NO;
	
	self.itemWidth = 56;
}


- (void)layoutSubviews {
	[super layoutSubviews];
	
	[self adjustItemSize];
}


- (void)setSources:(NSArray *)sources {

	_sources = sources;
	[self.collectionView reloadData];
	[self scrollToSelectedSource];
}


- (void)setSelectedSource:(UHDNewsSource *)selectedSource {
    
    _selectedSource = selectedSource;
    
    [self.logger log:[NSString stringWithFormat:@"Selected source: %@", selectedSource.title] forLevel:VILogLevelDebug];
	
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
    
        if (self.selectedSource == nil) {
            cell.sourceIconImageView.alpha = 1;
        }
        else {
            cell.sourceIconImageView.alpha = 0.3;
        }
		
		/*
		switch (((UHDNewsViewController *)self.delegate).displayMode) {
			case UHDNewsEventsDisplayModeNews:
				cell.sourceIconImageView.image = [UIImage imageNamed:@"news_symbol"];
				break;
			case UHDNewsEventsDisplayModeEvents:
				cell.sourceIconImageView.image = [UIImage imageNamed:@"talk_icon"];
				break;
			default:
				break;
		*/
        
        cell.sourceIconImageView.image = [UIImage imageNamed:@"all_news_icon"];
        cell.sourceIconImageView.tintColor = [UIColor brandColor];
        
	}
	else {
    
		UHDNewsSource *source = [self.sources objectAtIndex:(indexPath.row - 1)];
        
        if (self.selectedSource == source) {
            cell.sourceIconImageView.alpha = 1;
        }
        else {
            cell.sourceIconImageView.alpha = 0.3;
        }
        
        if (source.image != nil) {
            cell.sourceIconImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            cell.sourceIconImageView.image = source.image;
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
	
	[self scrollToSelectedSource];
    [self.delegate sourcesNavigationBar:self didSelectSource:self.selectedSource];
}


- (void)scrollToSelectedSource {
    
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
