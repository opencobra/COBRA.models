using JSON
using Requests

listModels = JSON.parsefile("models.json")

for model in listModels
    println(model["name"])
    modelFile = get(model["url"])
    save(modelFile, model["name"])
end
