<<<<<<< HEAD
using JSON
using Requests
=======
using JSON, SHA
>>>>>>> 0f7321a4a76ae78b8eef7e1f38b8c95cdc7eece9

function downloadModelZipFile(filename, url=""; fileToBeRenamed="", location=pwd())

    # modelName
    modelName = "model.zip"

    # create a temporary directory
    tempDirPath = mktempdir()

    # change to the temporary directory
    cd(tempDirPath)

    println(" > downloadModelZipFile | The directory is: $tempDirPath")

<<<<<<< HEAD
    modelFile = Requests.get(url)
    save(modelFile, modelName)
=======
    #modelFile = HTTP.get(url)
    download(url, modelName)
>>>>>>> 0f7321a4a76ae78b8eef7e1f38b8c95cdc7eece9

    # unzip the file
    run(`unzip -qq $modelName`)

    # rename unzipped file if necessary
    if ~isempty(fileToBeRenamed)
        println(" > downloadModelZipFile | Moving $fileToBeRenamed to $filename")
<<<<<<< HEAD
        mv(fileToBeRenamed, filename, remove_destination=true);
=======
        mv(fileToBeRenamed, filename, force=true);
>>>>>>> 0f7321a4a76ae78b8eef7e1f38b8c95cdc7eece9
    end

    # remove the temporary folder
    rm(tempDirPath, recursive=true)

    # print feedback message
    println(" > downloadModelZipFile | Temporary download folder $tempDirPath removed.")
    println(" > downloadModelZipFile | Model from .zip file stored in $location")
end

<<<<<<< HEAD
# create a temporary directory
tempDirPath = mktempdir()
repoDir = "/var/lib/jenkins/COBRA.models"
=======
# set the environment variables
if !("ARTENOLIS_DATA_PATH" in keys(ENV))
    ENV["ARTENOLIS_DATA_PATH"] = "/tmp"
end

if !("ARTENOLIS_EMAIL" in keys(ENV))
    ENV["ARTENOLIS_EMAIL"] = "artenobot@uni.lu"
end

# create a temporary directory
tempDirPath = mktempdir()
repoDir = ENV["ARTENOLIS_DATA_PATH"] * "/repos/COBRA.models"
>>>>>>> 0f7321a4a76ae78b8eef7e1f38b8c95cdc7eece9

# change directory
cd(repoDir)

# parse the JSON list of models
listModels = JSON.parsefile("models.json")

println(" > The temporary directory is: $tempDirPath")

# counters
counter = 0

# loop through the models and download them
for model in listModels
<<<<<<< HEAD
=======
    global counter
>>>>>>> 0f7321a4a76ae78b8eef7e1f38b8c95cdc7eece9
    modelExt = model["name"][end-3:end]
    modelName = tempDirPath*"/"*model["name"]

    if model["url"][end-3:end] == ".mat" || model["url"][end-3:end]  == ".xml"
        # download the file name
<<<<<<< HEAD
        modelFile = get(model["url"])
        save(modelFile, modelName)
        # get the original model
        modelOrig = modelExt[2:end]*"/"*model["name"]

=======
        download(model["url"], modelName)

        # get the original model
        modelOrig = modelExt[2:end]*"/"*model["name"]
>>>>>>> 0f7321a4a76ae78b8eef7e1f38b8c95cdc7eece9
    else
        modelOrig = model["name"][end-2:end]*"/"*model["name"]
        downloadModelZipFile(modelName, model["url"], fileToBeRenamed=model["fileToBeRenamed"], location=tempDirPath)
    end

    # save the checksum
<<<<<<< HEAD
    checkSum = Base.crc32c(read(modelName))
    checkSumOrig = Base.crc32c(read(repoDir*"/"*modelOrig))
=======
    checkSum = bytes2hex(sha256(read(modelName)))
    checkSumOrig = bytes2hex(sha256(read(repoDir*"/"*modelOrig)))
>>>>>>> 0f7321a4a76ae78b8eef7e1f38b8c95cdc7eece9

    if checkSum == checkSumOrig
        println(" - SAME: $(model["name"]) [new: $checkSum | orig: $checkSumOrig]")
    else
        println(" + DIFFERENT: $(model["name"]) [new: $checkSum | orig: $checkSumOrig]")
        counter = counter + 1
    end
end

# print a feedback message
if counter > 0
<<<<<<< HEAD
    run(pipeline(`echo "[COBRA.models] Models are different"`, `mail -s "+ [COBRA.models] Models are different" laurent.heirendt@uni.lu`))
else
    run(pipeline(`echo "[COBRA.models] Models are the same"`, `mail -s "- [COBRA.models] Models are the same" laurent.heirendt@uni.lu`))
=======
    run(pipeline(`echo "[COBRA.models] Models are different"`, `mail -s "+ [COBRA.models] Models are different" $(ENV["ARTENOLIS_EMAIL"])`))
else
    run(pipeline(`echo "[COBRA.models] Models are the same"`, `mail -s "- [COBRA.models] Models are the same" $(ENV["ARTENOLIS_EMAIL"])`))
>>>>>>> 0f7321a4a76ae78b8eef7e1f38b8c95cdc7eece9
end

# remove the temporary folder
rm(tempDirPath, recursive=true)

# print feedback message
println(" > Folder $tempDirPath has been removed.\n > Done.")

# exit
exit()
