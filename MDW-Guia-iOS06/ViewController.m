//
//  ViewController.m
//  MDW-Guia-iOS06
//
//  Created by Javier Cala Uribe on 19/10/11.
//  Copyright (c) 2011 *. All rights reserved.
//

#import "ViewController.h"
#import "sqlite3.h"

@implementation ViewController

- (void)createEditableCopyOfDatabaseIfNeeded 
{
	BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"myDB"];
    success = [fileManager fileExistsAtPath:writableDBPath];
	
	// Si ya existe el archivo, no lo crea -_-
    if (success) return;
    
	// Crea el archivo en el dispositivo
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"myDB"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) 
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    
}

- (void)viewDidLoad 
{
    [super viewDidLoad];

	[self createEditableCopyOfDatabaseIfNeeded];
    
	NSString *sentencetDB = @"insert into userTable values ( NULL, 'Javier', 'Programador' )";
	[self executeSentence:sentencetDB sentenceIsSelect:NO];
	
	sentencetDB = @"select * from userTable";
	[self executeSentence:sentencetDB sentenceIsSelect:YES];
	
}

-(void)executeSentence:(NSString *)sentence sentenceIsSelect:(BOOL )isSelect{
	
	// Variables para realizar la consulta
	static sqlite3 *db;     
	sqlite3_stmt *resultado; 
	const char* siguiente;  
    
	// Buscar el archivo de base de datos
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"myDB"];
    
	// Abre el archivo de base de datos
	if (sqlite3_open([path UTF8String], &db) == SQLITE_OK) {		
		
		if (isSelect){				
            
			// Ejecuta la consulta
			if ( sqlite3_prepare(db,[sentence UTF8String],[sentence length],&resultado,&siguiente) == SQLITE_OK ){
                
				// Recorre el resultado
				while (sqlite3_step(resultado)==SQLITE_ROW){		
					NSLog([NSString stringWithFormat:@"ID:%@ NAME:%@ INFO:%@",
						   [NSString stringWithUTF8String: (char *)sqlite3_column_text(resultado, 0)],
						   [NSString stringWithUTF8String: (char *)sqlite3_column_text(resultado, 1)],	
						   [NSString stringWithUTF8String: (char *)sqlite3_column_text(resultado, 2)] ]						  
						  );					
				}
			}
		}
		else {
			// Ejecuta la consulta
			if ( sqlite3_prepare_v2(db,[sentence UTF8String],[sentence length],&resultado,&siguiente) == SQLITE_OK ){
				sqlite3_step(resultado);				
				sqlite3_finalize(resultado);
			}			
		}
	} 
	// Cierra el archivo de base de datos
	sqlite3_close(db);	
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
