//
//  IntroLayer.h
//  Penguin Rescue
//
//  Created by Stephen Johnson on 10/15/12.
//  Copyright Conquer LLC 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Constants.h"
#import "LevelHelperLoader.h"

@interface IntroLayer : CCLayer
{
	LevelHelperLoader* _levelLoader;
	
	CGSize _panelSize;
}

+(CCScene *) scene;

@end
