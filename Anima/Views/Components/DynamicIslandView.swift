import SwiftUI

struct DynamicIslandView: View {
    @State private var isExpanded = false
    let title: String
    let time: String

    var body: some View {
        HStack(spacing: 12) {
            // Gradient icon
            Circle()
                .fill(LinearGradient(colors: [.cyan, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: isExpanded ? 38 : 20, height: isExpanded ? 38 : 20)
                .overlay(
                    Image(systemName: "calendar")
                        .font(.system(size: isExpanded ? 18 : 9, weight: .bold))
                        .foregroundStyle(.white)
                )
                .animation(.spring(response: 0.4, dampingFraction: 0.65), value: isExpanded)

            if isExpanded {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Next Event")
                        .font(.system(size: 10))
                        .foregroundStyle(.gray)
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                    Text(time)
                        .font(.system(size: 12))
                        .foregroundStyle(.cyan)
                }
                .transition(.opacity.combined(with: .scale(scale: 0.9)))

                Spacer()

                // Animated waveform bars
                HStack(spacing: 3) {
                    ForEach(0..<4, id: \.self) { i in
                        WaveformBar(delay: Double(i) * 0.12)
                    }
                }
            } else {
                Spacer()
            }
        }
        .padding(.horizontal, isExpanded ? 18 : 10)
        .padding(.vertical, isExpanded ? 14 : 7)
        .frame(width: isExpanded ? 300 : 114, height: isExpanded ? 72 : 34)
        .background(Color.black)
        .clipShape(Capsule())
        .shadow(color: isExpanded ? .cyan.opacity(0.35) : .clear, radius: 18)
        .onTapGesture {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.65)) {
                isExpanded.toggle()
            }
        }
    }
}

// Persistent animated waveform bar
private struct WaveformBar: View {
    let delay: Double
    @State private var height: CGFloat = 8

    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(Color.cyan)
            .frame(width: 3, height: height)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 0.5)
                    .repeatForever(autoreverses: true)
                    .delay(delay)
                ) {
                    height = CGFloat.random(in: 12...22)
                }
            }
    }
}

#Preview {
    ZStack(alignment: .top) {
        AnimatedBackgroundView()
        DynamicIslandView(title: "Design Sync", time: "10:00 AM - 11:30 AM")
            .padding(.top, 8)
    }
}
