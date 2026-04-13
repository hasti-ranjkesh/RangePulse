//
//  BLEManager.swift
//  Range​Pulse
//
//  Created by Hasti on 10/04/2026.
//

import Foundation
import Combine

protocol BLEServiceProvider {
    //    func streamShots() async -> AsyncStream<Shot> // modern Swift
    var shotPublisher: AnyPublisher<Shot, Error> { get }
    func stopBLESimulation()
}

final class BLEManager: BLEServiceProvider {
    private let shotSubject = PassthroughSubject<Shot, Error>()
    private var simulationTask: Task<Void, Never>?

    init() {
        simulateBLE()
    }

    private func simulateBLE() {
        simulationTask = Task(priority: nil) { [weak self] in
            for _ in 0..<10 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                guard let self, !Task.isCancelled else { return }
                let shot = Shot(
                    speed: Double.random(in: 100...300),
                    distance: Double.random(in: 0...1000)
                )
                shotSubject.send(shot)
            }
        }
    }

    // Outputs

    var shotPublisher: AnyPublisher<Shot, Error> {
        shotSubject.eraseToAnyPublisher()
    }

    func stopBLESimulation() {
        simulationTask?.cancel()
    }
}
