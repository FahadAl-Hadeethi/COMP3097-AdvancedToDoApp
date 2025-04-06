import SwiftUI

struct CreateTaskView: View {
    @Environment(\.presentationMode) var presentationMode

    var category: String
    var addTask: (String, String, String, String, String) -> Void

    @State private var taskTitle = ""
    @State private var taskDescription = ""
    @State private var status = "Not Started"
    @State private var dueDate = Date()
    @State private var showConfirmation = false

    var isFormValid: Bool {
        return !taskTitle.isEmpty && taskDescription.count >= 10
    }

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Task Information")) {
                    TextField("Title", text: $taskTitle)

                    TextField("Description", text: $taskDescription)

                    if taskDescription.count > 0 && taskDescription.count < 10 {
                        Text("Description must be at least 10 characters")
                            .font(.caption)
                            .foregroundColor(.red)
                    }

                    HStack {
                        Text("Category")
                        Spacer()
                        Text(category)
                            .foregroundColor(.gray)
                            .italic()
                    }

                    Picker("Status", selection: $status) {
                        Text("Not Started").tag("Not Started")
                        Text("In Progress").tag("In Progress")
                        Text("Completed").tag("Completed")
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                }
            }

            Button(action: {
                let dueDateString = formatDate(dueDate)
                addTask(taskTitle, taskDescription, category, status, dueDateString)
                showConfirmation = true
            }) {
                Text("Create Task")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isFormValid ? Color.green : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .disabled(!isFormValid)
        }
        .navigationTitle("Create Task")
        .alert("Task Created!", isPresented: $showConfirmation) {
            Button("OK") {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
