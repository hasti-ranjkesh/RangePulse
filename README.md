# RangePulse

RangePulse is a small SwiftUI iOS app that displays golf shot data coming from a BLE-style data source. The current implementation uses a simulated BLE manager that emits random shot values over time, and the UI renders those incoming events in a live-updating shot list.

## Project Summary

The app is structured around a simple reactive flow:

- `BLEManager` acts as the data source and publishes incoming shot updates.
- `Shot` is the core model representing a single shot with speed and distance.
- `ShotsViewModel` subscribes to the BLE publisher, transforms events into view state, and exposes loading and error states to the UI.
- `ShotListView` renders the live list of shots and allows basic detail navigation for each entry.
- `RangePulseApp` wires the app together and injects the BLE-backed view model into the root view.

## Current Behavior

- On launch, the app creates a `BLEManager`.
- The BLE manager simulates a stream of 10 incoming shot events.
- Each new shot is inserted at the top of the list.
- The UI shows a loading spinner before the first event arrives and displays any publisher failure as an error message.

## Architecture Note

The current design is intentionally event-driven rather than polling-based.
In practice, that means the BLE layer pushes data as it arrives, and the view model reacts to those events on the main thread so the UI stays synchronized with live sensor updates.

## Files

- `Range​Pulse/Range​Pulse/Data/BLEManager.swift`: BLE abstraction and simulated shot publisher
- `Range​Pulse/Range​Pulse/Model/Shot.swift`: shot model
- `Range​Pulse/Range​Pulse/ViewModel/ShotsViewModel.swift`: state management and Combine subscription logic
- `Range​Pulse/Range​Pulse/View/ShotListView.swift`: SwiftUI list and detail navigation
- `Range​Pulse/Range​Pulse/Range​PulseApp.swift`: app entry point and dependency wiring

## Status

This is currently a solid prototype for validating the data flow from a streaming BLE source into a SwiftUI interface. The BLE layer is still simulated, but the project already reflects the structure you would use for a real push-based integration.
