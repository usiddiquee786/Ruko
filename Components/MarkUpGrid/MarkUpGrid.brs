sub Init()
    'm.top.backgroundURI = "pkg:/images/background.jpg"
      'm.top.setFocus(true)
    m.buttons =   m.top.FindNode("buttons")
    m.gridbutton=m.top.FindNode("gridbuttons")
    m.markupgrid = m.top.findNode("exampleMarkupGrid")
    m.backgroundImage=m.top.FindNode("bgimage")
    m.backgroundVideos=m.top.FindNode("backgroundVideo")
    m.readMarkupGridTask = createObject("roSGNode", "ContentReader")
    m.readMarkupGridTask.contenturi = "https://videoapps.b-cdn.net/Fireplace/Fireplace%20Meditation%20-%20Relaxing%20by%20Fire/videosDataSubscription.json"
    m.readMarkupGridTask.observeField("content", "showmarkupgrid")
    m.readMarkupGridTask.control = "RUN"
      
end sub
sub showmarkupgrid()
    m.markupgrid.content = m.readMarkupGridTask.content
    m.markupgrid.setFocus(true)
    m.markupGrid.observeField("itemFocused", "onGridItemFocused")
end sub

sub onGridItemFocused()
    focusedItem = m.markupGrid.content.getChild(m.markupGrid.itemFocused)
    ?"focused title" focusedItem.videoTitle
    ?" print" focusedItem.isFree
    if focusedItem.isFree
        ? "I'm here: " + focusedItem.videoPath
        m.backgroundImage.visible = false
        m.backgroundImage.uri=focusedItem.imagePath
        m.videoPlayer2 = CreateObject("roSGNode", "ContentNode") 
        m.videoPlayer2.url = focusedItem.videoPath
        m.videoPlayer2.streamformat = "HLS"
        m.backgroundVideos.visible = true
        m.backgroundVideos.content = m.videoPlayer2
        m.backgroundVideos.control = "play"
        
        m.backgroundVideos.ObserveField("state", "OnVideoStateChanged")
        
        if m.backgroundVideos.state = "error"
            print "error"
            ? "Video player error: "  m.backgroundVideos.error
            m.backgroundImage.visible = true
            m.backgroundImage.uri = focusedItem.imagePath
            m.backgroundVideos.visible = false
        end if
    else
        m.backgroundImage.visible=true
        m.backgroundImage.uri = focusedItem.imagePath
        m.backgroundVideos.visible = false
    end if
end sub
sub OnVideoStateChanged()
    if m.backgroundVideos.state = "buffering"
        ?"I m Buffering "
        m.backgroundVideos.visible = false
        m.backgroundImage.visible = true
    else if m.backgroundVideos.state = "playing"
        ?"Im  Playing"
        m.backgroundVideos.visible = true
        m.backgroundImage.visible = false
    end if
end sub
function OnkeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        currentItem = m.top.itemFocused ' position of currently focused item
        ' handle "left" button keypress
        if key = "up"
            m.markupgrid.setFocus(false)
            m.buttons.setFocus(true)
            m.backgroundVideos.control = "stop"
            m.backgroundVideos.visible=false
            m.backgroundImage.visible=true
            result = true
        ' handle "right" button keypress
        else if key="right"
            m.buttons.setFocus(false)
            m.gridbutton.setFocus(true)
        else if key="left"
            m.gridbutton.setFocus(false)
            m.buttons.setFocus(true)
            m.backgroundVideos.control = "stop"
             m.backgroundVideos.visible=false
            m.backgroundImage.visible=true
        else if key = "down"
            ' navigate to the right item in case of "right" keypress
            m.buttons.setFocus(false)
            m.markupgrid.setFocus(true)
            result = true
        end if
    end if
    return result
end function
' this method covert seconds to mm:ss format
function GetTime(length as Integer) as String
    minutes = (length \ 60).ToStr()
    seconds = length MOD 60
    if seconds < 10
       seconds = "0" + seconds.ToStr()
    else
       seconds = seconds.ToStr()
    end if
    return minutes + ":" + seconds
end function


