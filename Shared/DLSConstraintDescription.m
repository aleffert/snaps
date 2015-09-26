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
        DLSDecodeObject(aDecoder, affectedViewID);
        DLSDecodeObject(aDecoder, label);
        DLSDecodeObject(aDecoder, constraintID);
        DLSDecodeObject(aDecoder, locationFile);
        DLSDecodeInteger(aDecoder, locationLine);
        DLSDecodeObject(aDecoder, relation);
        DLSDecodeObject(aDecoder, sourceClass);
        DLSDecodeObject(aDecoder, sourceViewID);
        DLSDecodeObject(aDecoder, sourceAttribute);
        DLSDecodeObject(aDecoder, destinationClass);
        DLSDecodeObject(aDecoder, destinationViewID);
        DLSDecodeObject(aDecoder, destinationAttribute);
        DLSDecodeDouble(aDecoder, constant);
        DLSDecodeDouble(aDecoder, multiplier);
        DLSDecodeBool(aDecoder, active);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, affectedViewID);
    DLSEncodeObject(aCoder, label);
    DLSEncodeObject(aCoder, constraintID);
    DLSEncodeObject(aCoder, locationFile);
    DLSEncodeInteger(aCoder, locationLine);
    DLSEncodeObject(aCoder, relation);
    DLSEncodeObject(aCoder, sourceClass);
    DLSEncodeObject(aCoder, sourceViewID);
    DLSEncodeObject(aCoder, sourceAttribute);
    DLSEncodeObject(aCoder, destinationClass);
    DLSEncodeObject(aCoder, destinationViewID);
    DLSEncodeObject(aCoder, destinationAttribute);
    DLSEncodeDouble(aCoder, constant);
    DLSEncodeDouble(aCoder, multiplier);
    DLSEncodeBool(aCoder, active);
}

- (BOOL)isEqual:(id)object {
    if([object isKindOfClass:[DLSConstraintDescription class]]) {
        DLSConstraintDescription* description = object;
        return [description.constraintID isEqualToString:self.constraintID];
    }
    else {
        return false;
    }
}

- (NSUInteger)hash {
    return self.constraintID.hash ^ self.constraintID.hash;
}

@end
