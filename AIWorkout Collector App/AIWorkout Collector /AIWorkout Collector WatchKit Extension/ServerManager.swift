//
//  ServerManager.swift
//  AIWorkout Collector WatchKit Extension
//
//  Created by Aditya Saravana on 5/9/21.
//

import Foundation

class ServerManager {
    let url = "http://176.9.10.139/uploader"
    var urlSession = URLSession.shared
    
    func sendPostRequest (
        fileName: String
    ) {
        var request = URLRequest(
            url: URL(string: url)!,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        
        let fileBaseName = (fileName as NSString).lastPathComponent
        let file: FileHandle? = FileHandle(forReadingAtPath: fileName)
        let fullData = file?.readDataToEndOfFile()
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("multipart/form-data; file=" + fileBaseName, forHTTPHeaderField: "Content-Type")
        let task = urlSession.uploadTask(
            with: request,
            from: fullData,
            completionHandler: { data, response, error in
                // Validate response and call handler
                print(response)
                print(error)
            }
        )
        
        task.resume()
    }
}
