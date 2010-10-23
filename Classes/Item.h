//
//  Item.h
//  SaleChecker
//
//  Created by Nathan Vander Wilt on 4/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sqlite3.h>

@class Measure;

@interface Item : NSObject {
@private
	sqlite3* database;
	sqlite_int64 primaryKey;
	BOOL dirty;
	BOOL hydrated;
	
	NSString* detailedName;
	sqlite_int64 productKey;
	sqlite_int64 storeKey;
	Measure* measure;
	NSArray* priceHistory;
}

- (id)initWithPrimaryKey:(int)thePrimaryKey database:(sqlite3*)theDatabase;
- (void)insertIntoDatabase:(sqlite3*)theDatabase;
- (void)removeFromDatabase;

- (void)hydrate;
- (void)dehydrate;

@property (nonatomic, copy) NSString* detailedName;
@property (nonatomic, assign) sqlite_int64 productKey;
@property (nonatomic, assign) sqlite_int64 storeKey;
@property (nonatomic, copy) Measure* measure;
@property (nonatomic, retain) NSArray* priceHistory;

@end
