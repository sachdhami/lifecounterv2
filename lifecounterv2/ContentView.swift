//
//  ContentView.swift
//  lifecounterv2
//
//  Created by Sachin Dhami
import SwiftUI

struct ContentView: View {
    @State private var players: [Player] = [
        Player(name: "Player 1", lifeTotal: 20),
        Player(name: "Player 2", lifeTotal: 20),
        Player(name: "Player 3", lifeTotal: 20),
        Player(name: "Player 4", lifeTotal: 20)
    ]
    @State private var gameStarted = false
    @State private var showHistory = false
    @State private var history: [String] = []
    @State private var lifeChange: String = ""
    @State private var playerLifeChanged = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(players.indices, id: \.self) { index in
                            PlayerView(player: $players[index], history: $history, gameStarted: $gameStarted, playerLifeChanged: $playerLifeChanged)
                        }
                    }
                    .padding(.horizontal)
                }
                
                HStack {
                    Button(action: {
                        addPlayer()
                    }) {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Player")
                    }
                    .disabled(players.count >= 8 || gameStarted || playerLifeChanged)
                    
                    Spacer()
                    
                    Button(action: {
                        removePlayer()
                    }) {
                        Image(systemName: "minus.circle.fill")
                        Text("Remove Player")
                    }
                    .disabled(players.count <= 2 || gameStarted || playerLifeChanged)
                    
                    Spacer()
                    
                    Button(action: {
                        resetGame()
                    }) {
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                        Text("Reset")
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                HStack {
                    Button(action: {
                        showHistory.toggle()
                    }) {
                        Image(systemName: "list.bullet")
                        Text("History")
                    }
                    .sheet(isPresented: $showHistory, content: {
                        HistoryView(history: $history)
                    })
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                TextField("Life Change", text: $lifeChange)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding()
            }
            .navigationBarTitle("Life Counter")
        }
    }
    
    private func addPlayer() {
        if players.count < 8 {
            players.append(Player(name: "Player \(players.count + 1)", lifeTotal: 20))
        }
    }
    
    private func removePlayer() {
        if players.count > 2 {
            players.removeLast()
        }
    }
    
    private func resetGame() {
        for index in players.indices {
            players[index].lifeTotal = 20
        }
        gameStarted = false
        playerLifeChanged = false
        history = []
    }
}

struct PlayerView: View {
    @Binding var player: Player
    @Binding var history: [String]
    @Binding var gameStarted: Bool
    @Binding var playerLifeChanged: Bool
    @State private var lifeChange: String = ""
    
    var body: some View {
        VStack(spacing: 10) {
            Text(player.name)
                .font(.title3)
            Text("Life Total: \(player.lifeTotal)")
                .font(.headline)
                .foregroundColor(player.lifeTotal <= 0 ? .red : .primary)
            HStack(spacing: 20) {
                Button(action: {
                    modifyLife(by: 1)
                }) {
                    Text("+")
                }
                Button(action: {
                    modifyLife(by: -1)
                }) {
                    Text("-")
                }
                HStack(spacing: 5) {
                    TextField("", text: $lifeChange)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .frame(width: 50)
                    Button(action: {
                        if let change = Int(lifeChange) {
                            modifyLife(by: change)
                            lifeChange = ""
                        }
                    }) {
                        Text("Apply")
                    }
                }
            }
        }
        .padding(8)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
    
    private func modifyLife(by value: Int) {
        player.lifeTotal += value
        if player.lifeTotal <= 0 {
            player.lifeTotal = 0
            gameStarted = true
            history.append("\(player.name) lost the game.")
        }
        let action = value > 0 ? "gained" : "lost"
        history.append("\(player.name) \(action) \(abs(value)) life.")
        playerLifeChanged = true
    }
}

struct Player {
    var name: String
    var lifeTotal: Int
}

struct HistoryView: View {
    @Binding var history: [String]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(history, id: \.self) { event in
                    Text(event)
                }
            }
            .navigationBarTitle("History")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}







