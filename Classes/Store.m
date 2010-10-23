//
//  Store.m
//  SaleChecker
//
//  Created by Nathan Vander Wilt on 4/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Store.h"


@implementation Store

@synthesize identifier;
@synthesize name;

- (void)dealloc {
	self.identifier = nil;
	self.name = nil;
	[super dealloc];
}

@end
