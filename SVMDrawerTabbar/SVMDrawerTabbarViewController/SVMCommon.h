//
//  SVMCommon.h
//  SVMDrawerTabbar
//
//  Created by staticVoidMan on 29/08/15.
//  Copyright (c) 2015 svmLogics. All rights reserved.
//

#ifndef SVMDrawerTabbar_SVMCommon_h
#define SVMDrawerTabbar_SVMCommon_h

typedef enum SVMTabIndexes : NSInteger {
	eSVMTabIndex_First,
	eSVMTabIndex_Second,
	eSVMTabIndex_Third
} SVMTabIndex;

#define kSVM_Animation_Speed	0.27f

#define kSVM_NOTIFICATION_DRAWER_SHOW	@"SVM_DRAWER_SHOW"
#define kSVM_NOTIFICATION_DRAWER_HIDE	@"SVM_DRAWER_HIDE"

#endif
