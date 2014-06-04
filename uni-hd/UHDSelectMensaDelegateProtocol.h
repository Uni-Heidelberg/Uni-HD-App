//
//  UHDSelectMensaDelegateProtocol.h
//  uni-hd
//
//  Created by Lukas Schmidt on 04.06.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UHDMensa.h"


@protocol UHDSelectMensaDelegateProtocol <NSObject>
- (void)selectMense:(UHDMensa *)mensa;
@end