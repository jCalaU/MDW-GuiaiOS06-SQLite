//
//  ViewController.h
//  MDW-Guia-iOS06
//
//  Created by Javier Cala Uribe on 19/10/11.
//  Copyright (c) 2011 *. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


- (void)createEditableCopyOfDatabaseIfNeeded;
- (void)executeSentence:(NSString *)sentence sentenceIsSelect:(BOOL )isSelect;

@end
