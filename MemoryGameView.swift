import SwiftUI

struct MemoryGameView: View {
    @ObservedObject var viewModel: MemoryGameViewModel // live connection to the ViewModel, whenever ViewModel changes it published data, the enitre View will automatically refresh to reflect those changes (DATA BINDING)
    @State private var showGameBoard = false // local, transient UI state
    
    // local state variables to manage pulsing "Start Game" button
    @State private var animationAmount = 1.0
    @State private var o = 1.0
    
    @State private var timeRemaining = 100 // timer
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var gridItems = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        // Stack views on top of each other
        ZStack {
            // start button is behind game board itself
            Button("Start Game") {
                // when tapped, show game board and fade itself out
                showGameBoard = true
                o = 0.0 // opacity to 0 (completely transparent)
            }
            .padding(50)
            .background(Color(hue: 0.85, saturation: 0.40, brightness: 0.95, opacity: o))
            .foregroundStyle(.white)
            .clipShape(.circle)
            .scaleEffect(animationAmount)
            .animation(
                .easeInOut(duration: 2)
                .repeatForever(autoreverses: true),
                    value: animationAmount)
            .onAppear {
                animationAmount += 0.5
            }
            if showGameBoard {
                VStack {
                    // header
                    HStack {
                        Text("Time Remaining: \n\(timeRemaining) seconds")
                        ProgressView("\(Int(viewModel.getMatchProgress())) / 6 Matches", value: viewModel.getMatchProgress(), total: 6)
                        Spacer()
                    }
                    // Dispays title
                    Text("Flower Memory \n Game").font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hue: 0.85, saturation: 0.40, brightness: 0.95))
                        .multilineTextAlignment(.center)
                    // card grid
                    LazyVGrid(columns: gridItems, spacing: 5) {
                        ForEach(viewModel.cards) { card in
                            FlowerCard(card: card)
                                .aspectRatio(1, contentMode: .fit)
                                .onTapGesture {
                                    withAnimation {
                                        viewModel.choose(card)
                                    }
                                }
                        }
                    }
                    .padding(5)
                    .onReceive(timer) {
                        time in
                        if self.timeRemaining > 0 && viewModel.getMatchProgress() < 6 {
                            self.timeRemaining -= 1
                        }
                    }
                    Button("🔁") {
                        withAnimation {
                            viewModel.restart()
                            self.timeRemaining = 100
                        }
                    }
                }
            }
        }
    }
}

struct FlowerCard: View {
    var card: MemoryGameModel.Card
    var body: some View {
        ZStack {
            let shape = Rectangle()
                .foregroundColor(Color(hue: 0.85, saturation: 0.40, brightness: 0.95))
                .frame(width: 125, height: 125)
                .cornerRadius(8)
            if card.isFaceUp {
                Image(card.content)
                    .resizable()
                    .frame(width: 125.0, height: 125.0)
                    .cornerRadius(8)
            } else {
                shape.foregroundColor(Color(hue: 0.85, saturation: 0.40, brightness: 0.95))
            }
        }.animation(.linear(duration: 1))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryGameView(viewModel: MemoryGameViewModel())
    }
}
