//
//  DBObject.m
//  SaleChecker
//
//  Created by Nathan Vander Wilt on 5/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DBObject.h"

@interface DBObject ()
@property (nonatomic, assign) sqlite3* database;
@property (nonatomic, assign) BOOL hydrated;
@end


@implementation DBObject

@synthesize database;
@synthesize primaryKey;
@synthesize dirty;
@synthesize hydrated;

- (sqlite3_stmt*)prepareStatement:(NSString*)statement {
	NSAssert(self.database, @"Database must be set before statements may be prepared");
	
	// TODO: cache per-database prepared statements classwide
	sqlite3_stmt* preparedStatement = NULL;
	int err = sqlite3_prepare_v2(self.database, [statement UTF8String], -1, &preparedStatement, NULL);
	if (err) {
		sqlite3_finalize(preparedStatement);
		NSAssert2(NO, @"Could not prepare '%@':\n %s", statement, sqlite3_errmsg(self.database));
	}
	return preparedStatement;
}

- (id)initWithPrimaryKey:(int)thePrimaryKey database:(sqlite3*)theDatabase {
	self = [super init];
	if (self) {
		self.database = theDatabase;
		self.primaryKey = thePrimaryKey;
	}
	return self;
}

- (id)init {
	self = [super init];
	if (self) {
		self.hydrated = YES;
	}
	return self;
}

- (void)insertIntoDatabase:(sqlite3*)theDatabase {
	self.database = theDatabase;
}

- (void)removeFromDatabase {
	self.database = NULL;
}

- (void)hydrate {}
- (void)dehydrate {}

@end
