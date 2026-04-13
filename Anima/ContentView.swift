import SwiftUI

// MARK: – Tab enum

enum CalendarTab: String, CaseIterable {
    case today    = "Today"
    case month    = "Month"
    case upcoming = "Upcoming"
    case search   = "Search"

    var icon: String {
        switch self {
        case .today:    return "calendar"
        case .month:    return "square.grid.2x2"
        case .upcoming: return "list.bullet.rectangle"
        case .search:   return "magnifyingglass"
        }
    }
}

// MARK: – Root View

struct ContentView: View {
    #if os(iOS)
    @Environment(\.horizontalSizeClass) var sizeClass
    #endif

    @State private var selectedTab: CalendarTab = .today
    @State private var selectedDay: Int         = 26
    @State private var isFABPressed             = false

    var body: some View {
        ZStack(alignment: .top) {

            // ── Background ──────────────────────────────────────────────
            AnimatedBackgroundView().ignoresSafeArea()

            // ── Content ─────────────────────────────────────────────────
            #if os(iOS)
            if sizeClass == .compact {
                iPhoneLayout
            } else {
                iPadLayout
            }
            #elseif os(macOS)
            macLayout
            #else
            iPhoneLayout
            #endif

        }
        .ignoresSafeArea(edges: .top)
    }

