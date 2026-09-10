import AppKit
import MacPerfMonitorCore
import SwiftUI
import XCTest

@testable import MacPerfMonitor

@MainActor
final class MetricCardPresentationTests: XCTestCase {
    func testFirstCardClickPresentsTheCapturedChartInAFullSizeSheet() async throws {
        _ = NSApplication.shared
        let feed = MetricCardFeed()
        let end = Date(timeIntervalSinceReferenceDate: 120)
        feed.publish(
            value: "25%", tint: .systemGreen,
            column: LiveColumn(times: [0, 30, 60, 90, 120], values: [10, 30, 20, 40, 25]),
            xDomain: end.addingTimeInterval(-120)...end, yDomain: 0...100,
            statisticsInterval: 5, gapThreshold: 45, name: "Pressure")
        let card = MetricCardData(
            label: "Pressure", value: "25%", unit: .percent,
            explanation: MetricExplanation(
                meaning: "Memory pressure describes demand on the memory system.",
                calculation: "The index uses the recorded pressure samples."), live: feed)
        let host = NSHostingView(rootView: MetricCard(data: card).frame(width: 220, height: 140))
        let window = NSWindow(
            contentRect: CGRect(x: 100, y: 100, width: 900, height: 850),
            styleMask: [.titled, .closable], backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.contentView = host
        window.orderFront(nil)
        defer {
            if let sheet = window.attachedSheet { window.endSheet(sheet) }
            window.close()
        }
        host.layoutSubtreeIfNeeded()
        window.displayIfNeeded()
        let surface = try XCTUnwrap(descendants(of: host, type: TrendSurfaceView.self).first)
        XCTAssertNotNil(surface.onActivate)

        let sheet = try await presentCard(surface, in: window)
        let content = try XCTUnwrap(sheet.contentView)
        content.layoutSubtreeIfNeeded()
        sheet.displayIfNeeded()
        XCTAssertGreaterThanOrEqual(content.bounds.width, 700)
        XCTAssertGreaterThanOrEqual(content.bounds.height, 450)
        let chart = try XCTUnwrap(descendants(of: content, type: TrendSurfaceView.self).first)
        let model = try XCTUnwrap(chart.feed?.model)
        XCTAssertFalse(model.bare)
        XCTAssertTrue(model.showsTimeAxis)
        XCTAssertEqual(model.series.first?.column.values.map { $0 }, [10, 30, 20, 40, 25])

        let newEnd = Date(timeIntervalSinceReferenceDate: 150)
        feed.publish(
            value: "65%", tint: .systemGreen,
            column: LiveColumn(times: [30, 60, 90, 120, 150], values: [30, 20, 40, 25, 65]),
            xDomain: newEnd.addingTimeInterval(-120)...newEnd, yDomain: 0...100,
            statisticsInterval: 5, gapThreshold: 45, name: "Pressure")
        XCTAssertEqual(
            chart.feed?.model.series.first?.column.values.map { $0 }, [10, 30, 20, 40, 25])

        let done = try XCTUnwrap(
            NSEvent.keyEvent(
                with: .keyDown, location: .zero, modifierFlags: [], timestamp: 0,
                windowNumber: sheet.windowNumber, context: nil, characters: "\r",
                charactersIgnoringModifiers: "\r", isARepeat: false, keyCode: 36))
        let dismissed = expectation(description: "Done dismisses the detail sheet")
        let dismissalObserver = NotificationCenter.default.addObserver(
            forName: NSWindow.didEndSheetNotification, object: window, queue: .main
        ) { _ in
            DispatchQueue.main.async { dismissed.fulfill() }
        }
        defer { NotificationCenter.default.removeObserver(dismissalObserver) }
        sheet.makeKey()
        if !sheet.performKeyEquivalent(with: done) { sheet.sendEvent(done) }
        await fulfillment(of: [dismissed], timeout: 5)
        XCTAssertNil(window.attachedSheet)

        let reopened = try await presentCard(surface, in: window)
        let reopenedContent = try XCTUnwrap(reopened.contentView)
        reopenedContent.layoutSubtreeIfNeeded()
        let reopenedChart = try XCTUnwrap(
            descendants(of: reopenedContent, type: TrendSurfaceView.self).first)
        XCTAssertGreaterThanOrEqual(reopenedContent.bounds.width, 700)
        XCTAssertEqual(
            reopenedChart.feed?.model.series.first?.column.values.map { $0 }, [30, 20, 40, 25, 65])
        XCTAssertEqual(reopenedChart.feed?.model.xDomain?.upperBound, newEnd)
    }

    private func presentCard(
        _ surface: TrendSurfaceView, in window: NSWindow
    ) async throws -> NSWindow {
        let presented = expectation(description: "The card presents its detail sheet")
        let observer = NotificationCenter.default.addObserver(
            forName: NSWindow.willBeginSheetNotification, object: window, queue: .main
        ) { _ in
            DispatchQueue.main.async { presented.fulfill() }
        }
        defer { NotificationCenter.default.removeObserver(observer) }
        let event = try XCTUnwrap(
            NSEvent.mouseEvent(
                with: .leftMouseDown, location: .zero, modifierFlags: [], timestamp: 0,
                windowNumber: window.windowNumber, context: nil, eventNumber: 0,
                clickCount: 1, pressure: 1))
        surface.mouseDown(with: event)
        await fulfillment(of: [presented], timeout: 5)
        return try XCTUnwrap(window.attachedSheet)
    }

    private func descendants<ViewType: NSView>(of view: NSView, type: ViewType.Type) -> [ViewType] {
        var found = (view as? ViewType).map { [$0] } ?? []
        for child in view.subviews { found.append(contentsOf: descendants(of: child, type: type)) }
        return found
    }

}
