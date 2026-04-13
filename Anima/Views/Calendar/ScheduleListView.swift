import SwiftUI

// MARK: – Model

struct CalEvent: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let time: String
    let color: Color
    let icon: String
    let avatarCount: Int
    let day: Int // day number in mock dataset
}

// MARK: – List

struct ScheduleListView: View {
    let selectedDay: Int

    private let allEvents = [
        CalEvent(title: "Product Strategy Sync", subtitle: "Boardroom",    time: "10:00 AM - 11:30 AM", color: Color.cyan,                            icon: "person.2.fill",    avatarCount: 3, day: 26),
        CalEvent(title: "Lunch with Anya",        subtitle: "Nomad Cafe",   time: "12:00 PM - 1:00 PM",  color: Color.orange,                          icon: "fork.knife",       avatarCount: 1, day: 26),
        CalEvent(title: "Design Review",          subtitle: "Figma Studio", time: "3:00 PM - 4:00 PM",   color: Color(red: 0.7, green: 0.1, blue: 1.0), icon: "paintbrush.fill",  avatarCount: 2, day: 26),
        CalEvent(title: "Team Dinner",            subtitle: "City Lights",  time: "6:30 PM - 8:30 PM",   color: Color.gray,                            icon: "bell.fill",        avatarCount: 0, day: 26),
        CalEvent(title: "Morning Standup",        subtitle: "Zoom",         time: "9:00 AM - 9:30 AM",   color: Color.green,                           icon: "video.fill",       avatarCount: 4, day: 22),
        CalEvent(title: "Client Presentation",   subtitle: "HQ",           time: "2:00 PM - 3:30 PM",   color: Color.yellow,                          icon: "person.3.fill",    avatarCount: 2, day: 22),
        CalEvent(title: "Gym Session",            subtitle: "FitLife",      time: "7:00 AM - 8:00 AM",   color: Color.pink,                            icon: "figure.run",       avatarCount: 0, day: 25),
        CalEvent(title: "Weekend Brunch",         subtitle: "The Patio",    time: "11:00 AM - 1:00 PM",  color: Color.mint,                            icon: "cup.and.saucer.fill", avatarCount: 3, day: 27),
    ]

    var events: [CalEvent] {
        allEvents.filter { $0.day == selectedDay }
    }

    var body: some View {
        if events.isEmpty {
            VStack(spacing: 16) {
                Image(systemName: "calendar.badge.checkmark")
                    .font(.system(size: 48))
                    .foregroundStyle(.gray)
                Text("No events on day \(selectedDay)")
                    .font(.headline)
                    .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 60)
        } else {
            VStack(spacing: 14) {
                ForEach(events) { event in
                    EventCard(event: event)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 6)
        }
    }
}

// MARK: – Card

struct EventCard: View {
    let event: CalEvent
    @State private var pressed = false

    var body: some View {
        HStack(spacing: 14) {
            // Icon circle
            Circle()
                .fill(event.color.opacity(0.18))
                .frame(width: 46, height: 46)
                .overlay(
                    Image(systemName: event.icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(event.color)
                )

            // Text
            VStack(alignment: .leading, spacing: 3) {
                Text(event.time)
                    .font(.system(size: 12))
                    .foregroundStyle(.gray)
                Text(event.title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.white)
                HStack(spacing: 4) {
                    Image(systemName: "arrow.down.to.line")
                        .font(.system(size: 10))
                    Text(event.subtitle)
                        .font(.system(size: 13))
                }
                .foregroundStyle(Color.gray)
            }

            Spacer()

            // Avatar stack
            if event.avatarCount > 0 {
                HStack(spacing: -8) {
                    ForEach(0..<min(event.avatarCount, 3), id: \.self) { _ in
                        Circle()
                            .fill(Color(white: 0.4))
                            .frame(width: 26, height: 26)
                            .overlay(Circle().stroke(Color.black, lineWidth: 1.5))
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        // iOS 26 glass with neon border
        .ios26Glass(
            cornerRadius: 22,
            borderColor: event.color,
            borderWidth: 1.5,
            glowRadius: 14,
            tintColor: event.color
        )
        .scaleEffect(pressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: pressed)
        .onTapGesture {
            withAnimation { pressed = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                withAnimation { pressed = false }
            }
        }
    }
}

#Preview {
    ZStack {
        AnimatedBackgroundView()
        ScrollView { ScheduleListView(selectedDay: 26).padding(.top) }
    }
}
