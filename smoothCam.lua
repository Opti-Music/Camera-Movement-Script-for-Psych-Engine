-- Configuration variables (Adjust these to tweak the feel)
local shiftAmount = 15     -- How far the camera moves when a note is hit
local smoothSpeed = 2.5    -- Lower = smoother/slower, Higher = snappier

local targetX = 0
local targetY = 0

function onCreatePost()
    -- Get the default camera positions based on stage setup
    targetX = getProperty('camFollow.x')
    targetY = getProperty('camFollow.y')
end

function onMoveCamera(focus)
    -- Reset baseline targets when the camera focus switches characters
    if focus == 'boyfriend' then
        targetX = getProperty('dad.cameraPosition[0]') + getProperty('boyfriendCameraOffset[0]')
        targetY = getProperty('dad.cameraPosition[1]') + getProperty('boyfriendCameraOffset[1]')
    else
        targetX = getProperty('dad.cameraPosition[0]') + getProperty('opponentCameraOffset[0]')
        targetY = getProperty('dad.cameraPosition[1]') + getProperty('opponentCameraOffset[1]')
    end
end

-- Triggers on section hits to handle regular camera panning updates
function onSectionHit()
    targetX = getProperty('camFollowTarget.x')
    targetY = getProperty('camFollowTarget.y')
end

-- Master function that catches note hits and offsets the camera target
function goodNoteHit(id, noteData, noteType, isSustainNote)
    shiftCam(noteData)
end

function opponentNoteHit(id, noteData, noteType, isSustainNote)
    shiftCam(noteData)
end

function shiftCam(dir)
    -- Reset to section baseline first, then apply directional shift
    targetX = getProperty('camFollowTarget.x')
    targetY = getProperty('camFollowTarget.y')

    -- 0: Left, 1: Down, 2: Up, 3: Right
    if dir == 0 then targetX = targetX - shiftAmount
    elseif dir == 1 then targetY = targetY + shiftAmount
    elseif dir == 2 then targetY = targetY - shiftAmount
    elseif dir == 3 then targetX = targetX + shiftAmount
    end
end

function onUpdatePost(elapsed)
    -- Calculate lerp based on delta time so it's frame-rate independent
    local currentX = getProperty('camFollow.x')
    local currentY = getProperty('camFollow.y')
    
    local lerpVal = elapsed * smoothSpeed * 2
    
    -- Smoothly glide the actual camera follow point toward our target
    local newX = currentX + (targetX - currentX) * lerpVal
    local newY = currentY + (targetY - currentY) * lerpVal
    
    setProperty('camFollow.x', newX)
    setProperty('camFollow.y', newY)
end