    // ───────────────────────────────────────────────────────────────────
    // MARK: iPhone layout
    // ───────────────────────────────────────────────────────────────────
    private var iPhoneLayout: some View {
        ZStack(alignment: .top) {

            VStack(spacing: 0) {
                // Dead space so the Dynamic Island pill has room
                Color.clear.frame(height: 56)

                // ── STATIC header  (does NOT scroll) ──────────────────
                WeekStripView(selectedDay: $selectedDay)
                    .padding(.top, 4)

                // ── SCROLLABLE body ────────────────────────────────────
                tabContentView
                    .padding(.bottom, 90) // clear tab bar
            }

            // ── Dynamic Island pill (top overlay) ─────────────────────
            HStack {
                Spacer()
                DynamicIslandView(title: "Design Sync", time: "10:00 AM")
                Spacer()
            }
            .padding(.top, 10)

            // ── FAB ───────────────────────────────────────────────────
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        #if os(iOS)
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        #endif
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.55)) { isFABPressed.toggle() }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
                            withAnimation { isFABPressed = false }
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(width: 56, height: 56)
                            .background(
                                Circle()
                                    .fill(Color.cyan)
                                    .shadow(color: Color.cyan.opacity(0.8), radius: 18)
                            )
                            .overlay(Circle().stroke(Color.white.opacity(0.35), lineWidth: 1))
                            .rotationEffect(.degrees(isFABPressed ? 45 : 0))
                            .scaleEffect(isFABPressed ? 0.88 : 1.0)
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 94)
                }
            }

            // ── Tab bar ───────────────────────────────────────────────
            VStack {
                Spacer()
                HStack {
                    ForEach(CalendarTab.allCases, id: \.self) { tab in
                        Spacer()
                        TabItem(tab: tab, isSelected: selectedTab == tab) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedTab = tab
                            }
                        }
                        Spacer()
                    }
                }
                .padding(.top, 14)
                .padding(.bottom, 26)
                .background(
                    .ultraThinMaterial.opacity(0.9)
                )
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(Color.white.opacity(0.07))
                        .frame(height: 0.5)
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }

    // ───────────────────────────────────────────────────────────────────
    // MARK: Tab content switcher
    // ───────────────────────────────────────────────────────────────────
    @ViewBuilder
    private var tabContentView: some View {
        switch selectedTab {
        case .today:
            ScrollView(showsIndicators: false) {
                ScheduleListView(selectedDay: selectedDay)
                    .padding(.top, 8)
            }

        case .month:
            ScrollView(showsIndicators: false) {
                MonthView()
                    .padding()
            }

        case .upcoming:
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Upcoming Events")
                        .font(.headline)
                        .foregroundStyle(.gray)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    ForEach([22, 25, 27], id: \.self) { day in
                        ScheduleListView(selectedDay: day)
                    }
                }
            }

        case .search:
            SearchView()
        }
    }

    // ───────────────────────────────────────────────────────────────────
    // MARK: iPad layout (mirrors Mac 3-panel design)
    // ───────────────────────────────────────────────────────────────────

    // Split into 3 sub-views to avoid Swift type-checker timeout
    private var iPadLayout: some View {
        HStack(spacing: 0) {
            iPadIconRail
            iPadCalendarSidebar
            iPadDetailPanel
        }
    }

    // ── Panel 1: Icon Rail ─────────────────────────────────────────────────
    @ViewBuilder
    private var iPadIconRail: some View {
        VStack(spacing: 0) {
            VStack(spacing: 5) {
                Image(systemName: "calendar.circle.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(.cyan)
                    .shadow(color: .cyan.opacity(0.6), radius: 10)
                Text("Anima")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(.gray)
            }
            .padding(.top, 56)
            .padding(.bottom, 16)

            Divider().background(Color.white.opacity(0.1)).padding(.horizontal, 8)

            VStack(spacing: 4) {
                ForEach(CalendarTab.allCases, id: \.self) { tab in
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { selectedTab = tab }
                    } label: {
                        VStack(spacing: 5) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 22, weight: .medium))
                                .foregroundStyle(selectedTab == tab ? Color.cyan : Color.gray)
                                .shadow(color: selectedTab == tab ? Color.cyan.opacity(0.8) : .clear, radius: 8)
                            Text(tab.rawValue)
                                .font(.system(size: 9))
                                .foregroundStyle(selectedTab == tab ? .white : .gray)
                        }
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background {
                            if selectedTab == tab {
                                RoundedRectangle(cornerRadius: 12).fill(Color.cyan.opacity(0.15))
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 4)
                }
            }
            .padding(.top, 8)

            Spacer()

            Button {
                #if os(iOS)
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                #endif
                withAnimation(.spring(response: 0.3, dampingFraction: 0.55)) { isFABPressed.toggle() }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
                    withAnimation { isFABPressed = false }
                }
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 34))
                    .foregroundStyle(.cyan)
                    .shadow(color: .cyan.opacity(0.7), radius: 12)
                    .rotationEffect(.degrees(isFABPressed ? 45 : 0))
                    .scaleEffect(isFABPressed ? 0.88 : 1.0)
            }
            .buttonStyle(.plain)
            .padding(.bottom, 32)
        }
        .frame(width: 76)
        .background {
            Rectangle().fill(Color.black.opacity(0.55)).background(.ultraThinMaterial).ignoresSafeArea()
        }
        .overlay(alignment: .trailing) {
            Rectangle().fill(Color.white.opacity(0.08)).frame(width: 1).ignoresSafeArea()
        }
    }

    // ── Panel 2: Calendar Sidebar ──────────────────────────────────────────
    @ViewBuilder
    private var iPadCalendarSidebar: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Calendar")
                        .font(.system(size: 22, weight: .black))
                        .foregroundStyle(.white)
                    Text("October 2024")
                        .font(.system(size: 13))
                        .foregroundStyle(.gray)
                }
                Spacer()
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { selectedDay = 26 }
                } label: {
                    Text("Today")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1))
                }
                .buttonStyle(.plain)
                Image(systemName: "gearshape")
                    .font(.system(size: 18))
                    .foregroundStyle(.gray)
                    .padding(.leading, 4)
            }
            .padding(.horizontal, 16)
            .padding(.top, 52)
            .padding(.bottom, 12)

            Divider().background(Color.white.opacity(0.1)).padding(.horizontal, 10)
            WeekStripView(selectedDay: $selectedDay).padding(.top, 10)
            Divider().background(Color.white.opacity(0.08)).padding(.horizontal, 10).padding(.top, 12)

            ScrollView(showsIndicators: false) {
                MonthView().padding(.horizontal, 4).padding(.vertical, 8)
            }
        }
        .frame(width: 320)
        .background {
            Rectangle().fill(Color.black.opacity(0.38)).background(.ultraThinMaterial).ignoresSafeArea()
        }
        .overlay(alignment: .trailing) {
            Rectangle().fill(Color.white.opacity(0.07)).frame(width: 1).ignoresSafeArea()
        }
    }

    // ── Panel 3: Detail Panel ─────────────────────────────────────────────
    @ViewBuilder
    private var iPadDetailPanel: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(selectedTab.rawValue)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(.white)
                    Text("Saturday, October 2024")
                        .font(.system(size: 15))
                        .foregroundStyle(.gray)
                }
                Spacer()
                InteractiveNotchView(title: "Upcoming Sync", time: "In 10 mins")
            }
            .padding(.horizontal, 28)
            .padding(.top, 52)
            .padding(.bottom, 14)

            Divider().background(Color.white.opacity(0.08)).padding(.horizontal, 20)

            tabContentViewiPad.padding(.top, 6)
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var tabContentViewiPad: some View {
        switch selectedTab {
        case .today:
            ScrollView(showsIndicators: false) {
                ScheduleListView(selectedDay: selectedDay)
                    .padding(.horizontal, 12)
                    .padding(.top, 8)
            }
        case .month:
            ScrollView(showsIndicators: false) {
                MonthView().padding()
            }
        case .upcoming:
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 14) {
                    Text("All Upcoming Events")
                        .font(.headline).foregroundStyle(.gray)
                        .padding(.horizontal, 28).padding(.top, 8)
                    ForEach([22, 25, 26, 27], id: \.self) { day in
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Oct \(day)")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.cyan)
                                .padding(.leading, 28)
                            ScheduleListView(selectedDay: day)
                                .padding(.horizontal, 12)
                        }
                    }
                }
            }
        case .search:
            SearchView().padding(.horizontal, 16)
        }
    }

    #if os(macOS)
    private var macLayout: some View {
        HStack(spacing: 0) {

            // ── ICON RAIL (far left, macOS convention) ─────────────────────
            VStack(spacing: 0) {
                // App icon area
                VStack(spacing: 6) {
                    Image(systemName: "calendar.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(.cyan)
                        .shadow(color: .cyan.opacity(0.6), radius: 10)
                    Text("Anima")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.gray)
                }
                .padding(.vertical, 20)
                .padding(.top, 20)

                Divider().background(Color.white.opacity(0.1))

                // Tab rail icons
                VStack(spacing: 6) {
                    ForEach(CalendarTab.allCases, id: \.self) { tab in
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedTab = tab
                            }
                        } label: {
                            VStack(spacing: 5) {
                                Image(systemName: tab.icon)
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundStyle(selectedTab == tab ? Color.cyan : Color.gray)
                                    .shadow(color: selectedTab == tab ? Color.cyan.opacity(0.8) : .clear, radius: 8)
                                Text(tab.rawValue)
                                    .font(.system(size: 9))
                                    .foregroundStyle(selectedTab == tab ? .white : .gray)
                            }
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background {
                                if selectedTab == tab {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.cyan.opacity(0.15))
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 6)
                    }
                }
                .padding(.top, 12)

                Spacer()

                // macOS "New Event" button at bottom of rail
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.55)) { isFABPressed.toggle() }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
                        withAnimation { isFABPressed = false }
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 30))
                        .foregroundStyle(.cyan)
                        .shadow(color: .cyan.opacity(0.7), radius: 10)
                        .rotationEffect(.degrees(isFABPressed ? 45 : 0))
                        .scaleEffect(isFABPressed ? 0.88 : 1.0)
                }
                .buttonStyle(.plain)
                .padding(.bottom, 24)
            }
            .frame(width: 72)
            .background {
                Rectangle()
                    .fill(Color.black.opacity(0.55))
                    .background(.ultraThinMaterial)
                    .ignoresSafeArea()
            }
            .overlay(alignment: .trailing) {
                Rectangle().fill(Color.white.opacity(0.07)).frame(width: 1).ignoresSafeArea()
            }

            // ── CALENDAR SIDEBAR (week strip + optional mini month) ─────────
            VStack(alignment: .leading, spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Calendar")
                            .font(.system(size: 22, weight: .black))
                            .foregroundStyle(.white)
                        Text("October 2024")
                            .font(.system(size: 13))
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { selectedDay = 26 }
                    } label: {
                        Text("Today")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 12)

                Divider().background(Color.white.opacity(0.1)).padding(.horizontal, 10)

                WeekStripView(selectedDay: $selectedDay)
                    .padding(.top, 10)

                Divider().background(Color.white.opacity(0.08)).padding(.horizontal, 10).padding(.top, 14)

                // Mini month grid (macOS only, extra space available)
                ScrollView(showsIndicators: false) {
                    MonthView()
                        .padding(.horizontal, 4)
                        .padding(.vertical, 10)
                }
                .padding(.bottom, 8)
            }
            .frame(width: 320)
            .background {
                Rectangle()
                    .fill(Color.black.opacity(0.38))
                    .background(.ultraThinMaterial)
                    .ignoresSafeArea()
            }
            .overlay(alignment: .trailing) {
                Rectangle().fill(Color.white.opacity(0.07)).frame(width: 1).ignoresSafeArea()
            }

            // ── MAIN DETAIL PANEL ───────────────────────────────────────────
            VStack(spacing: 0) {
                // Detail header
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(selectedTab.rawValue)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.white)
                        Text("Saturday, October 2024")
                            .font(.system(size: 13))
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                    // Interactive Notch overlay positioned at top of this panel
                    InteractiveNotchView(title: "Upcoming Sync", time: "In 10 mins")
                }
                .padding(.horizontal, 28)
                .padding(.top, 20)
                .padding(.bottom, 14)

                Divider().background(Color.white.opacity(0.08)).padding(.horizontal, 20)

                // Tab content
                macTabContent
                    .padding(.top, 6)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private var macTabContent: some View {
        switch selectedTab {
        case .today:
            ScrollView(showsIndicators: false) {
                ScheduleListView(selectedDay: selectedDay)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
            }
        case .month:
            ScrollView(showsIndicators: false) {
                // On mac, the mini month is in the sidebar so show a larger full-month view here
                MonthView().padding(24)
            }
        case .upcoming:
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    Text("All Upcoming Events")
                        .font(.headline).foregroundStyle(.gray)
                        .padding(.horizontal, 28).padding(.top, 8)
                    ForEach([22, 25, 26, 27], id: \.self) { day in
                        VStack(alignment: .leading, spacing: 6) {
                            Text("October \(day)")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.cyan)
                                .padding(.leading, 28)
                            ScheduleListView(selectedDay: day)
                                .padding(.horizontal, 20)
                        }
                    }
                }
            }
        case .search:
            SearchView().padding(.horizontal, 24)
        }
    }
    #endif
}

// MARK: – Tab Item

private struct TabItem: View {
    let tab: CalendarTab
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 21))
                    .foregroundStyle(isSelected ? Color.cyan : Color.gray)
                    .shadow(color: isSelected ? Color.cyan.opacity(0.8) : .clear, radius: 8)
                Text(tab.rawValue)
                    .font(.system(size: 10))
                    .foregroundStyle(isSelected ? .white : .gray)
            }
            .frame(minWidth: 44)
        }
        .buttonStyle(.plain)
    }
}

// MARK: – Search placeholder

private struct SearchView: View {
    @State private var query = ""
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Image(systemName: "magnifyingglass").foregroundStyle(.gray)
                TextField("Search events…", text: $query)
                    .foregroundStyle(.white)
            }
            .padding()
            .ios26Glass(cornerRadius: 16, borderColor: .white.opacity(0.2), borderWidth: 1, glowRadius: 0)
            .padding(.horizontal, 16)
            .padding(.top, 8)
            Spacer()
            Text("Start typing to search your events")
                .foregroundStyle(.gray)
            Spacer()
        }
    }
}

#Preview { ContentView() }
