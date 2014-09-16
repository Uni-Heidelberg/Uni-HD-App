//
//  UHDFavouriteMensaCell.m
//  uni-hd
//
//  Created by Felix on 16.09.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDFavouriteMensaCell.h"
@interface UHDFavouriteMensaCell()
@property (strong, nonatomic) NSMutableArray *favouriteMensen;
@end
@implementation UHDFavouriteMensaCell

-(void)addFavouriteMensa:(UHDMensa *)mensa{
    if (self.favouriteMensen == nil) {
        self.favouriteMensen = [[NSMutableArray alloc] initWithObjects:mensa, nil];
    }
    else{
        [self.favouriteMensen addObject:mensa];
    }
    NSLog(@"array: %@", self.favouriteMensen);
    [self updateFavouriteMensenImages];
}
-(void)removeFavouriteMensa:(UHDMensa *)mensa{
    //still to be implemented
}
-(void)updateFavouriteMensenImages{
//    TODO: check if favouriteMensaCell is displayed, if not, display it
//    if(!self.hidden){
//        NSLog(@"Die Zelle ist: %@",self);
//    }
    self.image1.image = [UIImage imageWithData:((UHDMensa*)[self.favouriteMensen objectAtIndex:0]).imageData];
}

@end

