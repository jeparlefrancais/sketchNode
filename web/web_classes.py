import re

class Api(object):
    def __init__(self, apiClass):
        self.apiClass = apiClass
    
    def getClass(self):
        return self.apiClass


class ApiValue(Api):
    def __init__(self, name, typeString):
        super().__init__('Value')
        self.name = name
        self.type = typeString

    def getName(self):
        return self.name

    def getType(self):
        return self.type

    def __str__(self):
        return '<{}> {}'.format(self.type, self.name)


class ApiArgument(ApiValue):
    def __init__(self, name, typeString, description, defaultValue):
        super().__init__(name, typeString)
        self.apiClass = 'Argument'
        self.description = description
        self.defaultValue = defaultValue

    def getDescription(self):
        return self.description

    def getDefaultValue(self):
        return self.defaultValue

    def __str__(self):
        if self.defaultValue == '':
            return '<{}> {} [{}]'.format(self.getType(), self.getName(), self.description)
        else:
            return '<{}> {}={} [{}]'.format(self.getType(), self.getName(), self.defaultValue, self.description)


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


class ApiSignal(Api):
    def __init__(self, name, description=''):
        super().__init__('Signal')
        self.name = name
        self.description = description
        self.values = []

    def addValue(self, value):
        self.values.append(value)

    def getValues(self):
        return self.values

    def getName(self):
        return self.name

    def getDescription(self):
        return self.description

    def __str__(self):
        return '{} : ({})'.format(self.name, ', '.join(str(value) for value in self.values))


class ApiModule(Api):
    def __init__(self, moduleName, description):
        super().__init__('Module')
        self.name = moduleName
        self.description = description
        self.methods = []
        self.signals = []

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

    def addSignal(self, signal):
        if len(self.signals) == 0:
            self.signals.append(signal)
        else:
            name = signal.getName().lower()
            for i, selfSignal in enumerate(self.signals):
                if name < selfSignal.getName().lower():
                    self.signals.insert(i, signal)
                    return
            self.signals.append(signal)

    def getName(self):
        return self.name
    
    def getDescription(self):
        return self.description

    def getMethods(self):
        return self.methods

    def getSignals(self):
        return self.signals

    def __str__(self):
        if len(self.description) > 0:
            return '{}\n[{}]\n + '.format(self.name, self.description) + '\n + '.join(str(method) for method in self.methods)
        else:
            return '{}\n + '.format(self.name) + '\n + '.join(str(method) for method in self.methods)


class ApiClass(ApiModule):
    def __init__(self, className, description):
        super().__init__(className, description)
        self.apiClass = 'Class'
        self.childClasses = []
        self.parentClasses = []
        self.parentClassNames = []
    
    def addParentClass(self, otherClass):
        self.parentClasses.append(otherClass)
        otherClass._addChildClass(self)
    
    def _addChildClass(self, otherClass):
        self.childClasses.append(otherClass)

    def addParentClassName(self, className):
        self.parentClassNames.append(className)

    def getChildClasses(self):
        return self.childClasses

    def getParentClasses(self):
        parents = []
        parents.extend(self.parentClasses)
        for parent in self.parentClasses:
            parents.extend(parent.getParentClasses())
        return parents

    def getInheritedMethods(self, parent):
        methods = []
        for method in parent.getMethods():
            add = True
            for ownMethod in self.getMethods():
                if ownMethod.getName() == method.getName():
                    add = False
                    break
            if add:
                methods.append(method)
        return methods

    def getInheritedSignals(self, parent):
        signals = []
        for signal in parent.getSignals():
            add = True
            for ownSignal in self.getSignals():
                if ownSignal.getName() == signal.getName():
                    add = False
                    break
            if add:
                signals.append(signal)
        return signals

    def __str__(self):
        if len(self.parentClassNames) == 0:
            return super().__str__()
        else:
            if len(self.description) > 0:
                return '{} ({})\n[{}]\n + '.format(self.name, ', '.join(self.parentClassNames), self.description) + '\n + '.join(str(method) for method in self.methods)
            else:
                return '{} ({})\n + '.format(self.name, ', '.join(self.parentClassNames)) + '\n + '.join(str(method) for method in self.methods)


    def getParentClassNames(self):
        return self.parentClassNames


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
            apiObject = None
            if match.group(1) == 'class':
                apiObject = ApiClass(search("__name = '(\w*)'", file, 'Unknown Class'), search("\\Description: (.*?)\n", file))

                superClassList = search('__super\s*=\s*\{(.*?)\}', file)

                for superClassPath in re.finditer('[\w\.]+', superClassList, re.DOTALL):
                    superClassName = search('(\w*)$', superClassPath.group())
                    apiObject.addParentClassName(superClassName)


            elif match.group(1) == 'module':
                apiObject = ApiModule(search("(.*)\.lua", filename, 'Unknown Module'), search("\\Description: (.*?)\n", file))
            
            if apiObject is not None:
                signalsList = search('__signals\s*=\s*\{(.*?\})\s*,?\s*\}', file)
                if signalsList is not None:
                    for signal in re.finditer('(\w+)\s*=\s*\{(.*?)\}', signalsList, re.DOTALL):
                        signalName = signal.group(1)
                        signalContent = signal.group(2)
                        signalObject = ApiSignal(signalName)

                        for value in re.finditer('(\w*)[\W]*?--\s*(\w*)', signalContent):
                            valueName = value.group(2)
                            valueType = value.group(1)
                            if valueType == '':
                                valueType = 'any'
                            signalObject.addValue(ApiValue(valueName, valueType))

                        apiObject.addSignal(signalObject)

                for group in re.finditer('function (?:class|module)(?::|\.)(\w*)\((\w*[\w ,]*)\)\s(.*?)end', file, re.DOTALL):
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
                                
                        apiObject.addMethod(method)
                
                #print(apiObject)
                return apiObject
            else:
                pass #print('   -> other capture:', match.group(1))
        else:
            pass # this is the main file
    
