//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import <Foundation/Foundation.h>

//클래스 선언부
@interface DirectoryManager: NSObject

-(id)init;    //-: instance method

+(void) deleteTmpDirectory;    //+: static

@end
