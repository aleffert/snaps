//
//  DLSConstraintDescription.h
//  Dials+SnapKit
//
//  Created by Akiva Leffert on 9/25/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLSConstraintDescription : NSObject <NSCoding>

@property (copy, nonatomic, nullable) NSString* label;
@property (copy, nonatomic) NSString* constraintID;

@property (copy, nonatomic, nullable) NSString* locationFile;
@property (assign, nonatomic) NSUInteger locationLine;

@property (copy, nonatomic) NSString* sourceClass;
@property (copy, nonatomic) NSString* sourceAttribute;

@property (copy, nonatomic, nullable) NSString* destinationClass;
@property (copy, nonatomic, nullable) NSString* destinationAttribute;

@property (assign, nonatomic) CGFloat constant;
@property (assign, nonatomic) CGFloat multiplier;
@property (assign, nonatomic) BOOL active;

@end

NS_ASSUME_NONNULL_END