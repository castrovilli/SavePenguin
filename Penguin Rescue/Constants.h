//
//  Constants.h
//  Penguin Rescue
//
//  Created by Stephen Johnson on 10/24/12.
//  Copyright (c) 2012 Conquer LLC. All rights reserved.
//

#ifndef Penguin_Rescue_Constants_h
#define Penguin_Rescue_Constants_h




#define TEST_MODE true
#define TEST_LEVEL_PACK @"Arctic"
#define TEST_LEVEL @"Showdown"
#define DEBUG_ALL_THE_THINGS false
#define DEBUG_PENGUIN false	//can be overridden in game
#define DEBUG_SHARK false	//can be overridden in game

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCALING_FACTOR_H (IS_IPHONE ? 480.0/1024.0 : 1.0)
#define SCALING_FACTOR_V (IS_IPHONE ? 320.0/768.0 : 1.0)
#define SCALING_FACTOR_GENERIC SCALING_FACTOR_V
#define SCALING_FACTOR_FONTS .60
#define TARGET_FPS 60

#define SHARK_DIES_WHEN_STUCK false
#define PENGUIN_MOVE_HISTORY_SIZE 20
#define SHARK_MOVE_HISTORY_SIZE 50


#define HUD_BUTTON_MARGIN_V 14*SCALING_FACTOR_V
#define HUD_BUTTON_MARGIN_H 16*SCALING_FACTOR_H

#define TOOLBOX_MARGIN_TOP 10*SCALING_FACTOR_V
#define TOOLBOX_MARGIN_LEFT 20*SCALING_FACTOR_H
#define TOOLBOX_ITEM_CONTAINER_PADDING_H 20*SCALING_FACTOR_H
#define TOOLBOX_ITEM_CONTAINER_PADDING_V 20*SCALING_FACTOR_V
#define TOOLBOX_ITEM_CONTAINER_COUNT_FONT_SIZE 14


#endif