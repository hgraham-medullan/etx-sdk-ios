//
//  TrendService.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 3/10/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation

/**
 Fetches trends data for specified classes and timeframe
 */
public class ETXTrendService {
    
    /**
     Get trends data for a list of classes between two dates
     - parameter startDate: The oldest date to fetch date for. Compares to the date the model was logged
     - parameter endDate: The cut off date
     - parameter classes: The list of classes to run the aggregation for
     - parameter completion: Callback when the request completes
     - parameter trendResultSet: A collection of trends for the specified classes
     - parameter err: The error, when an error occurs during the request
     */
    public class func getTrend(startDate: Date, endDate: Date, classes: [ETXAggregatableModel.Type], completion: @escaping (_ trendResultSet: ETXTrendResultSet?, _ err: ETXError?)->Void) {
        ETXTrendService.getAggregatedData(timeframe: ETXTimeframe(startDate: startDate, endDate: endDate),  classes: classes, gdoConfig: nil, forUser: nil, completion: completion)
    }
    
    /**
     Get trends data for a list of classes between two dates
     - parameter startDate: The oldest date to fetch date for. Compares to the date the model was logged
     - parameter endDate: The cut off date
     - parameter classes: The list of classes to run the aggregation for
     - parameter forUser: The user to get the Trends data for. The current user must have an affiliation with the user
     - parameter completion: Callback when the request completes
     - parameter trendResultSet: A collection of trends for the specified classes
     - parameter err: The error, when an error occurs during the request
     */
    public class func getTrend(startDate: Date, endDate: Date, classes: [ETXAggregatableModel.Type], forUser: ETXUser, completion: @escaping (_ trendResultSet: ETXTrendResultSet?, _ err: ETXError?)->Void) {
        ETXTrendService.getAggregatedData(timeframe: ETXTimeframe(startDate: startDate, endDate: endDate),  classes: classes, gdoConfig: nil, forUser: forUser, completion: completion)
    }
    
    /**
     Get trends data for a list of classes between two dates
     - parameter startDate: The oldest date to fetch date for. Compares to the date the model was logged
     - parameter endDate: The cut off date
     - parameter classes: The list of classes to run the aggregation for
     - parameter gdoConfig: The configuration for how to perform aggregation for the specified Generic Data Objects
     - parameter completion: Callback when the request completes
     - parameter trendResultSet: A collection of trends for the specified classes
     - parameter err: The error, when an error occurs during the request
     */
    public class func getTrend(startDate: Date, endDate: Date, classes: [ETXAggregatableModel.Type], gdoConfig: ETXGenericDataObjectConfiguration, completion: @escaping (_ trendResultSet: ETXTrendResultSet?, _ err: ETXError?)->Void) {
        
        ETXTrendService.getAggregatedData(timeframe: ETXTimeframe(startDate: startDate, endDate: endDate),  classes: classes, gdoConfig: gdoConfig, forUser: nil, completion: completion)
    }
    
    /**
     Get trends data for a list of classes between two dates
     - parameter startDate: The oldest date to fetch date for. Compares to the date the model was logged
     - parameter endDate: The cut off date
     - parameter classes: The list of classes to run the aggregation for
     - parameter gdoConfig: The configuration for how to perform aggregation for the specified Generic Data Objects
     - parameter forUser: The user to get the Trends data for. The current user must have an affiliation with the user
     - parameter completion: Callback when the request completes
     - parameter trendResultSet: A collection of trends for the specified classes
     - parameter err: The error, when an error occurs during the request
     */
    public class func getTrend(startDate: Date, endDate: Date, classes: [ETXAggregatableModel.Type], gdoConfig: ETXGenericDataObjectConfiguration, forUser: ETXUser, completion: @escaping (_ trendResultSet: ETXTrendResultSet?, _ err: ETXError?)->Void) {
        
        ETXTrendService.getAggregatedData(timeframe: ETXTimeframe(startDate: startDate, endDate: endDate),  classes: classes, gdoConfig: gdoConfig, forUser: forUser, completion: completion)
    }
    
    
    
    /**
     Get trends data for a list of classes over a timeframe leading up to the current date
     - parameter trendTimeframe: The timeframe over which to query data
     - parameter classes: The list of classes to run the aggregation for
     - parameter completion: Callback when the request completes
     - parameter trendResultSet: A collection of trends for the specified classes
     - parameter err: The error, when an error occurs during the request
     */
    public class func getTrend(trendTimeframe: ETXTrendTimeframe, classes: [ETXAggregatableModel.Type], completion: @escaping (_ trendResultSet: ETXTrendResultSet?, _ err: ETXError?)->Void) {
        
