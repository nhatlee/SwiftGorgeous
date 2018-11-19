import Foundation
import UIKit

/*
 Converting nil into errors
 
 When working with optional values, it's very common to want to convert a nil value into a proper Swift error, that can then be propagated and displayed to the user. For example, here we're preparing an image to be uploaded to our server through a series of operations. Since each operation might return nil, we're unwrapping the result of each step, throwing an error if nil was encountered - like this:
 -----------------------------------------
 func prepareImageForUpload(_ image: UIImage) throws -> UIImage {
 guard let watermarked = watermark(image) else {
 throw Error.preparationFailed
 }
 
 guard let encrypted = encrypt(watermarked) else {
 throw Error.preparationFailed
 }
 
 return encrypted
 }
 --------------------------------------------
 The above code works, but let's see if we can use the power of extensions to make it a bit more concise. First, let's create an extension on the Optional enum type that lets us either return its wrapped value or throw an error in case it contained nil, like this:
 */

public extension Optional {
   public func orThrow(_ errorExpression: @autoclosure () -> Error) throws -> Wrapped {
        guard let value = self else {
            throw errorExpression()
        }
        
        return value
    }
}

/*
 Above we use @autoclosure so that we only have to evaluate the error expression if needed, as to not do any unnecessary work - without requiring the caller of our new function to use any additional syntax.
 */

public func watermark(_ image: UIImage) -> UIImage? {
    print("watermark Do Something for test")
    return nil
}

public func encrypt(_ image: UIImage) -> UIImage? {
    print("encrypt Do Something for test")
    return nil
}



//----------------------------------------------
/*
 Assigning reusable views
 Finally, let's take a look at how we can extend the Optional type to make working with reusable views a bit nicer. A common pattern in Apple's UI frameworks is for views to provide certain "slots" where we as the API user can insert our own custom subviews. For example, UITableViewCell provides an accessoryView property that lets us place any view we want at the trailing edge of a cell - which is super convenient when building custom lists.
 
 However, since those slots need to support any kind of view, the type we're dealing with is most often Optional<UIView> - which means that we almost always have to do typecasting to convert the value of such a property into our own view type, leading to many if let dances that look something like this:
 
 
 // Since we want to reuse any existing accessory view if possible,
 // we first need to cast it to our own view type
 if let statusView = cell.accessoryView as? TodoItemStatusView {
 statusView.status = item.status
 } else {
 let statusView = TodoItemStatusView()
 statusView.status = item.status
 cell.accessoryView = statusView
 }


 */


public extension Optional where Wrapped == UIView {
    public mutating func get<T: UIView>(orSet expression: @autoclosure () -> T) -> T {
        guard let view = self as? T else {
            let newView = expression()
            self = newView
            return newView
        }
        
        return view
    }
}
