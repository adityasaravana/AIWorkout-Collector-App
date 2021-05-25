//
//  ServerManager.swift
//  AIWorkout Collector WatchKit Extension
//
//  Created by Aditya Saravana on 5/9/21.
//

import Foundation

class ServerManager {
    let url = "https://devknight.studio/uploader"
    var urlSession = URLSession.shared
    
    func sendPostRequest(fileName: String, completion: ((_ success: Bool) -> Void)!) {
        let directory = FileManager.documentsDirectoryURL
        let fileBaseName = (fileName as NSString).lastPathComponent
        
        let fullFilePath = directory.appendingPathComponent(fileName)
        let fullFilePathString = fullFilePath.absoluteString
        
        let file: FileHandle? = FileHandle(forReadingAtPath: fullFilePathString)
        let fullData = file?.readDataToEndOfFile()
        
        var request = URLRequest(
            url: URL(string: url)!,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        
        print(fileName)
        print(fullData ?? "No Data (nil)")
        print(fullFilePathString)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("multipart/form-data; file=" + fileBaseName, forHTTPHeaderField: "Content-Type")
        
        let task = urlSession.uploadTask(
            with: request,
            from: fullData,
            completionHandler: { data, response, error in
                // Validate response and call handler
                print(response ?? "Error printing response")
                print(error ?? "Error printing error")
                if error != nil {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        )
        
        task.resume()
    }
}
