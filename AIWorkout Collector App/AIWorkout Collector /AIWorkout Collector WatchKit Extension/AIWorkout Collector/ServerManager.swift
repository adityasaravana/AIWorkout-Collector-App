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
        

        var request = URLRequest(
            url: URL(string: url)!,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        
        
        request.httpMethod = "POST"
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var httpBody = Data()
        let dataBody = createDataBody(data: fullData!, boundary: boundary, fileName: fileBaseName)
        let dataString = String(decoding: fullData!, as: UTF8.self)
        let formFields = ["version": "1.0", "key": "12344321", "content": dataString]
        
        for (key, value) in formFields {
          httpBody.append(convertFormField(named: key, value: value, using: boundary))
        }
        
        
        httpBody.append(dataBody)
        request.httpBody = httpBody
        request.setValue("\(httpBody.count)", forHTTPHeaderField: "Content-Length")
        //        request.setValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        request.allowsCellularAccess = true
        print(request.allHTTPHeaderFields)
        
        print(String(decoding: httpBody, as: UTF8.self))
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        
        
        let task = urlSession.uploadTask(with: request, from: httpBody ) { data, response, error in
                // Validate response and call handle
                
                print(response ?? "Error printing response")
                print(error ?? "Error printing error")
                if (error != nil) {
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
    
    func convertFormField(named name: String, value: String, using boundary: String) -> String {
      var fieldString = "--\(boundary)\r\n"
      fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
      fieldString += "\r\n"
      fieldString += "\(value)\r\n"

      return fieldString
    }

    
    
    func createDataBody(data: Data, boundary: String, fileName: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\(lineBreak)")
        body.append("Content-Type: text/html; charset=utf-8\(lineBreak) \(lineBreak)")
        //body.append("Content-Length: \(body.count)")
        body.append(data)
        body.append(lineBreak)
        
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
}

