import SwiftUI

// MARK: - Data Model

struct AvatarPersonalization: Codable, Equatable {

    // Asset name for the cape layer (e.g. "capa_azul"). nil = no cape.
    var capeAsset: String? = nil

    // Asset name for the accessory layer (e.g. "kiddo_rana"). nil = no accessory.
    var accesorioAsset: String? = nil

    // MARK: - Cape options
    enum CapeType: String, CaseIterable, Identifiable {
        case none     = "none"
        case azul     = "capa_azul"
        case morada   = "capa_morada"
        case roja     = "capa_roja"
        case verde    = "capa_verde"

        var id: String { rawValue }

        /// Display label shown under the thumbnail
        var label: String {
            switch self {
            case .none:   return "Sin capa"
            case .azul:   return "Azul"
            case .morada: return "Morada"
            case .roja:   return "Roja"
            case .verde:  return "Verde"
            }
        }

        /// The PNG asset name to load (nil for "none")
        var assetName: String? {
            self == .none ? nil : rawValue
        }
    }

    // MARK: - Accessory options
    enum AccesorioType: String, CaseIterable, Identifiable {
        case none    = "none"
        case rana    = "kiddo_rana"
        case conejo  = "kiddo_conejo"

        var id: String { rawValue }

        var label: String {
            switch self {
            case .none:   return "Ninguno"
            case .rana:   return "Rana"
            case .conejo: return "Conejo"
            }
        }

        var assetName: String? {
            self == .none ? nil : rawValue
        }
    }

    // MARK: - Convenience computed helpers
    var selectedCape: CapeType {
        get { CapeType(rawValue: capeAsset ?? "none") ?? .none }
        set { capeAsset = newValue.assetName }
    }

    var selectedAccesorio: AccesorioType {
        get { AccesorioType(rawValue: accesorioAsset ?? "none") ?? .none }
        set { accesorioAsset = newValue.assetName }
    }
}


// MARK: - Avatar Customizer View

struct AvatarCustomizerView: View {

    @Binding var config: AvatarPersonalization
    var onClose: () -> Void

    @State private var floatingOffset: CGFloat = 0

    var body: some View {
        ZStack {
            // Dimmed background — tap outside to dismiss
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { onClose() }

            VStack(spacing: 0) {
                headerView

                ScrollView {
                    VStack(spacing: 24) {
                        previewSection

                        VStack(spacing: 20) {
                            selectionSection(
                                title: "Capa",
                                icon: "theatermasks",
                                items: AvatarPersonalization.CapeType.allCases,
                                keyPath: \.selectedCape
                            )

                            selectionSection(
                                title: "Accesorio",
                                icon: "hare",
                                items: AvatarPersonalization.AccesorioType.allCases,
                                keyPath: \.selectedAccesorio
                            )
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
                .background(Color.white)

                footerView
            }
            .frame(maxWidth: 500)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .shadow(radius: 20)
            .padding()
        }
    }

    // MARK: - Header

    private var headerView: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "wand.and.stars")
                        .font(.title)
                    Text("Crea tu Superhéroe")
                        .font(.title2.bold())
                }
                Text("¡Hazlo único y especial!")
                    .font(.subheadline)
                    .opacity(0.9)
            }
            Spacer()
            Button(action: onClose) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
        .padding(25)
        .background(
            LinearGradient(
                colors: [Color(hex: "#7BC67E"), Color(hex: "#87CEEB"), Color(hex: "#B4A7D6")],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .foregroundColor(.white)
    }

    // MARK: - Live Preview

    private var previewSection: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#E8F5E9"), Color(hex: "#FFF9E6")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 250)

                ZStack {
                    // Layer 1 – Cape (behind the body)
                    if let capeName = config.capeAsset {
                        Image(capeName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140)
                            .offset(y: 20) // push cape slightly below body center
                            .zIndex(0)
                    }

                    // Layer 2 – Base character body
                    Image("kiddo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120)
                        .zIndex(1)

                    // Layer 3 – Accessory (on top of body)
                    if let accName = config.accesorioAsset {
                        Image(accName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120)
                            .zIndex(2)
                    }
                }
                .offset(y: floatingOffset)
                .onAppear {
                    withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                        floatingOffset = -12
                    }
                }
            }
            .padding(.horizontal)

            Text("¡Tu Superhéroe!")
                .font(.headline)
            Text("Personaliza cada detalle 🎨")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    // MARK: - Generic selection grid

    /// Works for any enum that is `CaseIterable + Identifiable` and has `label` & `assetName`.
    private func selectionSection<T>(
        title: String,
        icon: String,
        items: [T],
        keyPath: WritableKeyPath<AvatarPersonalization, T>
    ) -> some View where T: Identifiable & Hashable & SelectableItem {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon)
                .font(.headline)

            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())],
                spacing: 12
            ) {
                ForEach(items) { item in
                    let isSelected = config[keyPath: keyPath] == item

                    Button {
                        config[keyPath: keyPath] = item
                    } label: {
                        VStack(spacing: 8) {
                            // Thumbnail: real asset or placeholder
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(isSelected ? Color.blue.opacity(0.12) : Color.gray.opacity(0.07))
                                    .frame(height: 80)

                                if let asset = item.assetName {
                                    Image(asset)
                                        .resizable()
                                        .scaledToFit()
                                        .padding(10)
                                } else {
                                    // "None" option
                                    Image(systemName: "xmark.circle")
                                        .font(.largeTitle)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                            )

                            Text(item.label)
                                .font(.caption)
                                .fontWeight(isSelected ? .bold : .regular)
                                .foregroundColor(isSelected ? .blue : .primary)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Footer

    private var footerView: some View {
        Button(action: onClose) {
            HStack {
                Image(systemName: "sparkles")
                Text("¡Guardar mi Superhéroe!")
                    .fontWeight(.bold)
                Image(systemName: "sparkles")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: [Color(hex: "#7BC67E"), Color(hex: "#87CEEB"), Color(hex: "#B4A7D6")],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .clipShape(Capsule())
            .shadow(radius: 5)
        }
        .padding(20)
        .background(Color.white)
    }
}


// MARK: - SelectableItem protocol
// Lets the generic grid work with both enum types.

protocol SelectableItem {
    var label: String { get }
    var assetName: String? { get }
}

extension AvatarPersonalization.CapeType: SelectableItem {}
extension AvatarPersonalization.AccesorioType: SelectableItem {}


// MARK: - Preview

struct AvatarCustomizerView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarCustomizerView(
            config: .constant(AvatarPersonalization()),
            onClose: {}
        )
    }
}
