import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false

    var body: some View {
        VStack {
            
            VStack {
                Text("Advanced ToDo Application")
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.top, 60)
            }
            .frame(maxWidth: .infinity, alignment: .center)

            Spacer()

            // Team Members
            VStack(alignment: .center, spacing: 8) {
                Text("Fahad Al-Hadeethi, 101432174")
                Text("Alexis Gorospe, 10140518")
                Text("Lara Alkhatabi, 101461068")
            }
            .font(.body)
            .foregroundColor(.gray)
            .padding(.horizontal)

            Spacer()

            
            Button(action: {
                isActive = true
            }) {
                Text("Tap to Continue")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.3))
                    .foregroundColor(.black)
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
            }
            .padding(.bottom, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .fullScreenCover(isPresented: $isActive) {
            TaskCategoriesView()
        }
    }
}
