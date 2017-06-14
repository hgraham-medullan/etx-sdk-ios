//
//  Blob.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 6/14/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

/**
 * Represent a blob/file that can be stored on the platform
 */
public class ETXBlob: ETXPersistedModel, FirstClassModel {
    private static let blobsUrl = "/blobs"
    /**
     The name of the blob (auto-generated)
    */
    public private(set)  var name: String?
    
    /**
     The content(mime) type of the blob
    */
    public private(set) var contentType: String?
    
    /*
     The size of the file (in bytes)
     */
    public private(set) var size: Int?
    
    /*
     The URL to the blob
     */
    
    public var url: URL? {
        return ETXBlob.getUrl(self.id)
    }
    
    /*
     The URL to the blob
     */
    public static func getUrl(_ blobId: String?) -> URL? {
        return BlobRepository<ETXBlob>(resourcePath: ETXBlob.blobsUrl).getUrl(blobId)
    }
    
     var fileData: Data?
     var fileName: String?
     var mimeType: String?
    
    /**
     Create a new blob to be saved
     - parameter fileData: The file data to be stored
     - parameter fileName: The name of the file
     - parameter mimeType: The files mime/content-type  
    */
    public init(fileData: Data, fileName: String, mimeType: String) {
        self.fileData = fileData
        self.fileName = fileName
        self.mimeType = mimeType
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override open func mapping(map: Map) {
        super.mapping(map: map)
        name <- map["name"]
        size <- map["size"]
        contentType <- map["contentType"]
    }

    open override class func getDataSvc<ETXBlob>() -> ETXDataService<ETXBlob>? {
        let blobRepository: Repository<ETXBlob> = BlobRepository<ETXBlob>(resourcePath: blobsUrl)
        return ETXDataService<ETXBlob>(repository: blobRepository)
    }
    
    
    
}
