import UIKit

// I>
/*
 Matching against a predicate
 
 
+ For example, here we're unwrapping a search bar's text, and then verifying that it contains at least 3 characters before performing a search:
 ----->
 guard let query = searchBar.text, query.length > 2 else {
 return
 }
 
 performSearch(with: query)
 */

extension Optional {
    func matching(_ predicate: (Wrapped) -> Bool) -> Wrapped? {
        guard let value = self else {
            return nil
        }
        
        guard predicate(value) else {
            return nil
        }
        
        return value
    }
}

func performSearch(with text: String) {
    print(text)
}
var testString: String?
testString = "Something For test"
testString.matching { $0.count > 2 }
    .map(performSearch)

var testFailed: String?
testFailed.matching{$0.count > 3}.map(performSearch)

var testFailed2: String?
testFailed2 = "ab c"
testFailed2.matching{$0.count > 3}.map(performSearch)

/*
 Anoter use case
 
 let activeFriend = database.userRecord(withID: id)
 .matching { $0.isFriend }
 .matching { $0.isActive }
 */



// II>
enum MyError: Error {
    case preparationFailed
}

public func prepareImageForUpload(_ image: UIImage) throws -> UIImage {
    return try watermark(image)
        .flatMap(encrypt)
        .orThrow(MyError.preparationFailed)
}


// III>
class TodoItemStatusView: UITableViewCell {
}
let cell = UITableViewCell()

let statusView = cell.accessoryView.get(orSet: TodoItemStatusView())
//statusView.status = item.status
