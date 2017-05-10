import Foundation
/*@testable import Utils*/

class StyleCollectionParser {
    /**
     * Returns an array of style names
     */
    static func styleNames(_ styleCollection:IStyleCollection) -> [String]{
        var styleNames:[String] = []
        for i in 0..<styleCollection.styles.count{//TODO:use forEach instead
            styleNames.append(styleCollection.styles[i].name)
        }
        return styleNames
    }
    /**
     * Describes the stylecollection content
     * Note can you use the ObjectDescriber in place of this class?
     */
    static func describe(_ styleCollection:IStyleCollection) {
        func printStyleProperties(_ style:IStyle) {
            Swift.print("<style.name>:"+style.name)
            var propertyNames:Array = StyleParser.stylePropertyNames(style)
            (0..<style.styleProperties.count).indices.forEach{ e in
                let property:Any = style.getValueAt(e)
                let name:String = propertyNames[e]
                Swift.print("name:" + name + ", property: " +  String(describing: property))
            }
        }
        for i in 0..<styleCollection.styles.count{//<--swift 3 for loop upgrade
            let style:IStyle = styleCollection.styles[i]
            printStyleProperties(style)
        }
    }
}
