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
        let dataString = String(decoding: fullData!, as: UTF8.self)
        let dataBody = createDataBody(data: dataString, boundary: boundary, fileName: fileBaseName)
        let formFields = ["version": "1.0", "key": "12344321"]
        
        for (key, value) in formFields {
          httpBody.append(convertFormField(named: key, value: value, using: boundary))
        }
        
        httpBody.append(dataBody)
        request.httpBody = httpBody
        request.setValue("\(httpBody.count)", forHTTPHeaderField: "Content-Length")
        request.allowsCellularAccess = true

        let task = urlSession.uploadTask(with: request, from: httpBody ) { data, response, error in
                // Validate response and call handle
            if (error != nil) {
                print(error ?? "Error printing error")
                completion(false)
                return
            }
            
            let httpResponse = response as? HTTPURLResponse
            let statusCode = httpResponse!.statusCode
            
            if (statusCode != 200) {
                completion(false)
                print(response ?? "Error printing response")
            } else {
                print("File \(fullFilePath) uploaded successfully!")
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

    
    
    func createDataBody(data: String, boundary: String, fileName: String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\(lineBreak)\(lineBreak)")
        body.append(data)
        body.append(lineBreak)
        
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
}

