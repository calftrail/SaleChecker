//
//  Product.h
//  SaleChecker
//
//  Created by Nathan Vander Wilt on 4/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sqlite3.h>

@class Measure, Item;

@interface Product : NSObject {
@private
	sqlite3* database;
	sqlite_int64 primaryKey;
	BOOL dirty;
	BOOL hydrated;
	
	NSString* name;
	Measure* standardMeasure;
	NSMutableArray* itemsArray;
}

- (id)initWithPrimaryKey:(int)thePrimaryKey database:(sqlite3*)theDatabase;
- (void)insertIntoDatabase:(sqlite3*)theDatabase;
- (void)removeFromDatabase;

- (void)hydrate;
- (void)dehydrate;

@property (nonatomic, assign) sqlite_int64 primaryKey;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) Measure* standardMeasure;

@property (nonatomic, readonly) NSArray* items;
- (void)addItem:(Item*)newItem;
- (void)removeItem:(Item*)deadItem;

@end
