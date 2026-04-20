import SwiftUI

struct AvatarView: View {
    let avatar: Avatar
    
    var body: some View {
        ZStack {
            // Capa
            if let capa = avatar.capa {
                Image(capa)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            // Cuerpo
            Image(avatar.cuerpo)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            // Accesorio
            if let accesorio = avatar.accesorio {
                Image(accesorio)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .frame(width: 250, height: 250) // Tamaño ajustable
    }
}
