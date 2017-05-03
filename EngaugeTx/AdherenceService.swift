//
//  AdherenceService.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/21/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation


public class ETXAdherenceService {
    
    /**
     * Get data over a specific timeframe with some level of aggregation
     *
     * @param startDate    The oldest date to fetch date for. Compares to the date the model was logged
     * @param endDate      The cut off date
     * @param callback     Callback when the request completes
     */
    public class func getAdherence(startDate: Date, endDate: Date, completion: @escaping ([ETXAdherenceResultSet]?, ETXError?) ->Void) {
        ETXAdherenceService.getAdherence(medicationId: nil, timeframe: ETXTimeframe(startDate: startDate, endDate: endDate), forUser: nil, completion: completion);
    }
    
    /**
     * Get data over a specific timeframe with some level of aggregation
     *
     * @param medicationId The ID of the medication
     * @param startDate    The oldest date to fetch date for. Compares to the date the model was logged
     * @param endDate      The cut off date
     * @param callback     Callback when the request completes
     */
    public class func getAdherence(medicationId: String, startDate: Date, endDate: Date, completion: @escaping ([ETXAdherenceResultSet]?, ETXError?) ->Void) {
        ETXAdherenceService.getAdherence(medicationId: medicationId, timeframe: ETXTimeframe(startDate: startDate, endDate: endDate), forUser: nil, completion: completion);
    }
    
    /**
     * Get data over a specific timeframe with some level of aggregation
     *
     * @param medicationId The ID of the medication
     * @param startDate    The oldest date to fetch date for. Compares to the date the model was logged
     * @param endDate      The cut off date
     * @param forUser      User to get the data for
     * @param callback     Callback when the request completes
     */
    public class func getAdherence(medicationId: String, startDate: Date, endDate: Date, forUser: ETXUser,  completion: @escaping ([ETXAdherenceResultSet]?, ETXError?) ->Void) {
        ETXAdherenceService.getAdherence(medicationId: medicationId, timeframe: ETXTimeframe(startDate: startDate, endDate: endDate), forUser: forUser, completion: completion);
    }
    
    /**
     * Get data over a specific timeframe with some level of aggregation
     *
     * @param trendTimeframe How far back to get data, up to now.
     * @param callback       Callback when the request completes
     */
    public class func getAdherence(trendTimeframe: ETXTrendTimeframe, completion: @escaping ([ETXAdherenceResultSet]?, ETXError?) ->Void) {
        ETXAdherenceService.getAdherence(medicationId: nil, timeframe: ETXTimeframe(trendTimeframe: trendTimeframe), forUser: nil, completion: completion);
    }
    
    /**
     * Get data over a specific timeframe with some level of aggregation
     *
     * @param medicationId   The ID of the medication
     * @param trendTimeframe How far back to get data, up to now.
     * @param callback       Callback when the request completes
     */
    public class func getAdherence(medicationId: String, trendTimeframe: ETXTrendTimeframe, completion: @escaping ([ETXAdherenceResultSet]?, ETXError?) ->Void) {
        ETXAdherenceService.getAdherence(medicationId: medicationId, timeframe: ETXTimeframe(trendTimeframe: trendTimeframe), forUser: nil, completion: completion);
    }
    
    /**
     * Get data over a specific timeframe with some level of aggregation
     *
     * @param medicationId   The ID of the medication
     * @param trendTimeframe How far back to get data, up to now.
     * @param callback       Callback when the request completes
     * @param forUser        User to get the data for
     */
    public class func getAdherence(medicationId: String, trendTimeframe: ETXTrendTimeframe, forUser: ETXUser, completion: @escaping ([ETXAdherenceResultSet]?, ETXError?) ->Void) {
        ETXAdherenceService.getAdherence(medicationId: medicationId, timeframe: ETXTimeframe(trendTimeframe: trendTimeframe), forUser: forUser, completion: completion);
    }
    
    /**
     * Get data over a specific timeframe with some level of aggregation
     *
     * @param medicationId   The ID of the medication
     * @param trendTimeframe How far back to get data
     * @param leadingUpTo    Date to end date filter. Must be greater than trendTimeframe
     * @param callback       Callback when the request completes
     */
    public class func getAdherence(medicationId: String, trendTimeframe: ETXTrendTimeframe, leadingUpTo: Date, completion: @escaping ([ETXAdherenceResultSet]?, ETXError?) ->Void) {
        ETXAdherenceService.getAdherence(medicationId: medicationId, timeframe: ETXTimeframe(trendTimeframe: trendTimeframe, leadingUpTo: leadingUpTo), forUser: nil, completion: completion);
    }
    
    /**
     * Get data over a specific timeframe with some level of aggregation
     *
     * @param medicationId   The ID of the medication
     * @param trendTimeframe How far back to get data
     * @param leadingUpTo    Date to end date filter. Must be greater than trendTimeframe
     * @param forUser        User to get the data for
     * @param callback       Callback when the request completes
     */
    public class func getAdherence(medicationId: String, trendTimeframe: ETXTrendTimeframe, leadingUpTo: Date, forUser: ETXUser?, completion: @escaping ([ETXAdherenceResultSet]?, ETXError?) ->Void) {
        ETXAdherenceService.getAdherence(medicationId: medicationId, timeframe: ETXTimeframe(trendTimeframe: trendTimeframe, leadingUpTo: leadingUpTo), forUser: forUser, completion: completion);
    }
    
    public class func getAdherence(medicationId: String?, timeframe: ETXTimeframe, forUser: ETXUser?, completion: @escaping ([ETXAdherenceResultSet]?, ETXError?) ->Void) {
        let adherenceRespository =  ETXAdherenceRepository()
        
        adherenceRespository.getMedicationAdherence(medicationId: medicationId, startDate: timeframe.startDate!, endDate: timeframe.endDate!, forUser: forUser, completion: completion);
    }
}
