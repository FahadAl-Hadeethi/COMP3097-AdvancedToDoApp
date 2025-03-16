import SwiftUI

struct CreateTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var taskTitle = ""
    @State private var taskDescription = ""
    @State private var category = ""
    @State private var status = "Not Started"
    @State private var dueDate = Date()
    @State private var showConfirmation = false
    var addTask: (String, String, String, String, String) -> Void

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Task Information")) {
                    TextField("Title", text: $taskTitle)
                    TextField("Description", text: $taskDescription)
                    TextField("Category", text: $category)

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
                if !taskTitle.isEmpty && !category.isEmpty {
                    let dueDateString = formatDate(dueDate)
                    addTask(taskTitle, taskDescription, category, status, dueDateString)
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Create Task")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(taskTitle.isEmpty || category.isEmpty ? Color.gray : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .disabled(taskTitle.isEmpty || category.isEmpty)
        }
        .navigationTitle("Create Task")
    }

    // Helper function to format the date
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
