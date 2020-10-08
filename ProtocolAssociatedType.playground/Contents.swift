//: Exmple of protocol with associated type
//: ## Problem
//: Let's say that we have a View and a ViewModel. The view is just a form, with different types of inputs.
//: For this example, we can have UITextField and UITextView.
//: One way of doing this is just creating as many fields needed in the UIView, and link each of them to the ViewModel.
//: That's ok, but, if you want to dynamically add more fields, you won't be able to. (i.e BE Driven UI)
//: On the other hand, you could let your ViewModel to define all of the fields that needs to be shown.
//: This example follows the 2nd approach, but with a limitation: Since different type of fields will need different configurations,
//: we've created a protocol called `FormField` who has an associatedType (the configuration structure for different fields).
//: So, if you want to create a new type of field, you'll have to conform to `FormField` and provide the configuration data structure for that field.
//: The problem showed is that `FormField` cannot be used as a first-class citizen since it's constrained by the associatedType. So you can't have an
//: array of FormField: `[FormField]`. And this means, in your UI, you won't be able to receive an array of fields, and layout them accordingly.

import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    
    var viewModel: MyViewControllerViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            // Separate laying out by different models
            layoutStringFormFields(viewModel.stringFields)
            layoutTextFormFields(viewModel.textFields)
            /// If we had only one array of fields, we could create only one layout function
            /// that could check the `field.type` and create a view according to it.
            /// This will also make the UI to render the fields in the same order described in the array
            /// Now, stringFields (UITextFields) are displayed first, and then textFields (UITextView) are displayed at last.
        }
    }
    
    private let stackView: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 5
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
    }
    
    func layoutStringFormFields(_ fields: [StringFormField]) {
        fields.forEach { field in
            let textField = UITextField(frame: .zero)
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.placeholder = field.data.titleText
            stackView.addArrangedSubview(textField)
        }
    }
    
    func layoutTextFormFields(_ fields: [TextFormField]) {
        fields.forEach { field in
            let textView = UITextView(frame: .zero)
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.text = field.data.message
            textView.backgroundColor = field.data.backgroundColor
            textView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            textView.widthAnchor.constraint(equalToConstant: 50).isActive = true
            stackView.addArrangedSubview(textView)
        }
    }
}

class MyViewControllerViewModel {
    /// it would be good to have everything in only one array, stringFields and textFields
    /// And each field would have it's own configuration data structure. Different types of fields could be differentiated by the `fieldType` enum.
    /// Uncomment the following code to see the compiler error.
//    let fields: [FormField] = [
//        StringFormField(fieldType: .string, data: StringFieldData(titleText: "Enter first name", errorText: nil)),
//        TextFormField(data: TextFieldData(titleText: "First Message", showCount: true)),
//    ]
    
    let stringFields: [StringFormField] = [
        StringFormField(data: StringFieldData(titleText: "String Field 1")),
        StringFormField(data: StringFieldData(titleText: "String Field 2")),
        StringFormField(data: StringFieldData(titleText: "String Field 3")),
        StringFormField(data: StringFieldData(titleText: "String Field 4")),
        StringFormField(data: StringFieldData(titleText: "String Field 5")),
        StringFormField(data: StringFieldData(titleText: "String Field 6")),
        StringFormField(data: StringFieldData(titleText: "String Field 7")),
        StringFormField(data: StringFieldData(titleText: "String Field 8")),
    ]
    
    let textFields: [TextFormField] = [
        TextFormField(data: TextFieldData(message: "First Message", backgroundColor: .red)),
        TextFormField(data: TextFieldData(message: "Second Message", backgroundColor: .blue))
    ]
}

protocol FormField {
    associatedtype FieldData
    var fieldType: FormFieldType {get}
    var data: FieldData {get set}
}

enum FormFieldType {
    case string, text
}

/// This have some dummy config for UITextFleld
struct StringFormField: FormField {
    typealias FieldData = StringFieldData
    let fieldType: FormFieldType = .string
    var data: StringFieldData
}

struct StringFieldData {
    let titleText: String
}


/// This have some dummy config for UITextFleld
struct TextFormField: FormField {
    typealias FieldData = TextFieldData
    let fieldType: FormFieldType = .text
    var data: TextFieldData
}
struct TextFieldData {
    let message: String
    let backgroundColor: UIColor
}

let viewController = MyViewController()
let viewModel = MyViewControllerViewModel()

viewController.viewModel = viewModel

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = viewController
