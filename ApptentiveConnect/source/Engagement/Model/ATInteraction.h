//
//  ATInteraction.h
//  ApptentiveConnect
//
//  Created by Peter Kamb on 8/23/13.
//  Copyright (c) 2013 Apptentive, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ATInteractionUsageData;

@interface ATInteraction : NSObject <NSCoding>
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, assign) int priority;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSDictionary *configuration;
@property (nonatomic, strong) NSDictionary *criteria;
@property (nonatomic, strong) NSString *version;

+ (ATInteraction *)interactionWithJSONDictionary:(NSDictionary *)jsonDictionary;

- (ATInteractionUsageData *)usageData;
- (BOOL)criteriaAreMet;
- (BOOL)criteriaAreMetForUsageData:(ATInteractionUsageData *)usageData;

- (NSPredicate *)criteriaPredicate;
+ (NSPredicate *)predicateForInteractionCriteria:(NSDictionary *)interactionCriteria hasError:(BOOL *)hasError;
@end
