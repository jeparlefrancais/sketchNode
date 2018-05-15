import os
from jinja2 import Environment, FileSystemLoader

from web_classes import getApi

ROOT_FOLDER = 'web/'
BUILD_FOLDER = ROOT_FOLDER + 'build'

PAGES = {
    'Home': 'index',
    'Reference': 'api',
    'About': 'about'
}

env = Environment(loader=FileSystemLoader('{}templates/'.format(ROOT_FOLDER)))

if not os.path.exists(BUILD_FOLDER):
    os.makedirs(BUILD_FOLDER)

css = None
with open('{}templates/main.css'.format(ROOT_FOLDER), 'r') as file:
    css = ''.join(file.readlines())

with open('{}/main.css'.format(BUILD_FOLDER), 'w+') as file:
    file.write(css)

classes = []
modules = []
# Generate the api
for (folder, dirnames, filenames) in os.walk('sketchNode'):
    for filename in filenames:
        with open('{}/{}'.format(folder, filename)) as file:
            content = ''.join(file.readlines())
            apiObject = getApi(content, filename)
            if apiObject is not None:
                if apiObject.getClass() == 'Class':
                    classes.append(apiObject)
                elif apiObject.getClass() == 'Module':
                    modules.append(apiObject)

for classObject in classes:
    for otherClass in classes:
        if classObject != otherClass:
            if otherClass.getName() in classObject.getParentClassNames():
                classObject.addParentClass(otherClass)

modules.sort(key=lambda x: x.getName().lower())

for classObject in classes:
    with open('{}/api_{}.html'.format(BUILD_FOLDER, classObject.getName()), 'w+') as newPage:
        newPage.write(env.get_template('api_class.html').render(pages=PAGES, obj=classObject))
        #print('Page', filename, 'created.')

for moduleObject in modules:
    with open('{}/api_{}.html'.format(BUILD_FOLDER, moduleObject.getName()), 'w+') as newPage:
        newPage.write(env.get_template('api_module.html').render(pages=PAGES, obj=moduleObject))
        #print('Page', filename, 'created.')

# Create the main pages
for page, fileName in PAGES.items():
    with open('{}/{}.html'.format(BUILD_FOLDER, fileName), 'w+') as file:
        if page == 'Reference':
            file.write(env.get_template('{}.html'.format(fileName)).render(pages=PAGES, pageName=page, classes=classes, modules=modules))
        else:
            file.write(env.get_template('{}.html'.format(fileName)).render(pages=PAGES, pageName=page))

