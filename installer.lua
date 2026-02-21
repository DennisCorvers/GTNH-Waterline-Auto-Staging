local shell = require("shell")
local term = require("term")
local filesystem = require("filesystem")
local internet = require("internet")

local installerScript =
"https://raw.githubusercontent.com/DennisCorvers/GTNH-Waterline-Auto-Staging/refs/heads/master/installer.lua"

local tarManUrl = "https://raw.githubusercontent.com/mpmxyz/ocprograms/master/usr/man/tar.man"
local tarBinUrl = "https://raw.githubusercontent.com/mpmxyz/ocprograms/master/home/bin/tar.lua"

---Check if Open OS installed
local function checkIsOsInstall()
    print("Verifying if OS is installed...")
    local file = io.open("/home/test.txt", "w")

    if file == nil then
        error("Open OS is not installed")
    end

    file:close()

    shell.execute("rm /home/test.txt")
    print('Open OS is installed.')
end

---Check connection to github
local function checkGithub()
    print("Checking github connection...")
    local success, result = pcall(internet.request, installerScript)

    if not success then
        if result then
            if result():match("PKIX") then
                error(
                    "Download server SSL certificates was rejected by Java. Update your Java version or install certificates for github.com manually")
            else
                error("Download server is unavailable: " .. tostring(result))
            end
        else
            error("Download server is unavailable for unknown reasons")
        end
    end

    print('Github connection established.')
end

---Download and install tar utility
local function downloadTarUtility()
    if filesystem.exists("/bin/tar.lua") then
        return
    end

    shell.setWorkingDirectory("/usr/man")
    shell.execute("wget -fq " .. tarManUrl)
    shell.setWorkingDirectory("/bin")
    shell.execute("wget -fq " .. tarBinUrl)
end

local function downloadProgram()
    term.write("Installing WaterMonitor\n")

    shell.execute("wget -fq " .. program.url .. " program.tar")
    shell.execute("tar -xf program.tar")
    shell.execute("rm program.tar")

    term.write("Installation complete\n")
end

---Main
local function main()
    checkIsOsInstall()
    checkGithub()

    term.clear()

    downloadTarUtility()

    shell.setWorkingDirectory("/home")

    downloadProgram(programUrl)
end

main()
