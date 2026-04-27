//
//  TaskGroupDataManager.swift
//  TaskGroup
//
//  Created by Srinivasa Billava on 13/03/25.
//
import SwiftUI


class TaskGroupDataManager: NSObject {
    
    func fetchImagesWithAsyncLet() async throws -> [UIImage] {
        async let fetchImage1 = fetchImage(urlString: "https://picsum.photos/301")
        async let fetchImage2 = fetchImage(urlString: "https://picsum.photos/302")
        
        let (image1, image2) = await (try fetchImage1, try fetchImage2)
        return [image1, image2]
    }
    
    func fetchImagesWithTaskGroup() async throws -> [UIImage] {
        let urlStrings = [
            "https://picsum.photos/301",
            "https://picsum.photos/302",
            "https://picsum.photos/303",
            "https://picsum.photos/304",
            "https://picsum.photos/305",
            "https://picsum.photos/306",
        ]
        return try await withThrowingTaskGroup(of: UIImage?.self) { group in
            var images: [UIImage] = []
            
            for urlString in urlStrings {
                group.addTask() {
                    try? await self.fetchImage(urlString: urlString)
                }
            }
            
            for try await image in group {
                if let image = image {
                    images.append(image)
                }
            }
            
            return images
        }
    }
    
    private func fetchImage(urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        do {
            let session = URLSession(configuration: .default,
                                     delegate: self,
                                     delegateQueue: nil)
            let (data, _) = try await session.data(from: url, delegate: nil)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
}

extension TaskGroupDataManager: URLSessionDelegate {
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if let trust = challenge.protectionSpace.serverTrust {
            completionHandler(.useCredential, URLCredential(trust: trust))
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}
