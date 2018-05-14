import os
from item_classes import *

# settings
SOURCE = "sketchNode"
EXPORT_DIRECTORY = "builds"
EXPORT_NAME = "sketchNode_plugin"

root = Root()
pluginFolder = Folder("sketchRBX")
root.addChild(pluginFolder)

def getContent(directory, parent):
    for filename in os.listdir(directory):
        if filename.endswith(".lua"): #  it's a module script
            if directory == SOURCE:
                script = Script(filename[:-4], open(directory + "/" + filename, 'r').read())
                parent.addChild(script)
            else:
                moduleScript = ModuleScript(filename[:-4], open(directory + "/" + filename, 'r').read())
                parent.addChild(moduleScript)

        else: # it's folder
            nextParent = Folder(filename)
            parent.addChild(nextParent)
            getContent(directory + "/" + filename, nextParent)

def getFileName(n):
    if n == 0:
        return EXPORT_DIRECTORY + "/" + EXPORT_NAME + ".rbxmx"
    else:
        return EXPORT_DIRECTORY + "/" + EXPORT_NAME + " (" + str(n) + ").rbxmx"

getContent(SOURCE, pluginFolder)

if not os.path.exists(EXPORT_DIRECTORY):
    os.mkdir(EXPORT_DIRECTORY)

n = 0
name = getFileName(n)
while os.path.exists(name):
    n += 1
    name = getFileName(n)

data = root.getData()
with open(name, 'w') as file:
    file.write(data)
    print("File " + name + " exported.")

if os.path.exists('build_locations.txt'):
    other_locations = [line.rstrip('\n') for line in open('build_locations.txt')]
    for location in other_locations:
        with open(location + '/' + EXPORT_NAME + '.rbxmx', 'w') as file:
            file.write(data)
