//
//  UHDMeal.m
//  uni-hd
//
//  Created by Felix on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMeal.h"
#import "UHDDailyMenu.h"
#import "UHDMensaSection.h"


@implementation UHDMeal

@dynamic title;
@dynamic menus;
@dynamic isFavourite, isVegetarian, isMain;
@dynamic priceStud, priceBed, priceGuest;

- (NSMutableSet *)mutableMenus
{
    return [self mutableSetValueForKey:@"menus"];
}

- (NSString *)localizedPriceDescription {
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    currencyFormatter.currencyCode = @"EUR";
    return [NSString stringWithFormat:@"S: %@ / B: %@ / G: %@", [currencyFormatter stringFromNumber:self.priceStud], [currencyFormatter stringFromNumber:self.priceBed], [currencyFormatter stringFromNumber:self.priceGuest]];
}

- (NSString *)localizedExtrasDescription {
    NSString *description = @"1, 3, 7"; // TODO: get from database
    if (self.isVegetarian) {
        description = [[NSString stringWithFormat:@"%@ | ", NSLocalizedString(@"vegetarisch", nil)] stringByAppendingString:description];
    }
    return description;
}

@end
