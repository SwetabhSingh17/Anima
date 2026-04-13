import SwiftUI

struct AnimatedBackgroundView: View {
    @State private var phase = false

    var body: some View {
        ZStack {
            // Absolute dark base
            Color(red: 0.04, green: 0.04, blue: 0.07).ignoresSafeArea()

            // Left orb – electric cyan
            Ellipse()
                .fill(Color(red: 0.0, green: 0.7, blue: 1.0))
                .frame(width: 320, height: 320)
                .blur(radius: 100)
                .offset(x: phase ? -120 : -80, y: phase ? -160 : -80)
                .opacity(0.65)

            // Right orb – magenta / pink
            Ellipse()
                .fill(Color(red: 0.85, green: 0.0, blue: 0.75))
                .frame(width: 300, height: 300)
                .blur(radius: 110)
                .offset(x: phase ? 130 : 90, y: phase ? 220 : 100)
                .opacity(0.60)

            // Bottom blue
            Ellipse()
                .fill(Color(red: 0.1, green: 0.1, blue: 0.85))
                .frame(width: 260, height: 260)
                .blur(radius: 130)
                .offset(x: phase ? 40 : -40, y: phase ? 300 : 200)
                .opacity(0.45)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 9).repeatForever(autoreverses: true)) {
                phase = true
            }
        }
    }
}

#Preview { AnimatedBackgroundView() }
