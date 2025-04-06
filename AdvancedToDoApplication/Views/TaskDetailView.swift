import SwiftUI

struct TaskDetailView: View {
    @ObservedObject var task: TaskEntity
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State private var showDeleteConfirmation = false

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: Binding(
                        get: { task.title ?? "" },
                        set: { task.title = $0 }
                    ))

                    TextField("Description", text: Binding(
                        get: { task.taskDescription ?? "" },
                        set: { task.taskDescription = $0 }
                    ))

                    Picker("Status", selection: Binding(
                        get: { task.status ?? "" },
                        set: { task.status = $0 }
                    )) {
                        Text("Not Started").tag("Not Started")
                        Text("In Progress").tag("In Progress")
                        Text("Completed").tag("Completed")
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    DatePicker("Due Date", selection: Binding(
                        get: { task.dueDate ?? Date() },
                        set: { task.dueDate = $0 }
                    ), displayedComponents: .date)
                }
            }

            Button(action: {
                try? viewContext.save()
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom)

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
            .padding(.bottom)
            .alert("Confirm Deletion", isPresented: $showDeleteConfirmation) {
                Button("Yes", role: .destructive) {
                    viewContext.delete(task)
                    try? viewContext.save()
                    presentationMode.wrappedValue.dismiss()
                }
                Button("No", role: .cancel) {}
            } message: {
                Text("Are you sure you want to delete this task?")
            }
        }
        .navigationTitle("Task Details")
    }
}
