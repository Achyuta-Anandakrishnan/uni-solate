import Foundation

struct FreeWindow: Identifiable {
    var id = UUID()
    let start: Date
    let end: Date
}

struct FreeTimeService {
    static func freeWindows(for blocks: [BusyBlock], days: Int = 7) -> [FreeWindow] {
        let cal = Calendar.current
        let now = Date()
        var windows: [FreeWindow] = []

        for dayOffset in 0..<days {
            guard let day = cal.date(byAdding: .day, value: dayOffset, to: now) else { continue }
            let startAwake = cal.date(bySettingHour: 8, minute: 0, second: 0, of: day)!
            let endAwake = cal.date(bySettingHour: 22, minute: 0, second: 0, of: day)!

            let dayBlocks = blocks
                .filter { $0.endDate > startAwake && $0.startDate < endAwake }
                .sorted { $0.startDate < $1.startDate }

            var cursor = startAwake
            for block in dayBlocks {
                let blockStart = max(block.startDate, startAwake)
                let blockEnd = min(block.endDate, endAwake)
                if blockStart > cursor { windows.append(.init(start: cursor, end: blockStart)) }
                cursor = max(cursor, blockEnd)
            }
            if cursor < endAwake { windows.append(.init(start: cursor, end: endAwake)) }
        }
        return windows
    }
}
