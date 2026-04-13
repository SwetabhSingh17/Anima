import SwiftUI

struct InteractiveNotchView: View {
    @State private var isExpanded = false
    let title: String
    let time: String
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "calendar.badge.clock")
                    .foregroundStyle(.cyan)
                    .font(.title2)
                
                if isExpanded {
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.headline)
                            .foregroundStyle(.white)
                        Text(time)
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                    .transition(.opacity.combined(with: .scale))
                }
                
                Spacer()
                
                if isExpanded {
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                            isExpanded.toggle()
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray)
                            .font(.title2)
                    }
                    .buttonStyle(.plain)
                    .transition(.opacity)
                }
            }
            .padding(isExpanded ? 16 : 8)
            .background(
                RoundedRectangle(cornerRadius: isExpanded ? 24 : 40, style: .continuous)
                    .fill(.black)
                    .shadow(color: .cyan.opacity(isExpanded ? 0.3 : 0.0), radius: 20, y: 10)
            )
            .overlay(
                RoundedRectangle(cornerRadius: isExpanded ? 24 : 40, style: .continuous)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            .frame(width: isExpanded ? 300 : 80, height: isExpanded ? 80 : 36)
            .onTapGesture {
                if !isExpanded {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        isExpanded.toggle()
                    }
                }
            }
            
            Spacer()
        }
        .padding(.top, 10) // Position near the top notch area
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        InteractiveNotchView(title: "Upcoming Sync", time: "In 10 mins")
    }
}
