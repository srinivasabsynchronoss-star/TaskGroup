//
//  ContentView.swift
//  TaskgroupDemo
//
//  Created by Srinivasa Billava on 13/03/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoading = false
    @State private var viewModel =  TaskGroupViewModel()

    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            VStack(alignment: .center) {
                Text("Task Group Gallery")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 24)
                    .padding(.bottom, 8)
                if isLoading {
                    VStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(.circular)
                            .controlSize(.large)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    if isLandscape {
                        // Grid style in landscape
                        let columns = [
                            GridItem(.flexible(), spacing: 50, alignment: .center),
                            GridItem(.flexible(), spacing: 50, alignment: .center)
                        ]
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 50) {
                                ForEach(viewModel.images, id: \.self) { image in
                                    GeometryReader { geo in
                                        Image(uiImage: image)
                                            .resizable()
                                            .aspectRatio(1, contentMode: .fill)
                                            .frame(width: geo.size.width, height: geo.size.width)
                                            .clipped()
                                    }
                                    .aspectRatio(1, contentMode: .fit)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    } else {
                        // List style in portrait
                        List(viewModel.images, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
            }
        }
        .task {
            isLoading = true
            await viewModel.getImages()
            isLoading = false
        }
    }
}
