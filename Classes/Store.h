//
//  Store.h
//  SaleChecker
//
//  Created by Nathan Vander Wilt on 4/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Store : NSObject {
@private
	id identifier;
	NSString* name;
}

@property (nonatomic, copy) id identifier;
@property (nonatomic, copy) NSString* name;

@end
