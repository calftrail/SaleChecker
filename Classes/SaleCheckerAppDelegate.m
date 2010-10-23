//
//  SaleCheckerAppDelegate.m
//  SaleChecker
//
//  Created by Nathan Vander Wilt on 4/27/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "SaleCheckerAppDelegate.h"

#import "Product.h"
#import "Item.h"
#import "Store.h"

@interface SaleCheckerAppDelegate ()
@property (nonatomic, assign) sqlite3* database;
@property (nonatomic, retain) NSMutableArray* mutableProducts;
- (void)createEditableCopyOfDatabaseIfNeeded;
- (void)initializeDatabase;
@end


@implementation SaleCheckerAppDelegate

@synthesize database;
@synthesize window;
@synthesize navController;
@synthesize mutableProducts = products;

- (NSArray*)products {
	return self.mutableProducts;
}

- (void)applicationDidFinishLaunching:(UIApplication*)application {
	(void)application;
	[window addSubview:[self.navController view]];
    [window makeKeyAndVisible];
	[self createEditableCopyOfDatabaseIfNeeded];
	[self initializeDatabase];
}

- (void)dealloc {
	self.window = nil;
	self.navController = nil;
    [super dealloc];
}

#pragma mark Database handling

- (NSString*)databasePath {
	NSArray* documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:@"pricebook.sqlite3"];
}

- (void)createEditableCopyOfDatabaseIfNeeded {
	NSString* writableDBPath = [self databasePath];
    BOOL editableCopyExists = [[NSFileManager defaultManager] fileExistsAtPath:writableDBPath];
    if (editableCopyExists) return;
	
    NSString* initialDBPath = [[NSBundle mainBundle] pathForResource:@"default_pricebook.sqlite3" ofType:nil];
	NSError* error = nil;
    (void)[[NSFileManager defaultManager] copyItemAtPath:initialDBPath
												  toPath:writableDBPath
												   error:&error];
    if (error) {
        NSAssert1(NO, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

- (void)initializeDatabase {
	//NSLog(@"%@", [self databasePath]);
	sqlite3* theDatabase = NULL;
	int err = sqlite3_open([[self databasePath] UTF8String], &theDatabase);
	if (err) {
		sqlite3_close(theDatabase);
		NSAssert1(NO, @"Failed to open database. (%s)", sqlite3_errmsg(theDatabase));
	}
	
	self.database = theDatabase;
	sqlite3_stmt* productKeysQuery = NULL;
	err = sqlite3_prepare_v2(theDatabase,
							 "SELECT id FROM products", -1,
							 &productKeysQuery, NULL);
	if (err) {
		sqlite3_finalize(productKeysQuery);
		NSAssert1(NO, @"Could not compile query. (%s)", sqlite3_errmsg(theDatabase));
	}
	
	NSMutableArray* tempProducts = [NSMutableArray array];
	while (sqlite3_step(productKeysQuery) == SQLITE_ROW) {
		NSAssert(sqlite3_column_count(productKeysQuery) > 0, @"Bad number of columns returned by query");
		int primaryKey = sqlite3_column_int(productKeysQuery, 0);
		Product* product = [[Product alloc] initWithPrimaryKey:primaryKey database:theDatabase];
		[tempProducts addObject:product]; 
		[product release];
	}
	sqlite3_finalize(productKeysQuery);
	
	self.mutableProducts = tempProducts;
}

- (void)addProduct:(Product*)newProduct {
	[newProduct insertIntoDatabase:self.database];
	[self.mutableProducts addObject:newProduct];
}

- (void)removeProduct:(Product*)deadProduct {
	[deadProduct removeFromDatabase];
	[self.mutableProducts removeObject:deadProduct];
}

@end
