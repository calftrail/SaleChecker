//
//  Item.m
//  SaleChecker
//
//  Created by Nathan Vander Wilt on 4/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Item.h"

// NOTE: these globally cached queries assume database is constant
static sqlite3_stmt* ItemNameQuery = NULL;
static sqlite3_stmt* ItemInsertQuery = NULL;
static sqlite3_stmt* ItemRemoveQuery = NULL;
static sqlite3_stmt* ItemDehydrateQuery = NULL;


@interface Item ()
@property (nonatomic, assign) sqlite3* database;
@property (nonatomic, assign) sqlite_int64 primaryKey;
@property (nonatomic, assign) BOOL dirty;
@property (nonatomic, assign) BOOL hydrated;
@end


@implementation Item

@synthesize database;
@synthesize primaryKey;
@synthesize detailedName;
@synthesize productKey;
@synthesize storeKey;
@synthesize measure;
@synthesize priceHistory;
@synthesize dirty;
@synthesize hydrated;

- (void)dealloc {
	self.detailedName = nil;
	self.measure = nil;
	self.priceHistory = nil;
	[super dealloc];
}

- (id)initWithPrimaryKey:(int)thePrimaryKey database:(sqlite3*)theDatabase {
	self = [super init];
	if (self) {
		self.database = theDatabase;
		self.primaryKey = thePrimaryKey;
		
		if (!ItemNameQuery) {
			int err = sqlite3_prepare_v2(theDatabase,
										 "SELECT name FROM items WHERE id=?", -1,
										 &ItemNameQuery, NULL);
			if (err) {
				sqlite3_finalize(ItemNameQuery);
				NSAssert1(NO, @"Could not compile ItemNameQuery. (%s)", sqlite3_errmsg(theDatabase));
			}
		}
		NSAssert(sqlite3_db_handle(ItemNameQuery) == theDatabase, @"Database handle must not change");
		
		sqlite3_bind_int(ItemNameQuery, 1, thePrimaryKey);
		if (sqlite3_step(ItemNameQuery) == SQLITE_ROW) {
			NSAssert(sqlite3_column_count(ItemNameQuery) > 0, @"Bad number of columns returned by query");
			const char* nameValue = (const char*)sqlite3_column_text(ItemNameQuery, 0);
			if (nameValue) {
				self.detailedName = [NSString stringWithUTF8String:nameValue];
			}
        }
		sqlite3_reset(ItemNameQuery);
	}
	return self;
}

- (void)insertIntoDatabase:(sqlite3*)theDatabase {
	NSAssert(self.productKey, @"Item productKey must be set before database insertion");
	self.database = theDatabase;
	
	if (!ItemInsertQuery) {
		int err = sqlite3_prepare_v2(theDatabase,
									 "INSERT INTO items (name, productKey) VALUES (?, ?)", -1,
									 &ItemInsertQuery, NULL);
		if (err) {
			sqlite3_finalize(ItemInsertQuery);
			NSAssert1(NO, @"Could not compile ItemInsertQuery. (%s)", sqlite3_errmsg(theDatabase));
		}
	}
	NSAssert(sqlite3_db_handle(ItemInsertQuery) == theDatabase, @"Database handle must not change");
	
	sqlite3_bind_text(ItemInsertQuery, 1, [self.detailedName UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int64(ItemInsertQuery, 2, self.productKey);
	int result = sqlite3_step(ItemInsertQuery);
	sqlite3_reset(ItemInsertQuery);
    if (result != SQLITE_DONE) {
        NSAssert1(NO, @"ItemInsertQuery failed. (%s)", sqlite3_errmsg(theDatabase));
    }
	
	self.primaryKey = sqlite3_last_insert_rowid(database);
	self.hydrated = YES;
}

- (void)removeFromDatabase {
	if (!ItemRemoveQuery) {
		int err = sqlite3_prepare_v2(self.database,
									 "DELETE FROM items WHERE id=?", -1,
									 &ItemRemoveQuery, NULL);
		if (err) {
			sqlite3_finalize(ItemRemoveQuery);
			NSAssert1(NO, @"Could not compile ItemRemoveQuery. (%s)", sqlite3_errmsg(self.database));
		}
	}
	NSAssert(sqlite3_db_handle(ItemRemoveQuery) == self.database, @"Database handle must not change");
	
	sqlite3_bind_int64(ItemRemoveQuery, 1, self.primaryKey);
	int result = sqlite3_step(ItemRemoveQuery);
	sqlite3_reset(ItemRemoveQuery);
    if (result != SQLITE_DONE) {
        NSAssert1(NO, @"ItemRemoveQuery failed. (%s)", sqlite3_errmsg(self.database));
    }
}

- (void)hydrate {
	NSAssert(self.database, @"Database must be set before hydration");
	if (self.hydrated) return;
	
}

- (void)dehydrate {
	NSAssert(self.database, @"Database must be set before dehydration");
	if (self.dirty) {
		if (!ItemDehydrateQuery) {
			int err = sqlite3_prepare_v2(self.database,
										 "UPDATE items SET name=? WHERE id=?", -1,
										 &ItemDehydrateQuery, NULL);
			if (err) {
				sqlite3_finalize(ItemDehydrateQuery);
				NSAssert1(NO, @"Could not compile ItemDehydrateQuery. (%s)", sqlite3_errmsg(self.database));
			}
		}
		NSAssert(sqlite3_db_handle(ItemDehydrateQuery) == self.database, @"Database handle must not change");
		
		sqlite3_bind_text(ItemDehydrateQuery, 1, [self.detailedName UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_int64(ItemDehydrateQuery, 2, self.primaryKey);
		
		int result = sqlite3_step(ItemDehydrateQuery);
		sqlite3_reset(ItemDehydrateQuery);
		if (result == SQLITE_ERROR) {
			NSAssert1(NO, @"ItemDehydrateQuery failed. (%s)", sqlite3_errmsg(self.database));
		}
		self.dirty = NO;
	}
	self.priceHistory = nil;
	self.hydrated = NO;
}

@end
