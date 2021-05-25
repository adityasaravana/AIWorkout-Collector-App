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
        let boundary = generateBoundary()
        
        let directory = FileManager.documentsDirectoryURL
        let fileBaseName = (fileName as NSString).lastPathComponent
        
        let fullFilePath = directory.appendingPathComponent(fileName)
        print("Full file path - \(fullFilePath)")
        let fileHandle = try? FileHandle(forReadingFrom: fullFilePath)
        let fullData = fileHandle?.readDataToEndOfFile()
        
        let dataBody = createDataBody(data: fullData!, boundary: boundary, fileName: fileBaseName)
        
        var request = URLRequest(
            url: URL(string: url)!,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        
        
        request.httpMethod = "POST"
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = dataBody
        request.setValue("\(dataBody.count)", forHTTPHeaderField: "Content-Length")
        //        request.setValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        request.allowsCellularAccess = true
        print(request.allHTTPHeaderFields)
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        
        
        let task = urlSession.dataTask(with: request) { data, response, error in
                // Validate response and call handler
                print(response ?? "Error printing response")
                print(error ?? "Error printing error")
                if error != nil {
                    completion(false)
                } else {
                    completion(true)
                }
        }
    
        task.resume()
    }
    
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func createDataBody(data: Data, boundary: String, fileName: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\(lineBreak)")
        body.append("Content-Type: application/octet-stream\(lineBreak) \(lineBreak)")
        body.append(data)
        body.append(lineBreak)
        
        body.append("--\(boundary)--\(lineBreak)")
        print(String(decoding: body, as: UTF8.self))
        return body
    }
}

