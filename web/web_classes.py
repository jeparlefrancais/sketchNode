import re

class Api(object):
    def __init__(self, type):
        self.type = type
    
    def getType(self):
        return self.type

class ApiArgument(Api):
    def __init__(self, name, typeString, description, defaultValue):
        super().__init__('Argument')
        self.name = name
        self.type = typeString
        self.description = description
        self.defaultValue = defaultValue

    def getName(self):
        return self.name

    def getType(self):
        return self.type

    def getDescription(self):
        return self.description

    def getDefaultValue(self):
        return self.defaultValue

    def __str__(self):
        if self.defaultValue == '':
            return '<{}> {} [{}]'.format(self.type, self.name, self.description)
        else:
            return '<{}> {}={} [{}]'.format(self.type, self.name, self.defaultValue, self.description)


class ApiMethod(Api):
    def __init__(self, name, returnType, description):
        self.name = name
        self.returnType = returnType
        self.description = description
        self.args = []

    def addArgument(self, arg):
        self.args.append(arg)

    def getName(self):
        return self.name

    def getReturnType(self):
        return self.returnType

    def getDescription(self):
        return self.description

    def getArguments(self):
        return self.args

    def __str__(self):
        argsStr = '\n   -> '.join(str(arg) for arg in self.args)
        if argsStr != '':
            argsStr = '\n   -> ' + argsStr
        if self.description == '':
            return '{} {}'.format(self.returnType, self.name) + argsStr
        else:
            return '{} {} [{}]'.format(self.returnType, self.name, self.description) + argsStr


class ApiClass(Api):
    def __init__(self, className, description):
        super().__init__('Class')

        self.name = className
        self.description = description
        self.methods = []

    def addMethod(self, method):
        if len(self.methods) == 0:
            self.methods.append(method)
        else:
            name = method.getName().lower()
            for i, selfMethod in enumerate(self.methods):
                if name < selfMethod.getName().lower():
                    self.methods.insert(i, method)
                    return
            self.methods.append(method)

    def getName(self):
        return self.name
    
    def getDescription(self):
        return self.description

    def getMethods(self):
        return self.methods

    def __str__(self):
        return '{}\n{}\n + '.format(self.name, self.description) + '\n + '.join(str(method) for method in self.methods)


class ApiModule(Api):
    def __init__(self, file):
        super().__init__('Module')


def search(pattern, string, default=''):
    match = re.search(pattern, string, re.DOTALL)
    if match:
        return match.group(1)
    else:
        return default

def getApi(file, filename):
    checkFunction = re.search('return (function)\(.*\).*end\s*$', file, re.DOTALL)

    if checkFunction and checkFunction.group(1) == 'function':
        pass #print('   -> function')
    else:
        match = re.search('return (\w*)\s*$', file)
        if match:
            if match.group(1) == 'class':
                classObject = ApiClass(search("__name = '(\w*)'", file, 'Unknown Class'), search("\\Description: (.*?)\n", file))
                
                for group in re.finditer('function class(?::|\.)(\w*)\((\w*[\w ,]*)\)\s(.*?)end', file, re.DOTALL):
                    methodName = group.group(1)
                    if methodName != 'Init':
                        arguments = group.group(2)
                        argumentList = [arg.group(0) for arg in re.finditer('[\w]+', arguments)]
                        methodContent = group.group(3)

                        returnType = search(r'\\ReturnType: (.*?)\n', methodContent, 'void')
                        doc = search(r'\Doc: (.*?)\n', methodContent)
                        method = ApiMethod(methodName, returnType, doc)

                        argumentTests = search('GetArguments\((.*?)\)', methodContent)
                        
                        for arg in argumentList:
                            argMatch = re.search("\{'(\w*)',\s+" + arg + "+(?:,\s+(\w+))?\},?\s+\-\-\s+(.+?)\n", argumentTests, re.DOTALL)
                            if argMatch:
                                argType = argMatch.group(1)
                                if argType == '':
                                    argType = 'any'
                                argDefaultValue = argMatch.group(2)
                                if argDefaultValue is None:
                                    argDefaultValue = ''
                                argDescription = argMatch.group(3)
                                method.addArgument(ApiArgument(arg, argType, argDescription, argDefaultValue))
                                
                        classObject.addMethod(method)
                #print(classObject)
                return classObject

            elif match.group(1) == 'module':
                #print('   -> module')
                return ApiModule(file)
            else:
                pass #print('   -> other capture:', match.group(1))
        else:
            pass # this is the main file
    
