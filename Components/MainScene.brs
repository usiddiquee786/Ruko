sub Init()
    m.titlef = m.top.FindNode("titlef")
    
    m.loadingIndicator=m.top.FindNode("titleLabel")
    ' detailsScreen = CreateObject("roSGNode", "Main")
    ' detailsScreen.ObserveField("buttonSelected", "OnButtonSelected")
    InitScreenStack()
    ShowRowListScreen()
    RunContentTask()
end sub
function OnkeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        ' handle "back" key press
        if key = "back"
            numberOfScreens = m.screenStack.Count()
            ' close top screen if there are two or more screens in the screen stack
            if numberOfScreens > 1
                CloseScreen(invalid)
                result = true
            end if
        end if
    end if
    ' The OnKeyEvent() function must return true if the component handled the event,
    ' or false if it did not handle the event.
    return result
end function

