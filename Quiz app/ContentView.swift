import SwiftUI
import AVFoundation

struct Question {
    let question: String
    let options: [String]
    let correctAnswerIndex: Int
    let points: Int
}

struct ContentView: View {
    var audioPlayer: AVAudioPlayer?
    let questions: [Question] = [
        Question(question: "What is the engine displacement of the latest Suzuki Swift?", options: ["1.0L", "1.2L", "1.4L", "1.6L"], correctAnswerIndex: 1, points: 10),
                Question(question: "Which transmission types are available in the Suzuki Swift?", options: ["Manual", "Automatic", "CVT", "All of the above"], correctAnswerIndex: 3, points: 10),
                Question(question: "What is the maximum horsepower of the Suzuki Swift Sport?", options: ["100hp", "125hp", "150hp", "175hp"], correctAnswerIndex: 2, points: 10),
                Question(question: "What is the fuel efficiency (mileage) of the Suzuki Swift?", options: ["20 MPG", "25 MPG", "30 MPG", "35 MPG"], correctAnswerIndex: 3, points: 10),
                Question(question: "Which safety feature is available in the Suzuki Swift?", options: ["ABS", "Airbags", "ESP", "All of the above"], correctAnswerIndex: 3, points: 10),
                Question(question: "What is the maximum cargo capacity of the Suzuki Swift?", options: ["10 cubic feet", "15 cubic feet", "20 cubic feet", "25 cubic feet"], correctAnswerIndex: 1, points: 10),
                Question(question: "Which trim level of the Suzuki Swift includes a touchscreen infotainment system?", options: ["GL", "GLX", "Sport", "RS"], correctAnswerIndex: 2, points: 10),
                Question(question: "What is the starting price of the Suzuki Swift?", options: ["$10,000", "$15,000", "$20,000", "$25,000"], correctAnswerIndex: 1, points: 10)
    ]
    
    @State private var currentQuestionIndex = 0
    @State private var attemptsRemaining = 3
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var score = 0
    @State private var quizCompleted = false
    @State private var showSheet = false
    
    var currentQuestion: Question {
        questions[currentQuestionIndex]
    }
    init() {
        if let audioURL = Bundle.main.url(forResource: "Voicy_Kahoot Lobby Music", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            } catch {
                print("Error initializing audio player: \(error.localizedDescription)")
            }
        }
    }
    
    var body: some View {
        Button(action: {
              audioPlayer?.play()
          }) {
              Text("Play Audio")
          }
        
        if quizCompleted {
            VStack {
                
                    Text("Quiz Completed!")
                        .font(.title)
                        .padding()
                    Text("Your Score: \(score)/70")
                        .font(.headline)
                        .padding()
                Button {
                    currentQuestionIndex = currentQuestionIndex - 7
                    quizCompleted = false
                    score = 0
                } label: {
                    Text("Restart")
                        .cornerRadius(10)
                }

                
            }
        } else {
            VStack(spacing: 20) {
                Text(currentQuestion.question)
                    .font(.headline)
                    .padding()
                
                VStack(spacing: 10) {
                    ForEach(0..<currentQuestion.options.count, id: \.self) { index in
                        Button(action: {
                            checkAnswer(selectedAnswerIndex: index)
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.blue)
                                    .frame(height: 50)
                                
                                Text(currentQuestion.options[index])
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                
                if attemptsRemaining == 0 {
                    Text("Try again.")
                        .foregroundColor(.red)
                        .font(.headline)
                        .padding()
                }
                
                Text("Attempts Remaining: \(attemptsRemaining)")
                    .font(.subheadline)
                
                Button(action: {
                    moveToNextQuestion()
                }) {
                    Text("Next Question")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
            .padding()
            .onChange(of: currentQuestionIndex) { _ in
                resetQuestion()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func checkAnswer(selectedAnswerIndex: Int) {
        if selectedAnswerIndex == currentQuestion.correctAnswerIndex {
            score += currentQuestion.points
            showAlert = true
            alertMessage = "Correct!"
            moveToNextQuestion()
        } else {
            attemptsRemaining -= 1
            if attemptsRemaining == 0 {
                showAlert = true
                alertMessage = "Wrong answer. Try again next time!"
                currentQuestionIndex += 1
            }
        }
    }
    
    func moveToNextQuestion() {
        attemptsRemaining = 3
        
        if currentQuestionIndex + 1 < questions.count {
            currentQuestionIndex += 1
        } else {
            quizCompleted = true
        }
    }
    
    func resetQuestion() {
        attemptsRemaining = 3
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

