import Foundation
@testable import Utils
/**
 * TODO: if you strip the inital css data for spaces then you won't need to removeWrappingWhiteSpace all the time
 */
class CSSParser{
    static let precedingWith:String = "(?<=^|\\})"
    static let nameGroup:String = "([\\w\\s\\,\\[\\]\\.\\#\\:]*?)"
    static let valueGroup:String = "((?:.|\\n)*?)"
    static let CSSElementPattern:String = precedingWith + nameGroup + "\\{" + valueGroup + "\\}"/*this pattern is here so that its not recrated every time*/
    static var stylePattern:String = "([\\w\\s\\,\\-]*?)\\:(.*?)\\;"
    static var stylePropertyValuePattern:String = "\\w\\.\\-%#\\040<>\\/~"
    enum CSSElementType:Int{ case name = 1, value}
    /**
     * Returns a StyleCollection populated with Style instances, by converting a css string and assigning each style to a Styleclass and then adding these to the StyleCollection
     * RETURN: StyleCollection populated with Styles
     * PARAM: cssString: a string comprised by css data h1{color:blue;} etc
     * NOTE: We can't sanitize the cssString for whitespace becuase whitespace is needed to sepereate some variables (i.e: linear-gradient)
     * TODO: ⚠️️ Use mapReduce in the bellow method
     */
    static func styleCollection(_ cssString:String)->IStyleCollection{
        //var styleCollection:IStyleCollection = StyleCollection()
        let matches = RegExp.matches(cssString, CSSElementPattern)/*Finds and seperates the name of the style and the content of the style*/// :TODO: name should be +? value also?;
        return matches.mapReduce(StyleCollection()) {/*Loops through the pattern*/
            var styleCollection:StyleCollection = $0
            let match:NSTextCheckingResult = $1
            let styleName:String = match.value(cssString, 1)/*name*/
            Swift.print("styleName: " + "\(styleName)")
            let value:String = match.value(cssString, 2)/*value*/
            Swift.print("value: " + "\(value)")
            if(StringAsserter.contains(styleName, ",")){/*Sibling styles*/
                let siblingStyles:[IStyle] = Utils.siblingStyles(styleName, value)
                styleCollection.addStyles(siblingStyles)/*If the styleName has multiple comma-seperated names*/
            }else{/*Single style*/
                let style:IStyle = CSSParser.style(styleName,value)
                styleCollection.addStyle(style)/*If the styleName has 1 name*/
            }
            return styleCollection
        }
    }
    /**
     * Converts cssStyleString to a Style instance
     * Also transforms the values so that : (with swift readable values, colors: become hex colors, boolean strings becomes real booleans etc)
     * PARAM: name: the name of the style
     * PARAM: value: a string comprised of a css style syntax (everything between { and } i.e: color:blue;border:true;)
     */
    static func style(_ name:String,_ value:String)->IStyle{
        let name = name != "" ? RegExpModifier.removeWrappingWhitespace(name) : ""/*removes space from left and right*/
        let selectors:[ISelector] = SelectorParser.selectors(name)
        let matches = value.matches(stylePattern)
        let s:[IStyleProperty] = matches.lazy.map{ match -> [IStyleProperty] in
            let propertyName:String = match.value(value, 1)/*name*/
            //Swift.print("propertyName: " + "\(propertyName)")
            let propertyValue:String = match.value(value, 2)/*value*/
            //Swift.print("propertyValue: " + "\(propertyValue)")
            let styleProperties:[IStyleProperty] = CSSParser.styleProperties(propertyName,propertyValue)
            //Swift.print("styleProperties.count: " + "\(styleProperties.count)")
            return styleProperties
            }.reduce([]){
                return $0 + $1
        }
        //Swift.print("s.styleProperties.count: " + "\(s.styleProperties.count)")
        return Style(name,selectors, s)
    }
    /**
     * Returns an array of StyleProperty items (if a name is comma delimited it will create a new styleProperty instance for each match)
     * NOTE: now supports StyleProperty2 that can have many property values
     */
    static func styleProperties(_ propertyName:String, _ propertyValue:String)->[IStyleProperty]{
        var styleProperties:[IStyleProperty] = []
        let names = propertyName.contains(",") ? propertyName.split(propertyValue) : [propertyName]//Converts a css property to a swift compliant property that can be read by the swift api
        names.forEach { name in
            let name:String = RegExpModifier.removeWrappingWhitespace(name)
            let valExp:String = stylePropertyValuePattern/*expression for a single value, added the tilde char to support relative paths while in debug, could be usefull for production aswell*/
            let pattern:String = "(["+valExp+"]+?|["+valExp+"]+?\\(["+valExp+",]+?\\))(?=,|$)"/*find each value that is seperated with the "," character (value can by itself contain commas, if so thous commas are somewhere within a "(" and a ")" character)*/
            var values:[String] = propertyValue.match(pattern)
            for i in 0..<values.count{
                let value = RegExpModifier.removeWrappingWhitespace(values[i])
                let propertyValue:Any = CSSPropertyParser.property(value)
                let styleProperty:IStyleProperty = StyleProperty(name,propertyValue,i)/*values that are of a strict type, boolean, number, uint, string or int*/
                styleProperties.append(styleProperty)
            }
        }
        return styleProperties
    }
}

