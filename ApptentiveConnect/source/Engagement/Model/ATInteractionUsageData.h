//
//  ATInteractionUsageData.h
//  ApptentiveConnect
//
//  Created by Peter Kamb on 10/14/13.
//  Copyright (c) 2013 Apptentive, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATInteraction.h"

@interface ATInteractionUsageData : NSObject

@property (nonatomic, strong) ATInteraction *interaction;
@property (nonatomic, strong) NSNumber *timeSinceInstallTotal;
@property (nonatomic, strong) NSNumber *timeSinceInstallVersion;
@property (nonatomic, strong) NSNumber *timeSinceInstallBuild;
@property (nonatomic, strong) NSString *applicationVersion;
@property (nonatomic, strong) NSString *applicationBuild;
@property (nonatomic, strong) NSNumber *isUpdateVersion;
@property (nonatomic, strong) NSNumber *isUpdateBuild;
@property (nonatomic, strong) NSDictionary *codePointInvokesTotal;
@property (nonatomic, strong) NSDictionary *codePointInvokesVersion;
@property (nonatomic, strong) NSDictionary *codePointInvokesBuild;
@property (nonatomic, strong) NSDictionary *codePointInvokesTimeAgo;
@property (nonatomic, strong) NSDictionary *interactionInvokesTotal;
@property (nonatomic, strong) NSDictionary *interactionInvokesVersion;
@property (nonatomic, strong) NSDictionary *interactionInvokesBuild;
@property (nonatomic, strong) NSDictionary *interactionInvokesTimeAgo;

- (id)initWithInteraction:(ATInteraction *)interaction;
+ (ATInteractionUsageData *)usageDataForInteraction:(ATInteraction *)interaction;

- (NSDictionary *)predicateEvaluationDictionary;

@end
