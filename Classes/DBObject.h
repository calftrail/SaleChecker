//
//  DBObject.h
//  SaleChecker
//
//  Created by Nathan Vander Wilt on 5/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sqlite3.h>


@interface DBObject : NSObject {
@private
	sqlite3* database;
	sqlite_int64 primaryKey;
	BOOL hydrated;
	BOOL dirty;
}

- (id)initWithPrimaryKey:(int)thePrimaryKey database:(sqlite3*)theDatabase;
- (void)insertIntoDatabase:(sqlite3*)theDatabase;
- (void)removeFromDatabase;

- (void)hydrate;
- (void)dehydrate;

- (sqlite3_stmt*)prepareStatement:(NSString*)statement;
@property (nonatomic, assign) sqlite_int64 primaryKey;
@property (nonatomic, assign) BOOL dirty;



@end
