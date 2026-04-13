//
//  BLEManager.swift
//  Range​Pulse
//
//  Created by Hasti on 10/04/2026.
//

import Foundation
import Combine

protocol BLEServiceProvider {
    var shotPublisher: AnyPublisher<Shot, Error> { get }
    func stopBLESimulation()
    func streamShots() -> AsyncStream<Shot>
}

// Provides two implementations for streaming Bluetooth data: AsyncStream and Combine.
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

    func streamShots() -> AsyncStream<Shot> {
        AsyncStream { continuation in
            let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                let shot = Shot(
                    speed: Double.random(in: 100...300),
                    distance: Double.random(in: 0...1000)
                )
                continuation.yield(shot)
            }

            // If Timer never stops it causes memory leak.
            // When view disappears, the timer should stop.
            continuation.onTermination = { @Sendable _ in
                timer.invalidate()
            }
        }
    }
}
