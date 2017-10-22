using JSON
using Requests

# create a temporary directory
tempDirPath = mktempdir()

# parse the JSON list of models
listModels = JSON.parsefile("models.json")

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
        println("SAME: $(model["name"]) [new: $checkSum | orig: $checkSumOrig]")
    else
        println("DIFFERENT: $(model["name"]) [new: $checkSum | orig: $checkSumOrig]")
    end
end
