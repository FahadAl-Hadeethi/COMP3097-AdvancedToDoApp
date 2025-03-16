import SwiftUI

struct TaskDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var task: String
    @Binding var description: String
    @Binding var status: String
    @Binding var dueDate: String
    @State private var updatedTask: String
    @State private var updatedDescription: String
    @State private var updatedStatus: String
    @State private var updatedDueDate: String
    @State private var showDeleteConfirmation = false
    var updateTask: (String, String, String, String) -> Void
    var deleteTask: () -> Void

    init(task: Binding<String>, description: Binding<String>, status: Binding<String>, dueDate: Binding<String>, updateTask: @escaping (String, String, String, String) -> Void, deleteTask: @escaping () -> Void) {
        self._task = task
        self._description = description
        self._status = status
        self._dueDate = dueDate
        self._updatedTask = State(initialValue: task.wrappedValue)
        self._updatedDescription = State(initialValue: description.wrappedValue)
        self._updatedStatus = State(initialValue: status.wrappedValue)
        self._updatedDueDate = State(initialValue: dueDate.wrappedValue)
        self.updateTask = updateTask
        self.deleteTask = deleteTask
    }

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $updatedTask)
                    TextField("Description", text: $updatedDescription)

                    Picker("Status", selection: $updatedStatus) {
                        Text("Not Started").tag("Not Started")
                        Text("In Progress").tag("In Progress")
                        Text("Completed").tag("Completed")
                    }
                    .pickerStyle(SegmentedPickerStyle())

            
                    TextField("Due Date", text: $updatedDueDate)
                }
            }

            Button(action: {
                updateTask(updatedTask, updatedDescription, updatedStatus, updatedDueDate)
                task = updatedTask
                description = updatedDescription
                status = updatedStatus
                dueDate = updatedDueDate
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            Button(action: {
                showDeleteConfirmation = true
            }) {
                Text("Delete")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .alert("Confirm Deletion", isPresented: $showDeleteConfirmation) {
                Button("Yes", role: .destructive) {
                    deleteTask()
                    presentationMode.wrappedValue.dismiss()
                }
                Button("No", role: .cancel) { }
            } message: {
                Text("Are you sure you want to delete this task?")
            }
        }
        .navigationTitle("Task Details")
    }
}
