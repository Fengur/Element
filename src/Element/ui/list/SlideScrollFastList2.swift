import Cocoa
@testable import Utils

protocol Fast{}
extension Fast{
    func setProgress(_ progress:CGFloat){
        Swift.print("🍌 setProgress: progress")
    }
}
protocol SlidableScrollableFast:Fast, SlidableScrollable{}
extension SlidableScrollableFast{
    func onScrollWheelChange(_ event:NSEvent) {
        let progressVal:CGFloat = SliderListUtils.progress(event.deltaY, interval, slider!.progress)
        slider!.setProgressValue(progressVal)
        (self as Fast).setProgress(progressVal)
    }
    
}

class SlideScrollFastList2:FastList2,SlidableScrollableFast {
    var slider:VSlider?
    var sliderInterval:CGFloat?
    override var itemsHeight: CGFloat {return dp.count * itemHeight}//👈 temp, move into protocol extension, if possible
    override func resolveSkin() {
        super.resolveSkin()
        Swift.print("itemsHeight: " + "\(itemsHeight)")
        Swift.print("height: " + "\(height)")
        /*slider*/
        sliderInterval = floor(itemsHeight - height)/itemHeight// :TODO: use ScrollBarUtils.interval instead?// :TODO: explain what this is in a comment
        slider = addSubView(VSlider(itemHeight,height,0,0,self))
        let thumbHeight:CGFloat = SliderParser.thumbSize(height/itemsHeight, slider!.height)
        slider!.setThumbHeightValue(thumbHeight)
        slider!.thumb!.fadeOut()//inits fade out anim on init
    }
    override func onEvent(_ event:Event) {
        //Swift.print("event: " + "\(event)")
        if(event === (SliderEvent.change,slider!)){
            setProgress((event as! SliderEvent).progress)
        }/*events from the slider*/
        super.onEvent(event)
    }
    /**
     * When the the user scrolls
     * NOTE: this method overides the Native NSView scrollWheel method
     */
    override func scrollWheel(with event: NSEvent) {
        scroll(event)
    }
}
