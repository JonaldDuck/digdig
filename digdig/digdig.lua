-- MIT License

-- Copyright (c) 2023 Jonald Duck

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

addon.name      = "digdig";
addon.author    = "JonaldDuck";
addon.version   = "1.0.0";
addon.desc      = "Track how many digs you've done in a day";
addon.link      = "https://github.com/JonaldDuck/digdig";

require("common");

local chocoBuffId = 252;

local countersFileName = "digCounter.txt";

local path = ('%s\\config\\addons\\%s'):fmt(AshitaCore:GetInstallPath(), 'digdig');

digCounter = 0;




print("-- digdig --")

ashita.events.register('text_in', 'text_in_cb', function (e)
    if e ~= nil and e.message ~= nil and isOnChocobo() then
        if string.find(e.message, "Obtained:") then
            e.message_modified = e.message_modified .. trackDig();
        end
        -- if string.find(e.message, "You dig and you dig, but you find nothing") then
        --     e.message_modified = e.message_modified .. " Items dug up so far: " .. digCounter;
        -- end
    end
    
end);

function trackDig()
    saveDigData();
    return  " Items dug up so far: " .. digCounter;
end

function isOnChocobo()
    local player = AshitaCore:GetMemoryManager():GetPlayer();
    local buffs = player:GetBuffs();
    for i=1, 32 do
        if buffs[i] == chocoBuffId then
            return true;
        end
    end
    return false;
end

function saveDigData()
    if not ashita.fs.exists(path) then
        ashita.fs.create_directory(path);
    end
    local file, errorString = io.open( path .. "\\" .. countersFileName, "w+" );
    file:write(digCounter);
    
    io.close(file);
end

function loadDigData()
    if ashita.fs.exists(path) then
        local file, errorString = io.open(path .. "\\" .. countersFileName, "r");
        digCounter = file.read();
        io.close(file);
    end
    print("Current chocobo dig count: " .. digCounter)
end

loadDigData()