import AppKit
import MacPerfMonitorCore
import SwiftUI
import XCTest

@testable import MacPerfMonitor

@MainActor
final class EnergyChartHoverTests: XCTestCase {
    func testEnergyTimelinesEnableHoverAndKeepTheirUnits() async {
        let points = [point(time: 0), point(time: 30)]
        let charge = BatteryChart(points: points, currentLevel: BatteryLevel(percent: 50)).chart
        let temperature = TemperatureChart(points: points).chart
        let fans = FanChart(points: points).chart
        XCTAssertTrue(charge.scrubbable)
        XCTAssertTrue(temperature.scrubbable)
        XCTAssertTrue(fans.scrubbable)
        XCTAssertEqual(charge.yFormat(50), "50%")
        XCTAssertEqual(temperature.yFormat(65), "65°C")
        XCTAssertEqual(fans.yFormat(2400), "2400 rpm")
        XCTAssertEqual(fans.yFormat(0), "0 rpm")
    }

    func testThermalHoverIncludesBothReadingsAtTheSelectedTime() async throws {
        let chart = TemperatureChart(points: [point(time: 0), point(time: 30)]).chart
        let selected = try XCTUnwrap(chart.nearestPoint(fraction: 1, tMin: 0, span: 30))
        XCTAssertEqual(selected.date, Date(timeIntervalSinceReferenceDate: 30))
        XCTAssertEqual(selected.readings.map(\.name), [t("CPU die"), t("GPU die")])
        XCTAssertEqual(selected.readings.map(\.value), [65, 45])
        XCTAssertEqual(selected.readings.map(\.color), [ThermalStyle.cpu, ThermalStyle.gpu])
    }

    func testThermalHoverDoesNotReuseAnEarlierGPUReading() async throws {
        var missingGPU = point(time: 30)
        missingGPU.gpuDieC = nil
        let chart = TemperatureChart(points: [point(time: 0), missingGPU, point(time: 60)]).chart
        let selected = try XCTUnwrap(chart.nearestPoint(fraction: 0.5, tMin: 0, span: 60))
        XCTAssertEqual(selected.readings[0].value, 65)
        XCTAssertNil(selected.readings[1].value)
    }

    func testChargeHoverUsesTheRecordedSampleTimeAndValue() async throws {
        let chart = BatteryChart(
            points: [point(time: 0), point(time: 30)], currentLevel: BatteryLevel(percent: 50)
        ).chart
        let selected = try XCTUnwrap(chart.nearestPoint(fraction: 0.8, tMin: 0, span: 30))
        XCTAssertEqual(selected.date, Date(timeIntervalSinceReferenceDate: 30))
        XCTAssertEqual(chart.yFormat(selected.value), "50%")
    }

    func testEmptyEnergyChartsDoNotInventHoverReadings() async {
        let charts = [
            BatteryChart(points: [], currentLevel: BatteryLevel(percent: 50)).chart,
            TemperatureChart(points: []).chart,
            FanChart(points: []).chart,
        ]
        for chart in charts {
            XCTAssertNil(chart.nearestPoint(fraction: 0.5, tMin: 0, span: 30))
        }
    }

    func testEnergyCardSparklinesEnableNativeHoverWithUnits() async throws {
        _ = NSApplication.shared
        for (unit, value, expected) in [
            (MetricUnit.percent, 50.0, "50%"), (.watts, 18.25, "18.25 W"), (.celsius, 32, "32°C"),
        ] {
            let appeared = expectation(description: "The card loads its samples")
            let card = MetricCardData(
                label: "Power", value: expected,
                samples: [
                    MetricSample(date: Date(timeIntervalSinceReferenceDate: 0), value: value),
                    MetricSample(date: Date(timeIntervalSinceReferenceDate: 30), value: value),
                ],
                unit: unit)
            let host = NSHostingView(
                rootView: MetricCard(data: card)
                    .frame(width: 220, height: 140)
                    .onAppear { DispatchQueue.main.async { appeared.fulfill() } })
            let window = NSWindow(
                contentRect: CGRect(x: 100, y: 100, width: 300, height: 200),
                styleMask: [.titled], backing: .buffered, defer: false)
            window.isReleasedWhenClosed = false
            window.contentView = host
            window.orderFront(nil)
            defer { window.close() }
            host.layoutSubtreeIfNeeded()
            window.displayIfNeeded()
            await fulfillment(of: [appeared], timeout: 5)
            let surface = try XCTUnwrap(chartSurface(in: host))
            XCTAssertTrue(surface.scrubbable)
            XCTAssertNotNil(surface.onActivate)
            XCTAssertEqual(surface.feed?.model.yFormat(value), expected)
            XCTAssertNil(surface.feed?.model.statisticsInterval)

            let hiddenLayers = surface.layer?.sublayers?.filter(\.isHidden) ?? []
            let location = surface.convert(
                CGPoint(x: surface.bounds.midX, y: surface.bounds.midY), to: nil)
            let move = try XCTUnwrap(
                NSEvent.mouseEvent(
                    with: .mouseMoved, location: location, modifierFlags: [], timestamp: 0,
                    windowNumber: window.windowNumber, context: nil, eventNumber: 0,
                    clickCount: 0, pressure: 0))
            surface.mouseMoved(with: move)
            let overlays = hiddenLayers.filter { !$0.isHidden }
            XCTAssertEqual(overlays.count, 1)
            let overlay = try XCTUnwrap(overlays.first)
            overlay.displayIfNeeded()
            XCTAssertNotNil(overlay.contents)
            surface.mouseExited(with: move)
            XCTAssertTrue(overlay.isHidden)
        }
    }

    private func point(time: Double) -> SystemHistoryPoint {
        SystemHistoryPoint(
            date: Date(timeIntervalSinceReferenceDate: time), pressurePercent: 10,
            appMemory: 0, wired: 0, compressed: 0, cachedFiles: 0, swapUsed: 0,
            batteryCharge: 50, cpuDieC: 65, gpuDieC: 45, fanRPM: 2400)
    }

    private func chartSurface(in view: NSView) -> TrendSurfaceView? {
        if let surface = view as? TrendSurfaceView { return surface }
        for child in view.subviews {
            if let surface = chartSurface(in: child) { return surface }
        }
        return nil
    }
}
