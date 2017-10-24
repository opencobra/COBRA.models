using JSON
using Requests

# create a temporary directory
tempDirPath = mktempdir()

# parse the JSON list of models
listModels = JSON.parsefile("models.json")

println(" > The temporary directory is: $tempDirPath")

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
        run(pipeline(`echo "[COBRA.models] Models are the same"`, `mail -s "- [COBRA.models] Models are the same" laurent.heirendt@uni.lu`))
    else
        println(" + DIFFERENT: $(model["name"]) [new: $checkSum | orig: $checkSumOrig]")
        run(pipeline(`echo "[COBRA.models] Models are different"`, `mail -s "+ [COBRA.models] Models are different" laurent.heirendt@uni.lu`))
    end
end
