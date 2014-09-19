//
//  QQList.h
//  TQQTableView
//
//  Created by Futao on 11-6-21.
//  Copyright 2011 ftkey.com. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface QQPerson : NSObject {
	int DeviceIndex;
	
    NSString *m_strKeyName;
	NSString *m_strLoopCode;
	NSString *m_strKeyID;
	NSString *m_strRSSI;
	NSString *m_strStatus;
	 
	//NSString *xxxx;
}
@property (nonatomic, assign) int DeviceIndex;

@property (nonatomic, retain) NSString *m_strKeyName;
@property (nonatomic, retain) NSString *m_strLoopCode;
@property (nonatomic, retain) NSString *m_strKeyID;
@property (nonatomic, retain) NSString *m_strRSSI;
@property (nonatomic, retain) NSString *m_strStatus;
@property (nonatomic, retain) NSString *m_strImageName;


@end

@interface QQListBase : NSObject {
	int m_nID;
	NSString *m_strName;
	NSMutableArray * m_arrayPersons;
}
@property (nonatomic, assign) int m_nID;
@property (nonatomic, retain) NSString *m_strName;
@property (nonatomic, retain) NSMutableArray *m_arrayPersons;
@end


@interface QQList : QQListBase {
	BOOL opened;
	NSMutableArray *indexPaths;
}
@property (assign) BOOL opened; // 是否为展开
@property (nonatomic,retain) NSMutableArray *indexPaths; // 临时保存indexpaths




@end