//
//  SettingsManager.h
//  Penguin Rescue
//
//  Created by Stephen Johnson on 10/25/12.
//  Copyright (c) 2012 Conquer LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsManager : NSObject


+(bool)boolForKey:(NSString*)key;
+(NSString*)stringForKey:(NSString*)key;
+(int)intForKey:(NSString*)key;
+(double)doubleForKey:(NSString*)key;

+(NSString*)getUUID;


+(void)setString:(NSString*)value forKey:(NSString*)key;
+(void)setBool:(bool)value forKey:(NSString*)key;
+(void)setInt:(int)value forKey:(NSString*)key;
+(void)setDouble:(double)value forKey:(NSString*)key;

+(int)incrementIntBy:(int)amount forKey:(NSString*)key;
+(int)decrementIntBy:(int)amount forKey:(NSString*)key;


+(void)remove:(NSString*)key;

@end






#define SETTING_UUID @"UUID"
#define SETTING_SOUND_ENABLED @"SoundEnabled"
#define SETTING_MUSIC_ENABLED @"MusicEnabled"

#define SETTING_HAS_SEEN_TUTORIAL_1 @"HasSeenTutorial1"
#define SETTING_HAS_SEEN_TUTORIAL_2 @"HasSeenTutorial2"
#define SETTING_HAS_SEEN_TUTORIAL_3 @"HasSeenTutorial3"

#define SETTING_LAST_RUN_TIMESTAMP @"LastRunTimestamp"
#define SETTING_NUM_APP_OPENS @"NumAppOpens"

#define SETTING_HAS_CREATED_UUID_ON_SERVER @"HasCreatedUUIDOnServer"


#define SETTING_LEFT_REVIEW_VERSION @"LeftReviewVersion"
#define SETTING_CURRENT_VERSION @"CurrentVersion"

#define SETTING_TOTAL_EARNED_COINS @"TotalEarnedCoins"
#define SETTING_TOTAL_AVAILABLE_COINS @"TotalAvailableCoins"
#define SETTING_TOTAL_EARNED_COINS_FOR_LEVEL @"TotalEarnedCoinsForLevel_"


#define SETTING_LAST_LEVEL_PACK_PATH @"LastLevelPackPath"
#define SETTING_LAST_LEVEL_PATH @"LastLevelPath"
#define SETTING_LAST_LEVEL_PACK_SELECT_SCREEN_NUM @"LastLevelPackSelectScreenNum"
#define SETTING_LAST_LEVEL_SELECT_SCREEN_NUM @"LastLevelSelectScreenNum"

