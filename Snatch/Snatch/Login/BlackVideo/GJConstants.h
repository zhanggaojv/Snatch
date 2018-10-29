//
//  GJVideoFunctions.h
//  Snatch
//
//  Created by Zhanggaoju on 16/10/8.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#ifndef GJVideo_JSConstants_h
#define GJVideo_JSConstants_h


#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPhone" ] )
#define IS_IPOD   ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPod touch" ] )
#define IS_IPHONE_5 ( IS_IPHONE && IS_WIDESCREEN )


#endif
