//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    
    var viewModel: MyViewControllerViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            layoutStringFormFields(viewModel.stringFields)
            layoutTextFormFields(viewModel.textFields)
            /// if we had only one array of fields, we could create only one layout function
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
    /// And each field would have it's own configuration data structure.
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
