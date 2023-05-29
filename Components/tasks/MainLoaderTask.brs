sub Init()
    'set the name of the function in the Task node component to be executed when the state field changes to RUN in our case this method executed after the following
    'cmd: m.contentTask. control
    m.top. functionName = "GetContent"
end sub
sub GetContent()
    'request the content feed from the API
    xfer = CreateObject("roURLTransfer")
    xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    xfer.SetURL("https://videoapps.b-cdn.net/Fireplace/Fireplace%20Meditation%20-%20Relaxing%20by%20Fire/videosDataSubscription.json")
    rsp = xfer.GetToString()
    rootChildren = []
    rows = {}
    'parse the feed and build a tree of ContentNodes to populate the GridView
    json = ParseJson(rsp)
    if json <> invalid
        for each category in json
            value = json.Lookup(category)
            if Type(value) = "roArray" 'if parsed key value having other objects in it
                'if category <> "row one"
                    row = {}
                    row.title = category
                    row.children = []
                    for each item in value 'parse items and push them to row
                        itemData = GetItemData(item)
                        ?"item =  " item
                        row.children.Push(itemData)
                    end for
                    ?"Row: " row
                    rootChildren.Push(row)
                'end if
            end if
        end for
        ' set up a root ContentNode to represent rowList on the GridScreen
        contentNode = CreateObject("roSGNode", "ContentNode")
        contentNode.Update({
            children: rootChildren
        }, true)
        ' populate content field with root content node.
        ' Observer(see OnMainContentLoaded in MainScene.brs) is invoked at that moment
        m.top.content = contentNode
    end if
end sub
function GetItemData(video as Object) as Object
    item = {}
    ' populate some standard content metadata fields to be displayed on the GridScreen
    ' https://developer.roku.com/docs/developer-program/getting-started/architecture/content-metadata.md
    if video.longDescription <> invalid
        item.description = video.longDescription
    else
        item.description = video.shortDescription
    end if
    ?"item title =  " video.title
    item.hdPosterURL = video.imagePath
    item.title = video.videoTitle
    item.releaseDate = video.releaseDate
    item.id = video.mediaId
    item.free=video.isFree
    item.url=video.videoPath
    ' if video.content <> invalid
    '     ' populate length of content to be displayed on the GridScreen
    '     item.length = video.content.duration
    ' end if
    return item
end function
