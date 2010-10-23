//
//  PricePoint.m
//  SaleChecker
//
//  Created by Nathan Vander Wilt on 4/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PricePoint.h"


@implementation PricePoint

@synthesize price;
@synthesize date;
@synthesize onSale;

+ (NSNumberFormatter*)priceFormatter {
	static NSNumberFormatter* priceFormatter = nil;
	if (!priceFormatter) {
		priceFormatter = [NSNumberFormatter new];
		[priceFormatter setLocale:[NSLocale systemLocale]];
		// TODO: finish configuring
		[priceFormatter setGeneratesDecimalNumbers:YES];
	}
	return priceFormatter;
}

+ (NSDateFormatter*)dateFormatter {
	// TODO: implement
	return nil;
}

- (id)initWithPrimaryKey:(int)thePrimaryKey database:(sqlite3*)theDatabase {
	self = [super initWithPrimaryKey:thePrimaryKey database:theDatabase];
	if (self) {
		sqlite3_stmt* readStatement = [self prepareStatement:
									   @"SELECT price, date, onSale FROM prices WHERE id = ?"];
		sqlite3_bind_int64(readStatement, 1, self.primaryKey);
		
		if (sqlite3_step(readStatement) == SQLITE_ROW) {
			// TODO: use formatter
			const char* priceText = (const char*)sqlite3_column_text(readStatement, 1);
			NSString* priceString = [NSString stringWithUTF8String:priceText];
			self.price = [NSDecimalNumber decimalNumberWithString:priceString
														   locale:[NSLocale systemLocale]];
			
			const char* dateText = (const char*)sqlite3_column_text(readStatement, 2);
			NSString* dateString = [NSString stringWithUTF8String:dateText];
			(void)dateString;
			// TODO: use formatter
			self.date = nil;
			
			self.onSale = !!sqlite3_column_int(readStatement, 3);
		}
	}
	return self;
}

/*
- (void)insertIntoDatabase:(sqlite3*)theDatabase;
- (void)removeFromDatabase;

- (void)hydrate;
- (void)dehydrate;
 */

@end
