import Foundation
import Cocoa
@testable import Utils
/**
 * NOTE: Container does not add the skin to the stage, Use Section if you need a skin added to
 * TODO: Rename to Div,Division,Section,Segment? or? Div sounds best and is closley related to css, too closley reletate. Container is a good name!
 * IMPRTANT: ⚠️️ May have probs with interactions like scrollWhell. use Section instead, which has a background
 */
class Container:Element{
    override func resolveSkin() {
        skin = SkinResolver.skin(self)/*We still need to generate the skin, why? I can't recall*/   
    }
    /**
     * New
     */
    var layerPos:CGPoint?{
        get{return self.layer?.position}
        set{
            Swift.print("setLayerPos: ")
            self.layer?.position = newValue!
        }
    }
}
