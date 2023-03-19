local vectors = {}

function createVector(width, height, rawData)
    local svgElm = svgCreate(width, height, rawData)
    local svgXML = svgGetDocumentXML(svgElm)
    local rect = xmlFindChild(svgXML, "rect", 0)

    return {
        svg = svgElm,
        xml = svgXML,
        rect = rect
    }
end

function createCircleStroke(id, width, height, sizeStroke)
    if (not id) then return end 
    if (not (width or height)) then return end

    if (not vectors[id]) then
        sizeStroke = sizeStroke or 2
        
        local radius = math.min(width, height) / 2
        local radiusLength = (2 * math.pi) * radius
        local newWidth, newHeight = width + (sizeStroke * 2), height + (sizeStroke * 2)

        local dashOffset = radiusLength - (radiusLength / 100) * 0

        local raw = string.format([[
            <svg width='%s' height='%s'>
                <rect x='%s' y='%s' rx='%s' width='%s' height='%s' fill='#FFFFFF' fill-opacity='0' stroke='#FFFFFF'
                stroke-width='%s' stroke-dasharray='%s' stroke-dashoffset='%s' stroke-linecap='round' stroke-linejoin='round'  />
            </svg>
        ]], newWidth, newHeight, sizeStroke, sizeStroke, radius, width, height, sizeStroke, radiusLength, dashOffset)
        local svg = createVector(width, height, raw)

        local attributes = {
            type = 'circle-stroke',
            svgDetails = svg,
            width = width,
            height = height,
            radius = radius,
            radiusLength = radiusLength
        }

        vectors[id] = attributes
    end
    return vectors[id]
end 

function createRoundedRectangle(id, width, height, radius)
    if (not id) then return end 
    if (not (width or height)) then return end

    if (not vectors[id]) then 
        width = width or 1
        height = height or 1
        radius = radius or 1


        local area = width * height
        local length = area / width
        local perimeter = (width + length) * 2
        local bottom = height - radius
        local raw = string.format([[ 
            <svg width='%s' height='%s'>
                <rect rx='%s' width='%s' height='%s'  fill='#FFFFFF'/>
            </svg>
        ]], width, height, radius, width, height)
        local svg = createVector(width, height, raw)

        local attributes = {
            type = 'rounded-rectangle',
            svgDetails = svg,
            width = width,
            height = height,
            radius = radius,
            radiusLength = length,
            perimeter = perimeter,
            area = area,
            length = length
        }
        vectors[id] = attributes
    end
    return vectors[id]
end




function createCircle(id, width, height)
    if (not id) then return end 
    if (not (width or height)) then return end

    if (not vectors[id]) then 
        width = width or 1
        height = height or 1
        
        local radius = math.min(width, height) / 2
        local raw = string.format([[
            <svg width='%s' height='%s'>
                <rect rx='%s' width='%s' height='%s' fill='#FFFFFF'/>
            </svg>
        ]], width, height, radius, width, height)
        local svg = createVector(width, height, raw)

        local attributes = {
            type = 'circle',
            svgDetails = svg,
            width = width,
            height = height,
        }
        vectors[id] = attributes
    end
    return vectors[id]
end



function setSVGOffset(id, value)
    if (not vectors[id]) then return end 
    local svg = vectors[id]
   
    if (cache[id][2] ~= value) then 
        if (not cache[id][1]) then
            cache[id][3] = getTickCount()
            cache[id][1] = true
        end
        
        local progress = (getTickCount() - cache[id][3]) / 2500
        cache[id][2] = interpolateBetween(cache[id][2], 0, 0, value, 0, 0, progress, 'OutQuad')
        
        if (progress > 1) then 
            cache[id][3] = nil
            cache[id][1] = false
        end

        if (svg.type == 'rounded-rectangle' ) then 
            local rect = svg.svgDetails.rect
            

            local newValue = (svg.length / 100) * cache[id][2]
            local reverseWidth = svg.width - newValue

            xmlNodeSetAttribute(rect, 'height', reverseWidth)
            svgSetDocumentXML(svg.svgDetails.svg, svg.svgDetails.xml)
        end

        local rect = svg.svgDetails.rect
        local newValue = svg.radiusLength - (svg.radiusLength / 100) * cache[id][2]

        xmlNodeSetAttribute(rect, 'stroke-dashoffset', newValue)
        svgSetDocumentXML(svg.svgDetails.svg, svg.svgDetails.xml)
    elseif cache[id][1] then
        cache[id][1] = false
    end
end      

