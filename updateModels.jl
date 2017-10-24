using JSON
using Requests

# create a temporary directory
tempDirPath = mktempdir()

# change directory
cd("/var/lib/jenkins/COBRA.models")

# parse the JSON list of models
listModels = JSON.parsefile("models.json")

println(" > The temporary directory is: $tempDirPath")

# counters
counter = 0

# loop through the models and download them
for model in listModels
    # download the file name
    modelFile = get(model["url"])
    modelName = tempDirPath*"/"*model["name"]
    modelExt = model["name"][end-3:end]
    save(modelFile, modelName)

    # get the original model
    modelOrig = modelExt[2:end]*"/"*model["name"]

    # save the checksum
    checkSum = Base.crc32c(read(modelName))
    checkSumOrig = Base.crc32c(read(modelOrig))

    if checkSum == checkSumOrig
        println(" - SAME: $(model["name"]) [new: $checkSum | orig: $checkSumOrig]")
    else
        println(" + DIFFERENT: $(model["name"]) [new: $checkSum | orig: $checkSumOrig]")
        counter = counter + 1
    end
end

# print a feedback message
if counter > 0
    run(pipeline(`echo "[COBRA.models] Models are different"`, `mail -s "+ [COBRA.models] Models are different" laurent.heirendt@uni.lu`))
else
    run(pipeline(`echo "[COBRA.models] Models are the same"`, `mail -s "- [COBRA.models] Models are the same" laurent.heirendt@uni.lu`))
end

# remove the temporary folder
rm(tempDirPath, recursive=true)

# print feedback message
println(" > Folder $tempDirPath has been removed. Done.")

# exit
exit()
