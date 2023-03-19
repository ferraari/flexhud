screenW, screenH = guiGetScreenSize()
circleScale, sizeStroke = 50, 3
iconScale = 20
circleLeft, circleTop = circleScale + 30, screenH - circleScale - 20
rightScreen, bottomScreen = screenW - circleScale - 20, screenH - circleScale - 20

fontePoppins = dxCreateFont("assets/fonts/Poppins-Medium.ttf", 36, true)
fontePoppinsGas = dxCreateFont("assets/fonts/Poppins-Medium.ttf", 15)
fonteRajdhani = dxCreateFont("assets/fonts/Rajdhani-SemiBold.ttf", 12, true)

addEventHandler("onClientResourceStart", resourceRoot, function()
    createComponents()
    hiddenComponents(false);
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    hiddenComponents(true);
end)

addEventHandler("onClientRender", root, function()
    local vehicle = getPedOccupiedVehicle(localPlayer)

    if vehicle then
        local Limit = getVehicleHandling(vehicle)['maxVelocity']
        local speed = getElementSpeed(vehicle, 1)
        local calcSpeed = ( 50 / Limit) * (speed > Limit and Limit or speed)
        local speedText = tostring(math.floor(speed))

        local health = getElementHealth(localPlayer)

        drawItem('bgSpeed', rightScreen -245, bottomScreen - 110, tocolor(0,0,0,170))
        drawItem('speed', rightScreen -245, bottomScreen - 110, tocolor(255,255,255,170))
        setSVGOffset('bgSpeed', ( 50 / 100 ) * 100)
        setSVGOffset('speed', calcSpeed)

        drawItem('bgGas', rightScreen - 55, bottomScreen - 50, tocolor(0,0,0,100))
        dxDrawImage(rightScreen - 115, bottomScreen - 43, iconScale , iconScale, 'assets/cinto.png', 0, 0, 0, tocolor(255,255,255,255), true)
        dxDrawImage(rightScreen - 50, bottomScreen - 43, iconScale, iconScale, 'assets/gasolina_icon.png', 0, 0, 0, tocolor(255,255,255,255), true)
        dxDrawText('100%', rightScreen - 30, bottomScreen - 45 , (rightScreen - 40) + (circleScale + 10) , (circleScale -15) + (bottomScreen - 50), tocolor(255,255,255,255), 1, fontePoppinsGas, "center", "center", false, false, false, false, false)

        --- TEXTS SPEED
        local formatSpeed = string.format("%03d", speedText)

        dxDrawText('Km/H', rightScreen - 245, bottomScreen - 180 , (rightScreen - 245) + (circleScale + 125) , (circleScale + 125) + (bottomScreen - 110), tocolor(255,255,255,255), 1, fonteRajdhani, "center", "center", false, false, false, false, false)
        dxDrawText(formatSpeed, rightScreen - 245, bottomScreen - 120 , (rightScreen - 245) + (circleScale + 125) , (circleScale + 125) + (bottomScreen - 110), tocolor(255,255,255,255), 1, fontePoppins, "center", "center", false, false, false, false, false)

    end

    createItems()
end)
