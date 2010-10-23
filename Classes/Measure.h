//
//  Measure.h
//  SaleChecker
//
//  Created by Nathan Vander Wilt on 4/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
	GallonUnits,
	LiterUnits,
	FluidOunceUnits
};

typedef NSUInteger Units;

@interface Measure : NSObject {
@private
	NSDecimal quantity;
	Units units;
}

@property (nonatomic, assign) NSDecimal quantity;
@property (nonatomic, assign) Units units;

@end
