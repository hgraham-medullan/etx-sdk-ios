//
//  BlobRepository.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 6/14/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import Siesta
import Alamofire
import ObjectMapper

class BlobRepository<M: ETXModel>: Repository<M> {
    let fieldNameForFile = "file"
    
    override func save(model: M, completion: @escaping (M?, ETXError?) -> Void) {
        let blob = model as! ETXBlob
        self.saveFile(imgData: blob.fileData!, filename: blob.fileName!, mimeType: blob.mimeType!, progress: nil, completion: completion)
    }
    
    func saveFile(imgData: Data, filename: String, mimeType: String, progress:  ((Float)-> Void)?, completion: @escaping (M?, ETXError?) -> Void) {
        var headers: HTTPHeaders = [:]
        
        headers[self.KEY_HEADER_APP_ID] = EngaugeTxApplication.appId
        headers[self.KEY_HEADER_CLIENT_KEY] = EngaugeTxApplication.clientKey
        headers[self.KEY_HEADER_AUTHORIZATION] =  self.getAccessToken()
        let blobsUrl = self.etxResource
        let URL = try! URLRequest(url: blobsUrl.url.absoluteString, method: .post, headers: headers)
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append (imgData, withName: self.fieldNameForFile, fileName: filename, mimeType: mimeType)
            
        }, with: URL, encodingCompletion: {
            encodingResult in
            let etxError = ETXError()
            switch encodingResult {
            case .success(let upload, _,_):
                upload.uploadProgress { uploadProgress in
                    if let progress = progress {
                        progress(Float(uploadProgress.fractionCompleted))
                    }
                }
                upload.validate()
                upload.responseJSON { response in
                    
                    guard response.result.isSuccess else {
                        print("Error while uploading file: \(response.result.error)")
                        completion(nil, etxError)
                        return
                    }
                    
                    guard let responseJSON = response.result.value as? [String: Any] else {
                        print("No data available in success save response")
                        completion(nil, nil)
                        return
                    }
                    let blob = Mapper<M>().map (JSON: responseJSON)
                    completion(blob, nil)
                }
            case .failure(let encodingError):
                let etxError = ETXError.init(message: encodingError.localizedDescription)
                print("An encoding error occurred while attempting to upload the file")
                completion(nil, etxError)
            }
        })
    }
    
    func getUrl(_ blobId: String?) -> URL? {
        guard let blobId = blobId, let accessToken =  self.getAccessToken() else {
            return nil
        }
        return self.etxResource
            .child(blobId)
            .withParam(QUERY_STRING_APP_ID, EngaugeTxApplication.appId)
            .withParam(QUERY_STRING_CLIENT_KEY, EngaugeTxApplication.clientKey)
            .withParam(QUERY_STRING_ACCESS_TOKEN, accessToken).url
    }
    
    func getUrl(model: ETXBlob) -> URL? {
        return self.getUrl(model.id)
    }
}
