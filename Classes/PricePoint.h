//
//  PricePoint.h
//  SaleChecker
//
//  Created by Nathan Vander Wilt on 4/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sqlite3.h>
#import "DBObject.h"

@interface PricePoint : DBObject {
	NSDecimalNumber* price;
	NSDate* date;
	BOOL onSale;
}

@property (nonatomic, copy) NSDecimalNumber* price;
@property (nonatomic, copy) NSDate* date;
@property (nonatomic, assign) BOOL onSale;

@end
