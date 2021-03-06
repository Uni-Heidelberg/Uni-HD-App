//
//  UHDMensaModule.m
//  uni-hd
//
//  Created by Nils Fischer on 26.04.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsStore.h"
#import "UHDNewsItem.h"
#import "UHDNewsSource.h"

@implementation UHDNewsStore

- (NSArray *)allItems
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDNewsItem entityName]];
    NSError *error = nil;
    NSArray *allItems = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        [self.logger log:@"Fetching all items" error:error];
    }
    return allItems;
}

- (void)generateSampleData
{
    // Create NewsSource object
    UHDNewsSource *newsSource = [UHDNewsSource insertNewObjectIntoContext:self.managedObjectContext];
    newsSource.title = @"Fakultät für Physik und Astronomie";
    newsSource.subscribed = YES;
    newsSource.color = @"red";

    // Create NewsArticles
    UHDNewsItem *newsItem = [UHDNewsItem insertNewObjectIntoContext:self.managedObjectContext];
    newsItem.title = @"Breaking News!";
    newsItem.abstract = @"But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.";
    newsItem.date = [NSDate date];
    newsItem.url = @"http://www.loremipsum.de/index_e.html";
    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"kip"]);
    newsItem.thumb = imageData;
    newsItem.source = newsSource;
    
    newsItem = [UHDNewsItem insertNewObjectIntoContext:self.managedObjectContext];
    newsItem.title = @"Bahnbrechende Neuigkeiten!";
    newsItem.abstract = @"Damit Ihr indess erkennt, woher dieser ganze Irrthum gekommen ist, und weshalb man die Lust anklagt und den Schmerz lobet, so will ich Euch Alles eröffnen und auseinander setzen, was jener Begründer der Wahrheit und gleichsam Baumeister des glücklichen Lebens selbst darüber gesagt hat.";
    newsItem.date = [NSDate dateWithTimeIntervalSince1970:0];
    newsItem.url = @"http://www.loremipsum.de";
    // no image for this news
    newsItem.source = newsSource;
    
    // Create new NewsSource
    newsSource = [UHDNewsSource insertNewObjectIntoContext:self.managedObjectContext];
    newsSource.title = @"Universität Heidelberg";
    newsSource.subscribed = YES;
    newsSource.color = @"blue";
    
    // Create further NewsArticles
    newsItem = [UHDNewsItem insertNewObjectIntoContext:self.managedObjectContext];
    newsItem.title = @"Novitas!";
    newsItem.abstract = @"Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
    newsItem.date = [NSDate dateWithTimeIntervalSinceReferenceDate:(-2000*365.25*24*3600)];
    newsItem.url = @"http://www.uni-heidelberg.de";
    newsItem.source = newsSource;
    imageData = UIImagePNGRepresentation([UIImage imageNamed:@"heidelberg"]);
    newsItem.thumb = imageData;
    
    // Save to store
    [newsItem.managedObjectContext save:NULL];
}

@end
