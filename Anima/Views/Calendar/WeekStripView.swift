import SwiftUI

struct WeekStripView: View {
    @Binding var selectedDay: Int

    private let labels  = ["Oct", "Mon", "Tue", "Wed", "Thu", "Fri", "Sun"]
    private let numbers = [21, 22, 23, 24, 25, 26, 27]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // ── Header ────────────────────────────────────────────────────
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("CALENDAR")
                        .font(.system(size: 26, weight: .black))
                        .foregroundStyle(.white)
                    Text("San Francisco Pro")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.gray)
                    Text("OCTOBER 2024")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.top, 8)
                }

                Spacer()

                HStack(spacing: 12) {
                    Text("Today")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(Color.white.opacity(0.12))
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1))

                    Image(systemName: "gearshape")
                        .font(.system(size: 18))
                        .foregroundStyle(.gray)
                }
            }

            // ── Week strip ───────────────────────────────────────────────
            HStack(spacing: 0) {
                ForEach(0..<7) { i in
                    let isSelected = numbers[i] == selectedDay
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedDay = numbers[i]
                        }
                    } label: {
                        VStack(spacing: 6) {
                            Text(labels[i])
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(isSelected ? Color.cyan : Color.gray)

                            ZStack {
                                if isSelected {
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color.cyan)
                                        .frame(width: 40, height: 42)
                                        .shadow(color: Color.cyan.opacity(0.8), radius: 12)
                                }
                                Text("\(numbers[i])")
                                    .font(.system(size: 17, weight: isSelected ? .bold : .regular))
                                    .foregroundStyle(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 18)
        .background {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white.opacity(0.06))
                .background(Color.black.opacity(0.35))
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    ZStack {
        AnimatedBackgroundView()
        WeekStripView(selectedDay: .constant(26))
    }
}
