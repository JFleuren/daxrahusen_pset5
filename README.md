## Many List

A many to-do list app that has a list of tasks that the user needs to complete. 
The application supports splitview for iPad and iPhone plus. 
Also it supports restiration support.

## Code Example

The application makes use of the following 3rd party pods:

- [DateTools by MatthewYork](https://github.com/MatthewYork/DateTools)
- [DZNEmptyDataSet by dzenbot](https://github.com/dzenbot/DZNEmptyDataSet)


```swift
    // function which encodes defined objects for restoration state
    override func encodeRestorableState(with coder: NSCoder) {
        
        // get the avaliable text from the textfield
        if let textFieldString = todoItemTextField.text {
            
            // encode the textfield with defined Key
            coder.encode(textFieldString, forKey: SaveStateIdentifiers.TextFieldStateKey)
        }
        
        super.encodeRestorableState(with: coder)
    }
    
    // function which decodes defined objects for restoration state
    override func decodeRestorableState(with coder: NSCoder) {
        
        // check if value is avaliable for Key
        if let textFieldString = coder.decodeObject(forKey: SaveStateIdentifiers.TextFieldStateKey) as? String {
            
            // set the text tot the textfield
            todoItemTextField.text = textFieldString
            
            // enable the user interaction for textfield
            todoItemTextField.isUserInteractionEnabled = true
        }
        
        super.decodeRestorableState(with: coder)
    }
```

## Assignment

The application is the result of an assignment of the Minor Programmeren at the [UvA](http://www.uva.nl/en/home).


## Installation

- Download Github Project
- Download Xcode 8.1
- Open project directory in terminal
- Write `pod install` in terminal 
- Open ManyList.xcworkspace


## License

license MIT
