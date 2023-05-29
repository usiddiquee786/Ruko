' entry point of the Grid Screen
sub Init()
    m.rowList = m.top.FindNode("rowList")
    m.rowList.SetFocus(true)
    'label with item description
    m.descriptionLabel = m.top.FindNode("descriptionLabel")
    'Label with the item title
    m.buttons =   m.top.FindNode("buttons")
    m.titleLabel = m.top.FindNode("titleLabel")
    m.backgroundImage=m.top.FindNode("bgimage")
    m.backgroundVideo=m.top.FindNode("backgroundVideo")
    m.gridbutton=m.top.FindNode("gridbuttons")
    m.hidebutton=m.top.FindNode("Hide")
    'observe rowItemFocused so we can know when another item of rowList will be focused
    ?"hi"
    m.rowList.ObserveField("rowItemFocused", "OnItemFocused")
    m.top.observeField("buttonSelected", "onHideButtonSelected")
    m.globalVariable = 0
    
end sub
sub onGridButtonPressed()
    ?"im here in button: "
    m.backgroundVideo.control = "stop"
end sub
function OnkeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        currentItem = m.top.itemFocused ' position of currently focused item
        ' handle "left" button keypress
        if key = "up"
            ' navigate to the left item in case of "left" keypress
            ?"Im here in up"
            m.rowList.setFocus(false)
            if m.hidebutton.hasFocus()
                ?"Im here in hide"
                m.buttons.setFocus(true)
            else
                ?"Im here in hide2"
                m.hidebutton.setFocus(true)
            end if

            result = true
        ' handle "right" button keypress
        else if key="right"
            m.buttons.setFocus(false)
            m.gridbutton.setFocus(true)
            m.backgroundVideo.control = "stop"
            m.backgroundVideo.visible=false
            m.backgroundImage.visible=true
        else if key="left"
            
            m.gridbutton.setFocus(false)
            m.buttons.setFocus(true)
        else if key = "down"
            ' navigate to the right item in case of "right" keypress
            m.buttons.setFocus(false)
            m.rowList.setFocus(true)
            result = true
        end if
    end if
    return result
end function
sub onRowListButtonFocusGained()
    m.buttons.setFocus(true)
    print "i'm here "
end sub
sub OnItemFocused()
    focusedIndex = m.rowList.rowItemFocused 'get position of the Focused item
    row = m.rowList.content.GetChild(focusedIndex[0])'get all items of row
    item = row.GetChild(focusedIndex[1]) 'get focused item

    ' update description label with description of focused item
    'm.descriptionLabel.text = item.description
    ' update title label with title of focused item
    m.titleLabel.text = item.title
    ' adding length of playback to the title if item length field was populated
    if item.length <> invalid
        m.titleLabel.text += " | " + GetTime(item.length)
    end if
    
    ? "item url: " + item.url
    if item.free
        m.backgroundVideo.visible = true
        ?"Im here: " item.url
        m.backgroundImage.visible=false
        m.backgroundImage.uri = item.hdPosterURL
        m.videoPlayer = CreateObject("roSGNode", "ContentNode") 
        m.videoPlayer.url = item.url
        m.videoPlayer.streamformat = "HLS"
        
        m.backgroundVideo.content = m.videoPlayer
        
        m.backgroundVideo.control = "play"
        m.backgroundVideo.ObserveField("state", "OnVideoStateChanged")
        ?m.backgroundVideo.state
    else
        m.backgroundImage.visible=true
        m.backgroundImage.uri = item.hdPosterURL
        m.backgroundVideo.visible = false
    end if
end sub
sub onHideButtonSelected(event as Object)
    ' Perform actions when the "hide" button is selected
    ?"Hide button selected"
    if m.globalVariable=0
        m.rowList.visible=false
        m.globalVariable=m.globalVariable + 1
    else if m.globalVariable=1
        m.rowList.visible=true
        m.globalVariable=0
    endif 
end sub
sub OnVideoStateChanged()
    if m.backgroundVideo.state = "buffering"
        ?"I m Buffering "
        m.backgroundVideo.visible = false
        m.backgroundImage.visible = true
    else if m.backgroundVideo.state = "playing"
        ?"Im  Playing"
        m.backgroundVideo.visible = true
        m.backgroundImage.visible = false
    else if m.backgroundVideo.state = "finished"
        ?"Im  stop"
        m.backgroundVideo.duration="0.0"
    end if
end sub
sub OnVideoVisibleChange() ' invoked when video node visibility is changed
    ?"I m here :"
    if m.videoPlayer.visible = false and m.top.visible = true
        ' the index of the video in the video playlist that is currently playing.
        currentIndex = m.videoPlayer.contentIndex
        m.videoPlayer.control = "stop" ' stop playback
        'clear video player content, for proper start of next video player
        m.videoPlayer.content = invalid
    end if
end sub
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
' sub handleButtonSelected()
'     CloseScreen()
'     m.GridScreen = CreateObject("roSGNode", "Scene")
'     m.GridScreen.xml = ReadAsciiFile("pkg:/grid.xml")
'     ShowScreen(m.GridScreen)
' end sub

sub onFieldNotify(id as String, value)
    ? " Im here or not "
    if id = "rowlistbutton" then
        ' Check if the video player is currently playing
        if m.backgroundVideo.visible = true then
            ' Stop the video playback
            m.backgroundVideo.control = "stop"
        end if
    end if
end sub
