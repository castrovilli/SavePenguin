//
//  LevelPackManager.h
//  Penguin Rescue
//
//  Created by Stephen Johnson on 10/24/12.
//  Copyright (c) 2012 Conquer LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevelPackManager : NSObject

+(NSDictionary*)allLevelPacks;
+(NSDictionary*)allLevelsInPack:(NSString*)packPath;

+(NSArray*)completedPacks;
+(NSDictionary*)completedLevelsInPack:(NSString*)packPath;

+(NSArray*)availablePacks;
+(NSArray*)availableLevelsInPack:(NSString*)packPath;

+(NSDictionary*)level:(NSString*)levelPath inPack:(NSString*)packPath;

+(void)completeLevel:(NSString*)levelPath inPack:(NSString*)packPath withScore:(int)score;
+(NSNumber*)scoreForLevel:(NSString*)levelPath inPack:(NSString*)packPath;

+(NSString*)levelAfter:(NSString*)levelPath inPack:(NSString*)packPath;


@end




#define LEVELPACKMAANGER_LEVELS_COMPLETED_REVIEW_PROMPT_INTERVAL 12


#define LEVELPACKMANAGER_KEY_USER_COMPLETED_PACKS @"CompletedPacks"

#define LEVELPACKMANAGER_KEY_NAME @"Name"
#define LEVELPACKMANAGER_KEY_PATH @"Path"
#define LEVELPACKMANAGER_KEY_REQUIRES_PACK @"RequiresPack"
#define LEVELPACKMANAGER_KEY_REQUIRES_NUM_PACK_LEVELS_COMPLETED @"RequiresNumPackLevelsCompleted"