        ETXTrendService.getAggregatedData(timeframe: ETXTimeframe(trendTimeframe: trendTimeframe),  classes: classes, gdoConfig: nil, forUser: nil, completion: completion)
    }
    
    /**
     Get trends data for a list of classes over a timeframe leading up to the current date
     - parameter trendTimeframe: The timeframe over which to query data
     - parameter classes: The list of classes to run the aggregation for
     - parameter forUser: The user to get the Trends data for. The current user must have an affiliation with the user
     - parameter completion: Callback when the request completes
     - parameter trendResultSet: A collection of trends for the specified classes
     - parameter err: The error, when an error occurs during the request
     */
    public class func getTrend(trendTimeframe: ETXTrendTimeframe, classes: [ETXAggregatableModel.Type], forUser: ETXUser, completion: @escaping (_ trendResultSet: ETXTrendResultSet?, _ err: ETXError?)->Void) {
        
        ETXTrendService.getAggregatedData(timeframe: ETXTimeframe(trendTimeframe: trendTimeframe),  classes: classes, gdoConfig: nil, forUser: forUser, completion: completion)
    }
    
    /**
     Get trends data for a list of classes over a timeframe leading up to the current date
     - parameter trendTimeframe: The timeframe over which to query data
     - parameter classes: The list of classes to run the aggregation for
     - parameter gdoConfig: The configuration for how to perform aggregation for the specified Generic Data Objects
     - parameter completion: Callback when the request completes
     - parameter trendResultSet: A collection of trends for the specified classes
     - parameter err: The error, when an error occurs during the request
     */
    public class func getTrend(trendTimeframe: ETXTrendTimeframe, classes: [ETXAggregatableModel.Type], gdoConfig: ETXGenericDataObjectConfiguration, completion: @escaping (_ trendResultSet: ETXTrendResultSet?, _ err: ETXError?)->Void) {
        
        ETXTrendService.getAggregatedData(timeframe: ETXTimeframe(trendTimeframe: trendTimeframe),  classes: classes, gdoConfig: gdoConfig, forUser: nil, completion: completion)
    }
    
    /**
     Get trends data for a list of classes over a timeframe leading up to the current date
     - parameter trendTimeframe: The timeframe over which to query data
     - parameter classes: The list of classes to run the aggregation for
     - parameter gdoConfig: The configuration for how to perform aggregation for the specified Generic Data Objects
     - parameter forUser: The user to get the Trends data for. The current user must have an affiliation with the user
     - parameter completion: Callback when the request completes
     - parameter trendResultSet: A collection of trends for the specified classes
     - parameter err: The error, when an error occurs during the request
     */
    public class func getTrend(trendTimeframe: ETXTrendTimeframe, classes: [ETXAggregatableModel.Type], gdoConfig: ETXGenericDataObjectConfiguration, forUser: ETXUser, completion: @escaping (_ trendResultSet: ETXTrendResultSet?, _ err: ETXError?)->Void) {
        
        ETXTrendService.getAggregatedData(timeframe: ETXTimeframe(trendTimeframe: trendTimeframe),  classes: classes, gdoConfig: gdoConfig, forUser: forUser, completion: completion)
    }
    
    
    /**
     Get trends data for a list of classes over a timeframe leading up to the current date
     - parameter trendTimeframe: The timeframe over which to query data
     - parameter leadingUpTo: The cut off date
     - parameter classes: The list of classes to run the aggregation for
     - parameter completion: Callback when the request completes
     - parameter trendResultSet: A collection of trends for the specified classes
     - parameter err: The error, when an error occurs during the request
     */
    public class func getTrend(trendTimeframe: ETXTrendTimeframe, leadingUpTo: Date, classes: [ETXAggregatableModel.Type], completion: @escaping (_ trendResultSet: ETXTrendResultSet?, _ err: ETXError?)->Void) {
        
        let timeframe = ETXTimeframe(trendTimeframe: trendTimeframe, leadingUpTo: leadingUpTo)
        ETXTrendService.getAggregatedData(timeframe: timeframe, classes: classes, gdoConfig: nil, forUser: nil, completion: completion
        )
    }
    
