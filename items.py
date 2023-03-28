import os, sys, time

class Item:
    _name = ""
    _id = 0
    _price = ""
    _url = ""

class YoworldItems():
    items = []
    found = []
    def __init__(self, item_search: str) -> None:
        __file = open("items.txt", "r")
        self.__data = __file.read()
        self.search = item_search
        __file.close()
        self.fetch_all_items()

        if isinstance(item_search, int):
            pass
        else:
            pass

    @staticmethod
    def create_item(name: str, iid: int, price: str, url: str) -> Item:
        i = Item()
        i._name = name
        i._id = iid
        i._price = price
        i._url = url
        return i

    def __parse(self, line: str) -> list:
        return line.replace("(", "").replace(")", "").replace("'", "").split(",")

    def get_str_between(self, text:str, start: str, end: str) -> str:
        new_str = ""
        ignore = True
        for i in range(len(text)):
            char = text[i]
            if char == start and ignore == True:
                ignore = False
            elif char == end and ignore == False:
                return new_str
            elif ignore == False:
                new_str += char
        return new_str

    def fetch_all_items(self) -> bool:
        lines = self.__data.split("\n")

        for line in lines:
            if len(line) == 0 | len(line) < 10: continue

            item_info = self.__parse(line)
            self.items.append(self.create_item(item_info[0], int(item_info[1]), item_info[3], item_info[2]))

        if len(self.items) > 0: return True
        return False

    def search_item_name(self) -> list:
        for item in self.items:
            no_case_sen = self.search.lower()

            if item._name == self.search: return [item]
            elif self.search.lower() in item._name: return [item]

        #     words_in_search = self.search.split(" ")
        #     for word in words_in_search:
        #         if word in item._name: 
        #             self.found.append(item)
        #             self.found_results = True
        #             break

        # if len(self.found) == 0: self.found_results = False
        return self.found

    def search_item_id(self) -> Item:
        for item in self.items:
            if f"{self.search}" in f"{item._id}": return item

        return create_item("", 0, 0, "")

    def set_new_price(self, item_id: int, new_price: int) -> bool:
        items = ""
        for i in self.found:
                if f"{i._id}" == f"{item_id}":
                        items += f"('{i._name}','{i._id}','{i._url}','{new_price}')\n"
                else:
                        items += f"('{i._name}','{i._id}','{i._url}','{i._price}')\n"
                        
        new_db = open("items.txt", "w")
        new_db.write(items)
        new_db.close()
        return True