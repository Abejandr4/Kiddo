import SwiftUI

struct AvatarView: View {
    let avatar: Avatar
    
    var body: some View {
        ZStack {
            // 1. Capa (al fondo)
            if let capa = avatar.capa {
                Image(capa)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            // 2. Cuerpo (en medio)
            Image(avatar.cuerpo)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            // 3. Accesorio (al frente)
            if let accesorio = avatar.accesorio {
                Image(accesorio)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .frame(width: 250, height: 250) // Tamaño ajustable
    }
}
