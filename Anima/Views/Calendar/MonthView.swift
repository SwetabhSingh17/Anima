import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct MonthView: View {
    let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    // Dummy calendar data
    let currentMonthDays = 1...31
    let selectedDay = 24
    
    // Grid layout
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                Text("October 2024")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Spacer()
                
                HStack(spacing: 12) {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.gray)
                    Text("Today")
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .foregroundStyle(.white)
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.gray)
                }
            }
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                }
                
                // Offset for 1st day (assuming Tuesday for this mock)
                ForEach(0..<2, id: \.self) { _ in
                    Text("")
                }
                
                ForEach(currentMonthDays, id: \.self) { day in
                    ZStack {
                        if day == selectedDay {
                            Circle()
                                .fill(
                                    LinearGradient(colors: [.cyan.opacity(0.6), .blue.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .frame(width: 40, height: 10)
                                .shadow(color: .cyan.opacity(0.5), radius: 10)
                        }
                        
                        Text("\(day)")
                            .font(.system(size: 16, weight: day == selectedDay ? .bold : .regular))
                            .foregroundStyle(day == selectedDay ? .white : .white.opacity(0.8))
                    }
                    .frame(height: 40)
                    .onTapGesture {
                        // Handle date selection here with haptics
                        #if os(iOS)
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                        #endif
                    }
                }
            }
        }
        .padding()
        .glassmorphism(cornerRadius: 24, opacity: 0.1)
    }
}

#Preview {
    ZStack {
        AnimatedBackgroundView()
        MonthView()
            .padding()
    }
}
