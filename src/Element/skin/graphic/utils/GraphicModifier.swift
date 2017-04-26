import Cocoa
@testable import Utils

class GraphicModifier {
    /**
     * TODO: Fill and linestyle should be graphic spessific see original code
     */
    static func applyProperties(_ decoratable:inout IGraphicDecoratable,_ fillStyle:IFillStyle,_ lineStyle:ILineStyle?,_ offsetType:OffsetType)->IGraphicDecoratable {
        decoratable.graphic.fillStyle = fillStyle
        decoratable.graphic.lineStyle = lineStyle
        decoratable.graphic.lineOffsetType = offsetType
        return decoratable
    }
    /**
     * New
     */
    static func applyTransform(_ decoratable:inout IGraphicDecoratable,_ rotation:CGFloat){
        let rot:CGFloat = Trig.normalize2(rotation * ㎭)/*between -π and π*/
    }
}
