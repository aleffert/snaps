//
//  DLSSnapKitConstraintEditor.h
//  Dials+SnapKit
//
//  Created by Akiva Leffert on 9/24/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <Dials/DLSEditor.h>
#else
#import "DLSEditor.h"
#endif

@interface DLSSnapKitConstraintEditor : NSObject <DLSEditor>

@end
