//
//  DLSConstraintDescription.m
//  Dials+SnapKit
//
//  Created by Akiva Leffert on 9/25/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

#import "DLSConstraintDescription.h"
#if TARGET_OS_IPHONE
#import <Dials/DLSConstants.h>
#else
#import "DLSConstants.h"
#endif

@implementation DLSConstraintDescription
    
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        DLSDecodeObject(aDecoder, constraintID);
        DLSDecodeObject(aDecoder, sourceClass);
        DLSDecodeObject(aDecoder, sourceAttribute);
        DLSDecodeObject(aDecoder, destinationClass);
        DLSDecodeObject(aDecoder, destinationAttribute);
        DLSDecodeObject(aDecoder, destinationAttribute);
        DLSDecodeDouble(aDecoder, constant);
        DLSDecodeDouble(aDecoder, multiplier);
        DLSDecodeBool(aDecoder, active);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, constraintID);
    DLSEncodeObject(aCoder, sourceClass);
    DLSEncodeObject(aCoder, sourceAttribute);
    DLSEncodeObject(aCoder, destinationClass);
    DLSEncodeObject(aCoder, destinationAttribute);
    DLSEncodeObject(aCoder, destinationAttribute);
    DLSEncodeDouble(aCoder, constant);
    DLSEncodeDouble(aCoder, multiplier);
    DLSEncodeBool(aCoder, active);
}

@end
