//
//  ShotsViewModel.swift
//  Range​Pulse
//
//  Created by Hasti on 10/04/2026.
//

import Foundation
import Combine

final class ShotsViewModel: ObservableObject {
    @Published var shots: [Shot] = []
    @Published var error: String?
    @Published var isLoading: Bool = false

    let bleManager: BLEServiceProvider
    var cancellable: Set<AnyCancellable> = []
    private var task: Task<Void, Never>?

    init(bleManager: BLEServiceProvider) {
        self.bleManager = bleManager

        // Choose one of the following methods to start listening to simulated Bluetooth data:
        // - startListeningWithAsyncStream()
        // - startListeningWithCombine()
        startListeningWithAsyncStream()
    }

    deinit {
        task?.cancel()
        cancellable.forEach { $0.cancel() }
    }

    // 1. Uses Combine.
    func startListeningWithCombine() {
        isLoading = true

        bleManager.shotPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                // FYI: BLEManager  never sends completion
                guard let self else { return }
                isLoading = false
                switch completion {
                case .finished:
                    print("Success")
                case .failure(let failure):
                    error = "Failed to fetch shots: \(failure)"
                }
            }) { [weak self] shot in
                guard let self else { return }
                isLoading = false
                shots.insert(shot, at: 0)
            }
            .store(in: &cancellable)
    }

    // 2. Uses AsyncStream-based approach.
    func startListeningWithAsyncStream() {
        isLoading = true
        task = Task {
            for await shot in bleManager.streamShots() {
                await MainActor.run {
                    isLoading = false
                    shots.insert(shot, at: 0)
                }
            }
        }
    }
}
