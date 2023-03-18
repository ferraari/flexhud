screenW, screenH = guiGetScreenSize()
local circleScale, sizeStroke = 50, 3
local iconScale = 20
local circleLeft, circleTop = circleScale + 30, screenH - circleScale - 20
local rightScreen, bottomScreen = screenW - circleScale - 20, screenH - circleScale - 20
fontePoppins = dxCreateFont("assets/fonts/Poppins-Medium.ttf", 36, true)
fontePoppinsGas = dxCreateFont("assets/fonts/Poppins-Medium.ttf", 15)
fonteRajdhani = dxCreateFont("assets/fonts/Rajdhani-SemiBold.ttf", 12, true)

addEventHandler("onClientResourceStart", resourceRoot, function()

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

    drawItem('bgOfAll', rightScreen - 240, bottomScreen -5, tocolor(0,0,0,100))

    drawItem('bgHealth', rightScreen - 220, bottomScreen, tocolor(0, 114, 246,170))
    drawItem('health', rightScreen - 220, bottomScreen, tocolor(28,28,28,255))
    dxDrawImage(rightScreen - 210, bottomScreen + 10, iconScale, iconScale, 'assets/icon_vida.png', 0, 0, 0, tocolor(255,255,255,255), true)
    setSVGOffset('health', getElementHealth(localPlayer))


    drawItem('bgArmor', rightScreen - 170, bottomScreen, tocolor(0, 114, 246,170))
    drawItem('armor', rightScreen - 170, bottomScreen, tocolor(28,28,28,255))
    dxDrawImage(rightScreen - 160, bottomScreen + 10, iconScale, iconScale, 'assets/icon_colete.png', 0, 0, 0, tocolor(255,255,255,255), true)   
    setSVGOffset('armor', getPedArmor(localPlayer))

    drawItem('bgFeed', rightScreen - 120, bottomScreen, tocolor(0, 114, 246,170))
    drawItem('feed', rightScreen - 120, bottomScreen, tocolor(28,28,28,255))
    dxDrawImage(rightScreen - 110, bottomScreen + 10, iconScale, iconScale, 'assets/icon_comida.png', 0, 0, 0, tocolor(255,255,255,255), true)
    setSVGOffset('feed', 70)

    drawItem('bgThirst', rightScreen - 70, bottomScreen, tocolor(0, 114, 246,170))
    drawItem('thirst', rightScreen - 70, bottomScreen, tocolor(28,28,28,255))
    dxDrawImage(rightScreen - 60, bottomScreen + 10, iconScale, iconScale, 'assets/icon_agua.png', 0, 0, 0, tocolor(255,255,255,255), true)
    setSVGOffset('thirst', 40)

    dxDrawImage(rightScreen - 20, bottomScreen + 10, iconScale - 5, iconScale, 'assets/icon_voz.png', 0, 0, 0, tocolor(255,255,255,255), true)
    drawItem('mic1', rightScreen , bottomScreen + 2, tocolor(15, 53, 128, 120))
    drawItem('mic2', rightScreen  , bottomScreen + 14, tocolor(0, 114, 246,170))
    drawItem('mic3', rightScreen  , bottomScreen + 26, tocolor(0, 114, 246,170))



end)
