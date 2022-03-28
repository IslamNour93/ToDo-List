//
//  Task.h
//  ToDo
//
//  Created by Islam NourEldin on 28/01/2022.
//

#import <Foundation/Foundation.h>


@interface Task : NSObject <NSCoding,NSSecureCoding>

@property NSString *taskName;
@property NSString *descrpt;
@property NSString *prior;
@property NSDate*datee;
@property int idd;



@end

