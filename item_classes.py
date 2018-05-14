_referentCount = 1

class Root(object):
    def __init__(self):
        self.start = """<roblox xmlns:xmime="http://www.w3.org/2005/05/xmlmime" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.roblox.com/roblox.xsd" version="4">
	<External>null</External>
	<External>nil</External>
    """
        self.end = "</roblox>"
        self.children = list()

    def addChild(self, child):
        self.children.append(child)

    def getData(self):
        data = self.start
        for child in self.children:
            data += child.getData()
        return data + self.end


class Item(Root):
    def __init__(self, start):
        global _referentCount
        _referentCount += 1
        self.children = list()
        self.start = start
        self.end = """</Item>
        """

class Folder(Item):
    def __init__(self, name):
        super().__init__('<Item class="Folder" referent="' + str(_referentCount) + """">
			<Properties>
				<string name="Name">""" + name + """</string>
				<BinaryString name="Tags"></BinaryString>
			</Properties>
            """)

class Script(Item):
    def __init__(self, name, source):
        super().__init__('<Item class="Script" referent="' + str(_referentCount) + """">
		<Properties>
			<bool name="Disabled">false</bool>
			<Content name="LinkedSource"><null></null></Content>
			<string name="Name">""" + name + """</string>
			<string name="ScriptGuid">{548D850C-54DB-4253-8F94-296D785DD820}</string>
			<ProtectedString name="Source"><![CDATA[""" + source + 
            """]]></ProtectedString>
			<BinaryString name="Tags"></BinaryString>
		</Properties>
        """)

class ModuleScript(Item):
    def __init__(self, name, source):
        super().__init__('<Item class="ModuleScript" referent="' + str(_referentCount) + """">
				<Properties>
					<Content name="LinkedSource"><null></null></Content>
					<string name="Name">""" + name + """</string>
					<string name="ScriptGuid">{2F021F34-1A3A-47E4-97B2-27F1DAC4ECB1}</string>
					<ProtectedString name="Source"><![CDATA[""" + source + """]]></ProtectedString>
					<BinaryString name="Tags"></BinaryString>
				</Properties>
        """)