function drawItem(id, x, y, color, postGUI)
    if (not vectors[id]) then return end
    if (not (x or y)) then return end
    local svg = vectors[id]

    postGUI = postGUI or false
    color = color or 0xFFFFFFFF

    local width, height = svg.width, svg.height

    dxSetBlendMode('add')
    dxDrawImage(x, y, width, height, svg.svgDetails.svg, 0, 0, 0, color, postGUI)
    dxSetBlendMode('blend')
end

function hiddenComponents(state)
    for _, component in pairs(components) do 
        setPlayerHudComponentVisible(component, state)
    end
end


function isCursorInPosition(x, y, width, height)
    local cursorX, cursorY = getCursorPosition()
    cursorX, cursorY = cursorX * screenW, cursorY * screenH
    return cursorX >= x and cursorX <= x + width and cursorY >= y and cursorY <= y + height
end

function getElementSpeed(theElement, unit)
    -- Check arguments for errors
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

function createComponents()
    createCircleStroke('bgSpeed', circleScale + 125, circleScale + 125, sizeStroke + 12)
    createCircleStroke('speed', circleScale + 125, circleScale + 125, sizeStroke + 12)

    createRoundedRectangle('bgHealth', circleScale - 10 , circleScale - 10, 5)
    createRoundedRectangle('bgOfAll', circleScale + 210,  circleScale, 15)
    createRoundedRectangle('bgArmor', circleScale - 10 , circleScale - 10, 5)
    createRoundedRectangle('bgFeed', circleScale - 10 , circleScale - 10, 5)
    createRoundedRectangle('bgThirst', circleScale - 10 , circleScale - 10, 5)
    createRoundedRectangle('bgGas', circleScale + 25 , circleScale -15, 10)

    createRoundedRectangle('health', circleScale - 10 , circleScale - 10, 2)
    createRoundedRectangle('armor', circleScale - 10 , circleScale - 10, 2)
    createRoundedRectangle('feed', circleScale - 10 , circleScale - 10, 2)
    createRoundedRectangle('thirst', circleScale - 10 , circleScale - 10, 2)

    createRoundedRectangle('mic1', circleScale - 40 , circleScale - 40, 2)
    createRoundedRectangle('mic2', circleScale - 40 , circleScale - 40, 2)
    createRoundedRectangle('mic3', circleScale - 40 , circleScale - 40, 2)
end

function createItems()
    drawItem('bgOfAll', rightScreen - 240, bottomScreen -5, tocolor(0,0,0,100))

    drawItem('bgHealth', rightScreen - 220, bottomScreen, tocolor(18, 232, 147,170))
    drawItem('health', rightScreen - 220, bottomScreen, tocolor(28,28,28,255))
    dxDrawImage(rightScreen - 210, bottomScreen + 10, iconScale, iconScale, 'assets/icon_vida.png', 0, 0, 0, tocolor(255,255,255,255), true)
    setSVGOffset('health', getElementHealth(localPlayer))


    drawItem('bgArmor', rightScreen - 170, bottomScreen, tocolor(18, 232, 147,170))
    drawItem('armor', rightScreen - 170, bottomScreen, tocolor(28,28,28,255))
    dxDrawImage(rightScreen - 160, bottomScreen + 10, iconScale, iconScale, 'assets/icon_colete.png', 0, 0, 0, tocolor(255,255,255,255), true)   
    setSVGOffset('armor', getPedArmor(localPlayer))

    drawItem('bgFeed', rightScreen - 120, bottomScreen, tocolor(18, 232, 147,170))
    drawItem('feed', rightScreen - 120, bottomScreen, tocolor(28,28,28,255))
    dxDrawImage(rightScreen - 110, bottomScreen + 10, iconScale, iconScale, 'assets/icon_comida.png', 0, 0, 0, tocolor(255,255,255,255), true)
    setSVGOffset('feed', 70)

    drawItem('bgThirst', rightScreen - 70, bottomScreen, tocolor(18, 232, 147,170))
    drawItem('thirst', rightScreen - 70, bottomScreen, tocolor(28,28,28,255))
    dxDrawImage(rightScreen - 60, bottomScreen + 10, iconScale, iconScale, 'assets/icon_agua.png', 0, 0, 0, tocolor(255,255,255,255), true)
    setSVGOffset('thirst', 40)

    dxDrawImage(rightScreen - 20, bottomScreen + 10, iconScale - 5, iconScale, 'assets/icon_voz.png', 0, 0, 0, tocolor(255,255,255,255), true)
    drawItem('mic1', rightScreen , bottomScreen + 2, tocolor(3, 119, 74, 150))
    drawItem('mic2', rightScreen  , bottomScreen + 14, tocolor(18, 232, 147,170))
    drawItem('mic3', rightScreen  , bottomScreen + 26, tocolor(18, 232, 147,170))
end