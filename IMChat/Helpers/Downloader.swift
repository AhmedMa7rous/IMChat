//
//  Downloader.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import Foundation

class FileDownloader {
    
    func loadFileAsync(url: URL, completion: @escaping (URL?, Error?) -> Void)
    {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        
        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl, nil)
        }
        else
        {
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler:
                                            {
                                                data, response, error in
                                                if error == nil
                                                {
                                                    if let response = response as? HTTPURLResponse
                                                    {
                                                        if response.statusCode == 200
                                                        {
                                                            if let data = data
                                                            {
                                                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                                                {
                                                                    completion(destinationUrl, error)
                                                                }
                                                                else
                                                                {
                                                                    completion(destinationUrl, error)
                                                                }
                                                            }
                                                            else
                                                            {
                                                                completion(destinationUrl, error)
                                                            }
                                                        }
                                                    }
                                                }
                                                else
                                                {
                                                    completion(destinationUrl, error)
                                                }
                                            })
            task.resume()
        }
    }
}

