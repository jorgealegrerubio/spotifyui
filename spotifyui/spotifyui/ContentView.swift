//
//  ContentView.swift
//  spotifyui
//
//  Created by Jorge on 11/4/23.
//

import SwiftUI
import AVFoundation

struct ContentView: View {

    @State private var player: AVAudioPlayer?
    @State private var isPlaying = false
    @State private var currentTime: TimeInterval = 0.0
    @State private var isSliderEditing = false
    @State private var newProgress: CGFloat = 0.0
    @State private var progress: CGFloat = 0.0 {
        didSet {
            if !isEditingSlider {
                // Solo actualizar el tiempo actual de la canción si el usuario no está editando el slider
                currentTime = duration * Double(progress)
            }
        }
    }
    @State private var isEditingSlider = false
    private let duration: TimeInterval = 180.0

    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            // Fondo
            LinearGradient(gradient: Gradient(colors: [.green, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                // Imagen de la canción
                Image("album_cover")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
                    .padding(.bottom, 50)

                // Información de la canción
                Text("Título de la canción")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)

                Text("Artista")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.bottom, 50)

                // Barra de progreso y tiempo actual

                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.5))
                        .frame(height: 8)
                    Capsule()
                        .fill(Color.white)
                        .frame(width: progress * (UIScreen.main.bounds.width - 32), height: 8)
                    Slider(value: $newProgress, in: 0...1, step: 0.01, onEditingChanged: { editing in
                        isEditingSlider = editing // Actualizar la variable isEditingSlider
                        if !editing {
                            // Si el usuario deja de editar el Slider, actualizar el tiempo actual de la canción y la variable progress
                            currentTime = newProgress * duration
                            progress = newProgress
                        }
                    })
                    .accentColor(.white)
                }
                .frame(width: UIScreen.main.bounds.width - 32)
                .padding(.horizontal, 16)

                HStack {
                    // Tiempo actual
                    Text(timeString(from: currentTime))
                        .foregroundColor(.white)
                        .padding(.leading, 20)

                    Spacer()

                    // Tiempo total de la canción
                    Text(timeString(from: duration))
                        .foregroundColor(.white)
                        .padding(.trailing, 20)
                }
                .padding(.bottom, 30)

                // Botón de Play/Pause
                Button(action: {
                    isPlaying.toggle()

                    if isPlaying {
                        // Iniciar la reproducción del archivo de audio
                        guard let url = Bundle.main.path(forResource: "harry", ofType: "mp3") else { return }
                        do {
                            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: url))
                            player?.play()
                            player?.currentTime = newProgress
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    } else {
                        // Detener la reproducción del archivo de audio
                        player?.stop()
                        player = nil
                    }
                }) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 75, height: 75)
                        .foregroundColor(.white)
                }
                .padding(.bottom, 50)
            }
        }
        .onReceive(timer) { _ in
            if isPlaying {
                // Si la canción está reproduciéndose, actualizar el tiempo actual de la canción
                currentTime += 0.1

                // Si se ha llegado al final de la canción, detener la reproducción
                if currentTime >= duration {
                    isPlaying = false
                    currentTime = 0.0
                    progress = 0.0
                    newProgress = 0.0
                } else if !isEditingSlider {
                    progress = CGFloat(currentTime / duration)
                    newProgress = progress
                }
            }
        }
    }
}

func timeString(from seconds: Double) -> String {
    let minutes = Int(seconds / 60)
    let seconds = Int(seconds.truncatingRemainder(dividingBy: 60))
    return String(format: "%d:%02d", minutes, seconds)
}

struct HomeView: View {
    var body: some View {
        Text("Courses")
            .navigationTitle("Courses")
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
