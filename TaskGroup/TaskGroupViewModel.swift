//
//  TaskGroupViewModel.swift
//  TaskGroup
//
//  Created by Srinivasa Billava on 13/03/25.
//
import SwiftUI
import Observation

@Observable
class TaskGroupViewModel {
    
    var images: [UIImage] = []
    let manager = TaskGroupDataManager()

    func getImages() async {
        if let images = try? await manager.fetchImagesWithTaskGroup() {
            await MainActor.run {
                self.images.append(contentsOf: images)
            }
        }
    }
    
}
