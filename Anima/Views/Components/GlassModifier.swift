import SwiftUI

// MARK: – iOS 26 Style Glass modifier
struct GlassModifier: ViewModifier {
    var cornerRadius: CGFloat
    var borderColor: Color
    var borderWidth: CGFloat
    var glowRadius: CGFloat
    var tintColor: Color
    
    func body(content: Content) -> some View {
        content
            // Deep translucent base — background bleeds through
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(tintColor.opacity(0.08))
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(Color.black.opacity(0.45))
                }
            }
            // Colored neon glow around the card
            .shadow(color: borderColor.opacity(0.55), radius: glowRadius, x: 0, y: 0)
            // Crisp neon stroke
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(borderColor, lineWidth: borderWidth)
                    .blendMode(.screen) // makes border feel emissive / luminous
            }
    }
}

extension View {
    func ios26Glass(cornerRadius: CGFloat = 22,
                    borderColor: Color = Color.white.opacity(0.2),
                    borderWidth: CGFloat = 1.4,
                    glowRadius: CGFloat = 12,
                    tintColor: Color = .clear) -> some View {
        modifier(GlassModifier(cornerRadius: cornerRadius,
                               borderColor: borderColor,
                               borderWidth: borderWidth,
                               glowRadius: glowRadius,
                               tintColor: tintColor))
    }
    
    // Legacy compat
    func glassmorphism(cornerRadius: CGFloat = 20, opacity: Double = 0.2) -> some View {
        ios26Glass(cornerRadius: cornerRadius)
    }
    func neonGlassmorphism(cornerRadius: CGFloat = 20,
                           strokeColor: Color = .white,
                           strokeWidth: CGFloat = 1.5,
                           glowRadius: CGFloat = 10) -> some View {
        ios26Glass(cornerRadius: cornerRadius,
                   borderColor: strokeColor,
                   borderWidth: strokeWidth,
                   glowRadius: glowRadius,
                   tintColor: strokeColor)
    }
}
