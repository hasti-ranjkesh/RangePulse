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

    init(bleManager: BLEServiceProvider) {
        self.bleManager = bleManager
        startListening()
    }

    deinit {
        cancellable.forEach { $0.cancel() }
    }

    func startListening() {
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
}
