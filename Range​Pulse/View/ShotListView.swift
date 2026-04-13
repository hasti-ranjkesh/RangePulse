//
//  ShotListView.swift
//  Range​Pulse
//
//  Created by Hasti on 10/04/2026.
//

import SwiftUI

struct ShotListView: View {

    @ObservedObject var viewModel: ShotsViewModel

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    if let error = viewModel.error {
                        Text(error)
                            .foregroundColor(.red)
                    } else {
                        List {
                            ForEach(viewModel.shots) { shot in
                                NavigationLink {
                                    VStack {
                                        Text("Distance: \(shot.distance)")
                                        Text("Ball Speed: \(shot.speed)")
                                    }
                                } label: {
                                    VStack(alignment: .leading) {
                                        Text("Speed: \(shot.speed, specifier: "%.1f") mph")
                                        Text("Distance: \(shot.distance, specifier: "%.1f") yd")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }

                            }
                        }
                    }
                }
            }
        }
    }
}