private class Utils{
    static var precedingWith:String = "(?<=\\,|^)"
    static var prefixGroup:String = "([\\w\\d\\s\\:\\#]*?)?"
    static var group:String = "(\\[[\\w\\s\\,\\.\\#\\:]*?\\])?"
    static var suffix:String = "([\\w\\d\\s\\:\\#]*?)?(?=\\,|$)"//the *? was recently changed from +?
    static var siblingPattern:String = precedingWith + prefixGroup + group + suffix/*this pattern is here so that its not recrated every time*/
    /**
     * Returns an array of style instances derived from PARAM: style (that has a name with 1 or more comma signs, or in combination with a group [])
     * PARAM: style: style.name has 1 or more comma seperated words
     * TODO: write a better description
     * TODO: optimize this function, we probably need to outsource the second loop in this function
     * TODO: using the words suffix and prefix is the wrong use of their meaning, use something els
     * TODO: add support for syntax like this: [Panel,Slider][Button,CheckBox]
     */
    static func siblingStyles(_ styleName:String,_ value:String)->[IStyle] {
        //Swift.print("CSSParser.siblingStyles(): " + "styleName: " + styleName)
        enum styleNameParts:Int{case prefix = 1, group, suffix}
        var sibblingStyles:[IStyle] = []
        let style:IStyle = CSSParser.style("", value)/*creates an empty style i guess?*/
        let matches = styleName.matches(siblingPattern)/*TODO: Use associate regexp here for identifying the group the subseeding name and if possible the preceding names*/
        //Swift.print("matches: " + "\(matches.count)")
        for match:NSTextCheckingResult in matches {
            if(match.numberOfRanges > 0){
                var prefix:String = match.value(styleName,1)
                prefix = prefix != "" ? RegExpModifier.removeWrappingWhitespace(prefix):prefix
                let group:String =  match.value(styleName,2)
                var suffix:String = match.value(styleName,3)
                suffix = suffix != "" ? RegExpModifier.removeWrappingWhitespace(suffix):suffix
                if(group == "") {
                    sibblingStyles.append(StyleModifier.clone(style, suffix, SelectorParser.selectors(suffix)))
                }else{
                    let precedingWith:String = "(?<=\\[)"
                    let endingWith:String = "(?=\\])"
                    let bracketPattern:String = precedingWith + "[\\w\\s\\,\\.\\#\\:]*?" + endingWith
                    let namesInsideBrackets:String = RegExp.match(group, bracketPattern)[0]
                    let names:[String] = StringModifier.split(namesInsideBrackets, ",")
                    for name in names {
                        let condiditonalPrefix:String = prefix != "" ? prefix + " " : ""
                        let conditionalSuffix:String = suffix != "" ? " " + suffix : ""
                        let fullName:String =  condiditonalPrefix + name + conditionalSuffix
                        //Swift.print("fullName: " + fullName)
                        sibblingStyles.append(StyleModifier.clone(style, fullName, SelectorParser.selectors(fullName)))
                    }
                }
            }
        }
        return sibblingStyles
    }
}
