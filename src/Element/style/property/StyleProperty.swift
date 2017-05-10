import Foundation

struct StyleProperty:IStyleProperty {//TODO: ⚠️️ this definitly needs to be converted to a struct
    var name:String
    var value:Any
    var depth:Int/*Depth should really be UInt, but since apple doesnt use/like UInt and the support isn't that great we use Int*/
    init(_ name:String,_ value:Any,_ depth:Int = 0){
        self.name = name
        self.value = value
        self.depth = depth
    }
}