    /**
     Get trends data for a list of classes over a timeframe leading up to the current date
     - parameter trendTimeframe: The timeframe over which to query data
     - parameter leadingUpTo: The cut off date
     - parameter classes: The list of classes to run the aggregation for
     - parameter forUser: The user to get the Trends data for. The current user must have an affiliation with the user
     - parameter completion: Callback when the request completes
     - parameter trendResultSet: A collection of trends for the specified classes
     - parameter err: The error, when an error occurs during the request
     */
    public class func getTrend(trendTimeframe: ETXTrendTimeframe, leadingUpTo: Date, classes: [ETXAggregatableModel.Type], forUser: ETXUser, completion: @escaping (_ trendResultSet: ETXTrendResultSet?, _ err: ETXError?)->Void) {
        
        let timeframe = ETXTimeframe(trendTimeframe: trendTimeframe, leadingUpTo: leadingUpTo)
        ETXTrendService.getAggregatedData(timeframe: timeframe, classes: classes, gdoConfig: nil, forUser: forUser, completion: completion
        )
    }

    
    /**
     Get trends data for a list of classes over a timeframe leading up to the current date
     - parameter trendTimeframe: The timeframe over which to query data
     - parameter leadingUpTo: The cut off date
     - parameter classes: The list of classes to run the aggregation for
     - parameter gdoConfig: The configuration for how to perform aggregation for the specified Generic Data Objects
     - parameter completion: Callback when the request completes
     - parameter trendResultSet: A collection of trends for the specified classes
     - parameter err: The error, when an error occurs during the request
     */
    public class func getTrend(trendTimeframe: ETXTrendTimeframe, leadingUpTo: Date, classes: [ETXAggregatableModel.Type], gdoConfig: ETXGenericDataObjectConfiguration, completion: @escaping (_ trendResultSet: ETXTrendResultSet?, _ err: ETXError?)->Void) {
        
        let timeframe = ETXTimeframe(trendTimeframe: trendTimeframe, leadingUpTo: leadingUpTo)
        ETXTrendService.getAggregatedData(timeframe: timeframe, classes: classes, gdoConfig: gdoConfig, forUser: nil, completion: completion
        )
    }
    
    /**
     Get trends data for a list of classes over a timeframe leading up to the current date
     - parameter trendTimeframe: The timeframe over which to query data
     - parameter leadingUpTo: The cut off date
     - parameter classes: The list of classes to run the aggregation for
     - parameter gdoConfig: The configuration for how to perform aggregation for the specified Generic Data Objects
     - parameter forUser: The user to get the Trends data for. The current user must have an affiliation with the user
     - parameter completion: Callback when the request completes
     - parameter trendResultSet: A collection of trends for the specified classes
     - parameter err: The error, when an error occurs during the request
     */
    public class func getTrend(trendTimeframe: ETXTrendTimeframe, leadingUpTo: Date, classes: [ETXAggregatableModel.Type], gdoConfig: ETXGenericDataObjectConfiguration, forUser: ETXUser, completion: @escaping (_ trendResultSet: ETXTrendResultSet?, _ err: ETXError?)->Void) {
        
        let timeframe = ETXTimeframe(trendTimeframe: trendTimeframe, leadingUpTo: leadingUpTo)
        ETXTrendService.getAggregatedData(timeframe: timeframe, classes: classes, gdoConfig: gdoConfig, forUser: forUser, completion: completion
        )
    }
    
    private class func getAggregatedData(timeframe: ETXTimeframe, classes: [ETXAggregatableModel.Type], gdoConfig: ETXGenericDataObjectConfiguration?, forUser: ETXUser?, completion: @escaping (_ trendResultSet: ETXTrendResultSet?, _ err: ETXError?)->Void) {
        
        let trendRepo = getRepository()
        trendRepo.getTrends(startDate: timeframe.startDate!, endDate: timeframe.endDate!, classes: classes, gdoConfig: gdoConfig, forUser: forUser, completion: completion)
    }
    
    private class func getRepository<R: TrendRepository>() -> R {
        if let customTrendRepositoryType = EngaugeTxApplication.getInstance().customTrendRepositoryType  {
            return customTrendRepositoryType.init() as! R
        }
        return TrendRepository() as! R
    }
    
    class func useCustomDataRepository<R: TrendRepository>(_ repoType: R.Type) {
        EngaugeTxApplication.getInstance().customTrendRepositoryType = repoType
    }
    
}
