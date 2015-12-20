import Foundation

class RectGraphicUtils2 {
    /**
     * 
     */
    class func offsetRect(rect:CGRect, _ lineStyle:ILineStyle, _ offsetType:OffsetType)->(lineFrameRect:CGRect,lineRect:CGRect,fillFrameRect:CGRect){
        var lineFrameRect:CGRect = rect.copy()
        var lineRect:CGRect = CGRect(0,0,rect.width,rect.height)
        var fillFrameRect:CGRect = rect.copy()
        
        //Swift.print("lineRect: " + "\(lineRect)")
        /*Left*/
        if(offsetType.left == OffsetType.outside){
            lineFrameRect = lineFrameRect.expand(lineStyle.thickness, 0)
            lineRect = lineRect.offset(lineStyle.thickness / 2, 0)//.expand(-lineStyle.thickness/2, 0)
            fillFrameRect = fillFrameRect.offset(lineStyle.thickness, 0)
        }else { //inside
            lineRect = lineRect.offset(-lineStyle.thickness/2, 0)//.expand(lineStyle.thickness/2 , 0)
        }
        /*Right*/
        if(offsetType.right == OffsetType.outside){
            lineFrameRect = lineFrameRect.expand(lineStyle.thickness, 0)
            lineRect = lineRect.expand(lineStyle.thickness , 0)
        }else{//inside
            lineRect = lineRect.expand(lineStyle.thickness , 0)
        }
        /*Top*/
        if(offsetType.top == OffsetType.outside){
            lineFrameRect = lineFrameRect.expand(0,lineStyle.thickness)
            lineRect = lineRect.offset(0, lineStyle.thickness/2)//.expand(0,-lineStyle.thickness/2)
            fillFrameRect = fillFrameRect.offset(0,lineStyle.thickness)
            
        }else{//inside
            lineRect = lineRect.offset(0, -lineStyle.thickness/2)//.expand(0,+lineStyle.thickness/2)
        }
        /*Bottom*/
        if(offsetType.bottom == OffsetType.outside){//outside
            lineFrameRect = lineFrameRect.expand(0,lineStyle.thickness)
            lineRect = lineRect.expand(0,lineStyle.thickness)
        }else{//inside
            lineRect = lineRect.expand(0,lineStyle.thickness)
        }
        return (lineFrameRect,lineRect, fillFrameRect)
    }
}
