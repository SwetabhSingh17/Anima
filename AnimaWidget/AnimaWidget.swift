import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), eventTitle: "Design Sync", eventTime: "10:00 AM")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), eventTitle: "Design Sync", eventTime: "10:00 AM")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, eventTitle: "Meeting \(hourOffset)", eventTime: "\(10 + hourOffset):00 AM")
            entries.append(entry)
        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let eventTitle: String
    let eventTime: String
}

struct AnimaWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            // Static dark gradient for widget (animations are limited in widgets)
            LinearGradient(colors: [Color(red: 0.05, green: 0.05, blue: 0.08), Color(red: 0.1, green: 0.0, blue: 0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("TUE 26 OCT")
                        .font(.headline)
                        .fontWeight(.black)
                        .foregroundStyle(.white)
                    Spacer()
                    Image(systemName: "calendar")
                        .foregroundStyle(.cyan)
                }
                
                Spacer()
                
                // Glass Event Card
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.eventTitle)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Text(entry.eventTime)
                        .font(.caption)
                        .foregroundStyle(.cyan)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                // Simulated glassmorphism for widget
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.2), lineWidth: 1))
            }
            .padding()
        }
        // Modern iOS 17 container background
        .containerBackground(for: .widget) {
            Color.clear
        }
    }
}

struct AnimaWidget: Widget {
    let kind: String = "AnimaWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AnimaWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Anima Calendar Widget")
        .description("A beautifully native futuristic calendar widget.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
