import SwiftUI

struct NavigationRow<Destination: View>: View {
    let icon: String
    let title: String
    let subtitle: String
    let gradient: Gradient
    let destination: Destination
    
    @State private var showModal = false
    
    var body: some View {
        Button(action: {
            showModal = true
        }) {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(Color(hex: "2D3748"))
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(Color(hex: "718096"))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(hex: "CBD5E0"))
            }
            .padding(.all, 18)
            .background(Color.white)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showModal) {
            destination
        }
    }
}
