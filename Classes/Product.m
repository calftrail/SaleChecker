//
//  Product.m
//  SaleChecker
//
//  Created by Nathan Vander Wilt on 4/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Product.h"

#import "Item.h"

// NOTE: these globally cached queries assume database is constant
static sqlite3_stmt* ProductNameQuery = NULL;
static sqlite3_stmt* ProductInsertQuery = NULL;
static sqlite3_stmt* ProductRemoveQuery = NULL;
static sqlite3_stmt* ProductHydrateQuery = NULL;
static sqlite3_stmt* ProductDehydrateQuery = NULL;

@interface Product ()
@property (nonatomic, assign) sqlite3* database;
@property (nonatomic, assign) BOOL dirty;
@property (nonatomic, assign) BOOL hydrated;
@property (nonatomic, retain) NSMutableArray* mutableItems;
@end


@implementation Product

@synthesize dirty;
@synthesize hydrated;
@synthesize database;
@synthesize primaryKey;
@synthesize name;
@synthesize standardMeasure;
@synthesize mutableItems = itemsArray;

- (NSArray*)items {
	return self.mutableItems;
}

- (void)dealloc {
	self.name = nil;
	self.standardMeasure = nil;
	self.mutableItems = nil;
	[super dealloc];
}

- (id)initWithPrimaryKey:(int)thePrimaryKey database:(sqlite3*)theDatabase {
	self = [super init];
	if (self) {
		self.database = theDatabase;
		self.primaryKey = thePrimaryKey;
		
		if (!ProductNameQuery) {
			int err = sqlite3_prepare_v2(theDatabase,
										 "SELECT name FROM products WHERE id=?", -1,
										 &ProductNameQuery, NULL);
			if (err) {
				sqlite3_finalize(ProductNameQuery);
				NSAssert1(NO, @"Could not compile ProductNameQuery. (%s)", sqlite3_errmsg(theDatabase));
			}
		}
		NSAssert(sqlite3_db_handle(ProductNameQuery) == theDatabase, @"Database handle must not change");
		
		sqlite3_bind_int(ProductNameQuery, 1, thePrimaryKey);
		if (sqlite3_step(ProductNameQuery) == SQLITE_ROW) {
			NSAssert(sqlite3_column_count(ProductNameQuery) > 0, @"Bad number of columns returned by query");
			const char* nameValue = (const char*)sqlite3_column_text(ProductNameQuery, 0);
			if (nameValue) {
				self.name = [NSString stringWithUTF8String:nameValue];
			}
        }
		sqlite3_reset(ProductNameQuery);
	}
	return self;
}

- (void)insertIntoDatabase:(sqlite3*)theDatabase {
	self.database = theDatabase;
	
	if (!ProductInsertQuery) {
		int err = sqlite3_prepare_v2(theDatabase,
									 "INSERT INTO products (name) VALUES (?)", -1,
									 &ProductInsertQuery, NULL);
		if (err) {
			sqlite3_finalize(ProductInsertQuery);
			NSAssert1(NO, @"Could not compile ProductInsertQuery. (%s)", sqlite3_errmsg(theDatabase));
		}
	}
	NSAssert(sqlite3_db_handle(ProductInsertQuery) == theDatabase, @"Database handle must not change");
	
	sqlite3_bind_text(ProductInsertQuery, 1, [self.name UTF8String], -1, SQLITE_TRANSIENT);
	int result = sqlite3_step(ProductInsertQuery);
	sqlite3_reset(ProductInsertQuery);
    if (result != SQLITE_DONE) {
        NSAssert1(NO, @"ProductInsertQuery failed. (%s)", sqlite3_errmsg(theDatabase));
    }
	
	self.primaryKey = sqlite3_last_insert_rowid(database);
	self.hydrated = YES;
}

- (void)removeFromDatabase {
	if (!ProductRemoveQuery) {
		int err = sqlite3_prepare_v2(self.database,
									 "DELETE FROM products WHERE id=?", -1,
									 &ProductRemoveQuery, NULL);
		if (err) {
			sqlite3_finalize(ProductRemoveQuery);
			NSAssert1(NO, @"Could not compile ProductRemoveQuery. (%s)", sqlite3_errmsg(self.database));
		}
	}
	NSAssert(sqlite3_db_handle(ProductRemoveQuery) == self.database, @"Database handle must not change");
	
	sqlite3_bind_int64(ProductRemoveQuery, 1, self.primaryKey);
	int result = sqlite3_step(ProductRemoveQuery);
	sqlite3_reset(ProductRemoveQuery);
    if (result != SQLITE_DONE) {
        NSAssert1(NO, @"ProductRemoveQuery failed. (%s)", sqlite3_errmsg(self.database));
    }
}

- (void)hydrate {
	NSAssert(self.database, @"Database must be set before hydration");
	if (self.hydrated) return;
	
	if (!ProductHydrateQuery) {
		int err = sqlite3_prepare_v2(self.database,
									 "SELECT id FROM items WHERE productKey=?", -1,
									 &ProductHydrateQuery, NULL);
		if (err) {
			sqlite3_finalize(ProductHydrateQuery);
			NSAssert1(NO, @"Could not compile ProductHydrateQuery. (%s)", sqlite3_errmsg(self.database));
		}
	}
	
	sqlite3_bind_int64(ProductHydrateQuery, 1, self.primaryKey);
	NSMutableArray* tempItems = [NSMutableArray array];
	while (sqlite3_step(ProductHydrateQuery) == SQLITE_ROW) {
		NSAssert(sqlite3_column_count(ProductHydrateQuery) > 0, @"Bad number of columns returned by query");
		int itemKey = sqlite3_column_int(ProductHydrateQuery, 0);
		Item* item = [[Item alloc] initWithPrimaryKey:itemKey database:self.database];
		[tempItems addObject:item]; 
		[item release];
	}
	sqlite3_reset(ProductHydrateQuery);
	
	self.mutableItems = tempItems;
}

- (void)dehydrate {
	NSAssert(self.database, @"Database must be set before dehydration");
	if (self.dirty) {
		if (!ProductDehydrateQuery) {
			int err = sqlite3_prepare_v2(self.database,
										 "UPDATE products SET name=? WHERE id=?", -1,
										 &ProductDehydrateQuery, NULL);
			if (err) {
				sqlite3_finalize(ProductDehydrateQuery);
				NSAssert1(NO, @"Could not compile ProductDehydrateQuery. (%s)", sqlite3_errmsg(self.database));
			}
		}
		NSAssert(sqlite3_db_handle(ProductDehydrateQuery) == self.database, @"Database handle must not change");
		
		sqlite3_bind_text(ProductDehydrateQuery, 1, [self.name UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_int64(ProductDehydrateQuery, 2, self.primaryKey);
		
		int result = sqlite3_step(ProductDehydrateQuery);
		sqlite3_reset(ProductDehydrateQuery);
		if (result == SQLITE_ERROR) {
			NSAssert1(NO, @"ProductDehydrateQuery failed. (%s)", sqlite3_errmsg(self.database));
		}
		self.dirty = NO;
	}
	self.standardMeasure = nil;
	self.mutableItems = nil;
	self.hydrated = NO;
}

- (void)addItem:(Item*)newItem {
	newItem.productKey = self.primaryKey;
	[newItem insertIntoDatabase:self.database];
	[self.mutableItems addObject:newItem];
}

- (void)removeItem:(Item*)deadItem {
	[deadItem removeFromDatabase];
	[self.mutableItems removeObject:deadItem];
}

@end
